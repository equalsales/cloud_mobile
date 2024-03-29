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

class CountryMaster extends StatefulWidget {
  CountryMaster(
      {Key? mykey, companyid, companyname, fbeg, fend, id, onlineValue})
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
  _CountryMasterState createState() => _CountryMasterState();
}

class _CountryMasterState extends State<CountryMaster> {
  List ItemDetails = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _countryname = new TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.xonlineValue != '') {
      setState(() {
        _countryname.text = widget.xonlineValue.toString().toUpperCase();
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
        "https://www.cloud.equalsoftlink.com/api/api_countrylist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _countryname.text = getValue(jsonData['country'], 'C');
    id = jsonData['id'].toString();
    return true;
  }

  Future<bool> saveData() async {
    //UnitVld();
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var countryname = _countryname.text;
    var id = widget.xid;
    id = int.parse(id);
    //print('In Save....');
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_countrystort?dbname=$clientid" +
            "&country=" +
            countryname +
            "&id=" +
            id.toString();
    print('dhruv');
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
      Navigator.pop(context, [countryname, jsonData['id']]);
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

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    setState(() {});

    setDefValue();
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "Country Master"),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: countryTextField(),
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
      )),
    );
  }

  EqTextField countryTextField() {
    return EqTextField(
      controller: _countryname,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autofocus: true,
      hintText: 'Country',
      labelText: 'Country',
      onTap: () {
        // gotoAgentScreen(context);
      },
      onChanged: (value) {
        _countryname.value = _countryname.value.copyWith(
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
        saveData();
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
