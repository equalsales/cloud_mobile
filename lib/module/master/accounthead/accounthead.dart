import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:flutter/material.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/alert.dart';
import '../../../common/global.dart' as globals;

class AccountHead extends StatefulWidget {
  AccountHead({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _AccountHeadState createState() => _AccountHeadState();
}

class _AccountHeadState extends State<AccountHead> {
  List ItemDetails = [];
  var bookid = 0;
  DateTime fromDate = DateTime.now();
  var partyid = 0;
  DateTime toDate = DateTime.now();


  final _formKey = GlobalKey<FormState>();
  TextEditingController _acchead = new TextEditingController();
  TextEditingController _paracchead = new TextEditingController();
  TextEditingController _index = new TextEditingController();
  TextEditingController _tdsnature = new TextEditingController();
  TextEditingController _altacchead = new TextEditingController();
  TextEditingController _active = new TextEditingController();

  String dropdownActive = "Active";

  var Active = [
    'Active',
    'YES',
    'NO',
  ];

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
        "${globals.cdomain2}/api/api_accheadlist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _acchead.text = getValue(jsonData['acchead'], 'C');
    _paracchead.text = getValue(jsonData['parhead'], 'C');
    _index.text = getValue(jsonData['indx'], 'C');
    _tdsnature.text = getValue(jsonData['tdsnature'], 'C');
    _altacchead.text = getValue(jsonData['altacchead'], 'C');
    _active.text = getValue(jsonData['active'], 'C');
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
      var acchead = _acchead.text;
      var paracchead = _paracchead.text;
      var index = _index.text;
      var tdsnature = _tdsnature.text;
      var altacchead = _altacchead.text;
      var active = _active.text;
      var id = widget.xid;
      id = int.parse(id);
      //print('In Save....');
      uri =
          "${globals.cdomain2}/api/api_accheadstort?dbname=$clientid" +
              "&acchead=" +
              acchead +
              "&paracchead=" +
              paracchead +
              "&index=" +
              index +
              "&tdsnature=" +
              tdsnature +
              "&altacchead=" +
              altacchead +
              "&active=" +
              active +
              "&id=" +
              id.toString();
      //print(uri);
      var response = await http.post(Uri.parse(uri));
      print(uri);
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
      //     "Account Head Add",
      //     style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
      //   ),
      // ),
      appBar: EqAppBar(AppBarTitle: "Account Head Add"),
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
                child: EqTextField(
                  controller: _acchead,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  hintText: 'AccHead',
                  labelText: 'AccHead',
                  onTap: () {},
                  onChanged: (value) {
                      _acchead.value = _acchead.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _paracchead,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  hintText: 'ParAccHead',
                  labelText: 'ParAccHead',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {
                      _paracchead.value = _paracchead.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _index,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  hintText: 'Index',
                  labelText: 'Index',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {},
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _tdsnature,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  hintText: 'TdsNature',
                  labelText: 'TdsNature',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {
                      _tdsnature.value = _tdsnature.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: EqTextField(
                  controller: _altacchead,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  hintText: 'AltAccHead',
                  labelText: 'AltAccHead',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {
                      _altacchead.value = _altacchead.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                      value: 'Active',
                      decoration: const InputDecoration(
                        labelText: 'Active/Yes/No',
                      ),
                      items: Active.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownActive = newValue!;
                        });
                      }),
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
