// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:cloud_mobile/list/design_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/machine_list.dart';
import 'package:cloud_mobile/module/looms/takaproduction/add_takaproductiondet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';


class TakaProductionAdd extends StatefulWidget {
  TakaProductionAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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

  @override
  _TakaProductionAddState createState() => _TakaProductionAddState();
}

class _TakaProductionAddState extends State<TakaProductionAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];
  List _designlist = [];

  List ItemDetails = [];

  bool isButtonActive = true;

  String dropdownTrnType = 'REGULAR';

  var branchid = 0;
  var partyid = 0;

  var meters = 0.0;

  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _branchid = new TextEditingController();
  TextEditingController _branch = new TextEditingController();
  TextEditingController _folddate = new TextEditingController();
  TextEditingController _machineno = new TextEditingController();
  TextEditingController _quality = new TextEditingController();
  TextEditingController _beamchr = new TextEditingController();
  TextEditingController _beamno = new TextEditingController(text: 0.toString());
  TextEditingController _beaminstalldate = new TextEditingController();
  TextEditingController _ends = new TextEditingController(text: 0.toString());
  TextEditingController _stdwt = new TextEditingController(text: 0.000.toString());
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController(text: 0.toString());
  TextEditingController _design = new TextEditingController();
  TextEditingController _foldmetrs = new TextEditingController(text: 0.00.toString());
  TextEditingController _extrameters = new TextEditingController(text: 0.00.toString());
  TextEditingController _weight = new TextEditingController(text: 0.000.toString());
  TextEditingController _avgwt = new TextEditingController();
  TextEditingController _pcs = new TextEditingController(text: 0.toString());
  TextEditingController _cut = new TextEditingController(text: 0.toString());
  TextEditingController _cutmeters = new TextEditingController(text: 0.toString());
  TextEditingController _remark = new TextEditingController();
  TextEditingController _actwt = new TextEditingController(text: 0.000.toString());
  TextEditingController _diffwt = new TextEditingController(text: 0.000.toString());

  final _formKey = GlobalKey<FormState>();
  var bmitem;

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _folddate.text = DateFormat("dd-MM-yyyy").format(curDate);
    _beaminstalldate.text = DateFormat("dd-MM-yyyy").format(curDate);
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
        '${globals.cdomain}/api/api_edittakaproduction?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id;
    print(" loadDetData : " +uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    print(jsonData);
    List ItemDet = [];
    ItemDetails = [];

    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      ItemDet.add({
        "controlid": jsonData[iCtr]['controlid'].toString(),
        "id": jsonData[iCtr]['id'].toString(),
        "date": jsonData[iCtr]['date'].toString(),
        "worker": jsonData[iCtr]['worker'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
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
    var fromdate = retconvdate(widget.xfbeg);
    var todate = retconvdate(widget.xfend);

    uri =
        '${globals.cdomain}/api/api_edittakaproduction?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id;
    print(" loadData :" +uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    // _serial.text = getValue(jsonData['serial'], 'C');
    // _srcr.text = getValue(jsonData['srchr'], 'C');

    _branch.text = getValue(jsonData['branch'].toString(), 'C');
    String inputDateString = getValue(jsonData['date'].toString(), 'N');
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String date = "${parts[2]}-${parts[1]}-${parts[0]}";
    _folddate.text = date.toString();
    _machineno.text = getValue(jsonData['machine'].toString(), 'C');
    _quality.text = getValue(jsonData['itemname'].toString(), 'C');
    _beamchr.text = getValue(jsonData['beamchr'].toString(), 'C');
    _beamno.text = getValue(jsonData['beamno'].toString(), 'C');
    String inputDateString2 = getValue(jsonData['beaminstalldate'].toString(), 'N');
    List<String> parts2 = inputDateString2.split(' ')[0].split('-');
    String beaminstalldate = "${parts2[2]}-${parts2[1]}-${parts2[0]}";
    _beaminstalldate.text = beaminstalldate.toString();
    _ends.text = getValue(jsonData['ends'].toString(), 'C');
    _stdwt.text = getValue(jsonData['stdwt'].toString(), 'C');
    _takachr.text = getValue(jsonData['takachr'].toString(), 'C');
    _takano.text = getValue(jsonData['takano'].toString(), 'C');
    _design.text = getValue(jsonData['design'].toString(), 'C');
    _foldmetrs.text = getValue(jsonData['foldmtrs'].toString(), 'C');
    _extrameters.text = getValue(jsonData['extrameters'].toString(), 'C');
    _weight.text = getValue(jsonData['weight'].toString(), 'C');
    _avgwt.text = getValue(jsonData['avgwt'].toString(), 'C');
    _pcs.text = getValue(jsonData['pcs'].toString(), 'C');
    _cut.text = getValue(jsonData['cut'].toString(), 'C');
    _cutmeters.text = getValue(jsonData['cutmeters'].toString(), 'C');
    _remark.text = getValue(jsonData['remarks'].toString(), 'C');
    _actwt.text = getValue(jsonData['actwt'].toString(), 'C');
    _diffwt.text = getValue(jsonData['diffwt'].toString(), 'C');
    
    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

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
    print(jsonData);
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
        _folddate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _beaminstalldate.text = DateFormat("dd-MM-yyyy").format(picked);
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
        var selBranch = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selBranch = selBranch + ',';
          }
          selBranch = selBranch + retResult[0][ictr].toString();
        }
        _branch.text = selBranch;
      });
    }

    void gotoMachineScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => machine_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                  )));
      setState(() {
        var retResult = result;

        var selMachineno = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selMachineno = selMachineno + ',';
          }
          selMachineno = selMachineno + retResult[0][ictr];
        }
        _machineno.text = selMachineno;
      });
    }

    void gotoItemnameScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => item_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                  )));
      setState(() {
        var retResult = result;
        var selItemname = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selItemname = selItemname + ',';
          }
          selItemname = selItemname + retResult[0][ictr];
        }
        _quality.text = selItemname;
      });
    }

    void gotoDesignScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => design_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                  )));
      setState(() {
        var retResult = result;
        var selDesign = '';
        for (var ictr = 0; ictr < retResult.length; ictr++) {
          if (ictr > 0) {
            selDesign = selDesign + ',';
          }
          selDesign = selDesign + retResult[ictr].toString();
        }
        _design.text = selDesign;
      });
    }

    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      var branchid = _branchid.text;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TakaProductionDetAdd(
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
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;

      var serial = _serial.text;
      var srchr = _srchr.text;
      var branch = _branch.text;
      var folddate = _folddate.text;
      var machineno = _machineno.text;
      var quality = _quality.text;
      var beamchr = _beamchr.text;
      var beamno = _beamno.text;
      var beaminstalldate = _beaminstalldate.text;
      var ends = _ends.text;
      var stdwt = _stdwt.text;
      var takachr = _takachr.text;
      var takano = _takano.text;
      var design = _design.text;
      var foldmetrs = _foldmetrs.text;
      var extrameters = _extrameters.text;
      var weight = _weight.text;
      var avgwt = _avgwt.text;
      var pcs = _pcs.text;
      var cut = _cut.text;
      var cutmeters = _cutmeters.text;
      var remark = _remark.text;
      var actwt = _actwt.text;
      var diffwt = _diffwt.text;
    
      var id = widget.xid;
      id = int.parse(id);


      print(jsonEncode(ItemDetails));

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(folddate);
      String newfolddate = DateFormat("yyyy-MM-dd").format(parsedDate); 

      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(beaminstalldate);
      String newbeaminstalldate = DateFormat("yyyy-MM-dd").format(parsedDate2); 

      uri =
          "${globals.cdomain}/api/api_storetakaproduction?dbname=" +
              db +
              "&company=&cno=" +
              cno +
              "&user=" +
              username +
              "&branch=" +
              branch +
              "&date=" +
              newfolddate.toString() +
              "&machine=" +
              machineno + 
              "&itemname=" +
              quality +
              "&beamchr=" +
              beamchr +
              "&beamno=" +
              beamno +
              "&beaminstalldate=" +
              newbeaminstalldate +
              "&ends=" +
              ends +
              "&stdwt=" +
              stdwt +
              "&takachr=" +
              takachr +
              "&takano=" +
              takano +
              "&design=" +
              design +
              "&foldmtrs=" + 
              foldmetrs +
              "&extrameters=" +
              extrameters +
              "&weight=" +
              weight +
              "&avgwt=" + 
              avgwt +
              "&pcs=" +
              pcs +  
              "&cut=" +
              cut +  
              "&cutmeters=" +
              cutmeters +
              "&remarks=" +
              remark +  
              "&actwt=" +
              actwt +  
              "&diffwt=" +
              diffwt +  
              "&srchr=" +
              srchr +
              "&serial=" +
              serial +
              "&id=" +
              id.toString();

      print(" SaveData " + uri);

      final headers = {
        'Content-Type': 'application/json',
      };
      print(ItemDetails);
      var response = await http.post(Uri.parse(uri),
          headers: headers, body: jsonEncode(ItemDetails));

      var jsonData = jsonDecode(response.body);


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
        isButtonActive = false;
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

      double totmtrs = 0;

      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        double nMeters = 0;
        if (ItemDetails[iCtr]['meters'] != '') {
          nMeters = nMeters + double.parse(ItemDetails[iCtr]['meters']);
          totmtrs += nMeters;
          _extrameters.text = totmtrs.toStringAsFixed(2);
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
          DataCell(Text(ItemDetails[iCtr]['newdate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['worker'].toString())),
          DataCell(Text(ItemDetails[iCtr]['meters'].toString())),
          DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['amount'].toString())),
        ]));
      }

      // setState(() {
      //   _tottaka.text = widget.tottaka.toString();
      //   _totmtrs.text = widget.totmtrs.toString();
      // });

      return _datarow;
    }

    calweightactwt(){
      var stdwt = double.parse(_stdwt.text);
      var foldmetrs = double.parse(_foldmetrs.text);
      var total = 0.0;

      total = (stdwt * foldmetrs) / 100;
      
      setState(() {
        _weight.text = total.toStringAsFixed(2);
        _actwt.text = total.toStringAsFixed(0);
      });
    }
    
    calavgwt(){
      var weight = double.parse(_weight.text);
      var foldmetrs = double.parse(_foldmetrs.text);
      var avgwt = 0.0;

      avgwt = (weight / foldmetrs) * 100;
      
      setState(() {
        _avgwt.text = avgwt.toStringAsFixed(2);
      });
    }
    
    calcutmeters(){
      var pcs = double.parse(_pcs.text);
      var cut = double.parse(_cut.text);
      var cutmeters = 0.0;

      cutmeters = pcs * cut;
      
      setState(() {
        _cutmeters.text = cutmeters.toStringAsFixed(2);
      });
    }

    caldiffwt(){
      var weight = double.parse(_weight.text);
      var actwt = double.parse(_actwt.text);
      var diffwt = 0.0;

      diffwt = weight - actwt;
      
      setState(() {
        _diffwt.text = diffwt.toStringAsFixed(2);
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taka Production [ ' +
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
              controller: _folddate,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'FoldDate',
                labelText: 'FoldDate',
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
                    controller: _machineno,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Machine No',
                      labelText: 'Machine No',
                    ),
                    onTap: () {
                      gotoMachineScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    controller: _quality,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Quality',
                      labelText: 'Quality',
                    ),
                    onTap: () {
                      gotoItemnameScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _beamchr,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'BeamChr',
                      labelText: 'BeamChr',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _beamno,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'BeamNo',
                      labelText: 'BeamNo',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _beaminstalldate,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam Install Date',
                      labelText: 'Beam Install Date',
                    ),
                    onTap: () {
                      _selectDate2(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _ends,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Ends',
                      labelText: 'Ends',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                  enabled: true,
                  controller: _stdwt,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Stdwt',
                    labelText: 'Stdwt',
                  ),
                  onTap: () {},
                  onChanged: (value) {
                    calweightactwt();
                    calavgwt();
                    calcutmeters();
                    caldiffwt();
                  },
                  validator: (value) {
                    return null;
                  },
                )),
                Expanded(
                  child: TextFormField(
                  enabled: true,
                  controller: _takachr,
                  keyboardType: TextInputType.text,
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
                  onTap: () {},
                  validator: (value) {
                    return null;
                  },
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _takano,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'TakaNo',
                      labelText: 'TakaNo',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                  enabled: true,
                  controller: _design,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Design',
                    labelText: 'Design',
                  ),
                  onTap: () {
                    gotoDesignScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _foldmetrs,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Fold Meters',
                      labelText: 'Fold Meters',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calweightactwt();
                      calavgwt();
                      calcutmeters();
                      caldiffwt();
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,  
                    controller: _extrameters,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Extra Meters',
                      labelText: 'Extra Meters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _weight,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weight',
                      labelText: 'Weight',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calweightactwt();
                      calavgwt();
                      calcutmeters();
                      caldiffwt();
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _avgwt,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Avgwt',
                      labelText: 'Avgwt',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _pcs,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pcs',
                      labelText: 'Pcs',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calweightactwt();
                      calavgwt();
                      calcutmeters();
                      caldiffwt();
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                  enabled: true,
                  controller: _cut,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Cut',
                    labelText: 'Cut',
                  ),
                  onTap: () {},
                  onChanged: (value) {
                    calweightactwt();
                    calavgwt();
                    calcutmeters();
                    caldiffwt();
                  },
                  validator: (value) {
                    return null;
                  },
                )),
              ],
            ),
            Row(  
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _cutmeters,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cut Meters',
                      labelText: 'Cut Meters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _remark,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Remarks',
                      labelText: 'Remarks',
                    ),
                    onChanged: (value) {
                      _remark.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _remark.selection);
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
                    controller: _actwt,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Act Weight',
                      labelText: 'Act Weight',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      caldiffwt();
                      calweightactwt();
                    },
                    validator: (value) {
                      return null;
                    },
                  )
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _diffwt,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Diff Weight',
                      labelText: 'Diff Weight',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  )
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
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Worker"),
                  ),
                  DataColumn(
                    label: Text("Meters"),
                  ),
                  DataColumn(
                    label: Text("Rate"),
                  ),
                  DataColumn(
                    label: Text("Amount"),
                  ),
                ], rows: _createRows())),
            SizedBox(
              height: 50,
            )
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
