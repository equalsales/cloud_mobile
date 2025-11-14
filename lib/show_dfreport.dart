// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:cloud_mobile/PdfPreviewPageNew.dart';
import 'package:cloud_mobile/report_setting.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:vs_scrollbar/vs_scrollbar.dart';

class ShowdfReport extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xfromDate;
  var xtoDate;
  var xData;
  var xColInfo;
  var xRptCaption;
  var xRptCaption2;
  var xRptalias;
  var xGroup;
  var xgrp = '';

  ShowdfReport(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      fromdate,
      todate,
      data,
      colinfo,
      RptCaption,
      RptCaption2,
      Rptalias,
      aGroup})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xfromDate = fromdate;
    xtoDate = todate;
    xData = data;
    xColInfo = colinfo;
    xRptCaption = RptCaption;
    xRptCaption2 = RptCaption2;
    xRptalias = Rptalias;
    xGroup = aGroup;
  }

  @override
  _ShowdfReportPageState createState() => _ShowdfReportPageState();
}

class _ShowdfReportPageState extends State<ShowdfReport> {
  List _companydetails = [];
  var loading = true;
  @override
  void initState() {
     loaddetails();
     loadreportsetting();
  }

  var res;

  Future<bool> loadreportsetting() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var cRptCaption = widget.xRptCaption;
    var ccalias = widget.xRptalias;
    var colInfo = widget.xColInfo;
    var grp = '';
    if (widget.xGroup.length > 0) {
      grp = widget.xGroup[0]['field'];
      print(grp);
      widget.xgrp = grp;
    }

    uri =
        '${globals.cdomain2}/api/api_reportsettinglist?dbname=$clientid&cno=$companyid&alias=' +
            ccalias +
            cRptCaption +
            'Setting';
    print(uri);

    var response = await http.get(Uri.parse(uri));
     
