import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/services.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
//import 'package:cloud_mobile/list/party_list.dart';

import '../../../common/global.dart' as globals;
//import 'package:cloud_mobile/list/city_list.dart';
//import 'package:cloud_mobile/list/state_list.dart';
//import 'package:cloud_mobile/list/branch_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

//// import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:barcode_scan/barcode_scan.dart';

//import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';

class LoomBeamJobIssueDetAdd extends StatefulWidget {
  LoomBeamJobIssueDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partyid,
      masterbeam,
      itemDet,
      id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xmasterbeam=masterbeam;
    xid = id;
    xItemDetails = itemDet;
    //xitemDet = itemDet;

    print('in Item Details');
    print(xbranch);
    print(xparty);
    print(xItemDetails);
    print(xmasterbeam);
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xbranch;
  var xparty;
  var xmasterbeam;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _LoomBeamJobIssueDetAddState createState() => _LoomBeamJobIssueDetAddState();
}

class _LoomBeamJobIssueDetAddState extends State<LoomBeamJobIssueDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  //TextEditingController _orderno = new TextEditingController();
  //TextEditingController _folddate = new TextEditingController();
  TextEditingController _beamchr = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _meters = new TextEditingController();
  TextEditingController _cbeamno = new TextEditingController();
  TextEditingController _pcs = new TextEditingController();
  TextEditingController _ends = new TextEditingController();
  TextEditingController _Weight = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _machine = new TextEditingController();
  
  
  TextEditingController _rate = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _beamid = new TextEditingController();
 

  final _formKey = GlobalKey<FormState>();

  var _jsonData = [];
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      setState(() {
        
      });
    }

    //_date.text = curDate.toString().split(' ')[0];

    // if (int.parse(widget.xid) > 0) {
    //   //loadData();
    // }
  }

  void gotoOrderScreen(BuildContext contex) async {
    // var result = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => loomsalesorder_list(
    //               companyid: widget.xcompanyid,
    //               companyname: widget.xcompanyname,
    //               fbeg: widget.xfbeg,
    //               fend: widget.xfend,
    //               partyid: widget.xparty,
    //             )));

    // setState(() {
    //   var retResult = result;

    //   print(retResult);
    //   var _orderlist = result[1];
    //   result = result[1];
    //   var orderid = _orderlist[0];

    //   print(orderid);

    //   var selOrder = '';
    //   for (var ictr = 0; ictr < retResult[0].length; ictr++) {
    //     if (ictr > 0) {
    //       selOrder = selOrder + ',';
    //     }
    //     selOrder = selOrder + retResult[0][ictr];
    //   }

    //   _orderno.text = selOrder;

    //   print('dhruv');
    //   print(result);
    //   setState(() {
    //     _folddate.text = result[0]['date'];
    //     _itemname.text = result[0]['itemname'];
    //     _design.text = result[0]['design'];
    //     _unit.text = result[0]['unit'];
    //     _rate.text = result[0]['rate'];
    //     _ordid.text = result[0]['ordid'].toString();
    //     _orddetid.text = result[0]['orddetid'].toString();
    //     ordMeters = double.parse(result[0]['balmeters'].toString());
    //     _ordbalmtrs.text = result[0]['balmeters'].toString();
    //   });
    // });
  }

  Future<bool> fetchdetails() async {
    String uri = '';
    print(_beamno.text);
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;
    var branch = widget.xbranch;
    var cbeamno = _beamno.text;
    var cbeamchr = _beamchr.text;
    var masterbeam = widget.xmasterbeam;
    
    print("JATIN " + _beamno.text);
    fromdate = retconvdate(fromdate);
    todate = retconvdate(todate);

    fromdate = fromdate.toString();
    todate = todate.toString();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      for (int iCtr = 0; iCtr < length; iCtr++) {
        if ((ItemDetails[iCtr]['beamno'] == cbeamno) &&
            ((ItemDetails[iCtr]['beamchr'] == cbeamchr))) {
          showAlertDialog(context, 'Beam no Already Exists...');
          setState(() {
            _beamno.text = '0';
            _beamchr.text = '';
          });
          return true;
        }
      }
    }

    // uri = 'https://looms.equalsoftlink.com/api/api_commonapi_beamstock?dbname=' +
    //     db +
    //     '&cno=' +
    //     cno +
    //     '&beamno=' +
    //     cbeamno +
    //     '&beamchr=' +
    //     cbeamchr +
    //     '&branch=' + 
    //     branch;
    // 'https://www.cloud.equalsoftlink.com/api/api_getsalechallanlist?dbname=' +
    //     db +
    //     '&cno=' +
    //     cno +
    //     '&id=' +
    //     id +
    //     '&startdate=' +
    //     fromdate +
    //     '&enddate=' +
    //     todate;
    uri = '${globals.cdomain}/api/api_beamstockiss?dbname=' +
            db +
            '&cno=' +
            cno +
            '&beamchr=' +
            cbeamchr +
            '&beamno=' +
            cbeamno +
            '&branch=' +
            branch +
            '&masterbeam=' +
            masterbeam;
            print(uri);
     var response = await http.get(Uri.parse(
        '${globals.cdomain}/api/api_beamstockiss?dbname=' +
            db +
            '&cno=' +
            cno +
            '&beamchr=' +
            cbeamchr +
            '&beamno=' +
            cbeamno +
            '&branch=' +
            branch + 
            '&masterbeam=' +
            masterbeam
            ));
    // print(uri);
    // var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    
    if (jsonData == null) {
      showAlertDialog(context, 'Carton no No Found...');
      return true;
    }

    jsonData = jsonData[0];

    setState(() {
      _itemname.text = jsonData['itemname'];
      _meters.text = jsonData['balbeammtrs'].toString();
      _pcs.text = jsonData['baltaka'].toString();
      _ends.text =   jsonData['ends'].toString();
       _Weight.text = jsonData['balbeamwt'].toString();
      _unit.text = 'M';
      //_beamno.text  = jsonData['beamno'].toString();
      //_beamchr.text  = jsonData['beamchr'].toString();
      _rate.text = jsonData['rate'].toString();
      _amount.text = jsonData['amount'].toString();
      _beamid.text = jsonData['beamid'].toString();
      _machine.text =  jsonData['machine'].toString();
    });
    print(jsonData);
    return true;
  }

  Future<void> barcodeScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      //     '#ff6666', 'Cancel', true, ScanMode.QR);

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#000000', 'Cancel', true, ScanMode.BARCODE);
      //barcodeScanRes = await BarcodeScanner.scan();
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      print(barcodeScanRes);

      //const string = barcodeScanRes;
      final splitted = barcodeScanRes.split('-');
      print(splitted); // [Hello, world!];
      print(splitted.length);
      print('dhruv');
      _beamno.text = splitted[0];
      // if (splitted.length > 1) {
      //   _Cartonno.text = splitted[1];
      // } else {
      //   _Cartonno.text = '0';
      // }

      fetchdetails();
      //_scanBarcode = barcodeScanRes;
    });
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var beamchr = _beamchr.text;
      var beamno = _beamno.text;
      var ccartonno = _cbeamno.text;
      var meters = _meters.text;
      var weight = _Weight.text;
      var pcs = _pcs.text;
      var ends = _ends.text;
      var itemname = _itemname.text;
      var machine = _machine.text;
      var rate = _rate.text;
      var unit = _unit.text;
      var amount = _amount.text;
      var beamid = _beamid.text;
     

      print("jatin");
      widget.xitemDet.add({
        'beamchr': beamchr,
        'beamno': beamno,
        'pcs': pcs,
        'meters': meters,
        'ends': ends,
        'weight': weight,
        'itemname': itemname,
        'machine': machine,
        'unit': unit,
        'rate': rate,
        'amount': amount,
        'beamid': beamid.toString(),
      });

      //print("tanshul");
      Navigator.pop(context, widget.xitemDet);
      // print("panshul");
      return true;
    }

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beam Job JobWork Item Details [ ] ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          onPressed: () => {saveData()}),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _beamchr,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select BeamChr ',
                      labelText: 'BeamChr',
                    ),
                    onChanged: (value) {
                      _beamchr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _beamchr.selection);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _beamno,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Beam No',
                      labelText: 'Beam No',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                Padding(padding: EdgeInsets.all(2)),
                ElevatedButton(
                  onPressed: () => {fetchdetails()},
                  child: Text('Fetch Details',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.all(2)),
                ElevatedButton(
                  onPressed: () => {barcodeScan()},
                  child: Text('Scan Barcode',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _itemname,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Item Name',
                      labelText: 'Item Name',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                    enabled: false,
                    controller: _machine,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Machine',
                      labelText: 'Machine',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                    controller: _pcs,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pcs',
                      labelText: 'Pcs',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _meters,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Meters',
                      labelText: 'Meters',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                    controller: _ends,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Ends',
                      labelText: 'Ends',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _Weight,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weight',
                      labelText: 'Weight',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                    controller: _rate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _unit,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Unit',
                      labelText: 'Unit',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                    controller: _amount,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Amount',
                      labelText: 'Amount',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
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
                    enabled: false,
                    controller: _beamid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'beamid',
                      labelText: 'beamid',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
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
