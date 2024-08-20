import 'dart:convert';

//import 'package:cloud_mobile/module/looms/saleschallan/loomsaleschallanlist.dart';
//import 'package:cloud_mobile/module/looms/saleschallan/add_loomsaleschallandet.dart';
import 'package:cloud_mobile/module/looms/greyjobissue/loomgreyjobissuelist.dart';
import 'package:cloud_mobile/module/looms/physicalstock/add_loomphysicalstockdet.dart';
import 'package:cloud_mobile/module/looms/physicalstock/loomphysicalstocklist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';

import '../../../common/global.dart' as globals;
//import 'package:cloud_mobile/list/city_list.dart';
//import 'package:cloud_mobile/list/state_list.dart';
import 'package:cloud_mobile/list/branch_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

//// import 'package:google_fonts/google_fonts.dart';
//import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';
import 'package:cloud_mobile/module/looms/greyjobissue/add_loomgreyjobissuedet.dart';

class physicalstockAdd extends StatefulWidget {
  physicalstockAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _physicalstockAddState createState() => _physicalstockAddState();
}

class _physicalstockAddState extends State<physicalstockAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];

  List ItemDetails = [];

  String dropdownTrnType = 'REGULAR';
  bool isButtonActive = true;

  var branchid = 0;
  var partyid = 0;

  TextEditingController _branch = new TextEditingController();
  TextEditingController _type = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _chlnno = new TextEditingController();
  TextEditingController _chlnchr = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _tottaka = new TextEditingController();
  TextEditingController _totmtrs = new TextEditingController();
  TextEditingController _branchid = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = curDate.toString().split(' ')[0];

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
        '${globals.cdomain}/api/api_getphysicalstockdetlist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id;
    print(uri);
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
        "orderno": jsonData[iCtr]['ordno'].toString(),
        "takano": jsonData[iCtr]['takano'].toString(),
        "takachr": jsonData[iCtr]['takachr'].toString(),
        "pcs": jsonData[iCtr]['pcs'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "weight": jsonData[iCtr]['weight'].toString(),
        "avgwt": jsonData[iCtr]['avgwt'].toString(),
        "tpmtrs": jsonData[iCtr]['tpmtrs'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "design": jsonData[iCtr]['design'].toString(),
        "machine": jsonData[iCtr]['machine'].toString(),
        "ordid": jsonData[iCtr]['ordid'].toString(),
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "inwid": jsonData[iCtr]['inwid'].toString(),
        "inwdetid": jsonData[iCtr]['inwdetid'].toString(),
        "inwdettkid": jsonData[iCtr]['inwdettkid'].toString(),
        "beamno": jsonData[iCtr]['beamno'].toString(),
        "beamitem": jsonData[iCtr]['beamitem'].toString()
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
        '${globals.cdomain}/api/api_getphysicalstocklist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id +
            '&startdate=' +
            fromdate +
            '&enddate=' +
            todate;
    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    print(jsonData);
    print("jatin" + getValue(jsonData['type'], 'C'));
    _branch.text = getValue(jsonData['branch'], 'C');
    _branchid.text = getValue(jsonData['branchid'], 'C');
    _type.text = getValue(jsonData['type'], 'C');
    _serial.text = getValue(jsonData['serial'], 'C');
    _srchr.text = getValue(jsonData['srchr'], 'C');
    String inputDateString = getValue(jsonData['date'], 'C');
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String formattedDate = "${parts[0]}-${parts[1]}-${parts[2]}";
    _date.text = getValue(formattedDate, 'C');
    _party.text = getValue(jsonData['party'], 'C');
    _remarks.text = getValue(jsonData['remarks'], 'C');
    _chlnno.text = getValue(jsonData['chlnno'], 'N');
    _chlnchr.text = getValue(jsonData['chlnchr'], 'C');

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

    setState(() {
      dropdownTrnType = _type.text;
    });

    return true;
  }

  Future<bool> fetchdjobissChallanno() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    uri =
        '${globals.cdomain}/api/api_greyjobissChallanno?dbname=' +
            db +
            '&branch='+
            _branch.text  +
             '&cno='+
            cno.toString();
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    print(jsonData);
    jsonData = jsonData['Data'];
    if (jsonData == null) {
      showAlertDialog(context, 'Taka No Found...');
      return true;
    }
    jsonData = jsonData[0];
    print(jsonData);
    setState(() {
      _chlnno.text=jsonData['chlnno'].toString();
    });
    print(jsonData);
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_date.text != '') {
      fromDate = retconvdate(_date.text, 'yyyy-mm-dd');
      //print(fromDate);
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _date.text = picked.toString().split(' ')[0];
      });
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    void gotoPartyScreen(
        BuildContext context, acctype, TextEditingController obj) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: acctype,
                  )));

      setState(() {
        var retResult = result;
        _partylist = result[1];
        result = result[1];

        var selParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }

        obj.text = selParty;
      });
    }

    void gotoPartyScreen2(
        BuildContext context, acctype, TextEditingController obj) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: acctype,
                  )));

      setState(() {
        var retResult = result;
        _partylist = result[1];
        result = result[1];

        partyid = _partylist[0];
        print(partyid);

        var selParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }

        obj.text = selParty;

        if (selParty != '') {
          getPartyDetails(obj.text, 0).then((value) {
            setState(() {});
          });
        }
      });
    }

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
        _branchid.text = branchid.toString();
      });
    }

    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      var branchid = _branchid.text;
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoomphysicalstockDetAdd(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    branch: branch,
                    partyid: partyid,
                    itemDet: ItemDetails,
                    branchid: branchid,
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
      if(ItemDetails.length == 0){
        showAlertDialog(context, 'ItemDetails can not be blank.');
        return true;
      }else{
        String uri = '';
        var cno = globals.companyid;
        var db = globals.dbname;
        var username = globals.username;

        var type = _type.text;
        var serial = _serial.text;
        var srchr = _srchr.text;
        var branch = _branch.text;
        var date = _date.text;
        var party = _party.text;
        var remarks = _remarks.text;
        var chlnno = _chlnno.text;
        var chlnchr = _chlnchr.text;

        var id = widget.xid;
        id = int.parse(id);

        print('In Save....');

        print(jsonEncode(ItemDetails));

        uri =
            "${globals.cdomain}/api/api_storeloomsphysicalstock?dbname=" +
                db +
                "&company=&cno=" +
                cno +
                "&user=" +
                username +
                "&branch=" +
                branch +
                "&type=" +
                type +
                "&party=" +
                party +
                "&srchr=" +
                srchr +
                "&serial=" +
                serial +
                "&date=" +
                date +
                "&remarks=" +
                remarks +
                "&chlnno=" +
                chlnno +
                "&chlnchr=" +
                chlnchr +
                "&id=" +
                id.toString() +
                "&parcel=1";
        print(uri);

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
    }

    Future<void> _handleSaveData() async {
      print("hasdgasdjbhds");
      setState(() {
        isButtonActive = false;
      });

      bool success = await saveData();
      setState(() {
        isButtonActive = success;
      });
    } 

    var items = [
      '',
      'REGULAR',
      'RETURN',
    ];

    setState(() {});

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
          DataCell(Text(ItemDetails[iCtr]['takachr'] +
              '-' +
              ItemDetails[iCtr]['takano'])),
          DataCell(Text(ItemDetails[iCtr]['pcs'])),
          DataCell(Text(ItemDetails[iCtr]['meters'])),
          DataCell(Text(ItemDetails[iCtr]['tpmtrs'])),
          DataCell(Text(ItemDetails[iCtr]['itemname'])),
          DataCell(Text(ItemDetails[iCtr]['design'])),
          DataCell(Text(ItemDetails[iCtr]['unit'])),
          DataCell(Text(ItemDetails[iCtr]['rate'])),
          DataCell(Text(ItemDetails[iCtr]['amount'])),
          DataCell(Text(ItemDetails[iCtr]['inwid'])),
          DataCell(Text(ItemDetails[iCtr]['inwdetid'])),
          DataCell(Text(ItemDetails[iCtr]['inwdettkid'])),
          DataCell(Text(ItemDetails[iCtr]['fmode'])),
          DataCell(Text(ItemDetails[iCtr]['ordid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['orddetid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['machine'].toString())),
          DataCell(Text(ItemDetails[iCtr]['weight'].toString())),
          DataCell(Text(ItemDetails[iCtr]['avgwt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['beamno'].toString())),
          DataCell(Text(ItemDetails[iCtr]['beamitem'].toString())),
        ]));
      }

      setState(() {
        _tottaka.text = widget.tottaka.toString();
        _totmtrs.text = widget.totmtrs.toString();
      });

      return _datarow;
    }

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Physical Stock Entry [ ' +
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
          enableFeedback: isButtonActive,
          onPressed:isButtonActive
            ? () {  
              print("HIIIIIIIIIIIII");              
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data saving progressing...')),
                    );
                    _handleSaveData();
                  }
              }
            : null,
          ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _branch,
                  autofocus: true,
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
              Expanded(
                child: Visibility(
                visible:false,
                child: DropdownButtonFormField(
                    value: dropdownTrnType,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Type',
                    ),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                           fetchdjobissChallanno();
                           print('jatin');
                        dropdownTrnType = newValue!;
                        _type.text = dropdownTrnType;
                        print(_type.text);
                      });
                    }),
                 ),
              )
            ]),
            TextFormField(
              controller: _date,
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
                visible:false,
                  child: TextFormField(
                    controller: _party,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Party',
                      labelText: 'Party',
                    ),
                    onTap: () {
                      gotoPartyScreen2(context, 'JOBWORK PARTY', _party);
                    },
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
                child: Visibility(
                visible:false,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _chlnno,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Challan No',
                      labelText: 'Chln No',
                    ),
                    onChanged: (value) {
                      // _remarks.value = TextEditingValue(
                      //     text: value.toUpperCase(),
                      //     selection: _remarks.selection);
                    },
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                )),
                Expanded(
                child: Visibility(
                visible:false,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _chlnchr,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Challan Chr',
                      labelText: 'Chln Chr',
                    ),
                    onChanged: (value) {
                      _chlnchr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _chlnchr.selection);
                    },
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
                    controller: _remarks,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Remarks',
                      labelText: 'Remarks',
                    ),
                    onChanged: (value) {
                      _remarks.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _remarks.selection);
                    },
                    onTap: () {},
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
                  enabled: false,
                  controller: _tottaka,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Taka',
                    labelText: 'Total Taka',
                  ),
                  onTap: () {
                    //gotoBranchScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                )),
                Expanded(
                    child: TextFormField(
                  enabled: false,
                  controller: _totmtrs,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Meters',
                    labelText: 'Total Meters',
                  ),
                  onTap: () {
                    //gotoBranchScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                ))
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
                    label: Text("Taka No"),
                  ),
                  DataColumn(
                    label: Text("Pcs"),
                  ),
                  DataColumn(
                    label: Text("Meters"),
                  ),
                  DataColumn(
                    label: Text("TP Mtrs"),
                  ),
                  DataColumn(
                    label: Text("Item Name"),
                  ),
                  DataColumn(
                    label: Text("Design No"),
                  ),
                  DataColumn(
                    label: Text("Unit"),
                  ),
                  DataColumn(
                    label: Text("Rate"),
                  ),
                  DataColumn(
                    label: Text("Amount"),
                  ),
                  DataColumn(
                    label: Text("InwId"),
                  ),
                  DataColumn(
                    label: Text("InwDetId"),
                  ),
                  DataColumn(
                    label: Text("InwDetTkId"),
                  ),
                  DataColumn(
                    label: Text("FMode"),
                  ),
                  DataColumn(
                    label: Text("OrdId"),
                  ),
                  DataColumn(
                    label: Text("OrdDetId"),
                  ),
                  DataColumn(
                    label: Text("machine"),
                  ),
                  DataColumn(
                    label: Text("weight"),
                  ),
                  DataColumn(
                    label: Text("avgwt"),
                  ),
                  DataColumn(
                    label: Text("beamno"),
                  ),
                  DataColumn(
                    label: Text("beamitem"),
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
