import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/report/account/report_ledger.dart';
import 'package:cloud_mobile/report/account/show_ledger.dart';
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

class Ledgerview extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  Ledgerview({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _LedgerviewState createState() => _LedgerviewState();
}

class _LedgerviewState extends State<Ledgerview> {
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');
  List _partylist = [];
  String SelectedParty = '';
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();
  TextEditingController _partysel = new TextEditingController();

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
      setState(() {
        var retResult = result;

        print(retResult);
        _partylist = result[1];
        result = result[1];

        var selParty = '';
        SelectedParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
            SelectedParty = SelectedParty + retResult[1][ictr];
          }
          selParty = selParty + retResult[0][ictr];
          SelectedParty = SelectedParty + retResult[1][ictr].toString();
        }

        _partysel.text = selParty;

        print(SelectedParty);
      });
    }

    void GenerateReport(BuildContext context) async {
      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];

      var partylist = '';
      for (var ictr = 0; ictr < _partylist.length; ictr++) {
        if (ictr > 0) {
          partylist = partylist + ',';
        }
        partylist = partylist + _partylist[ictr].toString();
      }

      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ShowLedgerList(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    fromdate: fromdate,
                    todate: todate,
                    partylist: SelectedParty,
                  )));

      return;

      setState(() {
        var retResult = result;
        _partylist = result[1];
        print('xxxxxxxxx');
        print(_partylist);
        result = result[1];
        //print('ddddd');
        //print(result);
        var selParty = '';
        // for (var ictr = 0; ictr < result.length; ictr++) {
        //   if (ictr > 0) {
        //     selParty = selParty + ',';
        //   }
        //   selParty = selParty + result[ictr];
        // }

        //var selParty2 = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }
        _partysel.text = selParty;
      });
      //print(result);
    }

    Future<bool> getreportdata() async {
      var companyid = widget.xcompanyid;
      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];
      var partylist = '';
      for (var ictr = 0; ictr < _partylist.length; ictr++) {
        if (ictr > 0) {
          partylist = partylist + ',';
        }
        partylist = partylist + _partylist[ictr].toString();
      }
      // if (_partylist.length > 0) {
      //   partylist = _partylist[0].toString();
      // }

      partylist = partylist.replaceAll('/', '{{}}');

      String uri = '';

      //print('xxxx');
      var cfromdate = retconvdate(globals.startdate).toString();
      var ctodate = retconvdate(globals.enddate).toString();
      var cno = globals.companyid;
      var db = globals.dbname;
      print(partylist); //6288
      uri = 'https://www.cloud.equalsoftlink.com/api/api_genledger?dbname=' +
          db +
          '&party=' +
          partylist +
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
      //print('2');
      var response = await http.get(Uri.parse(uri));
      //print('3');
      var jsonData = jsonDecode(response.body);
      //print('4');

      jsonData = jsonData['Data'];

      //var list = jsonData['Data'] as List;
      //List<Item> itemsList = list.map((i) => Item.fromJSON(i)).toList();

      //print(itemsList);

      //print(jsonData);
      //print(uri);

      //http.Response response = await http.get(Uri.parse(Uri.encodeFull(uri)));
      //var response = await http.get(Uri.parse(uri));

      //print('1');
      //var Data = jsonDecode(response.body);
      //print('2');
      //Data = Data['Data'];
      //print('3');
      //print(Data);

      setState(() {
        _jsonData = jsonData;
      });
      return true;
    }

    void gotoLedgerReport(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'BANK',
                  )));

      //print('1234');

      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];

      //DialogBuilder(context).showLoadingIndicator('');
      await getreportdata();

      var ReportTitle = 'Account Ledger Report';
      var ReportTitle2 =
          'Reportitng Period Between ' + fromdate + ' To ' + todate;

      var oReport = new ReportPdf(ReportTitle, ReportTitle2);
      oReport.Data = _jsonData;

      var iCtr = 0;
      double dramt = 0;
      double cramt = 0;
      double runbal = 0;
      double totdramt = 0;
      double totcramt = 0;

      //var groupby = 'acname';
      var cgroup = '';
      var cNextGroup = '';
      oReport.xGroupBy = 'acname';
      //var cnextgroup = '';
      for (iCtr = 0; iCtr < _jsonData.length; iCtr++) {
        if ((iCtr + 1) < _jsonData.length) {
          cNextGroup = _jsonData[iCtr + 1]['acname'].toString();
        }
        if (cNextGroup != cgroup) {
          if (iCtr != 0) {
            _jsonData[iCtr + 1]['auto'] = 'Y';
          } else {
            _jsonData[iCtr]['auto'] = 'Y';
          }
          runbal = 0;
          totdramt = 0;
          totcramt = 0;
          cgroup = _jsonData[iCtr]['acname'].toString();
          _jsonData[iCtr]['autoword'] = cgroup;
          _jsonData[iCtr]['bold'] = 'Y';
        } else {
          _jsonData[iCtr]['auto'] = '';
          cgroup = _jsonData[iCtr]['acname'].toString();
          _jsonData[iCtr]['autoword'] = '';
          _jsonData[iCtr]['bold'] = '';
        }

        dramt = 0;
        cramt = 0;
        //print(_jsonData[iCtr]['dramt']);
        if (_jsonData[iCtr]['dramt'].toString() != '') {
          dramt = double.parse(_jsonData[iCtr]['dramt'].toString());
        }
        if (_jsonData[iCtr]['cramt'].toString() != '') {
          cramt = double.parse(_jsonData[iCtr]['cramt'].toString());
        }

        runbal = runbal + (dramt - cramt);
        totdramt = totdramt + dramt;
        totcramt = totcramt + cramt;

        if ((runbal) > 0) {
          _jsonData[iCtr]['balance'] = (runbal).toStringAsFixed(2) + ' Dr';
        } else {
          _jsonData[iCtr]['balance'] = (runbal).toStringAsFixed(2) + ' Cr';
        }
        cgroup = _jsonData[iCtr]['acname'].toString();
      }

      _jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': '',
        'dramt': totdramt.toStringAsFixed(2),
        'cramt': totcramt.toStringAsFixed(2),
        'balance': '',
        'bold': 'Y'
      });
      if ((runbal) > 0) {
        _jsonData.add({
          'date2': '',
          'acname': cgroup,
          'refacname': 'Closing Balance C/f Cr Amt',
          'dramt': '',
          'cramt': runbal.abs().toStringAsFixed(2),
          'balance': '',
          'bold': 'Y'
        });
      } else {
        _jsonData.add({
          'date2': '',
          'acname': cgroup,
          'refacname': 'Closing Balance C/f Dr Amt',
          'dramt': runbal.abs().toStringAsFixed(2),
          'cramt': '',
          'balance': '',
          'bold': 'Y'
        });
      }
      if ((totdramt - totcramt) > 0) {
        _jsonData.add({
          'date2': '',
          'acname': cgroup,
          'refacname': '',
          'dramt': (totdramt).toStringAsFixed(2),
          'cramt': (totdramt).toStringAsFixed(2),
          'balance': '',
          'bold': 'Y'
        });
      } else {
        _jsonData.add({
          'date2': '',
          'acname': cgroup,
          'refacname': '',
          'dramt': (totcramt).toStringAsFixed(2),
          'cramt': (totcramt).toStringAsFixed(2),
          'balance': '',
          'bold': 'Y'
        });
      }

      if ((runbal) > 0) {
        _jsonData.add({
          'date2': '',
          'acname': cgroup,
          'refacname': 'Balance Dr Amt',
          'dramt': runbal.abs().toStringAsFixed(2),
          'cramt': '',
          'balance': '',
          'bold': 'Y'
        });
      } else {
        _jsonData.add({
          'date2': '',
          'acname': cgroup,
          'refacname': 'Balance Cr Amt',
          'dramt': '',
          'cramt': runbal.abs().toStringAsFixed(2),
          'balance': '',
          'bold': 'Y'
        });
      }

      //print(_jsonData);
      oReport.addColumn('date2', 'Date', 'C', 10, 0, 'left', 'N', '');
      oReport.addColumn(
          'refacname', 'Description', 'C', 20, 0, 'left', 'N', '');
      oReport.addColumn('dramt', 'Debit', 'C', 10, 2, 'right', 'N', '');
      oReport.addColumn('cramt', 'Credit', 'C', 10, 2, 'right', 'N', '');
      oReport.addColumn('balance', 'Balance', 'C', 12, 2, 'right', 'N', '');

      //oReport.generate();
      final pdfFile2 = await oReport.generate();
      ;

      PdfApi.openFile(pdfFile2);

      //DialogBuilder(context).hideOpenDialog();
      return;

      final date2 = DateTime.now();
      final dueDate2 = date2.add(Duration(days: 7));

      final invoice2 = Invoice(
        supplier: Supplier(
          name: '',
          address: '',
          paymentInfo: '',
        ),
        customer: Customer(
          name: '',
          address: '',
        ),
        info: InvoiceInfo(
          date: date2,
          dueDate: dueDate2,
          description: 'My description...',
          number: '${DateTime.now().year}-9999',
        ),
        items: [
          InvoiceItem(
            description: 'Coffee',
            date: DateTime.now(),
            quantity: 3,
            vat: 0.19,
            unitPrice: 5.99,
          ),
        ],
      );

      final pdfFile = await PdfReportApi.generate(invoice2);

      PdfApi.openFile(pdfFile);
      return;
      // if (_partylist.length <= 0) {
      //   showAlertDialog(
      //       context, 'Select Atleast One Party To Generate Ledger Report!!!1');
      //   return;
      // }

      // DialogBuilder(context).showLoadingIndicator('Generating Report');
      // await getreportdata();

      // var result = await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => LedgerReport(
      //             companyid: widget.xcompanyid,
      //             companyname: widget.xcompanyname,
      //             fbeg: widget.xfbeg,
      //             fend: widget.xfend,
      //             fromDate: fromDate,
      //             toDate: toDate,
      //             partylist: _partylist,
      //             data: _jsonData)));

      // var result = await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => LedgerReport(
      //             companyid: widget.xcompanyid,
      //             companyname: widget.xcompanyname,
      //             fbeg: widget.xfbeg,
      //             fend: widget.xfend,
      //             fromDate: fromDate,
      //             toDate: toDate,
      //             partylist: _partylist,
      //             data: _jsonData)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ledger',
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
            TextFormField(
              controller: _partysel,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Select Party',
                labelText: 'Select Party',
              ),
              onTap: () {
                print('going to party screen');
                gotoPartyScreen(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                //onPressed: () => {gotoLedgerReport(context)},
                onPressed: () => {GenerateReport(context)},
                child: Text('Generate Report',
                    style: TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.normal)),
              ),
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
