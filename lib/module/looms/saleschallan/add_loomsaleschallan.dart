import 'dart:convert';

import 'package:cloud_mobile/module/looms/saleschallan/loomsaleschallanlist.dart';
import 'package:cloud_mobile/module/looms/saleschallan/add_loomsaleschallandet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/city_list.dart';
//import 'package:cloud_mobile/list/state_list.dart';
import 'package:cloud_mobile/list/branch_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';

class LoomSalesChallanAdd extends StatefulWidget {
  LoomSalesChallanAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _LoomSalesChallanAddState createState() => _LoomSalesChallanAddState();
}

class _LoomSalesChallanAddState extends State<LoomSalesChallanAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];
  List _delpartylist = [];
  List _booklist = [];
  List _agentlist = [];
  List _hastelist = [];
  List _transportlist = [];
  List _stationlist = [];

  List ItemDetails = [];

  String dropdownTrnType = 'PACKING';

  var branchid = 0;
  var partyid = 0;
  var bookid = 0;
  TextEditingController _branch = new TextEditingController();
  TextEditingController _packingtype = new TextEditingController();
  TextEditingController _packingsrchr = new TextEditingController();
  TextEditingController _packingserial = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _book = new TextEditingController();
  TextEditingController _bookno = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _agent = new TextEditingController();
  TextEditingController _delparty = new TextEditingController();
  TextEditingController _haste = new TextEditingController();
  TextEditingController _transport = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _parcel = new TextEditingController();
  TextEditingController _duedays = new TextEditingController();
  TextEditingController _station = new TextEditingController();
  TextEditingController _tottaka = new TextEditingController();
  TextEditingController _totmtrs = new TextEditingController();
  
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController _gstregno = new TextEditingController();
  var _jsonData = [];
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');

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

