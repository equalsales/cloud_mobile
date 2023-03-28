import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/report/account/report_ledger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
import 'package:cloud_mobile/report/salebill/view_lrpending.dart';
import 'package:cloud_mobile/report/salebill/view_salebillconc.dart';

class SaleBillMenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  SaleBillMenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _SaleBillMenuState createState() => _SaleBillMenuState();
}

class _SaleBillMenuState extends State<SaleBillMenu> {
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _companydetails = [];

  var _jsonData = [];

  @override
  void initState() {
    _companydetails.add({'menu': 'LR Pending'});
    _companydetails.add({'menu': 'Sale Bill Concise'});
  }

  @override
  Widget build(BuildContext context) {
    void gotoPartyScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: '',
                  )));

      //print(result);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sale Bill Report',
          style:
              GoogleFonts.abel(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
            child: ListView.builder(
          itemCount: this._companydetails.length,
          itemBuilder: (context, index) {
            print(this._companydetails[index]);
            String menu = this._companydetails[index]['menu'];

            return Card(
                child: Center(
                    child: ListTile(
              title: Text(menu,
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
              subtitle: Text(''),
              leading: Icon(Icons.select_all),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                //alert(context, menu, '');
                //sshowAlertDialog(context, menu);
                if (menu == 'LR Pending') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LRPendingView(
                              companyid: widget.xcompanyid,
                              companyname: widget.xcompanyname,
                              fbeg: widget.xfbeg,
                              fend: widget.xfend)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SaleBillConcView(
                              companyid: widget.xcompanyid,
                              companyname: widget.xcompanyname,
                              fbeg: widget.xfbeg,
                              fend: widget.xfend)));
                }
              },
            )));
          },
        )
            //child: JobsListView()
            ),
      ),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );

    // );
  }
}
