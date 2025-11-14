// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/projFunction.dart';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:cloud_mobile/list/salesman_list.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/module/looms/saleorder/add_saleorderdet.dart';

class SaleOrderAdd extends StatefulWidget {
  SaleOrderAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var serial = '';
  var srchr;
  double tottaka = 0;
  double totmtrs = 0;

  @override
  _SaleOrderAddState createState() => _SaleOrderAddState();
}

class _SaleOrderAddState extends State<SaleOrderAdd> {
  final _formKey = GlobalKey<FormState>();

  // DateTime fromDate = DateTime.now();
  // DateTime toDate = DateTime.now();

  final _branchCtrl = new TextEditingController(),
      _orderNoCtrl = new TextEditingController(),
      _orderChrCtrl = new TextEditingController(),
      _dateCtrl = new TextEditingController(),
      _partyCtrl = new TextEditingController(),
      _agentCtrl = new TextEditingController(),
      _hasteCtrl = new TextEditingController(),
      _salesmanCtrl = new TextEditingController(),
      _dharaCtrl = new TextEditingController(),
      _duedaysCtrl = new TextEditingController(),
      _paytermsCtrl = new TextEditingController(),
      _stationCtrl = new TextEditingController(),
      _transportCtrl = new TextEditingController(),
      _remarksCtrl = new TextEditingController();

  // List _branchlist = [];
  // List _partylist = [];

  List gridItems = [];

  bool isButtonActive = true;

  var branchid = 0;
  var partyid = 0;
  var ptyState = "";
  var recordId;