//api_getsalechallandetlist?dbname=admin_looms&cno=2&id=2997
    uri =
        'https://www.looms.equalsoftlink.com/api/api_getsalechallandetlist?dbname=' +
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
        "tpmtrs": jsonData[iCtr]['tpmtrs'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "hsncode": jsonData[iCtr]['hsncode'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        'var': 0,
        "unit": jsonData[iCtr]['unit'].toString(),
        'varper': 0,
        "amount": jsonData[iCtr]['amount'].toString(),
        "design": jsonData[iCtr]['design'].toString(),
        "machine": jsonData[iCtr]['machine'].toString(),
        "orditem": jsonData[iCtr]['itemname'].toString(),
        "orddesign": jsonData[iCtr]['design'].toString(),
        "ordmtr": 0,
        'stdwt': 0,        
        "ordid": jsonData[iCtr]['ordid'].toString(),
        "folddate": '',
        'type': '',
        'tkid': 0,
        'tkdetid': 0,
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "inwid": jsonData[iCtr]['inwid'].toString(),
        "inwdetid": jsonData[iCtr]['inwdetid'].toString(),
        "inwdettkid": jsonData[iCtr]['inwdettkid'].toString(),
        'cost': 0,
        'tp': '',
        "orddetid": jsonData[iCtr]['orddetid'].toString(),
        'ordbalmtrs': 0
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
        'https://www.looms.equalsoftlink.com/api/api_getsalechallanlist?dbname=' +
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
    _packingtype.text = getValue(jsonData['packingtype'], 'C');
    _packingsrchr.text = getValue(jsonData['packingsrchr'], 'C');
    _packingserial.text = getValue(jsonData['packingserial'], 'C');
    _serial.text = getValue(jsonData['serial'], 'C');
    _srchr.text = getValue(jsonData['srchr'], 'C');
    _book.text = getValue(jsonData['book'], 'C');
    _bookno.text = getValue(jsonData['bookno'], 'C');
    _date.text = getValue(jsonData['date'], 'C');
    _party.text = getValue(jsonData['party'], 'C');
    _delparty.text = getValue(jsonData['delparty'], 'C');
    _agent.text = getValue(jsonData['agent'], 'C');
    _delparty.text = getValue(jsonData['delparty'], 'C');
    _haste.text = getValue(jsonData['haste'], 'C');
    _transport.text = getValue(jsonData['transport'], 'C');
    _remarks.text = getValue(jsonData['remarks'], 'C');
    _parcel.text = getValue(jsonData['parcel'], 'C');
    _duedays.text = getValue(jsonData['duedays'], 'C');
    _station.text = getValue(jsonData['station'], 'C');

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

    setState(() {
      dropdownTrnType = _packingtype.text;
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
            setState(() {
              if (_delparty.text == '') {
                _delparty.text = selParty;
              }
              _station.text = value[0]['city'];
              _agent.text = value[0]['agent'];
              _transport.text = value[0]['transport'];
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

    void gotoCityScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => city_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;
        _stationlist = result[1];
        result = result[1];

        var selStation = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selStation = selStation + ',';
          }
          selStation = selStation + retResult[0][ictr];
        }

        _station.text = selStation;
      });
    }

    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoomSalesChallanDetAdd(
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

      var packingtype = _packingtype.text;
      var packingsrchr = _packingsrchr.text;
      var packingserial = _packingserial.text;
      var serial = _serial.text;
      var srchr = _srchr.text;
      var book = _book.text;
      var bookno = _bookno.text;
      var branch = _branch.text;
      var date = _date.text;
      var party = _party.text;
      var agent = _agent.text;
      var delparty = _delparty.text;
      var haste = _haste.text;
      var transport = _transport.text;
      var remarks = _remarks.text;
      var parcel = 0;
      //_parcel.text;
      var duedays = 0;
      // _duedays.text;
      var station = _station.text;

      var id = widget.xid;
      id = int.parse(id);

      print(packingtype);
      print('In Save....');
      
      print(jsonEncode(ItemDetails));
      //return true;

      uri =
          "https://looms.equalsoftlink.com/api/api_storeloomssalechln?dbname=" +
              db +
              "&company=&cno=" +
              cno +
              "&user=" +
              username +
              "&branch=" +
              branch +
              "&packingtype=" +
              packingtype +
              "&party=" +
              party +
              "&book=" +
              book +
              "&haste=" +
              haste +
              "&transport=" +
              transport +
              "&station=" +
              station +
              "&packingsrchr=" + packingsrchr + "&packingserial="+ packingserial+"&bookno=" +
              bookno +
              "&srchr=" + srchr+"&serial=" + serial+"&date=" +
              date +
              "&remarks=" +
              remarks +
              "&id=" +
              id.toString() +
              "&parcel=1&duedays=0&GridData=" +
              jsonEncode(ItemDetails);
      print(uri);
      var response = await http.post(Uri.parse(uri));

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
                builder: (_) => LoomSalesChallanList(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }
      return true;
    }

    var items = [
      'PACKING',
      'DELIVERY',
    ];

    setState(() {
      //_packingtype.text = 'PACKING';
    });

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
          'Sales Challan [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] '  + 'Packing Serial : ' + _packingserial.text + ' '+
              (int.parse(widget.xid) > 0
                  ? 'Challan No : ' + widget.serial.toString()
                  : ''),
          style:
              GoogleFonts.abel(fontSize: 25.0, fontWeight: FontWeight.normal),
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
              Expanded(
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
                        dropdownTrnType = newValue!;
                        _packingtype.text = dropdownTrnType;
                        print(_packingtype.text);
                      });
                    }),
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
                  child: TextFormField(
                    controller: _book,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Book',
                      labelText: 'Book',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'SALE BOOK', _book);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _party,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Party',
                      labelText: 'Party',
                    ),
                    onTap: () {
                      gotoPartyScreen2(context, 'SALE PARTY', _party);
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
                    controller: _delparty,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Delivery Party',
                      labelText: 'Delv Party',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'SALE PARTY', _delparty);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _agent,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Agent',
                      labelText: 'Agent',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'AGENT', _party);
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
                    controller: _haste,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Haste',
                      labelText: 'Haste',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'HASTE', _haste);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _transport,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Transport',
                      labelText: 'Transport',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'TRANSPORT', _transport);
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
                    controller: _station,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Station',
                      labelText: 'Station',
                    ),
                    onTap: () {
                      gotoCityScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
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
                  controller: _duedays,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Due Days',
                    labelText: 'Due Days',
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
                  controller: _parcel,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Parcel',
                    labelText: 'Parcel',
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
                  style: GoogleFonts.oswald(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
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
