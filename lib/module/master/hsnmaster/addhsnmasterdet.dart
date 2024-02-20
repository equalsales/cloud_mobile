// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/alert.dart';
import '../../../common/global.dart' as globals;

class HSNMasterDetAdd extends StatefulWidget {
  HSNMasterDetAdd({Key? mykey, companyid, companyname, fbeg, fend, itemDet, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xItemDetails = itemDet;

    //print('in Item Details');
    //print(xItemDetails);
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;

  List xitemDet = [];
  List xItemDetails = [];
  List _itemlist = [];
  List _Packinglist = [];

  @override
  _HSNMasterDetAddState createState() => _HSNMasterDetAddState();
}

class _HSNMasterDetAddState extends State<HSNMasterDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _type = new TextEditingController();
  TextEditingController _fromrate = new TextEditingController();
  TextEditingController _torate = new TextEditingController();
  TextEditingController _cgstrate = new TextEditingController();
  TextEditingController _sgstrate = new TextEditingController();
  TextEditingController _igstrate = new TextEditingController();
   
  final _formKey = GlobalKey<FormState>();
  // final _twoDigitFormatter = TwoDigitFormatter();
 

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);
    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    _fromrate.text='0';
    _torate.text='999999';
    //print('Length :' + length.toString());
    if (length > 0) {
      setState(() {});
    }
  }




  String dropdownType = "LOCAL";

  var Type = [
    'LOCAL',
    'EXPORT',
  ];



  void setDefValue() {}
  Future<bool> saveData() async {
    String uri = '';
    var companyid = globals.companyid;
    var clientid = globals.dbname;
    //var orderno = _orderno.text;
    //var orderchr = _orderchr.text;
    var type = _type.text;
    var fromrate = _fromrate.text;
    var torate = _torate.text;
    var sgstrate = _sgstrate.text;
    var cgstrate = _cgstrate.text;
    var igstrate = _igstrate.text;

    // var itemname = _itemname.text;
    // var packtype = _packtype.text;
    // var pcs = _pcs.text;
    // var unit = _unit.text;
    // var remarks = _remarks.text;
    // var rate = _rate.text;
    // var entryid = _entryid.text;
    // if (entryid == '') {
    //   entryid = '0';
    // }
    // if (orderno == '') {
    //   orderno = '0';
    // }
    // if (orderchr == '') {
    //   orderchr = '0';
    // }

    // if (_type.text == '') {
    //   showAlertDialog(context, 'Pcs Blank in this Item');
    //   return false;
    // }

    // if (orderchr == '') {
    //   _rate(_rate.text*100)/100;
    // }

    widget.xitemDet.add({
      // 'orderno': orderno,
      // 'orderchr': orderchr,
      'type': type,
      'fromrate': fromrate,
      'torate': torate,
      'sgstrate': sgstrate,
      'cgstrate': cgstrate,
      'igstrate': igstrate,
      'controlid': widget.xid
    });
    Navigator.pop(context, widget.xitemDet);
    return true;
  }

  var _total;

  @override
  Widget build(BuildContext context) {
    setDefValue();
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "Gst Rate Details[ ]"),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.done),
      //     backgroundColor: Colors.green,
      //     onPressed: () => {saveData()}),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: DropdownButtonFormField(
                    value: dropdownType,
                    decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Type',
                        hintText: "Type"),
                    items: Type.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownType = newValue!;
                      });
                    }),
              ),
              Expanded(
                child: TextFormField(
                  controller: _fromrate,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  //initialValue: '0',
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'FromRate',
                    labelText: 'FromRate',
                  ),
                  onTap: () {
                    // gotoPackingScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _torate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ToRate',
                      labelText: 'ToRate',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _sgstrate,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGSTRate',
                      labelText: 'SGSTRate',
                    ),
                    onTap: () {
                      // // gotoBranchScreen(context);
                      // print("hi");
                      // double value1 = double.parse((_sgstrate.text!='') ?_sgstrate.text : '0');
                      // double value2 = double.parse((_cgstrate.text!='') ?_cgstrate.text : '0');

                      //   double sum = value1 + value2;
                      //   print('Sum: $sum');
                      // setState(() {});
                    },
                    onChanged: (value) {
                      //   //_cgstrate = _sgstrate;
                      //    double.parse((_sgstrate.text != '')
                      // ? _sgstrate.text
                      // : '0'))
                      double sgstrate = double.parse(
                          (_sgstrate.text != '') ? _sgstrate.text : '0');
                      //double sgstrate = getValueN(_sgstrate.text);
                      _cgstrate.text = sgstrate.toStringAsFixed(2);
                      double cgstrate = getValueN(_cgstrate.text);
                      double igstrate = cgstrate + sgstrate;
                      //print(sgstrate);
                      //print(cgstrate);
                      _igstrate.text = igstrate.toStringAsFixed(2);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cgstrate,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGSTRate',
                      labelText: 'CGSTRate',
                    ),
                    onTap: () {},
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _igstrate,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGSTRate',
                      labelText: 'IGSTRate',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    onChanged: (value) {
                      // _remarks.value = TextEditingValue(
                      //     text: value.toUpperCase(),
                      //     selection: _remarks.selection);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 25,color: const Color.fromARGB(231, 255, 255, 255),), // Text style
                      backgroundColor: Colors.green, 
                      // Background color
                    ),
                    onPressed: () {
                      saveData();
                    },
                    child: const Text('SAVE',style: TextStyle(fontSize: 20,color: Color.fromARGB(231, 255, 255, 255),),),
                  )),
                  SizedBox(
                   width: 10
                  ),
                  Expanded(
                    child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 25,color: Color.fromARGB(231, 255, 255, 255),), // Text style
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
                    child: const Text('CANCEL',style: TextStyle(fontSize: 20,color: Color.fromARGB(231, 255, 255, 255),),),
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
