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

class DriverMaster extends StatefulWidget {
  DriverMaster(
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
  _DriverMasterState createState() => _DriverMasterState();
}

class _DriverMasterState extends State<DriverMaster> {
  List ItemDetails = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _drivername = new TextEditingController();
  @override
  void initState() {
    super.initState();

    // if (widget.xonlineValue != '') {
    //   setState(() {
    //     _drivername.text = widget.xonlineValue.toString().toUpperCase();
    //   });
    // }
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
        "${globals.cdomain}/api/api_driverlist?dbname=$clientid&cno=$companyid&id=$id";

    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _drivername.text = getValue(jsonData['driver'], 'C');
    id = jsonData['id'];
    return true;
  }

  Future<bool> saveData() async {
    String uri = '';
    var cno = widget.xcompanyid;
    var db = globals.dbname;
    var drivername = _drivername.text;
    var user = globals.username;
    var id = widget.xid;
    id = int.parse(id);
    //http://127.0.0.1:9000/api/api_storedrivermst?dbname=admin_looms&cno=3&driver=GHANSHYAM EQUAL1&user=KRISHNA

    uri =
        "${globals.cdomain}/api/api_storedrivermst?dbname=$db&cno=$cno&driver=$drivername&user=$user";
    
    print('saveData');
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
      Navigator.pop(context, [drivername, jsonData['id']]);
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
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "Driver Master"),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: driverTextField(),
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

  EqTextField driverTextField() {
    return EqTextField(
      controller: _drivername,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autofocus: true,
      hintText: 'Driver',
      labelText: 'Driver',
      onTap: () {},
      onChanged: (value) {
        _drivername.value = _drivername.value.copyWith(
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
