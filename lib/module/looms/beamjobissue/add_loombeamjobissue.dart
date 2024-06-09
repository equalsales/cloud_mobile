import 'dart:convert';

//import 'package:cloud_mobile/module/looms/saleschallan/loomsaleschallanlist.dart';
//import 'package:cloud_mobile/module/looms/saleschallan/add_loomsaleschallandet.dart';
import 'package:cloud_mobile/module/looms/greyjobissue/loomgreyjobissuelist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';

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
import 'package:cloud_mobile/module/looms/beamjobissue/loombeamjobissuelist.dart';
import 'package:cloud_mobile/module/looms/beamjobissue/add_loombeamjobissuedet.dart';

class beamJobIssueAdd extends StatefulWidget {
  beamJobIssueAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  double tottaka=0;
  double totmtrs=0;

  @override
  _beamJobIssueAddState createState() => _beamJobIssueAddState();
}

class _beamJobIssueAddState extends State<beamJobIssueAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];
  
  List ItemDetails = [];

  String dropdownTrnType = 'Y';

  var branchid = 0;
  var partyid = 0;
  
  TextEditingController _branch = new TextEditingController();
  //TextEditingController _type = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _chlnno = new TextEditingController();
  TextEditingController _chlnchr = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _tottaka = new TextEditingController();
  TextEditingController _totmtrs = new TextEditingController();
  TextEditingController _masterbeam = new TextEditingController();
    
  final _formKey = GlobalKey<FormState>();
    
  @override
  void initState() {
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
        'https://www.looms.equalsoftlink.com/api/api_getbeamjobissuedetlist?dbname=' +
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
        "beamno": jsonData[iCtr]['beamno'].toString(),
        "beamchr": jsonData[iCtr]['beamchr'].toString(),
        "pcs": jsonData[iCtr]['pcs'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "ends": jsonData[iCtr]['ends'].toString(),       
        "weight": jsonData[iCtr]['weight'].toString(),
        "machine": jsonData[iCtr]['machine'].toString(),
        "item": jsonData[iCtr]['itemname'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "beamid": jsonData[iCtr]['beamid'].toString()     
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
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;

    uri =
        'https://www.looms.equalsoftlink.com/api/api_getbeamjobissuelist?dbname=' +
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
    //print( "jatin"+ getValue(jsonData['type'], 'C'));
    _branch.text = getValue(jsonData['branch'], 'C');
    //_type.text = getValue(jsonData['type'], 'C');
    _serial.text = getValue(jsonData['serial'], 'C');
    _srchr.text = getValue(jsonData['srchr'], 'C');
    _date.text = getValue(jsonData['date'], 'C');
    _party.text = getValue(jsonData['party'], 'C');
    _remarks.text = getValue(jsonData['remarks'], 'C');
    _chlnno.text = getValue(jsonData['chlnno'], 'N');
    _chlnchr.text = getValue(jsonData['chlnchr'], 'C');
    _masterbeam.text = getValue(jsonData['masterbeam'], 'C');
    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

     setState(() {
     //loadDetData();
     });

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

        partyid = _partylist[0]['id'];
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
            setState(() {              
            });
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
      });
    }
    
    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      var masterbeam = _masterbeam.text;
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoomBeamJobIssueDetAdd(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    branch: branch,
                    partyid: partyid,
                    masterbeam: masterbeam,
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

      //var type = _type.text;
      var serial = _serial.text;
      var srchr = _srchr.text;
      var branch = _branch.text;
      var date = _date.text;
      var party = _party.text;
      var remarks = _remarks.text;
      var chlnno = _chlnno.text;
      var chlnchr = _chlnchr.text;
      var masterbeam = _masterbeam.text;
      
      var id = widget.xid;
      id = int.parse(id);

      print('In Save....');
      
      print(jsonEncode(ItemDetails));
      
      uri =
          "https://looms.equalsoftlink.com/api/api_storeloomsbeamissuechln?dbname=" +
              db +
              "&company=&cno=" +
              cno +
              "&user=" +
              username +
              "&branch=" +
              branch +
              "&party=" +
              party +
              "&srchr=" + srchr+"&serial=" + serial+"&date=" +
              date +
              "&remarks=" +
              remarks +
              "&chlnno=" +
              chlnno +
              "&chlnchr=" +
              chlnchr +
              "&id=" +
              id.toString() +
              "&masterbeam=" +
              masterbeam;  
               print(uri);

      final headers = {
          'Content-Type': 'application/json', // Set the appropriate content-type
          // Add any other headers required by your API
        };      
      print(ItemDetails);
      var response = await http.post(Uri.parse(uri), headers: headers, body: jsonEncode(ItemDetails));

      var jsonData = jsonDecode(response.body);

      
      //print('4');

      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        showAlertDialog(context, 'Saved !!!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => LoomBeamJobIssueList(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }
      return true;
    }
    setState(() {
      
    });

     var items = [
      'Y',
      'N',
    ];
    void deleteRow(index) {
      setState(() {
        ItemDetails.removeAt(index);
      });
    }

    List<DataRow> _createRows() {
      List<DataRow> _datarow = [];
      print(ItemDetails);

      widget.tottaka=0;
      widget.totmtrs=0;

      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        double nMeters = 0;
        if(ItemDetails[iCtr]['meters']!='')
        {
          nMeters = nMeters + double.parse(ItemDetails[iCtr]['meters']);
          widget.tottaka+=1;
          widget.totmtrs+=nMeters;
        }
        print("JATIN");
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
          DataCell(Text(ItemDetails[iCtr]['beamno'].toString())),
          DataCell(Text(ItemDetails[iCtr]['beamchr'].toString())),
          DataCell(Text(ItemDetails[iCtr]['pcs'].toString())),
          DataCell(Text(ItemDetails[iCtr]['meters'].toString())),
          DataCell(Text(ItemDetails[iCtr]['ends'].toString())),
          DataCell(Text(ItemDetails[iCtr]['weight'].toString())),
          DataCell(Text(ItemDetails[iCtr]['machine'].toString())),
          DataCell(Text(ItemDetails[iCtr]['item'].toString())),
          DataCell(Text(ItemDetails[iCtr]['unit'].toString())),
          DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['amount'].toString())),
          DataCell(Text(ItemDetails[iCtr]['beamid'].toString())),
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
          'Beam Job Issue Challan [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] '  +
              (int.parse(widget.xid) > 0
                  ? 'Serial No : ' + widget.serial.toString()
                  : ''),
          style:
              TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {saveData()}),
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
              // Expanded(
              //   child: DropdownButtonFormField(
              //       value: dropdownTrnType,
              //       decoration: const InputDecoration(
              //         icon: const Icon(Icons.person),
              //         labelText: 'Type',
              //       ),
              //       items: items.map((String items) {
              //         return DropdownMenuItem(
              //           value: items,
              //           child: Text(items),
              //         );
              //       }).toList(),
              //       icon: const Icon(Icons.arrow_drop_down_circle),
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           dropdownTrnType = newValue!;
              //           _type.text = dropdownTrnType;
              //           print(_type.text);
              //         });
              //       }),
              // )
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
                )
              ],
            ),
            Row(
              children: [
                Expanded(
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
                ),Expanded(
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
                )
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
                ),
              Expanded(
              child: DropdownButtonFormField(
                    value: dropdownTrnType,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Master Beam',
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
                        dropdownTrnType = newValue!;
                        _masterbeam.text = dropdownTrnType;
                        print(_masterbeam.text);
                      });
                    }),
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
                    hintText: 'Total Pcs',
                    labelText: 'Total Pcs',
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
                  style: TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: [
                  DataColumn(
                    label: Text("Action"),
                  ),
                  DataColumn(
                    label: Text("Beam No"),
                  ),
                   DataColumn(
                    label: Text("BeamChr"),
                  ),
                  DataColumn(
                    label: Text("Pcs"),
                  ),
                  DataColumn(
                    label: Text("Meters"),
                  ),
                  DataColumn(
                    label: Text("Ends"),
                  ),
                   DataColumn(
                    label: Text("Weight"),
                  ),
                  DataColumn(
                    label: Text("Machine"),
                  ),
                  DataColumn(
                    label: Text("Item"),
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
                    label: Text("beamid"),
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