  @override
  void initState() {
    super.initState();
    recordId = widget.xid;
    // fromDate = retconvdate(widget.xfbeg);
    // toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();

    _dateCtrl.text = DateFormat("dd-MM-yyyy").format(curDate);
    if (int.parse(recordId.toString()) > 0) {
      loadData();
      loadDetData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sale Order [ ' +
                (int.parse(recordId.toString()) > 0 ? 'EDIT' : 'ADD') +
                ' ] ' +
                (int.parse(recordId.toString()) > 0
                    ? 'Serial No : ' + widget.serial.toString()
                    : ''),
            style:
                const TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.done),
            backgroundColor: Colors.green,
            onPressed: isButtonActive
                ? () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text('Form submitted successfully !!')));
                      _handleSaveData();
                    }
                  }
                : null),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     int.parse(widget.xid) > 0
              //         ? Expanded(
              //             child: Center(
              //                 child: Text(
              //             'Challan No : ' + widget.serial.toString(),
              //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //           )))
              //         : Container(),
              //     Container(
              //       width: 300,
              //       child: TextFormField(
              //         textAlign: TextAlign.center,
              //         controller: _date,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Date',
              //           labelText: 'Date',
              //         ),
              //         onTap: () {
              //           _selectDate(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 20,)
              //   ],
              // ),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: _branchCtrl,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Select Branch',
                        labelText: 'Branch'),
                    onTap: openBranchList,
                    validator: (value) {
                      if (value == '') {
                        return "Please enter Branch";
                      }
                      return null;
                    },
                  ),
                ),
              ]),
              TextFormField(
                controller: _dateCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Date',
                    labelText: 'Date'),
                onTap: _selectDate,
                validator: (value) {
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                      child: Visibility(
                    visible: true,
                    child: TextFormField(
                      controller: _partyCtrl,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Party',
                          labelText: 'Party'),
                      onTap: () {
                        openPartyList('SALE PARTY', _partyCtrl);
                      },
                      onChanged: (value) {
                        _partyCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _partyCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  )),
                  Expanded(
                    child: TextFormField(
                      controller: _agentCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Agent',
                          labelText: 'Agent'),
                      onTap: () {
                        openPartyList('AGENT', _agentCtrl);
                      },
                      onChanged: (value) {
                        _agentCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _agentCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hasteCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Haste',
                          labelText: 'Haste'),
                      onTap: openHasteList,
                      onChanged: (value) {
                        _hasteCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _hasteCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _salesmanCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Salesman',
                          labelText: 'Salesman'),
                      onTap: openSalesmanList,
                      onChanged: (value) {
                        _salesmanCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _salesmanCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dharaCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter dhara',
                          labelText: 'Dhara'),
                      onChanged: (value) {
                        _dharaCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _dharaCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _duedaysCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter duedays',
                          labelText: 'Duedays'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _duedaysCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _duedaysCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _paytermsCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter Payterms',
                          labelText: 'Payterms'),
                      onChanged: (value) {
                        _paytermsCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _paytermsCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _stationCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Station',
                          labelText: 'Station'),
                      onTap: gotoStationScreen,
                      onChanged: (value) {
                        _stationCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _stationCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _transportCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Transport',
                          labelText: 'Transport'),
                      onTap: () {
                        openPartyList('TRANSPORT', _transportCtrl);
                      },
                      onChanged: (value) {
                        _transportCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _transportCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _remarksCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Select Remarks',
                          labelText: 'Remarks'),
                      onChanged: (value) {
                        _remarksCtrl.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _remarksCtrl.selection);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: AddSaleOrderGrid,
                      child: const Text('Add Item Details',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)))),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(columns: [
                    const DataColumn(label: Text("Action")),
                    const DataColumn(label: Text("Itemname")),
                    const DataColumn(label: Text("Hsncode")),
                    const DataColumn(label: Text("Design")),
                    const DataColumn(label: Text("Pcs")),
                    const DataColumn(label: Text("Meters")),
                    const DataColumn(label: Text("Rate")),
                    const DataColumn(label: Text("Amount")),
                    const DataColumn(label: Text("Unit")),
                    const DataColumn(label: Text("Discper")),
                    const DataColumn(label: Text("DiscAmt")),
                    const DataColumn(label: Text("AddAmt")),
                    const DataColumn(label: Text("TaxableValue")),
                    const DataColumn(label: Text("SGST %")),
                    const DataColumn(label: Text("SGST")),
                    const DataColumn(label: Text("CGST %")),
                    const DataColumn(label: Text("CGST")),
                    const DataColumn(label: Text("IGST %")),
                    const DataColumn(label: Text("IGST")),
                    const DataColumn(label: Text("FinalAmt")),
                    const DataColumn(label: Text("_gst")),
                  ], rows: _createRows())),
            ],
          ),
        )),
        bottomNavigationBar: BottomBar(
            companyname: widget.xcompanyname,
            fbeg: widget.xfbeg,
            fend: widget.xfend));
  }

  Future<bool> loadData() async {
    String formattedStartDate = getYMD(widget.xfbeg);
    String formattedEndDate = getYMD(widget.xfend);

    String url = "${globals.cdomain}/api/api_getsaleorderlist?1=1"
            "&dbname=${globals.dbname}" +
        "&cno=${globals.companyid}" +
        '&startdate=$formattedStartDate' +
        '&enddate=$formattedEndDate' +
        '&id=$recordId';

    print("mst url => " + url);

    var response = await http.get(Uri.parse(url));

    var mstData = jsonDecode(response.body);

    if (mstData['Code'] == "200") {
      mstData = mstData['Data'][0];

      _branchCtrl.text = getValue(mstData['branch'], 'C');
      _orderNoCtrl.text = getValue(mstData['orderno'], 'C');
      _orderChrCtrl.text = getValue(mstData['orderchr'], 'C');

      String inputDateString = getValue(mstData['date'], 'C');
      List<String> parts = inputDateString.split(' ')[0].split('-');
      String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
      _dateCtrl.text = formattedDate.toString();

      _partyCtrl.text = getValue(mstData['party'], 'C');
      _agentCtrl.text = getValue(mstData['agent'], 'C');
      _hasteCtrl.text = getValue(mstData['haste'], 'C');
      _salesmanCtrl.text = getValue(mstData['salesman'], 'C');
      _dharaCtrl.text = getValue(mstData['dhara'], 'N');
      _duedaysCtrl.text = getValue(mstData['duedays'], 'C');
      _paytermsCtrl.text = getValue(mstData['payterms'], 'C');
      _stationCtrl.text = getValue(mstData['city'], 'C');
      _transportCtrl.text = getValue(mstData['transport'], 'C');
      _remarksCtrl.text = getValue(mstData['remarks'], 'C');

      widget.serial = mstData['orderno'].toString();
      widget.srchr = mstData['orderchr'].toString();
    }

    return true;
  }

  Future<bool> loadDetData() async {
    String url = "${globals.cdomain}/api/api_getsaleorderdetlist?1=1"
            "&dbname=${globals.dbname}" +
        "&cno=${globals.companyid}" +
        '&id=$recordId';

    print("det url => " + url);
    var response = await http.get(Uri.parse(url));

    var gridData = jsonDecode(response.body);

    if (gridData['Code'] == "200") {
      gridData = gridData['Data'];

      print('gridData => ${gridData}');

      List ItemDet = [];
      gridItems = [];

      for (var i = 0; i < gridData.length; i++) {
        ItemDet.add({
          "controlid": gridData[i]['controlid'].toString(),
          "id": gridData[i]['id'].toString(),
          "itemname": gridData[i]['itemname'].toString(),
          "hsncode": gridData[i]['hsncode'].toString(),
          "design": gridData[i]['design'].toString(),
          "pcs": gridData[i]['pcs'].toString(),
          "meters": gridData[i]['meters'].toString(),
          "rate": gridData[i]['rate'].toString(),
          "amount": gridData[i]['amount'].toString(),
          "unit": gridData[i]['unit'].toString(),
          "discper": gridData[i]['discper'].toString(),
          "discamt": gridData[i]['discamt'].toString(),
          "addamt": gridData[i]['addamt'].toString(),
          "taxablevalue": gridData[i]['taxablevalue'].toString(),
          "sgstrate": gridData[i]['sgstrate'].toString(),
          "sgstamt": gridData[i]['sgstamt'].toString(),
          "cgstrate": gridData[i]['cgstrate'].toString(),
          "cgstamt": gridData[i]['cgstamt'].toString(),
          "igstrate": gridData[i]['igstrate'].toString(),
          "igstamt": gridData[i]['igstamt'].toString(),
          "finalamt": gridData[i]['finalamt'].toString(),
          "_gst": gridData[i]['_gst'].toString(),
        });
      }

      setState(() {
        gridItems = ItemDet;
      });
    }
    return true;
  }

  Future<bool> saveData() async {
    if (gridItems.length == 0) {
      showAlertDialog(context, "ItemDetails can't be not blank !!");
      return true;
    } else {
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;

      // var serial = _serialCtrl.text;
      // var srchr = _srchrCtrl.text;
      var branch = _branchCtrl.text;
      // var date = _dateCtrl.text;
      var party = _partyCtrl.text;
      var agent = _agentCtrl.text;
      var duedays = _duedaysCtrl.text;
      var haste = _hasteCtrl.text;
      var dhara = _dharaCtrl.text;
      var salesman = _salesmanCtrl.text;
      var station = _stationCtrl.text;
      var transport = _transportCtrl.text;
      var payterms = _paytermsCtrl.text;
      var remarks = _remarksCtrl.text;

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(_dateCtrl.text);
      String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      recordId = int.parse(recordId.toString());

      print(jsonEncode(gridItems));

      // DateTime parsedDate1 = DateFormat("dd-MM-yyyy").parse(widget.xfbeg);
      // String newfromdate = DateFormat("yyyy-MM-dd").format(parsedDate1);

      // DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(widget.xfend);
      // String newenddate = DateFormat("yyyy-MM-dd").format(parsedDate2);

      // DateTime parsedDate3 = DateFormat("dd-MM-yyyy").parse(date);
      // String newDate = DateFormat("yyyy-MM-dd").format(parsedDate3);

      String url = "${globals.cdomain}/api/api_storesaleorder?" +
          "dbname=$db" +
          "&cno=$cno" +
          "&id=${recordId.toString()}" +
          "&branch=$branch" +
          "&date=$newDate" +
          "&party=$party" +
          "&agent=$agent" +
          "&haste=$haste" +
          "&salesman=$salesman" +
          "&dhara=$dhara" +
          "&duedays=$duedays" +
          "&payterms=$payterms" +
          "&station=$station" +
          "&transport=$transport" +
          "&remarks=$remarks" +
          "&user=$username" +
          "&GridData=[{}]";

      print("Save url => " + url);

      final headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(gridItems));

      var jsonData = jsonDecode(response.body);
      print('jsonres: ${jsonData}');

      if (jsonData['Code'] == '500') {
        showAlertDialog(
            context, 'Error While Saving Data !!! ' + jsonData['Message']);
      } else {
        Fluttertoast.showToast(
            msg: "Saved !!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.purple,
            fontSize: 16.0);
        Navigator.pop(context);
      }

      return true;
    }
  }

  void openBranchList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => branch_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

    var retResult = result;

    print('result: ${result}');
    // _branchlist = result[1];
    result = result[1];
    // branchid = _branchlist[0];
    // print(branchid);

    var selBranch = '';
    for (var ictr = 0; ictr < retResult[0].length; ictr++) {
      if (ictr > 0) {
        selBranch = selBranch + ',';
      }
      selBranch = selBranch + retResult[0][ictr];
    }
    // setState(() {
    _branchCtrl.text = selBranch;
    // });
  }

  void openPartyList(acctype, TextEditingController obj) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => party_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend,
                acctype: acctype)));

    print('result: ${result}');

    var retResult = result;
    // _partylist = result[1];
    result = result[1];

    var selParty = '';
    for (var ictr = 0; ictr < retResult[0].length; ictr++) {
      if (ictr > 0) {
        selParty = selParty + ',';
      }
      selParty = selParty + retResult[0][ictr];
    }

    obj.text = selParty;
    if (acctype == 'SALE PARTY') {
      // setState(() {
      ptyState = result[0]['state']?.toString() ?? "";
      _agentCtrl.text = result[0]['agent']?.toString() ?? "";
      _transportCtrl.text = result[0]['transport']?.toString() ?? "";
      _salesmanCtrl.text = result[0]['salesman']?.toString() ?? "";
      // });
    }
  }

  void openHasteList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => party_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend,
                acctype: 'HASTE')));

    print('result: ${result}');
    var retResult = result;
    // _partylist = result[1];
    result = result[1];

    var selParty = '';
    for (var ictr = 0; ictr < retResult[0].length; ictr++) {
      if (ictr > 0) {
        selParty = selParty + ',';
      }
      selParty = selParty + retResult[0][ictr];
    }
    _hasteCtrl.text = selParty;
  }

  void openSalesmanList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => salesman_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

    print('result: ${result}');
    var retResult = result;

    var selSalesman = '';
    for (var ictr = 0; ictr < retResult[0].length; ictr++) {
      if (ictr > 0) {
        selSalesman = selSalesman + ',';
      }
      selSalesman = selSalesman + retResult[0][ictr];
    }

    _salesmanCtrl.text = selSalesman;
  }

  void gotoStationScreen() async {
    var result = await openCity_List(context, widget.xcompanyid,
        widget.xcompanyname, widget.xfbeg, widget.xfend);

    print('result: ${result}');
    var retResult = result[0];
    var selCity = '';

    for (var ictr = 0; ictr < retResult.length; ictr++) {
      if (ictr > 0) {
        selCity = selCity + ',';
      }
      selCity = selCity + retResult[ictr];
    }
    print(selCity);

    // setState(() {
    _stationCtrl.text = selCity;
    // });
  }

  void AddSaleOrderGrid() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SaleOrderDetAdd(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend,
                ptyState: ptyState,
                itemDet: gridItems)));
    print('result: ${result}');
    setState(() {
      gridItems.add(result[0]);
    });
  }

  Future<void> _handleSaveData() async {
    setState(() {
      isButtonActive = false;
    });

    bool success = await saveData();

    setState(() {
      isButtonActive = success;
    });
  }

  void deleteRow(index) {
    setState(() {
      gridItems.removeAt(index);
    });
  }

  List<DataRow> _createRows() {
    List<DataRow> _datarow = [];

    widget.tottaka = 0;
    widget.totmtrs = 0;

    for (int i = 0; i < gridItems.length; i++) {
      _datarow.add(DataRow(cells: [
        DataCell(ElevatedButton.icon(
            onPressed: () => {deleteRow(i)},
            icon: const Icon(Icons.delete, size: 24.0),
            label: const Text('',
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.bold)))),
        DataCell(Text(gridItems[i]['itemname'].toString())),
        DataCell(Text(gridItems[i]['hsncode'].toString())),
        DataCell(Text(gridItems[i]['design'].toString())),
        DataCell(Text(gridItems[i]['pcs'].toString())),
        DataCell(Text(gridItems[i]['meters'].toString())),
        DataCell(Text(gridItems[i]['rate'].toString())),
        DataCell(Text(gridItems[i]['amount'].toString())),
        DataCell(Text(gridItems[i]['unit'].toString())),
        DataCell(Text(gridItems[i]['discper'].toString())),
        DataCell(Text(gridItems[i]['discamt'].toString())),
        DataCell(Text(gridItems[i]['addamt'].toString())),
        DataCell(Text(gridItems[i]['taxablevalue'].toString())),
        DataCell(Text(gridItems[i]['sgstrate'].toString())),
        DataCell(Text(gridItems[i]['sgstamt'].toString())),
        DataCell(Text(gridItems[i]['cgstrate'].toString())),
        DataCell(Text(gridItems[i]['cgstamt'].toString())),
        DataCell(Text(gridItems[i]['igstrate'].toString())),
        DataCell(Text(gridItems[i]['igstamt'].toString())),
        DataCell(Text(gridItems[i]['finalamt'].toString())),
        DataCell(Text(gridItems[i]['_gst'].toString())),
      ]));
    }
    setState(() {});
    return _datarow;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _dateCtrl.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  // void setDates() {
  //   DateTime date = DateTime.now();
  //   _dateController.text = DateFormat("dd-MM-yyyy").format(date);
  //   strDate = DateFormat("yyyy-MM-dd").format(date);
  //   _ptyOrdDateController.text = DateFormat("dd-MM-yyyy").format(date);
  //   strPtyOrdDate = DateFormat("yyyy-MM-dd").format(date);
  // }
}
