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

class BookMaster extends StatefulWidget {
  BookMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _BookMasterState createState() => _BookMasterState();
}

class _BookMasterState extends State<BookMaster> {
  List ItemDetails = [];
  var bookid = 0;
  DateTime fromDate = DateTime.now();
  var partyid = 0;
  DateTime toDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _acchead = new TextEditingController();
  TextEditingController _bookname = new TextEditingController();
  TextEditingController _acctype = new TextEditingController();

  String dropdownAcctype = "ACCTYPE";

  var Acctype = [
    'ACCTYPE',
    'SALE BOOK',
    'SALE RETURN BOOK',
    'PURCHASE BOOK',
    'PURCHASE RETURN BOOK',
    'EXPENSE BOOK',
    'GREY PURCHASE BOOK',
    'GENERAL PURCHASE BOOK',
    'GREY RETURN BOOK',
    'GREY SALE BOOK',
    'INCOME SALE BOOK',
    'GREY SALE RETURN BOOK',
    'JOBWORK BOOK',
    'JOBWORK RETURN BOOK',
    'PROCESS BOOK',
  ];

  @override
  void initState() {
    super.initState();
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
        "https://www.cloud.equalsoftlink.com/api/api_acctypeheadvld?dbname=$clientid&cno=$companyid&acctype=$dropdownAcctype";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    _acchead.text = jsonData['acchead'].toString();
    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_booklist?dbname=$clientid&cno=$companyid&id=$id";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _acchead.text = jsonData['acchead'].toString();
    _bookname.text = jsonData['party'].toString();
    _acctype.text = getValue(jsonData['acctype'], 'C');
    dropdownAcctype = getValue(jsonData['acctype'], 'C');
    if (dropdownAcctype == '') {
      dropdownAcctype = 'ACCTYPE';
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
      var partyname = _bookname.text;
      var head = _acchead.text;
      var acctype = _acctype.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "https://www.cloud.equalsoftlink.com/api/api_bookstort?dbname=$clientid" +
              "&party=" +
              partyname +
              "&acchead=" +
              head +
              "&acctype=" +
              dropdownAcctype +
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
      //     "Book Master",
      //     style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
      //   ),
      // ),
      appBar: EqAppBar(AppBarTitle: "Book Master"),
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
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _bookname,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  hintText: 'Bookname',
                  labelText: 'Bookname',
                  onTap: () {},
                  onChanged: (value) {
                    _bookname.value = _bookname.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                      value: dropdownAcctype,
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
                          dropdownAcctype = newValue!;
                        });
                      }),
                ),
              ],
            ),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _acchead,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  hintText: 'AccHead',
                  labelText: 'AccHead',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {
                    _acchead.value = _acchead.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),
            ]),
            Padding(padding: EdgeInsets.all(5)),
          ],
        ),
      )),
    );
  }
}
