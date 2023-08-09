import 'dart:convert';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/state_list.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/country_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

//import 'package:myfirstapp/screens/dashboard/sidebar.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/statemaster/statemasterlist.dart';

class StateMasterAdd extends StatefulWidget {
  StateMasterAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;

  @override
  _StateMasterAddState createState() => _StateMasterAddState();
}

class _StateMasterAddState extends State<StateMasterAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _countrylist = [];

  String dropdownvalueType = '';
  String dropdownvalueBusiness = '';

  TextEditingController _statecode = new TextEditingController();
  TextEditingController _country = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _jsonData = [];
  TextEditingController _state = new TextEditingController();

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> loadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;

    uri = 'https://www.cloud.equalsoftlink.com/api/getstatelist?dbname=' +
        db +
        '&id=' +
        id;

    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _state.text = getValue(jsonData['state'], 'C');
    _statecode.text = getValue(jsonData['statecode'], 'C');
    _country.text = getValue(jsonData['country'], 'C');

    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    void gotoCountryScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => country_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;
        _countrylist = result[1];
        result = result[1];
        var selCountry = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selCountry = selCountry + ',';
          }
          selCountry = selCountry + retResult[0][ictr];
        }
        _country.text = selCountry;
      });
    }

    void gotoStateScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => state_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;
        _countrylist = result[1];
        result = result[1];
        //print(retResult[0][0]);
        var selState = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selState = selState + ',';
          }
          selState = selState + retResult[0][ictr];
        }
        //print(selCity);
        _state.text = selState;
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var state = _state.text;
      var statecode = _statecode.text;
      var country = _country.text;

      var id = widget.xid;
      id = int.parse(id);

      uri = 'https://www.cloud.equalsoftlink.com/api/api_addstate?dbname=' +
          db +
          '&state=' +
          state +
          '&statecode=' +
          statecode +
          '&country=' +
          country +
          '&user=' +
          username +
          '&cno=' +
          cno +
          '&id=' +
          id.toString();

      var response = await http.post(Uri.parse(uri));

      var jsonData = jsonDecode(response.body);

      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        showAlertDialog(context, 'Saved !!!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StateMasterList(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }

      return true;
    }

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'State Master [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ',
          style:
              TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {saveData()}),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.characters,
              controller: _state,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Name Of State',
                labelText: 'Name Of State',
              ),
              onChanged: (value) {
                _state.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _state.selection);
              },
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _statecode,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'State Code',
                labelText: 'State Code',
              ),
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _country,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Country',
                labelText: 'Country',
              ),
              onTap: () {
                gotoCountryScreen(context);
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
