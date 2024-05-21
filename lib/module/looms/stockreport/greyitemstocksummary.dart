// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/listbutton.dart';
import 'package:cloud_mobile/dfreport.dart';
import 'package:cloud_mobile/list/branchid_list.dart';
import 'package:cloud_mobile/list/designid_list.dart';
import 'package:cloud_mobile/list/itemid_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:intl/intl.dart';

class GreyItemStockSummaryReport extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  GreyItemStockSummaryReport({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _GreyItemStockSummaryReportState createState() => _GreyItemStockSummaryReportState();
}

class _GreyItemStockSummaryReportState extends State<GreyItemStockSummaryReport> {

  List retResultdesign = [];
  List retResultitem = [];
  List retResultbranch = [];
  List retResultgroup = [];
  List _itemlist = [];
 
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  String dropdownGroupBy = 'Regular';

  var GroupByList = [
    'Regular',
    'Itemnamewise',
    'Designwise',
    'Branchwise',
  ];

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();

  @override
  void initState() {
    DateTime aprilFirst2000 = DateTime(2000, 4, 1);
    toDate = retconvdate(widget.xfend);

    _fromdate.text = DateFormat("dd-MM-yyyy").format(aprilFirst2000);
    _todate.text = DateFormat("dd-MM-yyyy").format(toDate);
  }

  Future<bool> companydetails(_user, _pwd) async {
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000, 4, 1),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _fromdate.text = DateFormat("dd-MM-yyyy").format(picked);
        //print(fromDate);
      });
  }

  Future<void> _selecttoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
        _todate.text = DateFormat("dd-MM-yyyy").format(picked);
        //print(toDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    
    void gotoItemScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => itemid_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: '',
                  )));
      setState(() {
        retResultitem += result;
      });
    }

    void gotoDesignScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => designid_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                  )));
      setState(() {
        retResultdesign += result;
      });
    }
    
    void gotoBranchScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => branchid_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        retResultbranch += result;
      });
    }

    void GenerateReport(BuildContext context) async {
      _itemlist = retResultitem;

      var itemlist = '';
      for (var ictr = 0; ictr < retResultitem.length; ictr++) {
        if (ictr % 2 == 0) {
          itemlist = itemlist + retResultitem[ictr].toString() + ',';
        }
      }
      if (itemlist.isNotEmpty) {
        itemlist = itemlist.substring(0, itemlist.length - 1);
      }

      var designlist = '';
      for (var ictr = 0; ictr < retResultdesign.length; ictr++) {
        if (ictr % 2 == 0) {
          designlist = designlist + retResultdesign[ictr].toString() + ',';
        }
      }
      if (designlist.isNotEmpty) {
        designlist = designlist.substring(0, designlist.length - 1);
      }

      var branchlist = '';
      for (var ictr = 0; ictr < retResultbranch.length; ictr++) {
        if (ictr % 2 == 0) {
          branchlist = branchlist + retResultbranch[ictr].toString() + ',';
        }
      }
      if (branchlist.isNotEmpty) {
        branchlist = branchlist.substring(0, branchlist.length - 1);
      }

      DialogBuilder(context).showLoadingIndicator('');

      var fromdate = _fromdate.text.toString().split(' ')[0];
      var todate = _todate.text.toString().split(' ')[0];
      var cno = widget.xcompanyid;
      var _dbname = globals.dbname;

      var cReportType;
      var cPCA;

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(fromdate);
      String _fromDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(todate);
      String _toDate = DateFormat("yyyy-MM-dd").format(parsedDate2);

      cReportType = "takastockreport";

      String url = '';

      url = '${globals.cdomain}/gettakastockreport?' +
          'fromdate=' +
          _fromDate +
          '&todate=' +
          _toDate +
          '&groupby=' +
          dropdownGroupBy +
          '&created_at=' +
          '&tocreated_at=' +
          '&branch=' +
          branchlist +
          '&itemname=' +
          itemlist +
          '&incnegativestk=N' +
          '&incphysicalstk=N' +
          '&design=' +
          designlist +
          '&machineno=' +
          '&takachr=' +
          '&takano=0' +
          '&rvalue=P' +
          '&ncompany=' +
          '&rtype=D' +
          '&module=' +
          '&dbname=' +
          _dbname +
          '&cno=3' +
          cno +
          '&startdate=2024-04-01' +
          '&enddate=2025-03-31';

      print(" GenerateReport :" + url);

      if (cReportType == "takastockreport") {
        var response = await http.get(Uri.parse(url));
        var jsonData = jsonDecode(response.body);
        var aGroup = [];
        jsonData = jsonData['data'];
        print("chirag");
        print(jsonData);
        if (dropdownGroupBy.toLowerCase() == 'itemnamewise') {
          aGroup = [
            {'field': 'itemname', 'heading': 'Itemname'}
          ];
          jsonData.sort((a, b) =>
              a['itemname'].toString().compareTo(b['itemname'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'designwise') {
          aGroup = [
            {'field': 'design', 'heading': 'Design'}
          ];
          jsonData.sort((a, b) =>
              a['design'].toString().compareTo(b['design'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'branchwise') {
          aGroup = [
            {'field': 'branch', 'heading': 'Branch'}
          ];
          jsonData.sort((a, b) =>
              a['branch'].toString().compareTo(b['branch'].toString()));
        }

        DialogBuilder(context).hideOpenDialog();
        String calias = 'takastockreport';
        String cRptCaption = 'Taka Stock Report';
        String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
        dfReport oReport = new dfReport(jsonData, aGroup);
        oReport.addColumn('serial', 'Serial', 'N', '10', '2', 'l', '');
        oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('date2', 'Date', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('chlnno', 'ChlnNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('party', 'Party', 'C', '10', '0', 'l', '');
        oReport.addColumn('takachr', 'TakaChr', 'C', '10', '0', 'l', '');
        oReport.addColumn('takano', 'TakaNo', 'N', '12', '2', 'r', '');
        oReport.addColumn('itemname', 'Itemname', 'C', '10', '0', 'l', '');
        oReport.addColumn('design', 'Design', 'C', '10', '0', 'l', '');
        oReport.addColumn('machine', 'Machine', 'C', '10', '0', 'l', '');
        oReport.addColumn('meters', 'Meters', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('unit', 'Unit', 'C', '10', '0', 'l', '');
        oReport.addColumn('fmode', 'Fmode', 'C', '10', '0', 'l', '');
        oReport.addColumn('remarks', 'Remarks', 'C', '10', '0', 'l', '');
        oReport.addColumn('taka', 'Taka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('issueid', 'Issueid', 'N', '12', '2', 'r', '');
        oReport.addColumn('issuemtrs', 'IssueMtrs Taka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('beamitem', 'BeamItem', 'C', '10', '0', 'l', '');
        oReport.addColumn('issuetaka', 'IssueTaka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('balmtrs', 'Bal Meters', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('beamno', 'BeamNo', 'N', '12', '2', 'r', '');
        oReport.addColumn('company', 'Company', 'C', '20', '0', 'l', '');
        oReport.addColumn('itemid', 'ItemId', 'N', '12', '2', 'r', '');
        oReport.addColumn('baltaka', 'Bal Taka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('branch', 'Branch', 'C', '20', '0', 'l', '');
        oReport.addColumn('month', 'Month', 'C', '20', '0', 'l', '');
        oReport.addColumn('mnthno', 'Mnthno', 'C', '20', '0', 'l', '');
        oReport.addColumn('yr', 'Year', 'C', '20', '0', 'l', '');
        print("1");
        oReport.prepareReport();
        print("1");
        oReport.calias = calias;
        oReport.cRptCaption = cRptCaption;
        oReport.cRptCaption2 = cRptCaption2;
        oReport.GenerateReport(context);
      }
      return;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grey Item Stock Summary Report',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fromdate,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'From Date',
                        labelText: 'From Date',
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _todate,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'To Date',
                        labelText: 'To Date',
                      ),
                      onTap: () {
                        _selecttoDate(context);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              ListButton(
                buttonText: "Select Item",
                onPressed: () {
                  gotoItemScreen(context);
                },
              ),
              (retResultitem.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultitem.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Item List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultitem.length / 2).floor(),
                              itemBuilder: (context, index) {
                                int listIndex = index * 2;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: InkWell(
                                                onTap: () {
                                                  print(
                                                      retResultitem[listIndex]);
                                                },
                                                child: Text(
                                                    "${retResultitem[listIndex].toString()} "))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            "|",
                                            style: TextStyle(
                                                color: Colors.grey.shade400),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              print(
                                                  retResultitem[listIndex + 1]);
                                              print(
                                                  "${listIndex} + ${listIndex + 2}");
                                            },
                                            child: Text(
                                                retResultitem[listIndex + 1]
                                                    .toString())),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultitem.removeRange(
                                                listIndex, listIndex + 2);
                                            // Result.remove(Result[index]);
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ),
                                );
                              },
                            )
                    ),
              ListButton(
                buttonText: "Select Design",
                onPressed: () {
                  gotoDesignScreen(context);
                },
              ),
              (retResultdesign.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultdesign.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Design List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultdesign.length / 2).floor(),
                              itemBuilder: (context, index) {
                                int listIndex = index * 2;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: InkWell(
                                                onTap: () {
                                                  print(retResultdesign[
                                                      listIndex]);
                                                },
                                                child: Text(
                                                    "${retResultdesign[listIndex].toString()} "))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            "|",
                                            style: TextStyle(
                                                color: Colors.grey.shade400),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              print(retResultdesign[
                                                  listIndex + 1]);
                                              print(
                                                  "${listIndex} + ${listIndex + 2}");
                                            },
                                            child: Text(
                                                retResultdesign[listIndex + 1]
                                                    .toString())),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultdesign.removeRange(
                                                listIndex, listIndex + 2);
                                            // Result.remove(Result[index]);
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ),
                                );
                              },
                            )
                    ),
              ListButton(
                buttonText: "Select Branch",
                onPressed: () {
                  gotoBranchScreen(context);
                },
              ),
              (retResultbranch.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultbranch.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Branch List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultbranch.length / 2).floor(),
                              itemBuilder: (context, index) {
                                int listIndex = index * 2;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: InkWell(
                                                onTap: () {
                                                  print(retResultbranch[
                                                      listIndex]);
                                                },
                                                child: Text(
                                                    "${retResultbranch[listIndex].toString()} "))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            "|",
                                            style: TextStyle(
                                                color: Colors.grey.shade400),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              print(retResultbranch[
                                                  listIndex + 1]);
                                              print(
                                                  "${listIndex} + ${listIndex + 2}");
                                            },
                                            child: Text(
                                                retResultbranch[listIndex + 1]
                                                    .toString())),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultbranch.removeRange(
                                                listIndex, listIndex + 2);
                                            // Result.remove(Result[index]);
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ),
                                );
                              },
                            )
                    ),          
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                        value: 'Regular',
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Group By',
                            hintText: 'Group By'),
                        items: GroupByList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownGroupBy = newValue!;
                            print(dropdownGroupBy);
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => {GenerateReport(context)},
                  child: Text('Generate Report',
                      style:
                          TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
