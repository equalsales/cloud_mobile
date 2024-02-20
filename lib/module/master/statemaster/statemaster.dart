import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/eqtextfield.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;

class StateMaster extends StatefulWidget {
  StateMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _StateMasterState createState() => _StateMasterState();
}

class _StateMasterState extends State<StateMaster> {
  List ItemDetails = [];
  var bookid = 0;
  DateTime fromDate = DateTime.now();
  var partyid = 0;
  DateTime toDate = DateTime.now();

  
  final _formKey = GlobalKey<FormState>();
  
  
  TextEditingController _statename = new TextEditingController();
  TextEditingController _statecode = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  

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
        "https://www.cloud.equalsoftlink.com/api/api_statelist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _statename.text = getValue(jsonData['state'], 'C');
    _statecode.text = getValue(jsonData['statecode'], 'C');
    _country.text = getValue(jsonData['country'], 'C');
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
      var statecode = _statecode.text;
      var country = _country.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "https://www.cloud.equalsoftlink.com/api/api_statestort?dbname=$clientid" +
              "&state=" +
              statename +
              "&statecode=" +
              statecode +
              "&country=" +
              country +
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
      appBar: EqAppBar(AppBarTitle: "State Master"),
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
                    controller: _statename,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'State name',
                    labelText: 'State name',
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
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _statecode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'State Code',
                    labelText: 'State Code',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _country,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Country ',
                    labelText: 'Country ',
                    onTap: () {
                      //gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    onChanged: (value) {
                      _country.value = _country.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                ),
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
