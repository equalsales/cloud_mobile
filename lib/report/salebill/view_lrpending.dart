import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';
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

// import 'package:google_fonts/google_fonts.dart';

class LRPendingView extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  LRPendingView({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _LRPendingViewState createState() => _LRPendingViewState();
}

class _LRPendingViewState extends State<LRPendingView> {
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');

  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();

  var _jsonData = [];

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    _fromdate.text = fromDate.toString().split(' ')[0];
    _todate.text = toDate.toString().split(' ')[0];
  }

  //DateTime selectedDate = DateTime.parse();
  List _companydetails = [];

  Future<bool> companydetails(_user, _pwd) async {
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _fromdate.text = picked.toString().split(' ')[0];
        //print(fromDate);
      });
  }

  Future<void> _selecttoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
        _todate.text = picked.toString().split(' ')[0];
        //print(toDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> getreportdata() async {
      var companyid = widget.xcompanyid;
      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];

      String uri = '';

      //print('xxxx');
      var cfromdate = retconvdate(globals.startdate).toString();
      var ctodate = retconvdate(globals.enddate).toString();
      var cno = globals.companyid;
      var db = globals.dbname;

      cfromdate = cfromdate.toString().split(' ')[0];
      ctodate = ctodate.toString().split(' ')[0];

      uri =
          'https://www.cloud.equalsoftlink.com/api/api_salelrpending?dbname=' +
              db +
              '&fromdate=' +
              fromdate +
              '&todate=' +
              todate +
              '&cfromdate=' +
              cfromdate +
              '&ctodate=' +
              ctodate +
              '&cno=' +
              cno;

      print(uri);
      var response = await http.get(Uri.parse(uri));

      var jsonData = jsonDecode(response.body);

      jsonData = jsonData['Data'];

      setState(() {
        _jsonData = jsonData;
      });
      return true;
    }

    void gotoReport(BuildContext context) async {
      //print('1234');

      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];

      DialogBuilder(context).showLoadingIndicator('');
      await getreportdata();

      var ReportTitle = 'LR Pending Report';
      var ReportTitle2 =
          'Reportitng Period Between ' + fromdate + ' To ' + todate;

      var oReport = new ReportPdf(ReportTitle, ReportTitle2);
      print(_jsonData);
      oReport.Data = _jsonData;
      oReport.landscape = 'Y';

      oReport.addColumn('serial', 'Serial', 'C', 10, 0, 'left',  'N', '');
      oReport.addColumn('srchr', '(c)', 'C', 3, 0, 'left', 'N', '');
      oReport.addColumn('date2', 'Date', 'C', 10, 0, 'left', 'N', '');
      oReport.addColumn('party', 'Party', 'C', 20, 0, 'left', 'N', '');
      oReport.addColumn('netamt', 'Bill Amt', 'C', 13, 2, 'right', 'N', '');
      oReport.addColumn('transport', 'Transport', 'C', 20, 0, 'left', 'N', '');
      oReport.addColumn('station', 'Station', 'C', 20, 0, 'left', 'N', '');

      //oReport.generate();
      final pdfFile2 = await oReport.generate();
      ;

      PdfApi.openFile(pdfFile2);

      DialogBuilder(context).hideOpenDialog();
      return;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LR Pending Report',
          style:
              TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _fromdate,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'From Date',
                labelText: 'From Date',
              ),
              onTap: () {
                _selectDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _todate,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'To Date',
                labelText: 'To Date',
              ),
              onTap: () {
                _selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () => {gotoReport(context)},
              child: Text('Generate Report',
                  style: TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.normal)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Ledger ['+widget.xcompanyid+']'),
    //   ),
    //   body: Center(
    //       child: Column(children: <Widget>[
    //           Text('ssss', style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),),
    //           Text('ssss', style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),),
    //            FlatButton(
    //               onPressed: null,
    //               child: Text('From Date'),
    //             ),
    //           Container(
    //           width: 100,
    //           child: FlatButton(
    //               onPressed: null,
    //               child: Text('From Date'),
    //             )
    //           ),
    //           Container(
    //           width: 280,
    //           child: Text('Date')
    //           ),
    //           Container(
    //           width: 280,
    //           padding: EdgeInsets.all(10.0),
    //           child: RaisedButton(
    //               child: Text('Generate Ledger', style: TextStyle(fontSize: 15.0),),
    //             onPressed: () { /*executelogin(context);*/},
    //             )
    //           ),
    //       ],)
    //      //child: JobsListView()
    //   ),
    //   bottomNavigationBar: BottomAppBar(child: Text(widget.xcompanyname,
    //   style: TextStyle(color: Colors.white,fontSize: 15)),
    //   color: Colors.red,),
    // );
  }
}
