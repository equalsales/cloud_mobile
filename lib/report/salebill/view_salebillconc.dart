import 'dart:convert';
import 'dart:developer';

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

class SaleBillConcView extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var dropdownvalue = 'PARTY';
  SaleBillConcView({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _SaleBillConcViewState createState() => _SaleBillConcViewState();
}

class _SaleBillConcViewState extends State<SaleBillConcView> {
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');
  List _partylist = [];
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();
  TextEditingController _partysel = new TextEditingController();
  TextEditingController _booksel = new TextEditingController();
  TextEditingController _agentsel = new TextEditingController();
  TextEditingController _hastesel = new TextEditingController();
  TextEditingController _transportsel = new TextEditingController();
  TextEditingController _stationsel = new TextEditingController();

  var _jsonData = [];

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    _fromdate.text = fromDate.toString().split(' ')[0];
    _todate.text = toDate.toString().split(' ')[0];
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
    //String dropdownvalue = 'PARTY';

    void gotoPartyScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'SALE PARTY',
                  )));

      setState(() {
        var retResult = result;
        _partylist = result[1];
        result = result[1];
        var selParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }
        _partysel.text = selParty;
      });
    }

    Future<bool> getreportdata() async {
      var companyid = widget.xcompanyid;
      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];
      var partylist = '';
      var groupby = widget.dropdownvalue;
      groupby = groupby.toLowerCase();
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
      //print(partylist); //6288

      uri =
          'https://www.cloud.equalsoftlink.com/api/api_salelrpending?dbname=' +
              db +
              '&conc=Y' +
              '&fromdate=' +
              fromdate +
              '&todate=' +
              todate +
              '&cfromdate=' +
              cfromdate +
              '&party=' +
              partylist +
              '&ctodate=' +
              ctodate +
              '&cno=' +
              cno +
              '&groupby=' +
              groupby;

      //print('2');
      var response = await http.get(Uri.parse(uri));
      //print('3');
      var jsonData = jsonDecode(response.body);
      //print('4');

      jsonData = jsonData['Data'];

      /*
      jsonData.sort((a, b) {
        return a.party.toLowerCase().compareTo(b.party.toLowerCasepp());
      });*/

      //print(jsonData);

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

    void gotoReport(BuildContext context) async {
      //print(dropdownvalue);
      print(widget.dropdownvalue);
      var groupby = widget.dropdownvalue;
      groupby = groupby.toLowerCase();
      //print('1234');
      //print()

      var fromdate = fromDate.toString().split(' ')[0];
      var todate = toDate.toString().split(' ')[0];

      //DialogBuilder(context).showLoadingIndicator('');
      await getreportdata();

      var ReportTitle = 'Sales Bill Report';
      var ReportTitle2 =
          'Reportitng Period Between ' + fromdate + ' To ' + todate;

      var oReport = new ReportPdf(ReportTitle, ReportTitle2);
      oReport.Data = _jsonData;

      oReport.landscape = 'Y';
      //oReport.xGroupBy = 'party';
      oReport.xGroupBy = groupby;

      oReport.addColumn('serial', 'Serial', 'C', 10, 0, 'left', 'N', '');
      oReport.addColumn('srchr', '(c)', 'C', 3, 0, 'left', 'N', '');
      oReport.addColumn('date2', 'Date', 'C', 10, 0, 'left', 'N', '');
      oReport.addColumn('party', 'Party', 'C', 20, 0, 'left', 'N', '');
      oReport.addColumn('netamt', 'Bill Amt', 'C', 13, 2, 'right', 'N', 'SUM');
      oReport.addColumn('transport', 'Transport', 'C', 20, 0, 'left', 'N', '');
      oReport.addColumn('station', 'Station', 'C', 10, 0, 'left', 'N', '');
      oReport.addColumn('lrno', 'LR No.', 'C', 10, 0, 'left', 'N', '');

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

      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LedgerReport(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  fromDate: fromDate,
                  toDate: toDate,
                  partylist: _partylist,
                  data: _jsonData)));
    }

    var items = [
      'PARTY',
      'BOOK',
      'AGENT',
      'HASTE',
      'TRANSPORT',
      'STATION',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sale Bill Concise Report',
          style:
              GoogleFonts.abel(fontSize: 25.0, fontWeight: FontWeight.normal),
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
            DropdownButtonFormField(
                value: widget.dropdownvalue,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  //hintText: 'To Date',
                  labelText: 'Group By',
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down_circle),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.dropdownvalue = newValue!;
                    print(widget.dropdownvalue);
                  });
                }),
            // DropdownButton(
            //   value: dropdownvalue,
            //   icon: const Icon(Icons.keyboard_arrow_down),
            //   // Array list of items
            //   items: items.map((String items) {
            //     return DropdownMenuItem(
            //       value: items,
            //       child: Text(items),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       dropdownvalue = newValue!;
            //     });
            //   },
            // ),
            ElevatedButton(
              onPressed: () => {gotoReport(context)},
              child: Text('Generate Report',
                  style: GoogleFonts.oswald(
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
