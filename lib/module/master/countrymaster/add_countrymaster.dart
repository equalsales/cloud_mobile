import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
//import 'package:cloud_mobile/report/account/report_ledger.dart';
//import 'package:myfirstapp/screens/account/ledger_report.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/state_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

import 'package:cloud_mobile/common/reportpdf.dart';

//import 'package:myfirstapp/screens/dashboard/sidebar.dart';

import 'package:cloud_mobile/common/pdf_api.dart';
import 'package:cloud_mobile/common/pdf_report_api.dart';
import 'package:cloud_mobile/main.dart';
import 'package:cloud_mobile/common/customer.dart';
import 'package:cloud_mobile/common/invoice.dart';
import 'package:cloud_mobile/common/supplier.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/countrymaster/countrymasterlist.dart';

class CountryMasterAdd extends StatefulWidget {
  CountryMasterAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _CountryMasterAddState createState() => _CountryMasterAddState();
}

class _CountryMasterAddState extends State<CountryMasterAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  var _jsonData = [];
  TextEditingController _country = new TextEditingController();

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

    uri = 'https://www.cloud.equalsoftlink.com/api/getcountrylist?dbname=' +
        db +
        '&id=' +
        id;

    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);
    //print('4');

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    //print(jsonData);

    _country.text = getValue(jsonData['country'], 'C');

    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var country = _country.text;

      var id = widget.xid;
      id = int.parse(id);

      uri = 'https://www.cloud.equalsoftlink.com/api/api_addcountry?dbname=' +
          db +
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
                builder: (_) => CountryMasterList(
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
          'Country Master [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ',
          style:
              GoogleFonts.abel(fontSize: 25.0, fontWeight: FontWeight.normal),
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
              controller: _country,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Name Of Country',
                labelText: 'Name Of Country',
              ),
              onChanged: (value) {
                _country.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _country.selection);
              },
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
