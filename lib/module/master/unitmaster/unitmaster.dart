import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/eqtextfield.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;

class UnitMaster extends StatefulWidget {
  UnitMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _UnitMasterState createState() => _UnitMasterState();
}

class _UnitMasterState extends State<UnitMaster> {
  List ItemDetails = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _unitname = new TextEditingController();
  //TextEditingController _unitid = new TextEditingController();

  @override
  void initState() {
    super.initState();
    var curDate = getsystemdate();
    //_date.text = curDate.toString().split(' ')[0];

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
        "${globals.cdomain2}/api/api_unitlist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _unitname.text = getValue(jsonData['unit'], 'C');
    //_unitid.text = jsonData['id'].toString();
    id = jsonData['id'].toString();
    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> UnitVld() async {
      String uri = '';
      var companyid = widget.xcompanyid;
      var clientid = globals.dbname;
      var unitname = _unitname.text;
      var id = widget.xid;
      id = int.parse(id);
      uri =
          "${globals.cdomain2}/api/api_unitlist?dbname=$clientid&cno=$companyid&unit=$unitname";
      var response = await http.get(Uri.parse(uri));
      print(uri);
      var jsonData = jsonDecode(response.body);
      jsonData = jsonData['Code'];
      var cCode = "";
      cCode = jsonData['Code'];
      if (cCode != 100) {
        showAlertDialog(context, 'Unit Name Allready Exit !!! ');
      }
      return true;
    }

    Future<bool> saveData() async {
      //UnitVld();
      String uri = '';
      var companyid = widget.xcompanyid;
      var clientid = globals.dbname;
      var unitname = _unitname.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "${globals.cdomain2}/api/api_unitmststort?dbname=$clientid" +
              "&unit=" +
              unitname +
              "&id=" +
              id.toString();
      //print(uri);
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
      appBar: EqAppBar(AppBarTitle: "Unit Master"),
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
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _unitname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Unit',
                    labelText: 'Unit',
                    onTap: () {
                      // gotoAgentScreen(context);
                    },
                    onChanged: (value) {
                      _unitname.value = _unitname.value.copyWith(
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
