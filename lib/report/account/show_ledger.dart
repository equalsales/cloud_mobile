import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';
import 'package:cloud_mobile/function.dart';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/master/countrymaster/add_countrymaster.dart';

class ShowLedgerList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xfromDate;
  var xtoDate;
  var xPartyList;

  ShowLedgerList(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      fromdate,
      todate,
      partylist})
      : super(key: mykey) {
    print(companyid);
    print(companyname);
    print(fromdate);
    print(todate);
    print(partylist);

    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xfromDate = fromdate;
    xtoDate = todate;
    xPartyList = partylist;
  }

  @override
  _ShowLedgerListPageState createState() => _ShowLedgerListPageState();
}

class _ShowLedgerListPageState extends State<ShowLedgerList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;
    var companyid = widget.xcompanyid;
    var fromdate = widget.xfromDate.toString().split(' ')[0];
    var todate = widget.xtoDate.toString().split(' ')[0];

    //List _partylist = [];
    //_partylist = widget.xPartyList;
    var partylist = widget.xPartyList;
    // for (var ictr = 0; ictr < _partylist.length; ictr++) {
    //   if (ictr > 0) {
    //     partylist = partylist + ',';
    //   }
    //   partylist = partylist + _partylist[ictr].toString();
    // }

    partylist = partylist.replaceAll('/', '{{}}');

    String uri = '';
    var cfromdate = retconvdate(globals.startdate).toString();
    var ctodate = retconvdate(globals.enddate).toString();
    var cno = globals.companyid;

    print(partylist); //6288

    uri = 'https://www.cloud.equalsoftlink.com/api/api_genledger?dbname=' +
        db +
        '&party=' +
        partylist +
        '&fromdate=' +
        fromdate +
        '&todate=' +
        todate +
        '&cfromdate=' +
        cfromdate +
        '&ctodate=' +
        ctodate +
        '&cno=' +
        cno;

    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    double balance = 0;
    double dramt = 0;
    double cramt = 0;
    double totdramt = 0;
    double totcramt = 0;

    var cgroup = '';
    var cNextGroup = '';
    var narration = '';
    for (int iCtr = 0; iCtr < jsonData.length; iCtr++) {
      if ((iCtr + 1) < jsonData.length) {
        cNextGroup = jsonData[iCtr + 1]['acname'].toString();
      }

      //narration = jsonData[iCtr]['remarks'].toString();
      //print(narration);

      if (cNextGroup != cgroup) {
        if (iCtr != 0) {
          jsonData[iCtr + 1]['auto'] = 'Y';
        } else {
          jsonData[iCtr]['auto'] = 'Y';
        }
        balance = 0;
        totdramt = 0;
        totcramt = 0;
        cgroup = jsonData[iCtr]['acname'].toString();
        jsonData[iCtr]['autoword'] = cgroup;
        jsonData[iCtr]['bold'] = 'Y';
      } else {
        jsonData[iCtr]['auto'] = '';
        cgroup = jsonData[iCtr]['acname'].toString();
        jsonData[iCtr]['autoword'] = '';
        jsonData[iCtr]['bold'] = '';
      }

      dramt = 0;
      cramt = 0;

      if (jsonData[iCtr]['dramt'].toString() != '') {
        dramt = double.parse(jsonData[iCtr]['dramt'].toString());

        if (jsonData[iCtr]['dramt'].toString() != '') {
          totdramt =
              totdramt + double.parse(jsonData[iCtr]['dramt'].toString());
        }
      }
      if (jsonData[iCtr]['cramt'].toString() != '') {
        cramt = double.parse(jsonData[iCtr]['cramt'].toString());

        if (jsonData[iCtr]['cramt'].toString() != '') {
          totcramt =
              totcramt + double.parse(jsonData[iCtr]['cramt'].toString());
        }
      }

      balance = balance + (dramt - cramt);
      if ((balance) > 0) {
        jsonData[iCtr]['balance'] = (balance).abs().toStringAsFixed(2) + ' Dr';
      } else {
        jsonData[iCtr]['balance'] = (balance).abs().toStringAsFixed(2) + ' Cr';
      }

      // //For Remarks
      // if (narration != '') {
      //   jsonData.add({
      //     'date2': '',
      //     'acname': cgroup,
      //     'refacname': narration,
      //     'dramt': '',
      //     'cramt': '',
      //     'balance': '',
      //     'bold': 'Y',
      //     'auto': '',
      //     'autoword': ''
      //   });
      // }

      cgroup = jsonData[iCtr]['acname'].toString();
    }

    //print('xxxxxx');
    //print(cgroup);

    jsonData.add({
      'date2': '',
      'acname': cgroup,
      'refacname': '',
      'dramt': totdramt.toStringAsFixed(2),
      'cramt': totcramt.toStringAsFixed(2),
      'balance': '',
      'bold': 'Y',
      'auto': '',
      'autoword': ''
    });
    if ((balance) > 0) {
      jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': 'Closing Balance C/f Cr Amt',
        'dramt': '',
        'cramt': balance.abs().toStringAsFixed(2),
        'balance': '',
        'bold': 'Y',
        'auto': '',
        'autoword': ''
      });
    } else {
      jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': 'Closing Balance C/f Dr Amt',
        'dramt': balance.abs().toStringAsFixed(2),
        'cramt': '',
        'balance': '',
        'bold': 'Y',
        'auto': '',
        'autoword': ''
      });
    }
    if ((totdramt - totcramt) > 0) {
      jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': '',
        'dramt': (totdramt).toStringAsFixed(2),
        'cramt': (totdramt).toStringAsFixed(2),
        'balance': '',
        'bold': 'Y',
        'auto': '',
        'autoword': ''
      });
    } else {
      jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': '',
        'dramt': (totcramt).toStringAsFixed(2),
        'cramt': (totcramt).toStringAsFixed(2),
        'balance': '',
        'bold': 'Y',
        'auto': '',
        'autoword': ''
      });
    }

    if ((balance) > 0) {
      jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': 'Balance Dr Amt',
        'dramt': balance.abs().toStringAsFixed(2),
        'cramt': '',
        'balance': '',
        'bold': 'Y',
        'auto': '',
        'autoword': ''
      });
    } else {
      jsonData.add({
        'date2': '',
        'acname': cgroup,
        'refacname': 'Balance Cr Amt',
        'dramt': '',
        'cramt': balance.abs().toStringAsFixed(2),
        'balance': '',
        'bold': 'Y',
        'auto': '',
        'autoword': ''
      });
    }

    print(jsonData);

    this.setState(() {
      _companydetails = jsonData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    //double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger Rpeort',
            style: GoogleFonts.abel(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.share),
        onPressed: () => {},
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    child: Text('Date',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    child: Text('Description',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    child: Text('Debit',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    child: Text('Credit',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    child: Text('Balance',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              for (int i = 0; i < this._companydetails.length; i++) ...[
                if (this._companydetails[i]['autoword'] != '') ...[
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(2.0),
                        padding: EdgeInsets.all(4.0),
                        width: 850,
                        decoration: BoxDecoration(
                            //border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(this._companydetails[i]['autoword'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Text(this._companydetails[i]['date2'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(8.0),
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Text(this._companydetails[i]['refacname'],
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(8.0),
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Text(this._companydetails[i]['dramt'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(8.0),
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Text(this._companydetails[i]['cramt'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(8.0),
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Text(this._companydetails[i]['balance'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ]
            ]),
          )),
      // body: Center(
      //     child: ListView.builder(
      //   itemCount: this._companydetails.length,
      //   itemBuilder: (context, index) {
      //     print(this._companydetails[index]);
      //     String date = this._companydetails[index]['date2'];
      //     String refacname = this._companydetails[index]['refacname'];
      //     String dramt = this._companydetails[index]['dramt'];
      //     String cramt = this._companydetails[index]['cramt'];
      //     String id = this._companydetails[index]['controlid'].toString();
      //     int newid = 0;
      //     newid = int.parse(id);

      //     return Slidable(
      //       key: ValueKey(index),
      //       startActionPane:
      //           ActionPane(motion: const BehindMotion(), children: [
      //         SlidableAction(
      //             onPressed: (context) =>
      //                 {execDelete(context, index, int.parse(id), '')},
      //             icon: Icons.delete,
      //             label: 'Delete',
      //             backgroundColor: Color(0xFFFE4A49)),
      //         SlidableAction(
      //             onPressed: (context) => {},
      //             icon: Icons.edit,
      //             label: 'Edit',
      //             backgroundColor: Colors.blue)
      //       ]),
      //       child: Card(
      //           child: Center(
      //               child: ListTile(
      //         title: Row(
      //           children: <Widget>[
      //             Container(
      //               margin: EdgeInsets.all(12.0),
      //               padding: EdgeInsets.all(8.0),
      //               width: MediaQuery.of(context).size.width * 0.20,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(8),
      //                   color: Colors.green),
      //               child: Text(date,
      //                   style: TextStyle(
      //                       fontSize: 12.0, fontWeight: FontWeight.bold)),
      //             ),
      //             Container(
      //               margin: EdgeInsets.all(12.0),
      //               padding: EdgeInsets.all(8.0),
      //               width: MediaQuery.of(context).size.width * 0.60,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(8),
      //                   color: Colors.green),
      //               child: Text(refacname,
      //                   style: TextStyle(
      //                       fontSize: 12.0, fontWeight: FontWeight.bold)),
      //             ),
      //             Container(
      //               margin: EdgeInsets.all(12.0),
      //               padding: EdgeInsets.all(8.0),
      //               width: MediaQuery.of(context).size.width * 0.20,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(8),
      //                   color: Colors.green),
      //               child: Text(dramt,
      //                   style: TextStyle(
      //                       fontSize: 12.0, fontWeight: FontWeight.bold)),
      //             ),
      //           ],
      //         ),
      //         subtitle: Text('',
      //             style:
      //                 TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
      //         leading: Icon(Icons.select_all),
      //         trailing: Icon(Icons.arrow_forward),
      //         onTap: () {},
      //       ))),
      //     );
      //   },
      // )),
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
