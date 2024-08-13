// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/list/worker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class TakaProductionDetAdd extends StatefulWidget {
  TakaProductionDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partyid,
      itemDet,
      id,
      branchid})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xbranchid = branchid;
    xItemDetails = itemDet;
    //xitemDet = itemDet;

    print('in Item Details');
    print(xbranch);
    print(xparty);
    print(xItemDetails);
    print(xbranchid);
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xbranch;
  var xbranchid;
  var xparty;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _TakaProductionDetAddState createState() => _TakaProductionDetAddState();
}

class _TakaProductionDetAddState extends State<TakaProductionDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _date = new TextEditingController();
  TextEditingController _worker = new TextEditingController();
  TextEditingController _meters =
      new TextEditingController(text: 0.00.toString());
  TextEditingController _rate =
      new TextEditingController(text: 0.00.toString());
  TextEditingController _amount =
      new TextEditingController(text: 0.00.toString());

  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = DateFormat("dd-MM-yyyy").format(curDate);

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _date.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  void gotoWorkerScreen(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => worker_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  acctype: '',
                )));
    setState(() {
      var retResult = result;
      var newResult = result[1];
      var selJogname = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selJogname = selJogname + ',';
        }
        selJogname = selJogname + retResult[0][ictr];
      }
      setState(() {
        _worker.text = newResult[0]['worker'].toString();
      });
    });
  }

  calamount() {
    var rate = double.parse(_rate.text);
    var meters = double.parse(_meters.text);
    var amount = 0.0;

    amount = meters * rate;

    setState(() {
      _amount.text = amount.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      // var cno = globals.companyid;
      // var db = globals.dbname;
      // var username = globals.username;
      // var ctakano = _ctakano.text;

      var date = _date.text;
      var worker = _worker.text;
      var meters = _meters.text;
      var rate = _rate.text;
      var amount = _amount.text;

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      String newdate = DateFormat("yyyy-MM-dd").format(parsedDate);

      widget.xitemDet.add({
        'date': newdate,
        'worker': worker,
        'meters': meters,
        'rate': rate,
        'amount': amount,
      });
      Navigator.pop(context, widget.xitemDet);
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taka Production Item Details[ ] ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {
                if (_formKey.currentState!.validate())
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Form submitted successfully')),
                    ),
                    saveData()
                  }
              }),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _date,
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
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _worker,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Worker',
                      labelText: 'Select Worker',
                    ),
                    onTap: () {
                      gotoWorkerScreen(context);
                    },
                    validator: (value) {
                      if (value == '') {
                        return "Please enter worker";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _meters,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Meters',
                      labelText: 'Meters',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calamount();
                    },
                    validator: (value) {
                      if (value == '' ||
                          value == '0' ||
                          value == '0.' ||
                          value == '0.000' ||
                          value == '0.00' ||
                          value == '0.0') {
                        return "Please enter Meter";
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _rate,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calamount();
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _amount,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Amount',
                      labelText: 'Amount',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
