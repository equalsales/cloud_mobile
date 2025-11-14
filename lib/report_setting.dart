//ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/global.dart' as globals;

class reportSettingView extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xRptCaption;
  var xColInfo;
  var xcalias;
  bool isAppleChecked = false;

  reportSettingView(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      cRptCaption,
      ColInfo,
      calias})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xRptCaption = cRptCaption;
    xColInfo = ColInfo;
    xcalias = calias;
  }
  @override
  _reportSettingState createState() => _reportSettingState();
}

class _reportSettingState extends State<reportSettingView> {
  var loading = true;
  @override
  // void initState() {
  //   print(widget.xColInfo);
  // }

  void initState() {
    //fromDate = retconvdate(widget.xfbeg);
    //toDate = retconvdate(widget.xfend);

    //var curDate = getsystemdate();
    //_date.text = curDate.toString().split(' ')[0];
    //print (widget.xRptCaption);
    if ((widget.xRptCaption) != '') {
      loadreportsetting();
    }
  }

  Future<bool> companydetails(_user, _pwd) async {
    return true;
  }

  Future<bool> loadreportsetting() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var cRptCaption = widget.xRptCaption;
    var ccalias = widget.xcalias;

    var colInfo = widget.xColInfo;

    uri =
        // 'https://www.mssqlapi.equalsoftlink.com/api/api_reportsettinglist?cno=' +
        //     companyid +
        //     '&clientid=' +
        //     clientid +
        //     '&alias=' +
        //     ccalias +
        //     cRptCaption;
        uri ='${globals.cdomain2}/api/api_reportsettinglist?dbname=$clientid&cno=$companyid&alias=' +ccalias +cRptCaption;
    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    print(jsonData);

    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      for (int i = 0; i < colInfo.length; i++) {
        //print(jsonData[iCtr]['heading'].toString());
        //print(colInfo[i]['heading'].toString());
        if (jsonData[iCtr]['heading'].toString() ==
            colInfo[i]['heading'].toString()) {
          //print(jsonData[iCtr]['heading'].toString());
          //print(colInfo[i]['heading'].toString());
          //print(jsonData[iCtr]['visible'].toString());
          if (jsonData[iCtr]['visible'].toString() == '0') {
            colInfo[i]['visible'] = false;
            //print("tanshul0");
          } else if (jsonData[iCtr]['visible'].toString() == 'false') {
            colInfo[i]['visible'] = false;
            //print("panshulfalse");
          }
          if (jsonData[iCtr]['visible'].toString() == 'true') {
            colInfo[i]['visible'] = true;
            //print("tanshultrue");
          } else if (jsonData[iCtr]['visible'].toString() == '1') {
            colInfo[i]['visible'] = true;
            //print("panshul2");
          }
        }
      }
    }
    setState(() {
      loading = false;
    });

    return true;
  }

  void SaveData(BuildContext context) async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var colInfo = widget.xColInfo;
    var cRptCaption = widget.xRptCaption;
    var ccalias = widget.xcalias;
    var addsetting = [];

    //print(companyid);
    //print(clientid);
    //print(ccalias);

    //return;
    for (int i = 0; i < colInfo.length; i++) {
      addsetting.add({
        'alias': ccalias + cRptCaption,
        'heading': colInfo[i]['heading'],
        'visible': colInfo[i]['visible'],
      });
    }
    print(companyid);
    uri ="${globals.cdomain2}/api/api_storereportsetting?dbname=$clientid&cno=$companyid&alias="+ccalias.toString()+cRptCaption.toString() +"&GridData="+jsonEncode(addsetting);
    print(uri);
    var response = await http.post(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    var jsonCode = jsonData['Code'];
    var jsonMsg = jsonData['Message'];
    if (jsonCode == '500') {
      showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Saved !!!."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, 
                child: Text('Ok')
              )
            ],
          );
        },
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    var colInfo = widget.xColInfo;
    for (int i = 0; i < colInfo.length; i++) {
      print(colInfo[i]['visible']);
    }
    return Scaffold(
        appBar: EqAppBar(AppBarTitle: widget.xRptCaption + ' - [' + widget.xcompanyid + ' ]'),
        body: (loading)
            ? Center(child: CircularProgressIndicator())
            : Form(
                child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < colInfo.length; i++) ...[
                      //print(colInfo[i]['heading']),
                      CheckboxListTile(
                        title: Text(colInfo[i]['heading'].toString()),
                        value: colInfo[i]['visible'],
                        onChanged: (bool? value) {
                          print(value);
                          setState(() {
                            colInfo[i]['visible'] = value!;
                          });
                        },
                      ),
                    ],
                    ElevatedButton(
                      //onPressed: () => {gotoLedgerReport(context)},
                      onPressed: () => {SaveData(context)},
                      child: Text('Save Setting',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
              )));
  }
}
