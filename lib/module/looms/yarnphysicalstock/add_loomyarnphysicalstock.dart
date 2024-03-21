import 'dart:convert';
import 'package:cloud_mobile/module/looms/yarnphysicalstock/add_loomyarnphysicalstockdet.dart';
import 'package:cloud_mobile/module/looms/yarnphysicalstock/loomyarnphysicalstocklist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/machine_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';

class YarnphysicalstockAdd extends StatefulWidget {
  YarnphysicalstockAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  double totwt = 0;
  double totcops = 0;
  double totcone = 0;

  @override
  _YarnphysicalstockAddState createState() => _YarnphysicalstockAddState();
}

class _YarnphysicalstockAddState extends State<YarnphysicalstockAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];
  List _itemlist = [];
  List _machinelist = [];

  List ItemDetails = [];


  var branchid = 0;
  var itemid = 0;
  var machineid = 0;
  var partyid = 0;

  TextEditingController _branch = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _chlnno = new TextEditingController();
  TextEditingController _machine = new TextEditingController();
  TextEditingController _item = new TextEditingController();
  TextEditingController _creelno = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _totWt = new TextEditingController();
  TextEditingController _totcops = new TextEditingController();
  TextEditingController _totcone = new TextEditingController();

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
        'https://www.looms.equalsoftlink.com/api/api_getyarnphysicalstockdetlist?dbname=' +
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
        "cartonchr": jsonData[iCtr]['cartonchr'].toString(),
        "cartonno": jsonData[iCtr]['cartonno'].toString(),
        "netwt": jsonData[iCtr]['netwt'].toString(),
        "lotno": jsonData[iCtr]['lotno'].toString(),
        "cops": jsonData[iCtr]['cops'].toString(),
        "cone": jsonData[iCtr]['cone'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "cost": jsonData[iCtr]['cost'].toString(),
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "ychlnsubdetid": jsonData[iCtr]['ychlnsubdetid'].toString(),
        "ychlnid": jsonData[iCtr]['ychlnid'].toString(),
        "ychlndetid": jsonData[iCtr]['ychlndetid'].toString(),
      });
    }

    print(ItemDet);
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
        'https://www.looms.equalsoftlink.com/api/api_getyarnphysicalstocklist?dbname=' +
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

    _branch.text = getValue(jsonData['branch'], 'C');
    _serial.text = getValue(jsonData['serial'], 'C');
    _srchr.text = getValue(jsonData['srchr'], 'C');
    _date.text = getValue(jsonData['date'], 'C');
    _party.text = getValue(jsonData['party'], 'C');
    _remarks.text = getValue(jsonData['remarks'], 'C');
    _chlnno.text = getValue(jsonData['chlnno'], 'N');
    _creelno.text = getValue(jsonData['creelno'], 'N');
    _machine.text = getValue(jsonData['machine'], 'N');
    _item.text = getValue(jsonData['itemname'], 'N');

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

    setState(() {
      //dropdownTrnType = _type.text;
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
      });
    }

    void gotoItemScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => item_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;

        print(retResult);
        _itemlist = result[1];
        result = result[1];
        itemid = _itemlist[0];
        print(itemid);

        var stritem = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            stritem = stritem + ',';
          }
          stritem = stritem + retResult[0][ictr];
        }

        _item.text = stritem;
      });
    }

    void gotoMachineScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => machine_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;

        print(retResult);
        _machinelist = result[1];
        result = result[1];
        machineid = _machinelist[0];
        print(machineid);

        var strmachine = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            strmachine = strmachine + ',';
          }
          strmachine = strmachine + retResult[0][ictr];
        }
        print(strmachine);
        _machine.text = strmachine;
      });
    }

    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoomYarnphysicalstockdetAdd(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    branch: branch,
                    partyid: partyid,
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
      var remarks = _remarks.text;
      var chlnno = _chlnno.text;
      var creelno = _creelno.text;
      var cmachine = _machine.text;
      var citem = _item.text;

      var id = widget.xid;
      id = int.parse(id);

      print('In Save....');
      
      print(jsonEncode(ItemDetails));
      //return true;

      

      uri =
          "https://looms.equalsoftlink.com/api/api_storeloomsyarnphysicalstocstock?dbname=" +
              db +
              "&company=&cno=" +
              cno +
              "&user=" +
              username +
              "&branch=" +
              branch +
              "&party=" +
              party +
              "&item=" +
              citem +
              "&machine=" + cmachine + "&creelno="+ creelno+"&chlnno=" +
              chlnno +
              "&srchr=" + srchr+"&serial=" + serial+"&date=" +
              date +
              "&remarks=" +
              remarks +
              "&id=" +
              id.toString();
                   
      print(uri);

      final headers = {
          'Content-Type': 'application/json', // Set the appropriate content-type
          // Add any other headers required by your API
        };      

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
                builder: (_) => Loomyarnphysicalstocklist(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }
      return true;
    }

    void deleteRow(index) {
      setState(() {
        ItemDetails.removeAt(index);
      });
    }
    List<DataRow> _createRows() {
      List<DataRow> _datarow = [];
      print(ItemDetails);

      widget.totwt = 0;
      widget.totcops = 0;
      widget.totcone = 0;
      print(ItemDetails.length);
      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        print(iCtr);
        double nNetwt = 0;
        double nCops = 0;
        double nCone = 0;
        if (ItemDetails[iCtr]['netwt'] != '') {
          nNetwt = nNetwt + double.parse(ItemDetails[iCtr]['netwt']);
          nCops = nCops + double.parse(ItemDetails[iCtr]['cops']);
          nCone = nCone + double.parse(ItemDetails[iCtr]['cone']);
          widget.totcops += nCops;
          widget.totwt += nNetwt;
          widget.totcone += nCone;
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
          DataCell(Text(ItemDetails[iCtr]['cartonchr'])),
          DataCell(Text(ItemDetails[iCtr]['cartonno'])),
          DataCell(Text(ItemDetails[iCtr]['netwt'])),
          DataCell(Text(ItemDetails[iCtr]['itemname'])),
          DataCell(Text(ItemDetails[iCtr]['lotno'])),
          DataCell(Text(ItemDetails[iCtr]['cops'])),
          DataCell(Text(ItemDetails[iCtr]['cone'])),
          DataCell(Text(ItemDetails[iCtr]['unit'])),
          DataCell(Text(ItemDetails[iCtr]['rate'])),
          DataCell(Text(ItemDetails[iCtr]['amount'])),
          DataCell(Text(ItemDetails[iCtr]['cost'])),
          DataCell(Text(ItemDetails[iCtr]['ychlnsubdetid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['ychlnid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['ychlndetid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['fmode'])),
        ]));
      }

      setState(() {
        _totWt.text = widget.totwt.toString();
        _totcops.text = widget.totcops.toString();
        _totcone.text = widget.totcone.toString();
      });

      print('out');
      return _datarow;
    }

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yarn Physical Stock Challan [ ' +
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
                    controller: _creelno,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Creelno',
                      labelText: 'creelno',
                    ),
                    onChanged: (value) {
                      _creelno.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _creelno.selection);
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
                child: Visibility(
                visible:false,
                  child: TextFormField(
                    controller: _machine,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Machine',
                      labelText: 'Machine',
                    ),
                    onTap: () {
                      gotoMachineScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: Visibility(
                visible:false,
                  child: TextFormField(
                    controller: _item,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Item',
                      labelText: 'Item',
                    ),
                    onTap: () {
                      gotoItemScreen(context);
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
                  controller: _totWt,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Wt',
                    labelText: 'Total Wt',
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
                  controller: _totcops,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Cops',
                    labelText: 'Total Cops',
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
                  controller: _totcone,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Cone',
                    labelText: 'Total Cone',
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
                    label: Text("Cartonchr"),
                  ),
                  DataColumn(
                    label: Text("Cartonno"),
                  ),
                  DataColumn(
                    label: Text("Netwt"),
                  ),
                  DataColumn(
                    label: Text("ItemName"),
                  ),
                  DataColumn(
                    label: Text("LotNo"),
                  ),
                  DataColumn(
                    label: Text("Cops"),
                  ),
                  DataColumn(
                    label: Text("Cone"),
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
                    label: Text("Cost"),
                  ),
                  DataColumn(
                    label: Text("ychlnsubdetid"),
                  ),
                  DataColumn(
                    label: Text("ychlnid"),
                  ),
                  DataColumn(
                    label: Text("ychlndetid"),
                  ),
                  DataColumn(
                    label: Text("FMode"),
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
