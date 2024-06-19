// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:cloud_mobile/module/looms/machinecard/add_loomsmachinecarddet.dart';
import 'package:cloud_mobile/module/looms/takaadjustment/add_loomstakaadjustmentdet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';


class MachinecardAdd extends StatefulWidget {
  MachinecardAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  var serial;
  var srchr;
  double tottaka = 0;
  double totmtrs = 0;

  @override
  _MachinecardAddState createState() => _MachinecardAddState();
}

class _MachinecardAddState extends State<MachinecardAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];

  List ItemDetails = [];

  bool isButtonActive = true;

  String dropdownTrnType = 'REGULAR';

  var branchid = 0;
  var partyid = 0;

  TextEditingController _branch = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _beamstock = new TextEditingController();
  TextEditingController _yarnstock = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var bmitem;

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = DateFormat("dd-MM-yyyy").format(curDate);
    if (int.parse(widget.xid) > 0) {
      loadData();

      loadDetData();
    }
  }

  Future<bool> loadDetData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;

    uri =
        'https://www.looms.equalsoftlink.com/api/api_gettakaadjustmentdetlist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id;
    print(" loadDetData : " +uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //jsonData = jsonData[0];

    print(jsonData);
    List ItemDet = [];
    ItemDetails = [];


    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      ItemDet.add({
        "controlid": jsonData[iCtr]['controlid'].toString(),
        "id": jsonData[iCtr]['id'].toString(),
        "takano": jsonData[iCtr]['takano'].toString(),
        "takachr": jsonData[iCtr]['takachr'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "design": jsonData[iCtr]['design'].toString(),
        "pcs": jsonData[iCtr]['pcs'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "tpmtrs": jsonData[iCtr]['tpmtrs'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "itename": jsonData[iCtr]['itemname'].toString(),
        "machine": jsonData[iCtr]['machine'].toString(),
        "inwid": jsonData[iCtr]['inwid'].toString(),
        "inwdetid": jsonData[iCtr]['inwdetid'].toString(),
        "inwdettkid": jsonData[iCtr]['inwdettkid'].toString(),
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "avgwt": jsonData[iCtr]['avgwt'].toString(),
        "stdwt": jsonData[iCtr]['stdwt'].toString(),
        "netwt": jsonData[iCtr]['netwt'].toString(),
        "beamno": jsonData[iCtr]['beamno'].toString(),
        "beamitem": jsonData[iCtr]['beamitem'].toString(),
      });
    }

    setState(() {
      ItemDetails = ItemDet;
    });

    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = retconvdate(widget.xfbeg).toString();
    var todate = retconvdate(widget.xfend).toString();

    uri =
        'https://www.looms.equalsoftlink.com/api/api_gettakaadjustmentlist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id +
            '&startdate=' +
            fromdate +
            '&enddate=' +
            todate;
    print(" loadData :" +uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _branch.text = getValue(jsonData['branch'], 'C');
    _serial.text = getValue(jsonData['serial'], 'C');
    _srchr.text = getValue(jsonData['srchr'], 'C');
    _date.text = getValue(jsonData['date2'], 'C');
    _party.text = getValue(jsonData['bookno'], 'C');
    _beamstock.text = getValue(jsonData['beamstock'], 'C');
    _yarnstock.text = getValue(jsonData['yarnstock'], 'C');

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _date.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    void gotoBranchScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => branch_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;

        print(retResult);
        _branchlist = result[1];
        result = result[1];
        branchid = _branchlist[0];
        print(branchid);

        var selBranch = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selBranch = selBranch + ',';
          }
          selBranch = selBranch + retResult[0][ictr];
        }
        _branch.text = selBranch;
      });
    }

    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoomMachinecardDetAdd(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    itemDet: ItemDetails,
                  )));
      //print('out');
      //print(result);
      //print(result[0]['takachr']);
      setState(() {
        ItemDetails.add(result[0]);
        //ItemDetails = ItemDetails[0];
        print(ItemDetails);
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var serial = _serial.text;
      var srchr = _srchr.text;
      var branch = _branch.text;
      var date = _date.text;
      var party = _party.text;
      var beamstock = _beamstock.text;
      var yarnstock = _yarnstock.text;

      var id = widget.xid;
      id = int.parse(id);


      print(jsonEncode(ItemDetails));

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      String newDate = DateFormat("yyyy-MM-dd").format(parsedDate); 

      uri =
          "https://looms.equalsoftlink.com/api/api_storetakaadjustment?dbname=" +
              db +
              "&company=&cno=" +
              cno +
              "&user=" +
              username +
              "&branch=" +
              branch +
              "&type=" +
              "&party=" +
              "&srchr=" +
              srchr +
              "&serial=" +
              serial +
              "&date=" +
              newDate +
              "&book=" +
              "&remarks=" +
              "&chlnno=" +
              "&chlnchr=" +
              "&id=" +
              id.toString() +
              "&parcel=1";
      print(" SaveData " + uri);

      final headers = {
        'Content-Type': 'application/json', // Set the appropriate content-type
        // Add any other headers required by your API
      };
      print(ItemDetails);
      var response = await http.post(Uri.parse(uri),
          headers: headers, body: jsonEncode(ItemDetails));

      var jsonData = jsonDecode(response.body);

      //print('4');

      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        Fluttertoast.showToast(
          msg: "Saved !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.purple,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
      return true;
    }

    Future<void> _handleSaveData() async {
      setState(() {
        isButtonActive = false; // Disable the button
      });

      bool success = await saveData();

      setState(() {
        isButtonActive = success;
      });
    }


    void deleteRow(index) {
      setState(() {
        ItemDetails.removeAt(index);
      });
    }

    List<DataRow> _createRows() {
      List<DataRow> _datarow = [];
      print(ItemDetails);

      widget.tottaka = 0;
      widget.totmtrs = 0;

      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        double nMeters = 0;
        if (ItemDetails[iCtr]['meters'] != '') {
          nMeters = nMeters + double.parse(ItemDetails[iCtr]['meters']);
          widget.tottaka += 1;
          widget.totmtrs += nMeters;
        }

        print(ItemDetails[iCtr]);
        _datarow.add(DataRow(cells: [
          DataCell(ElevatedButton.icon(
            onPressed: () => {deleteRow(iCtr)},
            icon: Icon(
              // <-- Icon
              Icons.delete,
              size: 24.0,
            ),
            label: Text('',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          )),
          DataCell(Text(ItemDetails[iCtr]['machine'])),
          DataCell(Text(ItemDetails[iCtr]['takano'])),
          DataCell(Text(ItemDetails[iCtr]['pcs'])),
          DataCell(Text(ItemDetails[iCtr]['meters'])),
          DataCell(Text(ItemDetails[iCtr]['tpmtrs'])),
          DataCell(Text(ItemDetails[iCtr]['avgwt'])),
          DataCell(Text(ItemDetails[iCtr]['netwt'])),
          DataCell(Text(ItemDetails[iCtr]['itemname'])),
          DataCell(Text(ItemDetails[iCtr]['rate'])),
          DataCell(Text(ItemDetails[iCtr]['unit'])),
          DataCell(Text(ItemDetails[iCtr]['amount'])),
          DataCell(Text(ItemDetails[iCtr]['design'])),
          DataCell(Text(ItemDetails[iCtr]['machine'])),
          DataCell(Text(ItemDetails[iCtr]['stdwt'])),
          DataCell(Text(ItemDetails[iCtr]['inwid'])),
          DataCell(Text(ItemDetails[iCtr]['inwdetid'])),
          DataCell(Text(ItemDetails[iCtr]['inwdettkid'])),
          DataCell(Text(ItemDetails[iCtr]['beamitem'])),
          DataCell(Text(ItemDetails[iCtr]['beamno'].toString())),
          DataCell(Text(ItemDetails[iCtr]['fmode'])),
        ]));
      }
      setState(() {});
      return _datarow;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Machine Card [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ' +
              (int.parse(widget.xid) > 0
                  ? 'Serial No : ' + widget.serial.toString()
                  : ''),
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: isButtonActive ? () => _handleSaveData() : null,
      ),
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
                  controller: _branch,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Select Branch',
                    labelText: 'Branch',
                  ),
                  onTap: () {
                    gotoBranchScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ]),
            TextFormField(
              controller: _date,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Date',
                labelText: 'Date',
              ),
              onTap: () {
                _selectDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                child: Visibility(
                visible:true,
                  child: TextFormField(
                    controller: _party,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Party',
                      labelText: 'Party',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _beamstock,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam Stock',
                      labelText: 'Beam Stock',
                    ),
                    onChanged: (value) {
                      _beamstock.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _beamstock.selection);
                    },
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _yarnstock,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Yarn Stock',
                      labelText: 'Yarn Stock',
                    ),
                    onChanged: (value) {
                      _yarnstock.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _yarnstock.selection);
                    },
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
              onPressed: () => {gotoChallanItemDet(context)},
              child: Text('Add Item Details',
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: [
                  DataColumn(
                    label: Text("Action"),
                  ),
                  DataColumn(
                    label: Text("Machine"),
                  ),
                  DataColumn(
                    label: Text("Rpm"),
                  ),
                  DataColumn(
                    label: Text("Dsmeters"),
                  ),
                  DataColumn(
                    label: Text("Dsefficiency"),
                  ),
                  DataColumn(
                    label: Text("Dsname"),
                  ),
                  DataColumn(
                    label: Text("Nsmeters"),
                  ),
                  DataColumn(
                    label: Text("Nsefficiency"),
                  ),
                  DataColumn(
                    label: Text("Nsname"),
                  ),
                  DataColumn(
                    label: Text("Totmeters"),
                  ),
                  DataColumn(
                    label: Text("Warplength"),
                  ),
                  DataColumn(
                    label: Text("Outmeters"),
                  ),
                  DataColumn(
                    label: Text("Remainmeters"),
                  ),
                  DataColumn(
                    label: Text("Ends"),
                  ),
                  DataColumn(
                    label: Text("Reed"),
                  ),
                  DataColumn(
                    label: Text("Pick"),
                  ),
                  DataColumn(
                    label: Text("Itemname"),
                  ),
                  DataColumn(
                    label: Text("Remarks"),
                  ),
                ], rows: _createRows())),
          ],
        ),
      )),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
