import 'dart:convert';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/city_list.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/state_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

//import 'package:myfirstapp/screens/dashboard/sidebar.dart';

//// import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/citymaster/citymasterlist.dart';

class CityMasterAdd extends StatefulWidget {
  CityMasterAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _CityMasterAddState createState() => _CityMasterAddState();
}

class _CityMasterAddState extends State<CityMasterAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _statelist = [];

  String dropdownvalueType = '';
  String dropdownvalueBusiness = '';

  TextEditingController _city = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _distance = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _jsonData = [];

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

    uri = 'https://www.cloud.equalsoftlink.com/api/getcitylist?dbname=' +
        db +
        '&id=' +
        id;

    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _city.text = getValue(jsonData['city'], 'C');
    _state.text = getValue(jsonData['state'], 'C');
    _distance.text = getValue(jsonData['distance'], 'C');

    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
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
        _statelist = result[1];
        result = result[1];
        var selState = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selState = selState + ',';
          }
          selState = selState + retResult[0][ictr];
        }
        _state.text = selState;
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var city = _city.text;
      var state = _state.text;
      var distance = _distance.text;

      var id = widget.xid;
      id = int.parse(id);

      uri = 'https://www.cloud.equalsoftlink.com/api/api_addcity?dbname=' +
          db +
          '&city=' +
          city +
          '&state=' +
          state +
          '&distance=' +
          distance +
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
                builder: (_) => CityMasterList(
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
          'City Master [ ' +
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
              controller: _city,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Name Of City',
                labelText: 'Name Of City',
              ),
              onChanged: (value) {
                _city.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _city.selection);
              },
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
                controller: _state,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'State',
                  labelText: 'State',
                ),
                onTap: () {
                  gotoStateScreen(context);
                  //_selecttoDate(context);
                },
                validator: (value) {
                  return null;
                }),
            TextFormField(
              controller: _distance,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Distance',
                labelText: 'Distance',
              ),
              onTap: () {},
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
