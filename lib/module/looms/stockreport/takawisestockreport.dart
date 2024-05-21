// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/listbutton.dart';
import 'package:cloud_mobile/dfreport.dart';
import 'package:cloud_mobile/list/branchid_list.dart';
import 'package:cloud_mobile/list/designid_list.dart';
import 'package:cloud_mobile/list/itemid_list.dart';
import 'package:cloud_mobile/list/machineid_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:intl/intl.dart';

class TakawiseStockReport extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  TakawiseStockReport({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _TakawiseStockReportState createState() => _TakawiseStockReportState();
}

class _TakawiseStockReportState extends State<TakawiseStockReport> {
  List retResultmodule = [];
  List retResultmachine = [];
  List retResultdesign = [];
  List retResultitem = [];
  List retResulttakachr = [];
  List retResulttakano = [];
  List retResultbranch = [];
  List retResultgroup = [];

  String SelectedModule = '';
  String SelectedMachine = '';
  String SelectedDesign = '';
  String SelectedItem = '';
  String SelectedTakaChr = '';
  String SelectedTakaNo = '';
  String SelectedBranch = '';
  String SelectedGroup = '';

  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano= new TextEditingController(text: '0');

  String dropdownReportType = 'Detail';

  var ReportType = [
    'Detail',
    'Summary',
    'Concise',
  ];

  String dropdownTrnType = 'Pending';

  var TrnType = [
    'Pending',
    'Closed',
    'All',
  ];

  // String dropdownModuleType = '';

  // var ModuleType= [
  //   '',
  //   'Taka Production',
  //   'Taka Entry',
  //   'Grey Purchase Challan',
  //   'Dyegrey Jobwork Receive',
  //   'Purchase Challan',
  //   'Taka Return',
  //   'Folding Entry',
  //   'Taka Merge',
  //   'Grey Job Receive',
  // ];

  String dropdownIncNegStk = 'No';

  var IncNegStkList = [
    'No',
    'Yes',
  ];

  String dropdownIncPhyStk = 'No';

  var IncPhyStkList = [
    'No',
    'Yes',
  ];

  String dropdownGroupBy = 'Regular';

  var GroupByList = [
    'Regular',
    'Branch',
    'Itemname',
    'Design',
    'Machine',
    // 'Module',
  ];


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

    void gotoMachineScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => machineid_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        retResultmachine += result;
      });
    }
   
   void GenerateReport(BuildContext context) async {

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

      if(_formKey.currentState!.validate()){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('')),
        );
      }

      var takachr = _takachr.text;
      var takano = _takano.text;

      DialogBuilder(context).showLoadingIndicator('');

      var fromdate = _fromdate.text.toString().split(' ')[0];
      var todate = _todate.text.toString().split(' ')[0];
      var cno = widget.xcompanyid;
      var _dbname = globals.dbname;


      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(fromdate);
      String _fromDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(todate);
      String _toDate = DateFormat("yyyy-MM-dd").format(parsedDate2);

      if(dropdownIncNegStk == "No"){
        dropdownIncNegStk = 'N';
      } else if(dropdownIncNegStk == "Yes"){
        dropdownIncNegStk = 'Y';
      }

      if (dropdownIncPhyStk == "No") {
        dropdownIncPhyStk = 'N';
      } else if (dropdownIncPhyStk == "Yes") {
        dropdownIncPhyStk = 'Y';
      }

      if (dropdownReportType == "Detail") {
        dropdownReportType = 'D';
      } else if (dropdownReportType == "Summary") {
        dropdownReportType = 'S';
      } else if(dropdownReportType == 'Concise'){
        dropdownReportType = 'C';
      }

      if (dropdownTrnType == "Pending") {
        dropdownTrnType = 'P';
      } else if (dropdownTrnType == "Closed") {
        dropdownTrnType = 'C';
      } else if(dropdownTrnType == 'All'){
        dropdownTrnType = 'A';
      }

      String url = '';

      url = '${globals.cdomain}/gettakastockreport?fromdate=' +
      _fromDate +
      '&todate=' +
      _toDate +
      '&groupby=' +
      dropdownGroupBy.toLowerCase() +
      '&created_at=' +
      '&tocreated_at=' +
      '&branch=' +
      branchlist +
      '&itemname=' +
      itemlist +
      '&incnegativestk=' +
      dropdownIncNegStk +
      '&incphysicalstk=' +
      dropdownIncPhyStk +
      '&design=' +
      designlist +
      '&machineno=' +
      machinelist +
      '&takachr=' +
      takachr +
      '&takano=' +
      takano.toString() +
      '&rvalue=' +
      dropdownTrnType +
      '&ncompany=' +
      '&rtype=' +
      dropdownReportType +
      '&module=' +
      // dropdownModuleType +
      '&dbname=' +
      _dbname +
      '&cno=3' +
      cno +
      '&startdate=2024-04-01' +
      '&enddate=2025-03-31';

      print(" GenerateReport :" + url);

      if (dropdownReportType == "D") {
        var response = await http.get(Uri.parse(url));
        var jsonData = jsonDecode(response.body);
        var aGroup = [];
        jsonData = jsonData['data'];
        print("chirag");
        print(jsonData);
        if (dropdownGroupBy.toLowerCase() == 'branch') {
          aGroup = [
            {'field': 'branch', 'heading': 'Branch'}
          ];
          jsonData.sort((a, b) =>
              a['branch'].toString().compareTo(b['branch'].toString()));
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
          jsonData.sort(
              (a, b) => a['machine'].toString().compareTo(b['machine'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'takachr') {
          aGroup = [
            {'field': 'takachr', 'heading': 'Takachr'}
          ];
          jsonData.sort((a, b) =>
              a['takachr'].toString().compareTo(b['takachr'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'takano') {
          aGroup = [
            {'field': 'takano', 'heading': 'Takano'}
          ];
          jsonData.sort((a, b) =>
              a['takano'].toString().compareTo(b['takano'].toString()));
        }

        DialogBuilder(context).hideOpenDialog();
        String calias = 'takastockreport';
        String cRptCaption = 'Taka Stock Report';
        String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
        dfReport oReport = new dfReport(jsonData, aGroup);
        oReport.addColumn('takano', 'TakaNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('takachr', 'TakaChr', 'C', '10', '0', 'l', '');
        oReport.addColumn('fmode', 'Fmode', 'C', '10', '0', 'l', '');
        oReport.addColumn('ctakano', 'cTakaNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('itemname', 'Itemname', 'C', '10', '0', 'l', '');
        oReport.addColumn('design', 'Design', 'C', '10', '0', 'l', '');
        oReport.addColumn('machine', 'Machine', 'N', '10', '2', 'l', '');
        oReport.addColumn('pcs', 'Pcs', 'N', '10', '2', 'l', '');
        oReport.addColumn('balmeters', 'Balmeters', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('weight', 'Weight', 'N', '10', '2', 'l', 'sum'); 
        oReport.addColumn('inwid', 'InwId', 'N', '10', '2', 'l', '');
        oReport.addColumn('inwdetid', 'InwDetId', 'N', '10', '2', 'l', '');
        oReport.addColumn('inwdettkid', 'InwDettkId', 'N', '10', '2', 'l', '');
        oReport.addColumn('cost', 'Cost', 'N', '10', '2', 'l', '');
        oReport.addColumn('serial', 'Serial', 'N', '10', '2', 'l', '');
        oReport.addColumn('srchr', 'Srchr', 'N', '10', '2', 'l', '');
        oReport.addColumn('branch', 'Branch', 'C', '10', '0', 'l', '');
        oReport.addColumn('unit', 'Unit', 'C', '10', '0', 'l', '');        
        oReport.addColumn('stdwt', 'Stdweight', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('hsncode', 'HSNCode', 'N', '10', '2', 'l', '');
        oReport.addColumn('pertaka', 'PerTaka', 'N', '10', '2', 'l', '');
        oReport.addColumn('chlnno', 'ChlnNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('takaprodmtrs', 'Takaprodmtrs', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('takamtrs', 'Takamtrs', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('salechlnmtrs', 'SaleChlnmtrs', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('greypurcmtrs', 'Greypurcmtrs', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('greypurcretmtrs', 'Greypurcretmtrs', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('greyjobissuemtrs', 'Greyjobissuemtrs', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('dyegreyjobrecmtrs', 'Dyegreyjobrecmtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('greyjobrecmtrs', 'Greyjobrecmtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('takamergemtrs', 'Takamergemtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('foldingmtrs', 'Foldingmtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('takaretmtrs', 'Takaretmtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('tpmtrs', 'Tpmtrs', 'N', '12', '2', 'r', '');
        oReport.addColumn('avgwt', 'Avgweight', 'N', '12', '2', 'r', '');
        oReport.addColumn('itemid', 'ItemId', 'N', '12', '2', 'r', '');
        oReport.addColumn('machineid', 'MachineId', 'N', '12', '2', 'r', '');
        oReport.addColumn('branchid', 'BranchID', 'N', '12', '2', 'r', '');
        oReport.addColumn('dyegreyjobretmtrs', 'Dyegreyjobretmtrs', 'N', '12','2', 'r', 'sum');
        oReport.addColumn('designid', 'DesignId', 'N', '12', '2', 'r', '');
        oReport.addColumn('takaadjmtrs', 'Takaadjmtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('module', 'module', 'C', '10', '0', 'l', '');
        oReport.addColumn('beamitemid', 'BeamItemId', 'N', '12', '2', 'r', '');
        oReport.addColumn('beamitem', 'BeamItem', 'C', '10', '0', 'l', '');
        oReport.addColumn('beamno', 'BeamNo', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('shtmtrs', 'Shtmtrs', 'N', '12', '2', 'r', 'sum');
        oReport.addColumn('phystkmtrs', 'Phystkmtrs', 'N', '12', '2', 'r', '');
        oReport.addColumn('diffmtrs', 'Diffmtrs', 'N', '12', '2', 'r', '');
        print("1");
        oReport.prepareReport();
        print("1");
        oReport.calias = calias;
        oReport.cRptCaption = cRptCaption;
        oReport.cRptCaption2 = cRptCaption2;
        oReport.GenerateReport(context);
      } 
      else if(dropdownReportType == 'S'){
        var response = await http.get(Uri.parse(url));
        var jsonData = jsonDecode(response.body);
        var aGroup = [];
        jsonData = jsonData['data'];
        print("chirag");
        print(jsonData);
        DialogBuilder(context).hideOpenDialog();
        String calias = 'takastockreport' + dropdownGroupBy;
        String cRptCaption = 'Taka Stock Summary ' + dropdownGroupBy + 'wise Report';
        String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
        dfReport oReport = new dfReport(jsonData, aGroup);
        oReport.addColumn('det',dropdownGroupBy, 'C','10', '0', 'l', '');
        oReport.addColumn('takano', 'TakaNo', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('meters', 'Meters', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('weight', 'Weight', 'N', '10', '2', 'l', 'sum');
        print("1");
        oReport.prepareReport();
        print("1");
        oReport.calias = calias;
        oReport.cRptCaption = cRptCaption;
        oReport.cRptCaption2 = cRptCaption2;
        oReport.GenerateReport(context);
      }
      else if(dropdownReportType == 'C'){
        var response = await http.get(Uri.parse(url));
        var jsonData = jsonDecode(response.body);
        var aGroup = [];
        jsonData = jsonData['data'];
        print("chirag");
        print(jsonData);
        if (dropdownGroupBy.toLowerCase() == 'branch') {
          aGroup = [
            {'field': 'branch', 'heading': 'Branch'}
          ];
          jsonData.sort((a, b) =>
              a['branch'].toString().compareTo(b['branch'].toString()));
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
          jsonData.sort(
              (a, b) => a['machine'].toString().compareTo(b['machine'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'takachr') {
          aGroup = [
            {'field': 'takachr', 'heading': 'Takachr'}
          ];
          jsonData.sort((a, b) =>
              a['takachr'].toString().compareTo(b['takachr'].toString()));
        }
        if (dropdownGroupBy.toLowerCase() == 'takano') {
          aGroup = [
            {'field': 'takano', 'heading': 'Takano'}
          ];
          jsonData.sort((a, b) =>
              a['takano'].toString().compareTo(b['takano'].toString()));
        }

        DialogBuilder(context).hideOpenDialog();
        String calias = 'takastockreport';
        String cRptCaption = 'Taka Stock Consice Report';
        String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
        dfReport oReport = new dfReport(jsonData, aGroup);
        oReport.addColumn('takano', 'TakaNo', 'N', '10', '2', 'l', '');
        oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
        oReport.addColumn('meters', 'Meters', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('weight', 'Weight', 'N', '10', '2', 'l', 'sum');
        oReport.addColumn('serial', 'Serial', 'N', '10', '2', 'l', '');
        oReport.addColumn('branch', 'Branch', 'C', '10', '0', 'l', '');
        oReport.addColumn('chlnno', 'ChlnNo', 'N', '10', '2', 'l', '');
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
          'Taka Stock Report',
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
                            )
                    ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _takachr,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'TakaChr',
                        labelText: 'TakaChr',
                      ),
                      onChanged: (value) {
                        _takachr.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _takachr.selection);
                      },
                      onTap: () {
                        print('going to TakaChr screen');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _takano,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number ,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'TakaNo',
                        labelText: 'TakaNo',
                      ),
                      onTap: () {
                        print('going to g screen');
                      },
                    ),
                  ),
                ],
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
                        validator: (value) {
                          if (dropdownReportType == "Summary") {
                            if (dropdownGroupBy == 'Regular') {
                              return 'Please select group by.';
                            }
                          }
                          return null;
                        },
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
                        hintText: 'Report Type'
                      ),
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
                      }
                    ),
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
                            labelText: 'Include Negative Stk',
                            hintText: 'Include Negative Stk'),
                        items: IncNegStkList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownIncNegStk = newValue!;
                            print(dropdownIncNegStk);
                          });
                        }),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: 'No',
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Include Physical Stk',
                        hintText: 'Include Physical Stk'
                      ),
                      items: IncPhyStkList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownIncPhyStk = newValue!;
                          print(dropdownIncPhyStk);
                        });
                      }
                    ),
                  )
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: DropdownButtonFormField(
              //         value: '',
              //         decoration: const InputDecoration(
              //             icon: const Icon(Icons.person),
              //             labelText: 'Module',
              //             hintText: 'Module'),
              //         items: ModuleType.map((String items) {
              //           return DropdownMenuItem(
              //             value: items,
              //             child: Text(items),
              //           );
              //         }).toList(),
              //         icon: const Icon(Icons.arrow_drop_down_circle),
              //         onChanged: (String? newValue) {
              //           setState(() {
              //             dropdownModuleType = newValue!;
              //             print(dropdownModuleType);
              //           });
              //           }),
              //     )
              //   ],
              // ),
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
                      }
                    ),
                  )
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
