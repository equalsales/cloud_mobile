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



class DesignMaster extends StatefulWidget {
  DesignMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _DesignMasterState createState() => _DesignMasterState();
}

class _DesignMasterState extends State<DesignMaster> {
  List ItemDetails = [];
 

 
  final _formKey = GlobalKey<FormState>();
  TextEditingController _design = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _printname = new TextEditingController();
 
  

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
        "https://www.cloud.equalsoftlink.com/api/api_designlist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _design.text = getValue(jsonData['design'], 'C');
    _itemname.text = getValue(jsonData['itemname'], 'C');
    _printname.text = getValue(jsonData['printname'], 'C');
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
      var design = _design.text;
      var itemname = _itemname.text;
      var printname = _printname.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "https://www.cloud.equalsoftlink.com/api/api_designstort?dbname=$clientid" +
              "&design=" +
              design +
              "&itemname=" +
              itemname +
              "&printname=" +
              printname +
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

    setState(() {
    });

    setDefValue();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("City Master",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
      //   ),
      // ),
      appBar: EqAppBar(AppBarTitle: "Design Master"),
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
                    controller: _design,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Design Name',
                    labelText: 'Design Name',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {
                      _design.value = _design.value.copyWith(
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
                    controller: _itemname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Item Name',
                    labelText: 'Item Name',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {
                      _itemname.value = _itemname.value.copyWith(
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
                    controller: _printname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Printname',
                    labelText: 'Printname',
                    onTap: () {
                      // gotoAgentScreen(context);
                    },
                    onChanged: (value) {
                      _printname.value = _printname.value.copyWith(
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
          ],
        ),
      )),
    );
  }
}
