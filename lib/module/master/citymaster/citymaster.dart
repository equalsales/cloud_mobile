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

class CityMaster extends StatefulWidget {
  CityMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _CityMasterState createState() => _CityMasterState();
}

class _CityMasterState extends State<CityMaster> {
  List ItemDetails = [];
 

 
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cityname = new TextEditingController();
  TextEditingController _statename = new TextEditingController();
 
  

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
        "https://www.cloud.equalsoftlink.com/api/api_citylist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _cityname.text = getValue(jsonData['city'], 'C');
    _statename.text = getValue(jsonData['state'], 'C');
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
      var statename = _statename.text;
      var cityname = _cityname.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "https://www.cloud.equalsoftlink.com/api/api_citystort?dbname=$clientid" +
              "&state=" +
              statename +
              "&city=" +
              cityname +
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
      appBar: EqAppBar(AppBarTitle: "City Master"),
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
                    controller: _cityname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'City Name',
                    labelText: 'City Name',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {
                      _cityname.value = _cityname.value.copyWith(
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
                    controller: _statename,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Statename',
                    labelText: 'Statename',
                    onTap: () {
                      // gotoAgentScreen(context);
                    },
                    onChanged: (value) {
                      _statename.value = _statename.value.copyWith(
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
