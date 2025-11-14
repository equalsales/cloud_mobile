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

class ColorMaster extends StatefulWidget {
  ColorMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _ColorMasterState createState() => _ColorMasterState();
}

class _ColorMasterState extends State<ColorMaster> {
  List ItemDetails = [];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _colorname = new TextEditingController();
  TextEditingController _descr = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "${globals.cdomain2}/api/api_colorlist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _colorname.text = getValue(jsonData['color'], 'C');
    _descr.text = getValue(jsonData['descr'], 'C');
    id = jsonData['id'].toString();
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
      var colorname = _colorname.text;
      var descr = _descr.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "${globals.cdomain2}/api/api_colorstort?dbname=$clientid" +
              "&descr=" +
              descr +
              "&color=" +
              colorname +
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
      //   title: Text("City Master",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
      //   ),
      // ),
      appBar: EqAppBar(AppBarTitle: "Color Master"),
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
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _colorname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Color Name',
                    labelText: 'Color Name',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {
                      _colorname.value = _colorname.value.copyWith(
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
                    controller: _descr,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Description',
                    labelText: 'Description',
                    onTap: () {
                      // gotoAgentScreen(context);
                    },
                    onChanged: (value) {
                      _descr.value = _descr.value.copyWith(
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
