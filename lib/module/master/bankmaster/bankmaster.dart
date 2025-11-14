// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:flutter/material.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/alert.dart';
import '../../../common/global.dart' as globals;

class BankMaster extends StatefulWidget {
  BankMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var orderchr;
  double totmtrs = 0;
  double tottaka = 0;
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;

  @override
  _BankMasterState createState() => _BankMasterState();
}

class _BankMasterState extends State<BankMaster> {
  List ItemDetails = [];
  var bookid = 0;
  DateTime fromDate = DateTime.now();
  var partyid = 0;
  DateTime toDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _head = new TextEditingController();
  TextEditingController _accname = new TextEditingController();
  TextEditingController _acctype = new TextEditingController();
  TextEditingController _bankname = new TextEditingController();
  TextEditingController _ifsccode = new TextEditingController();
  TextEditingController _accno = new TextEditingController();
  TextEditingController _accholdernaame = new TextEditingController();
  TextEditingController _accopening = new TextEditingController();
  TextEditingController _upiid = new TextEditingController();

  String dropdownDRCR = 'DR/CR';

  var DRCR = [
    'DR/CR',
    'DR',
    'CR',
  ];

  String dropdownAccType = "ACCTYPE";

  var Acctype = [
    'ACCTYPE',
    'BANK',
    'CASH',
  ];

  @override
  void initState() {
    super.initState();
    var curDate = getsystemdate();

    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> acctypeheadvld() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "${globals.cdomain2}/api/api_acctypeheadvld?dbname=$clientid&cno=$companyid&acctype=$dropdownAccType";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    _head.text = jsonData['acchead'].toString();
    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "${globals.cdomain2}/api/api_banklist?dbname=$clientid&cno=$companyid&id=$id";
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    //print(jsonData);
    _head.text = jsonData['acchead'].toString();
    _accname.text = jsonData['party'].toString();
    _acctype.text = getValue(jsonData['acctype'], 'C');
    _ifsccode.text = getValue(jsonData['ifsccode'], 'C');
    _accno.text = getValue(jsonData['bankacno'], 'C');
    _accholdernaame.text = getValue(jsonData['accholdername'], 'C');
    _bankname.text = getValue(jsonData['bankname'], 'C');
    dropdownDRCR = getValue(jsonData['type'], 'C');
    id = jsonData['id'].toString();
    dropdownAccType = getValue(jsonData['acctype'], 'C');
    if (dropdownAccType == '') {
      dropdownAccType = 'ACCTYPE';
    }
    if (dropdownDRCR == '') {
      dropdownDRCR = 'TYPE';
    }
    print(dropdownDRCR);
    if (dropdownDRCR == 'DR') {
      _accopening.text = getValue(jsonData['opening'], 'N');
    } else {
      _accopening.text = getValue(jsonData['opening'], 'N');
    }
    id = jsonData['id'].toString();
    setState(() {});

    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      //UnitVld();
      String uri = '';
      var companyid = widget.xcompanyid;
      var clientid = globals.dbname;
      var partyname = _accname.text;
      var head = _head.text;
      var acctype = _acctype.text;
      var ifsccode = _ifsccode.text;
      var bankacno = _accno.text;
      var accholdername = _accholdernaame.text;
      var opbalance = _accopening.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "${globals.cdomain2}/api/api_bankstort?dbname=$clientid" +
              "&party=" +
              partyname +
              "&acchead=" +
              head +
              "&acctype=" +
              dropdownAccType +
              "&ifsccode=" +
              ifsccode +
              "&bankacno=" +
              bankacno +
              "&accholdername=" +
              accholdername +
              "&type=" +
              dropdownDRCR +
              "&opbalance=" +
              opbalance +
              "&cno=" +
              companyid +
              "&id=" +
              id.toString();
      print(uri);
      var response = await http.post(Uri.parse(uri));
      var jsonData = jsonDecode(response.body);
      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];
      print(jsonCode);
      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else if (jsonCode == '100') {
        showAlertDialog(context, 'Error While Saving !!! ' + jsonMsg);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Saved !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.purple,
          fontSize: 16.0,
        );
      }
      return true;
    }

    setState(() {});

    setDefValue();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Bank Master",
      //     style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
      //   ),
      // ),
      appBar: EqAppBar(AppBarTitle: "Bank Master"),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.done),
      //     backgroundColor: Colors.green,
      //     onPressed: () => {saveData()}),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _accname,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  hintText: 'Account Name',
                  labelText: 'Account Name',
                  onTap: () {},
                  onChanged: (value) {
                    _accname.value = _accname.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),
              Expanded(
                child: DropdownButtonFormField(
                    value: dropdownAccType,
                    decoration: const InputDecoration(
                      labelText: 'ACCTYPE',
                    ),
                    items: Acctype.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownAccType = newValue!;
                        acctypeheadvld();
                      });
                    }),
              ),
            ]),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _head,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  hintText: 'AccHead',
                  labelText: 'AccHead',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {
                    _head.value = _head.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _accopening,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  hintText: 'AccOpening',
                  labelText: 'AccOpening',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {},
                ),
              ),
              Expanded(
                child: DropdownButtonFormField(
                    value: dropdownDRCR,
                    decoration: const InputDecoration(
                      labelText: 'DR/CR',
                      hintText: "DR/CR",
                    ),
                    items: DRCR.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownDRCR = newValue!;
                      });
                    }),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _accno,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    hintText: 'AccNo',
                    labelText: 'AccNo',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _ifsccode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    hintText: 'IFSC Code',
                    labelText: 'IFSC Code',
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    onChanged: (value) {
                      _ifsccode.value = _ifsccode.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _upiid,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    hintText: 'UPI ID',
                    labelText: 'UPI ID',
                    onTap: () {
                      //gotoAgentScreen(context);
                    },
                    onChanged: (value) {
                      _upiid.value = _upiid.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Expanded(
                //   child: EqTextField(
                //     controller: _bankname,
                //     textInputAction: TextInputAction.next,
                //     keyboardType: TextInputType.text,
                //     hintText: 'Bankname',
                //     labelText: 'Bankname',
                //     onTap: () {
                //       //gotoPartyScreen2(context, 'SALE PARTY', _party);
                //     },
                //     onChanged: (value) {
                //       _bankname.value = _bankname.value.copyWith(
                //         text: value.toUpperCase(),
                //         selection:
                //             TextSelection.collapsed(offset: value.length),
                //       );
                //     },
                //   ),
                // ),
                Expanded(
                  child: EqTextField(
                    controller: _accholdernaame,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    hintText: 'Acc Holder Name',
                    labelText: 'Acc Holder Name',
                    onTap: () {
                      //gotoAgentScreen(context);
                    },
                    onChanged: (value) {
                      _accholdernaame.value = _accholdernaame.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: const Color.fromARGB(231, 255, 255, 255),
                      ), // Text style
                      backgroundColor: Colors.green,
                      // Background color
                    ),
                    onPressed: () {
                      saveData();
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ), // Text style
                      backgroundColor: Colors.green, // Background color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "CANCEL !!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.purple,
                        fontSize: 16.0,
                      );
                    },
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
