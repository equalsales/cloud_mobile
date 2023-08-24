import 'dart:convert';
import 'dart:developer';

import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';
import 'package:cloud_mobile/module/master/partygroupmaster/partygroupmasterlist.dart';
import 'package:cloud_mobile/module/master/countrymaster/countrymasterlist.dart';
import 'package:cloud_mobile/module/master/statemaster/statemasterlist.dart';
import 'package:cloud_mobile/module/master/citymaster/citymasterlist.dart';
import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
//import 'package:myfirstapp/screens/account/ledger_report.dart';
import '../../common/global.dart' as globals;

import 'package:cloud_mobile/common/bottombar.dart';

//// import 'package:google_fonts/google_fonts.dart';

class Transactionmenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  Transactionmenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _TransactionmenuState createState() => _TransactionmenuState();
}

class _TransactionmenuState extends State<Transactionmenu> {
  final _formKey = GlobalKey<FormState>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  var _jsonData = [];

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);
  }

  @override
  Widget build(BuildContext context) {
    void gotoPartyMaster(BuildContext context) async {
      //showAlertDialog(context, 'Party Master Clicked !!!');
      //return;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PartyMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));
    }

    void gotoPartyGroupMaster(BuildContext context) async {
      //showAlertDialog(context, 'Party Master Clicked !!!');
      //return;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PartyGroupMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));
    }

    void gotoCityMaster(BuildContext context) async {
      //showAlertDialog(context, 'Party Master Clicked !!!');
      //return;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CityMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));
    }

    void gotoStateMaster(BuildContext context) async {
      //showAlertDialog(context, 'Party Master Clicked !!!');
      //return;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => StateMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));
    }

    void gotoCountryMaster(BuildContext context) async {
      //showAlertDialog(context, 'Party Master Clicked !!!');
      //return;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CountryMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Menu',
          style:
            TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                onPressed: () => {gotoPartyMaster(context)},
                child: Text('Party Master',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                onPressed: () => {gotoPartyGroupMaster(context)},
                child: Text('Party Group Master',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                onPressed: () => {gotoCityMaster(context)},
                child: Text('City Master',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                onPressed: () => {gotoStateMaster(context)},
                child: Text('State Master',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                onPressed: () => {gotoCountryMaster(context)},
                child: Text('Country Master',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
