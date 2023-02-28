import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';
//import 'package:myfirstapp/screens/account/ledger_report.dart';
import '../../common/alert.dart' as globals;

import 'package:cloud_mobile/common/bottombar.dart';

//import 'package:myfirstapp/screens/dashboard/sidebar.dart';

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
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();
  TextEditingController _partysel = new TextEditingController();

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

      setState(() {
        _partylist = result;
        print('ddddd');
        print(result);
        var selParty = '';
        for (var ictr = 0; ictr < result.length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + result[ictr];
        }
        _partysel.text = selParty;
      });
      //print(result);
    }

    void gotoLedgerReport(BuildContext context) async {
      //print(_partylist.length);
      if (_partylist.length <= 0) {
        showAlertDialog(
            context, 'Select Atleast One Party To Generate Ledger Report!!!1');
        return;
      }

      /*
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Ledgerreport(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    fromDate: fromDate,
                    toDate: toDate,
                    partylist: _partylist,
                  )));
                  */
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger'),
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
            ElevatedButton(
              onPressed: () => {gotoLedgerReport(context)},
              child: Text('Generate Report', style: TextStyle(fontSize: 22.0)),
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
