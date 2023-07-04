import 'dart:convert';
import 'dart:developer';

import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';
import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/report/account/report_ledger.dart';
//import 'package:myfirstapp/screens/account/ledger_report.dart';
import '../../common/global.dart' as globals;

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

class Mastermenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  Mastermenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _MastermenuState createState() => _MastermenuState();
}

class _MastermenuState extends State<Mastermenu> {
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');
  List _partylist = [];
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Master Menu',
          style:
              GoogleFonts.abel(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => {gotoPartyMaster(context)},
                child: Text('Party Master',
                    style: GoogleFonts.oswald(
                        fontSize: 22.0, fontWeight: FontWeight.normal)),
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
