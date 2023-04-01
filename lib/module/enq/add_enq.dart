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
import 'package:cloud_mobile/module/enq/enqlist.dart';

class EnqAdd extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  EnqAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }
  @override
  _EnqAddState createState() => _EnqAddState();
}

class _EnqAddState extends State<EnqAdd> {
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');
  List _partylist = [];
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _type = new TextEditingController();
  TextEditingController _business = new TextEditingController();
  TextEditingController _node = new TextEditingController();
  TextEditingController _amc = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _conf = new TextEditingController();
  TextEditingController _partysel = new TextEditingController();

  var _jsonData = [];

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    _fromdate.text = fromDate.toString().split(' ')[0];

    //print('0');
    //_todate.text = toDate.toString().split(' ')[0];
  }

  void setDefValue() {
    _node.text = '0';
    _amc.text = '0';
    _amount.text = '0';
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
        //_todate.text = picked.toString().split(' ')[0];
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

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var name = _name.text;
      var address = _address.text;
      var city = _city.text;
      var type = _type.text;
      var business = _business.text;
      var node = _node.text;
      var amc = _amc.text;
      var amount = _amount.text;
      var conf = '';
      var id = widget.xid;
      id = int.parse(id);

      uri = 'https://www.cloud.equalsoftlink.com/api/api_createenq?dbname=' +
          db +
          '&name=' +
          name +
          '&address=' +
          address +
          '&city=' +
          city +
          '&type=' +
          type +
          '&business=' +
          business +
          '&node=' +
          node +
          '&amc=' +
          amc +
          '&amount=' +
          amount +
          '&conf=' +
          conf +
          '&id=' +
          id.toString();

      print(uri);
      var response = await http.get(Uri.parse(uri));

      var jsonData = jsonDecode(response.body);
      //print('4');

      jsonData = jsonData['Data'];

      showAlertDialog(context, 'Saved !!!');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EnqList(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                  )));
      return true;
    }

    Future<bool> loadData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var id = widget.xid;

      uri = 'https://www.cloud.equalsoftlink.com/api/api_enqlist?dbname=' +
          db +
          '&id=' +
          id;

      var response = await http.get(Uri.parse(uri));

      var jsonData = jsonDecode(response.body);
      //print('4');

      jsonData = jsonData['Data'];
      jsonData = jsonData[0];
      print(jsonData);

      _name.text = jsonData['name'];
      _address.text = jsonData['address'];
      _city.text = jsonData['city'];
      _type.text = jsonData['type'];
      _business.text = jsonData['business'];
      _amount.text = jsonData['amount'];
      _node.text = jsonData['node'];
      _amc.text = jsonData['amc'];

      print(_name.text);

      return true;
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
              cno;

      //print('2');
      var response = await http.get(Uri.parse(uri));
      //print('3');
      var jsonData = jsonDecode(response.body);
      //print('4');

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

      //DialogBuilder(context).showLoadingIndicator('');
      await getreportdata();

      var ReportTitle = 'Account Ledger Report';
      var ReportTitle2 =
          'Reportitng Period Between ' + fromdate + ' To ' + todate;

      var oReport = new ReportPdf(ReportTitle, ReportTitle2);
      oReport.Data = _jsonData;

      oReport.landscape = 'Y';
      oReport.xGroupBy = 'party';

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
    }

    String dropdownvalueType = 'CLOUD';
    var items = [
      'CLOUD',
      'OFFLINE',
    ];

    String dropdownvalueBusiness = 'TRADING';
    var itemsBusiness = [
      'TRADING',
      'ADHAT',
      'AGENCY',
      'EMBROIDERY',
      'LOOMS',
      'USERDEFINED',
      'RETAIL',
    ];

    setDefValue();

    if (int.parse(widget.xid) > 0) {
      loadData();
    }
    print('1');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enquiry [ ' + (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') + ' ] ',
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
              controller: _fromdate,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Date',
                labelText: 'Date',
              ),
              onTap: () {
                _selectDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _name,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Name Of Customer',
                labelText: 'Name Of Customer',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address',
                labelText: 'Address',
              ),
              onTap: () {
                //_selecttoDate(context);
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
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            DropdownButtonFormField(
                value: dropdownvalueType,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: 'Type',
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
                    dropdownvalueType = newValue!;
                  });
                }),
            DropdownButtonFormField(
                value: dropdownvalueBusiness,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: 'Type Of Business',
                ),
                items: itemsBusiness.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down_circle),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalueBusiness = newValue!;
                  });
                }),
            TextFormField(
              controller: _amount,
              //initialValue: _amount.text,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Value',
                labelText: 'Value',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _node,
              //initialValue: _node.text,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Node',
                labelText: 'Node',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _amc,
              //initialValue: _amc.text,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'AMC',
                labelText: 'AMC',
              ),
              onTap: () {
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
