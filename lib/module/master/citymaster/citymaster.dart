// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/projFunction.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:flutter/material.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/alert.dart';
import '../../../common/global.dart' as globals;

class CityMaster extends StatefulWidget {
  CityMaster({Key? mykey, companyid, companyname, fbeg, fend, id, onlineValue})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xonlineValue = onlineValue;
  }

  var orderchr;
  double totmtrs = 0;
  double tottaka = 0;
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xonlineValue;

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

    if ((widget.xonlineValue != '') && (widget.xonlineValue != null)) {
      setState(() {
        _cityname.text = widget.xonlineValue.toString().toUpperCase();
      });
    }
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

  void gotoStateScreen(BuildContext context) async {
    var result = await openState_List(context, widget.xcompanyid,
        widget.xcompanyname, widget.xfbeg, widget.xfbeg);

    print(result);

    var retResult = result[0];
    var selState = '';
    for (var ictr = 0; ictr < retResult.length; ictr++) {
      if (ictr > 0) {
        selState = selState + ',';
      }
      selState = selState + retResult[ictr];
    }
    setState(() {
      _statename.text = selState;
    });
  }

  void setDefValue() {}

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
    print(jsonData);
    if (jsonCode == '500') {
      showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
    } else if (jsonCode == '100') {
      showAlertDialog(context, 'Error While Saving !!! ' + jsonMsg);
    } else {
      //Navigator.pop(context);
      Navigator.pop(context, [cityname, jsonData['id'], statename]);
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

  @override
  Widget build(BuildContext context) {
    setDefValue();
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "City Master"),
      body: SingleChildScrollView(child: cityMasterForm()),
    );
  }

  Form cityMasterForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(child: cityTextfield()),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: stateTextField(),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(5)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: saveTextButton()),
                SizedBox(width: 10),
                Expanded(child: cancelTextButton())
              ],
            ),
          )
        ],
      ),
    );
  }

  EqTextField cityTextfield() {
    return EqTextField(
      controller: _cityname,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autofocus: true,
      hintText: 'City',
      labelText: 'City',
      onTap: () {
        //gotoPartyScreen2(context, 'SALE PARTY', _party);
      },
      onChanged: (value) {
        _cityname.value = _cityname.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField stateTextField() {
    return EqTextField(
      controller: _statename,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      hintText: 'State',
      labelText: 'State',
      onTap: () {
        gotoStateScreen(context);
        // gotoAgentScreen(context);
      },
      onChanged: (value) {
        _statename.value = _statename.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  TextButton saveTextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),

        textStyle: TextStyle(
          fontSize: 25,
          color: const Color.fromARGB(231, 255, 255, 255),
        ), // Text style
        backgroundColor: Colors.green,
        // Background color
      ),
      onPressed: () {
        this.saveData();
      },
      child: const Text(
        'SAVE',
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(231, 255, 255, 255),
        ),
      ),
    );
  }

  TextButton cancelTextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),

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
    );
  }
}
