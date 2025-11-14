import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/state_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/partygroupmaster/partygroupmasterlist.dart';

class PartyGroupMasterAdd extends StatefulWidget {
  PartyGroupMasterAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _PartyGroupMasterAddState createState() => _PartyGroupMasterAddState();
}

class _PartyGroupMasterAddState extends State<PartyGroupMasterAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _citylist = [];
  List _statelist = [];

  TextEditingController _acgroup = new TextEditingController();
  TextEditingController _addr1 = new TextEditingController();
  TextEditingController _addr2 = new TextEditingController();
  TextEditingController _addr3 = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _citysel = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _jsonData = [];
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');

  TextEditingController _state = new TextEditingController();
  TextEditingController _statesel = new TextEditingController();

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

    uri = '${globals.cdomain2}/api/getpartygrplist?dbname=' +
        db +
        '&id=' +
        id;
    //print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _acgroup.text = getValue(jsonData['acgroup'], 'C');
    _addr1.text = getValue(jsonData['addr1'], 'C');
    _addr2.text = getValue(jsonData['addr2'], 'C');
    _addr3.text = getValue(jsonData['addr3'], 'C');
    _city.text = getValue(jsonData['city'], 'C');
    _state.text = getValue(jsonData['state'], 'C');
    _phone.text = getValue(jsonData['phone'], 'C');
    _mobile.text = getValue(jsonData['mobile'], 'C');

    return true;
  }

  void setDefValue() {
    //_node.text = '0';
    //_amc.text = '0';
    //_amount.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    void gotoCityScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => city_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;
        _citylist = result[1];
        result = result[1];

        var selCity = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selCity = selCity + ',';
          }
          selCity = selCity + retResult[0][ictr];
        }

        _city.text = selCity;

        if (selCity != '') {
          getCityDetails(_city.text, 0).then((value) {
            setState(() {
              _state.text = value[0]['state'];
            });
          });
        }
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
        _statelist = result[1];
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
      var acgroup = _acgroup.text;
      var grpcode = '';
      var grpcodeno = '0';
      var addr1 = _addr1.text;
      var addr2 = _addr2.text;
      var addr3 = _addr3.text;
      var agent = '';
      var ptyarea = '';
      var contperson = '';
      var stdcode = '';
      var ptypincode = '';
      var city = _city.text;
      var state = _state.text;
      var country = '';
      var phone = _phone.text;
      var mobile = _mobile.text;
      var ptyemail = '';
      var transport = '';
      var dhara = '0';
      var duedays = '0';
      var ptydhara2 = '0';
      var commperc = '0';
      var crlimit = '0';
      var drlimit = '0';
      var remarks = '';

      var id = widget.xid;
      id = int.parse(id);

      uri = '${globals.cdomain2}/api/apiaddpartygrp?dbname=' +
          db +
          '&acgroup=' +
          acgroup +
          '&grpcode=' +
          grpcode +
          '&grpcodeno=' +
          grpcodeno +
          '&addr1=' +
          addr1 +
          '&addr2=' +
          addr2 +
          '&addr3=' +
          addr3 +
          '&agent=' +
          agent +
          '&ptyarea=' +
          ptyarea +
          '&contperson=' +
          contperson +
          '&city=' +
          city +
          '&stdcode=' +
          stdcode +
          '&ptypincode=' +
          ptypincode +
          '&state=' +
          state +
          '&country=' +
          country +
          '&phone=' +
          phone +
          '&mobile=' +
          mobile +
          '&ptyemail=' +
          ptyemail +
          '&transport=' +
          transport +
          '&dhara=' +
          dhara +
          '&duedays=' +
          duedays +
          '&ptydhara2=' +
          ptydhara2 +
          '&commperc=' +
          commperc +
          '&crlimit=' +
          crlimit +
          '&drlimit=' +
          drlimit +
          '&remarks=' +
          remarks +
          '&agent=' +
          agent +
          '&user=' +
          username +
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
                builder: (_) => PartyGroupMasterList(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }

      return true;
    }

    setDefValue();

    print('1');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Party Group  [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ',
          style:
              TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.done),
      //     backgroundColor: Colors.green,
      //     onPressed: () => {saveData()}),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.characters,
              controller: _acgroup,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Name Of GROUP',
                labelText: 'Name Of Group',
              ),
              onChanged: (value) {
                _acgroup.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _acgroup.selection);
              },
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addr1,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address 1',
                labelText: 'Address',
              ),
              onChanged: (value) {
                _addr1.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _addr1.selection);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addr2,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address 2',
                labelText: '',
              ),
              onChanged: (value) {
                _addr2.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _addr2.selection);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addr3,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address 3',
                labelText: '',
              ),
              onChanged: (value) {
                _addr3.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _addr3.selection);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'City',
                labelText: 'City',
              ),
              onTap: () {
                gotoCityScreen(context);
                //_selecttoDate(context);
              },
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
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Phone No',
                labelText: 'Phone No',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _mobile,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Mobile',
                labelText: 'Mobile',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 25,color: const Color.fromARGB(231, 255, 255, 255),), // Text style
                      backgroundColor: Colors.green, 
                      // Background color
                    ),
                    onPressed: () {
                      saveData();
                    },
                    child: const Text('SAVE',style: TextStyle(fontSize: 20,color: Color.fromARGB(231, 255, 255, 255),),),
                  )),
                  SizedBox(
                   width: 10
                  ),
                  Expanded(
                    child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 25,color: Color.fromARGB(231, 255, 255, 255),), // Text style
                      backgroundColor: Colors.green, // Background color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                        Fluttertoast.showToast(
                        msg: "CANCEL !!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.purple,
                        fontSize: 16.0,
                        );
                    },
                    child: const Text('CANCEL',style: TextStyle(fontSize: 20,color: Color.fromARGB(231, 255, 255, 255),),),
                  ))
                ],
              ),
            )
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