    res = response;
    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    //print(jsonData);

    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      for (int i = 0; i < colInfo.length; i++) {
        if (jsonData[iCtr]['heading'].toString() ==
            colInfo[i]['heading'].toString()) {
          if (jsonData[iCtr]['visible'].toString() == '0') {
            colInfo[i]['visible'] = 'false';
          } else if (jsonData[iCtr]['visible'].toString() == 'false') {
            colInfo[i]['visible'] = 'false';
          }
          if (jsonData[iCtr]['visible'].toString() == 'true') {
            colInfo[i]['visible'] = 'true';
          } else if (jsonData[iCtr]['visible'].toString() == '1') {
            colInfo[i]['visible'] = 'true';
          }
        }
      }
    }
    setState(() {
      loading = false;
    });
    return true;
  }

  void gotoReportSettings(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => reportSettingView(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: '',
                  fend: '',
                  cRptCaption: (widget.xRptCaption).toString() + 'Setting',
                  ColInfo: widget.xColInfo,
                  calias: widget.xRptalias,
                )));
  }

  Future<bool> loaddetails() async {
    this.setState(() {
      loadreportsetting();
      _companydetails = widget.xData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var colInfo = widget.xColInfo;
    var companyid = widget.xcompanyid;
    var cRptalias = widget.xRptalias;
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.blue.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            tileColor: Colors.blue.shade200,
            title: Text(widget.xcompanyname +
                '\n(' +
                widget.xfbeg +
                ' - ' +
                widget.xfend +
                ")"),
            leading: Icon(
              Icons.business_center,
              size: 50,
            ),
          ),
        ),
      ),
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: widget.xRptCaption,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'verdana',
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n ' + widget.xRptCaption2,
                    style: TextStyle(
                        fontSize: 9,
                        fontFamily: 'verdana',
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.replay_outlined),
              onPressed: () {
                loadreportsetting();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                       Future.delayed(Duration(seconds: 10), () {
                      Navigator.of(context).pop(true);
                    });
                      return AlertDialog(
                        backgroundColor: Colors.white10,
                        content: CircleAvatar(child: CircularProgressIndicator(color: Colors.blue,)),
                      );
                    },
                  );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: (widget.xRptCaption).toString() + 'Setting',
              onPressed: () {
                gotoReportSettings(context);
              },
            ),
            SizedBox(width: 10,),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PdfPreviewPageNew(
              companyid: globals.companyid,
              companyname: globals.companyname,
              fbeg: globals.startdate,
              fend: globals.enddate,
              fromdate: globals.startdate,
              todate: globals.enddate,
              data: widget.xData,
              colinfo: widget.xColInfo,
              RptCaption: widget.xRptCaption,
              RptCaption2: widget.xRptCaption2,
              Rptalias: widget.xRptalias,
              aGroup: widget.xGroup,
              grp: widget.xgrp,
            );
          }));
        },
        child: const Icon(Icons.picture_as_pdf_sharp),
      ),
      body: (loading)
          ? Center(child: CircularProgressIndicator())
          : VsScrollbar(
            style: VsScrollbarStyle(
              hoverThickness: 10.0,
              radius: Radius.circular(10),
              thickness: 10.0,
                color: Color.fromARGB(255, 199, 194, 194),
              ),
            // isAlwaysShown: true,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            for (int i = 0; i < colInfo.length; i++) ...[
                              if (colInfo[i]['visible'].toString() == 'true') ...[
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  padding: EdgeInsets.all(3.0),
                                  width: double.parse(colInfo[i]['width']) * 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.yellow),
                                  child: Text(colInfo[i]['heading'],
                                      textAlign: (colInfo[i]['align'] == 'r'
                                          ? TextAlign.right
                                          : TextAlign.left),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ],
                          ],
                        ),
                        for (int i = 0; i < this._companydetails.length; i++) ...[
                          if ((this._companydetails[i]['grp1total'].length > 0) &&
                              (i != this._companydetails.length - 1)) ...[
                            Row(
                              children: [
                                for (int j = 0; j < colInfo.length; j++) ...[
                                  if (colInfo[j]['visible'].toString() ==
                                      'true') ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text(
                                          this
                                              ._companydetails[i]['grp1total'][j]
                                              .toString(),
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 31, 7, 243),
                                              fontFamily: 'verdana',
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ],
                              ],
                            )
                          ],
                          if (this._companydetails[i]['autoword'] != '') ...[
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2.0),
                                  padding: EdgeInsets.all(4.0),
                                  width: 850,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(this._companydetails[i]['autoword'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'verdana',
                                          color: Colors.red,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            )
                          ],
                          Row(
                            children: [
                              for (int j = 0; j < colInfo.length; j++) ...[
                                if (colInfo[j]['visible'].toString() ==
                                    'true') ...[
                                  if (this
                                          ._companydetails[i][colInfo[j]['field']]
                                          .toString() ==
                                      ".00") ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text("0.00",
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                              fontFamily: 'verdana',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ] else if (this
                                          ._companydetails[i][colInfo[j]['field']]
                                          .toString() ==
                                      ".000") ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text("0.000",
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                              fontFamily: 'verdana',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ] else if (this
                                          ._companydetails[i][colInfo[j]['field']]
                                          .toString() ==
                                      ".0000") ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text("0.00",
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                              fontFamily: 'verdana',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ]  else if (this
                                          ._companydetails[i][colInfo[j]['field']]
                                          .toString() ==
                                      "null") ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text(" ",
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                              fontFamily: 'verdana',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),]else ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text(
                                          this
                                              ._companydetails[i]
                                                  [colInfo[j]['field']]
                                              .toString(),
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                              fontFamily: 'verdana',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ],
                              ],
                            ],
                          ),
                          if ((this._companydetails[i]['grp1total'].length > 0) &&
                              (i == this._companydetails.length - 2)) ...[
                            Row(
                              children: [
                                for (int j = 0; j < colInfo.length; j++) ...[
                                  if (colInfo[j]['visible'].toString() ==
                                      'true') ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text(
                                          this
                                              ._companydetails[i]['grp1total'][j]
                                              .toString(),
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                            fontFamily: 'verdana',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 31, 7, 243),
                                          )),
                                    ),
                                  ],
                                ],
                              ],
                            )
                          ],
                          if ((this._companydetails[i]['nettotal'].length >
                              0)) ...[
                            Row(
                              children: [
                                for (int j = 0; j < colInfo.length; j++) ...[
                                  if (colInfo[j]['visible'].toString() ==
                                      'true') ...[
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      padding: EdgeInsets.all(3.0),
                                      width:
                                          double.parse(colInfo[j]['width']) * 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: Text(
                                          this
                                              ._companydetails[i]['nettotal'][j]
                                              .toString(),
                                          textAlign: (colInfo[j]['align'] == 'r'
                                              ? TextAlign.right
                                              : TextAlign.left),
                                          style: TextStyle(
                                            fontFamily: 'verdana',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 31, 7, 243),
                                          )),
                                    ),
                                  ],
                                ],
                              ],
                            )
                          ],
                        ]
                      ]),
                )),
          ),
    );
  }
}

void execDelete(BuildContext context, int index, int id, String name) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Country ??'),
      content: Text('Do you want to delete this country ' + name + ' ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {},
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return;
}

void doNothing(BuildContext context) {}
