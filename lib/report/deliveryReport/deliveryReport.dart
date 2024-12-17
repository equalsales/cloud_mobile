// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/listbutton.dart';
import 'package:cloud_mobile/dfreport.dart';
import 'package:cloud_mobile/list/driverid_list.dart';
import 'package:cloud_mobile/list/partyid_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:intl/intl.dart';

class DeliveryReport extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  DeliveryReport({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _DeliveryReportState createState() => _DeliveryReportState();
}

class _DeliveryReportState extends State<DeliveryReport> {

  List retResultdesign = [];
  List retResultitem = [];
  List retResultParty = [];
  List retResultDriver = [];
  List retResultgroup = [];

  // String SelectedDesign = '';
  String SelectedItem = '';
  String SelectedGroup = '';

  final _formKey = GlobalKey<FormState>();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _fromdate = new TextEditingController();
  TextEditingController _todate = new TextEditingController();


  String dropdownGroupBy = '';

  var GroupByList = [
    '',
    'Party',
    'Driver',
  ];

  String dropdownTrnType = 'DELIVERED';

  var TrnType = [
    'DELIVERED',
    'PENDING',
  ];


  @override
  void initState() {
    super.initState();
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
        initialDate: DateTime(2024, 4, 1),
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
        retResultParty += result;
      });
    }

  void gotoDriverScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => driverid_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

      setState(() {
        retResultDriver += result;
      });
  }

    void GenerateReport(BuildContext context) async {
      
      var partylist = '';
      for (var ictr = 0; ictr < retResultParty.length; ictr++) {
        if (ictr % 2 == 0) {
          partylist = partylist + retResultParty[ictr].toString() + ',';
        }
      }
      if (partylist.isNotEmpty) {
        partylist = partylist.substring(0, partylist.length - 1);
      }

      var driverlist = '';
      for (var ictr = 0; ictr < retResultDriver.length; ictr++) {
        if (ictr % 2 == 0) {
          driverlist = driverlist + retResultDriver[ictr].toString() + ',';
        }
      }
      if (driverlist.isNotEmpty) {
        driverlist = driverlist.substring(0, driverlist.length - 1);
      }

      if(_formKey.currentState!.validate()){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('')),
        );
      }

      DialogBuilder(context).showLoadingIndicator('');

      var fromdate = _fromdate.text.toString().split(' ')[0];
      var todate = _todate.text.toString().split(' ')[0];
      var cno = widget.xcompanyid;
      var _dbname = globals.dbname;


      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(fromdate);
      String _fromDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(todate);
      String _toDate = DateFormat("yyyy-MM-dd").format(parsedDate2);

      if (dropdownTrnType == "DELIVERED") {
        dropdownTrnType = 'D';
      } else if (dropdownTrnType == "PENDING") {
        dropdownTrnType = 'P';
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
      '&itemname=' +
      '&machineno=' +
      '&takachr=' +
      '&takano=' +
      '&rvalue=' +
      dropdownTrnType +
      '&ncompany=' +
      '&rtype=' +
      '&module=' +
      '&dbname=' +
      _dbname +
      '&cno=3' +
      cno +
      '&startdate=2024-04-01' +
      '&enddate=2025-03-31';

      print(" GenerateReport :" + url);

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
      return;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Report',
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
                buttonText: "Select Party",
                onPressed: () {
                  gotoPartyScreen(context);
                },
              ),
              (retResultParty.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultParty.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Party List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultParty.length / 2).floor(),
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
                                                        retResultParty[listIndex]);
                                                  },
                                                  child: Text(
                                                      "${retResultParty[listIndex].toString()} ",overflow: TextOverflow.ellipsis))),
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
                                              child: Text(
                                                  retResultParty[listIndex + 1]
                                                      .toString(),overflow: TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultParty.removeRange(
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
                buttonText: "Select Driver",
                onPressed: () {
                  gotoDriverScreen();
                },
              ),
              (retResultDriver.isEmpty)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (retResultDriver.isEmpty)
                          ? Center(
                              child: Text(
                                'Selected Driver List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (retResultDriver.length / 2).floor(),
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
                                                    print(retResultDriver[
                                                        listIndex]);
                                                  },
                                                  child: Text(
                                                      "${retResultDriver[listIndex].toString()} ",overflow: TextOverflow.ellipsis))),
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
                                                print(retResultDriver[
                                                    listIndex + 1]);
                                                print(
                                                    "${listIndex} + ${listIndex + 2}");
                                              },
                                              child: Text(
                                                  retResultDriver[listIndex + 1]
                                                      .toString(),overflow: TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            retResultDriver.removeRange(
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
                        value: '',
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
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: 'DELIVERED',
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Report type ?',
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
