// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/listbutton.dart';
import 'package:cloud_mobile/dfreport.dart';
import 'package:cloud_mobile/list/branchid_list.dart';
import 'package:cloud_mobile/list/designid_list.dart';
import 'package:cloud_mobile/list/itemid_list.dart';
import 'package:cloud_mobile/list/machineid_list.dart';
import 'package:cloud_mobile/list/partyid_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:intl/intl.dart';

class DyegreyJobworkIssueStockReport extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  DyegreyJobworkIssueStockReport(
      {Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _DyegreyJobworkIssueStockReportState createState() =>
      _DyegreyJobworkIssueStockReportState();
}

class _DyegreyJobworkIssueStockReportState
    extends State<DyegreyJobworkIssueStockReport> {
  List retResultparty = [];
  List retResultmachine = [];
  List retResultdesign = [];
  List retResultitem = [];
  List retResultsalesman = [];
  // List retResultcompany = [];
  List retResultbranch = [];
  List retResultgroup = [];

  List _partylist = [];

  String SelectedParty = '';

  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();
  TextEditingController _stockdate = new TextEditingController();

  String dropdownReportType = 'Detail';

  var ReportType = [
    'Detail',
    'Concise',
  ];

  String dropdownIncOpening = 'No';

  var IncOpeningList = [
    'No',
    'Yes',
  ];

  String dropdownPendingNeg = 'No';

  var PendingNegList = [
    'No',
    'Yes',
  ];

  String dropdownTrnType = 'Pending';

  var TrnType = [
    'Pending',
    'Closed',
    'All',
  ];

  String dropdownGroupBy = 'Regular';

  var GroupByList = [
    'Regular',
    'Party',
    'Company',
    'Itemname',
    'Design',
    'Machine',
    'Branch',
  ];

  @override
  void initState() {
    DateTime aprilFirst2000 = DateTime(2000, 4, 1);
    toDate = retconvdate(widget.xfend);

    _fromdate.text = DateFormat("dd-MM-yyyy").format(aprilFirst2000);
    _todate.text = DateFormat("dd-MM-yyyy").format(toDate);
    _stockdate.text = DateFormat("dd-MM-yyyy").format(toDate);
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

  Future<void> _stockUptoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
        _stockdate.text = DateFormat("dd-MM-yyyy").format(picked);
        //print(toDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    void gotoPartyScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => partyid_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: '',
                  )));
      setState(() {
        retResultparty += result;
      });
    }

    void gotoMachineScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => machineid_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                  )));
      setState(() {
        retResultmachine += result;
      });
    }

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

    // void gotoCompanyScreen(BuildContext context) async {
    //   var result = await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (_) => companyid_list(
    //                 companyid: widget.xcompanyid,
    //                 companyname: widget.xcompanyname,
    //                 fbeg: widget.xfbeg,
    //                 fend: widget.xfend,
    //                 acctype: '',
    //               )));
    //   setState(() {
    //     retResultcompany += result;
    //   });
    // }

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
      _partylist = retResultparty;

      var partylist = '';
      for (var ictr = 0; ictr < retResultparty.length; ictr++) {
        if (ictr % 2 == 0) {
          partylist = partylist + retResultparty[ictr] + ',';
        }
      }
      if (partylist.isNotEmpty) {
        partylist = partylist.substring(0, partylist.length - 1);
      }

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

      var machinelist = '';
      for (var ictr = 0; ictr < retResultmachine.length; ictr++) {
        if (ictr % 2 == 0) {
          machinelist = machinelist + retResultmachine[ictr].toString() + ',';
        }
      }
      if (machinelist.isNotEmpty) {
        machinelist = machinelist.substring(0, machinelist.length - 1);
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

      // var companylist = '';
      // for (var ictr = 0; ictr < retResultcompany.length; ictr++) {
      //   if (ictr % 2 == 0) {
      //     companylist = companylist + retResultcompany[ictr].toString() + ',';
      //   }
      // }
      // if (companylist.isNotEmpty) {
      //   companylist = companylist.substring(0, companylist.length - 1);
      // }

      // print('companylist' + companylist);

      DialogBuilder(context).showLoadingIndicator('');

      var fromdate = _fromdate.text.toString().split(' ')[0];
      var todate = _todate.text.toString().split(' ')[0];
      var cno = widget.xcompanyid;
      var _dbname = globals.dbname;

      var cReportType;

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(fromdate);
      String _fromDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(todate);
      String _toDate = DateFormat("yyyy-MM-dd").format(parsedDate2);

      cReportType = "dyegreyjobworkissuestockreport";

      // if (companylist == '') {
      //   companylist = cno.toString();
      // }

      if (dropdownIncOpening == "No") {
        dropdownIncOpening = 'N';
      } else if (dropdownIncOpening == "Yes") {
        dropdownIncOpening = 'Y';
      }

      if (dropdownPendingNeg == "No") {
        dropdownPendingNeg = 'N';
      } else if (dropdownPendingNeg == "Yes") {
        dropdownPendingNeg = 'Y';
      }

      if (dropdownReportType == "Detail") {
        dropdownReportType = 'D';
      } else if (dropdownReportType == 'Concise') {
        dropdownReportType = 'C';
      }

      if (dropdownTrnType == "Pending") {
        dropdownTrnType = 'P';
      } else if (dropdownTrnType == "Closed") {
        dropdownTrnType = 'C';
      } else if (dropdownTrnType == 'All') {
        dropdownTrnType = 'A';
      }

      String url = '';

      url = '${globals.cdomain}/genautostockreport?party=' +
          partylist +
          '&itemname=' +
          itemlist +
          '&design=' +
          designlist +
          '&machine=' +
          machinelist +
          '&fromdate=' +
          _fromDate +
          '&todate=' +
          _toDate +
          '&stockupto=' +
          _toDate +
          '&includeopn=' +
          dropdownIncOpening +
          '&pendingnegative=' +
          dropdownPendingNeg +
          '&id=3' +
          '&company=' +
          cno +
          '&branch=' +
          branchlist +
          '&groupby=' +
          dropdownGroupBy +
          '&rpttype=' +
          dropdownReportType +
          '&pending=' +
          dropdownTrnType +
          '&zoomfunc=GREYJOBISSUEZOOM' +
          '&before0loadfunc=' +
          '&retqry=N' +
          '&dbname=' +
          _dbname +
          '&cno=' +
          cno;

      print(" GenerateReport :" + url);

      if (dropdownReportType == "D") {
        var response = await http.get(Uri.parse(url));
        var jsonData = jsonDecode(response.body);
        var aGroup = [];
        jsonData = jsonData['data'];
        print("chirag");
        print(jsonData);
        if (dropdownGroupBy.toLowerCase() == 'party') {
          aGroup = [
            {'field': 'party', 'heading': 'Party'}
          ];
          jsonData.sort(
              (a, b) => a['party'].toString().compareTo(b['party'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'company') {
          aGroup = [
            {'field': 'company', 'heading': 'Company'}
          ];
          jsonData.sort((a, b) =>
              a['company'].toString().compareTo(b['company'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'itemname') {
          aGroup = [
            {'field': 'itemname', 'heading': 'Itemname'}
          ];
          jsonData.sort((a, b) =>
              a['itemname'].toString().compareTo(b['itemname'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'design') {
          aGroup = [
            {'field': 'design', 'heading': 'Design'}
          ];
          jsonData.sort((a, b) =>
              a['design'].toString().compareTo(b['design'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'machine') {
          aGroup = [
            {'field': 'machine', 'heading': 'Machine'}
          ];
          jsonData.sort((a, b) =>
              a['machine'].toString().compareTo(b['machine'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'branch') {
          aGroup = [
            {'field': 'branch', 'heading': 'Branch'}
          ];
          jsonData.sort((a, b) =>
              a['branch'].toString().compareTo(b['branch'].toString()));
        }
        DialogBuilder(context).hideOpenDialog();
        String calias = 'dyegreyreport';
        String cRptCaption = 'Dyegrey Jobwork Issue Stock Report';
        String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
        dfReport oReport = new dfReport(jsonData, aGroup);
        oReport.addColumn('serial', 'Serial', 'N', '10', '2', 'l', '');
        oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('date2', 'Date2', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('chlnno', 'ChlnNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('party', 'Party', 'C', '10', '0', 'l', '');
        oReport.addColumn('takachr', 'TakaChr', 'C', '10', '0', 'l', '');
        oReport.addColumn('takano', 'TakaNo', 'N', '12', '2', 'r', 'count');
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
      } else if (dropdownReportType == "C") {
        print("jjjjjjjjjjjjj" + dropdownGroupBy);
        var response = await http.get(Uri.parse(url));
        var jsonData = jsonDecode(response.body);
        var aGroup = [];
        jsonData = jsonData['data'];
        print("chirag");
        print(jsonData);
        if (dropdownGroupBy.toLowerCase() == 'party') {
          aGroup = [
            {'field': 'party', 'heading': 'Party'}
          ];
          jsonData.sort(
              (a, b) => a['party'].toString().compareTo(b['party'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'itemname') {
          aGroup = [
            {'field': 'itemname', 'heading': 'Itemname'}
          ];
          jsonData.sort((a, b) =>
              a['itemname'].toString().compareTo(b['itemname'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'design') {
          aGroup = [
            {'field': 'design', 'heading': 'Design'}
          ];
          jsonData.sort((a, b) =>
              a['design'].toString().compareTo(b['design'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'machine') {
          aGroup = [
            {'field': 'machine', 'heading': 'Machine'}
          ];
          jsonData.sort((a, b) =>
              a['machine'].toString().compareTo(b['machine'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'branch') {
          aGroup = [
            {'field': 'branch', 'heading': 'Branch'}
          ];
          jsonData.sort((a, b) =>
              a['branch'].toString().compareTo(b['branch'].toString()));
        }
        DialogBuilder(context).hideOpenDialog();
        String calias = 'dyegreyreport';
        String cRptCaption = 'Dyegrey Jobwork Issue Stock Concise Report';
        String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
        dfReport oReport = new dfReport(jsonData, aGroup);
        oReport.addColumn('serial', 'Serial', 'N', '10', '2', 'l', '');
        oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('date2', 'Date2', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('chlnno', 'ChlnNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('party', 'Party', 'C', '10', '0', 'l', '');
        oReport.addColumn('itemname', 'Itemname', 'C', '10', '0', 'l', '');
        oReport.addColumn('remarks', 'Remarks', 'C', '10', '0', 'l', '');
        oReport.addColumn('issueid', 'Issueid', 'N', '12', '2', 'r', '');
        oReport.addColumn('meters', 'Meters', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('taka', 'Taka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('issuemtrs', 'IssueMtrs Taka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('issuetaka', 'IssueTaka', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('balmtrs', 'Bal Meters', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('branch', 'Branch', 'C', '20', '0', 'l', '');
        oReport.addColumn('baltaka', 'Bal Taka', 'C', '20', '0', 'l', 'sum');
        oReport.addColumn('month', 'Month', 'C', '20', '0', 'l', '');
        oReport.addColumn('mnthno', 'Mnthno', 'C', '20', '0', 'l', '');
        oReport.addColumn('yr', 'Year', 'C', '20', '0', 'l', '');
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
          'Dyegrey Jobwork Issue Stock Report',
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
              TextFormField(
                controller: _stockdate,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Stock Upto Date',
                  labelText: 'Stock Upto Date',
                ),
                onTap: () {
                  _stockUptoDate(context);
                },
                validator: (value) {
                  return null;
                },
              ),
              ListButton(
                buttonText: "Select Party",
                onPressed: () {
                  gotoPartyScreen(context);
                },
              ),
              (retResultparty.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultparty.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Party List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultparty.length / 2).floor(),
                              itemBuilder: (context, index) {
                                int listIndex = index * 2;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: ListTile(
                                    title: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 8),
                                              child: InkWell(
                                                  onTap: () {
                                                    print(retResultparty[
                                                        listIndex]);
                                                  },
                                                  child: Text(
                                                      "${retResultparty[listIndex].toString()} "))),
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
                                                print(retResultparty[
                                                    listIndex + 1]);
                                                print(
                                                    "${listIndex} + ${listIndex + 2}");
                                              },
                                              child: Text(
                                                  retResultparty[listIndex + 1]
                                                      .toString())),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultparty.removeRange(
                                                listIndex, listIndex + 2);
                                            // Result.remove(Result[index]);
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ),
                                );
                              },
                            ),
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
                                    title: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
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
                            )),
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
                                    title: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
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
                            )),
              ListButton(
                buttonText: "Select Machine",
                onPressed: () {
                  gotoMachineScreen(context);
                },
              ),
              (retResultmachine.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultmachine.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Machine List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultmachine.length / 2).floor(),
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
                                                  print(retResultmachine[
                                                      listIndex]);
                                                },
                                                child: Text(
                                                    "${retResultmachine[listIndex].toString()} "))),
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
                                              print(retResultmachine[
                                                  listIndex + 1]);
                                              print(
                                                  "${listIndex} + ${listIndex + 2}");
                                            },
                                            child: Text(
                                                retResultmachine[listIndex + 1]
                                                    .toString())),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultmachine.removeRange(
                                                listIndex, listIndex + 2);
                                            // Result.remove(Result[index]);
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ),
                                );
                              },
                            )),
              // ListButton(
              //   buttonText: "Select Company",
              //   onPressed: () {
              //     gotoCompanyScreen(context);
              //   },
              // ),
              // (retResultcompany.isEmpty)
              //     ? Container()
              //     : Container(
              //         margin: EdgeInsets.symmetric(horizontal: 20),
              //         height: 200,
              //         width: double.infinity,
              //         color: Colors.grey.shade200,
              //         child: (retResultcompany.isEmpty)
              //             ? Center(
              //                 child: Text(
              //                   'Selected Company List',
              //                   style: TextStyle(color: Colors.grey),
              //                 ),
              //               )
              //             : ListView.builder(
              //                 itemCount: (retResultcompany.length / 2).floor(),
              //                 itemBuilder: (context, index) {
              //                   int listIndex = index * 2;
              //                   return Padding(
              //                     padding:
              //                         const EdgeInsets.only(left: 6, right: 6),
              //                     child: ListTile(
              //                       title: Row(
              //                         children: [
              //                           Padding(
              //                               padding:
              //                                   const EdgeInsets.only(right: 8),
              //                               child: InkWell(
              //                                   onTap: () {
              //                                     print(retResultcompany[
              //                                         listIndex]);
              //                                   },
              //                                   child: Text(
              //                                       "${retResultcompany[listIndex].toString()} "))),
              //                           Padding(
              //                             padding:
              //                                 const EdgeInsets.only(right: 8),
              //                             child: Text(
              //                               "|",
              //                               style: TextStyle(
              //                                   color: Colors.grey.shade400),
              //                             ),
              //                           ),
              //                           InkWell(
              //                               onTap: () {
              //                                 print(retResultcompany[
              //                                     listIndex + 1]);
              //                                 print(
              //                                     "${listIndex} + ${listIndex + 2}");
              //                               },
              //                               child: Text(
              //                                   retResultcompany[listIndex + 1]
              //                                       .toString())),
              //                         ],
              //                       ),
              //                       trailing: IconButton(
              //                           onPressed: () {
              //                             setState(() {
              //                               retResultcompany.removeRange(
              //                                   listIndex, listIndex + 2);
              //                               // Result.remove(Result[index]);
              //                             });
              //                           },
              //                           icon: Icon(Icons.cancel)),
              //                     ),
              //                   );
              //                 },
              //               )
              //       ),
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
                            )),
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
                  Expanded(
                    child: DropdownButtonFormField(
                        value: 'Detail',
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Report Type',
                            hintText: 'Report Type'),
                        items: ReportType.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownReportType = newValue!;
                            print(dropdownReportType);
                          });
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                        value: 'No',
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Include Opening',
                            hintText: 'Include Opening'),
                        items: IncOpeningList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownIncOpening = newValue!;
                            print(dropdownIncOpening);
                          });
                        }),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: 'No',
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Pending Negative',
                            hintText: 'Pending Negative'),
                        items: PendingNegList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownPendingNeg = newValue!;
                            print(dropdownPendingNeg);
                          });
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                        value: 'Pending',
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: 'Pending ?',
                        ),
                        items: TrnType.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownTrnType = newValue!;
                            print(dropdownTrnType);
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
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.normal)),
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
