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

class SaleBillDetAdd extends StatefulWidget {
  SaleBillDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partyid,
      itemDet,
      id,
      branchid})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xbranchid = branchid;
    xItemDetails = itemDet;
    //xitemDet = itemDet;

    print('in Item Details');
    print(xbranch);
    print(xparty);
    print(xItemDetails);
    print(xbranchid);
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xbranch;
  var xbranchid;
  var xparty;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _SaleBillDetAddAddState createState() => _SaleBillDetAddAddState();
}

class _SaleBillDetAddAddState extends State<SaleBillDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController();
  TextEditingController _folddate = new TextEditingController();
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController();
  TextEditingController _ctakano = new TextEditingController();
  TextEditingController _pcs = new TextEditingController();
  TextEditingController _meters = new TextEditingController();
  TextEditingController _tpmeters = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _design = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _machine = new TextEditingController();
  TextEditingController _inwid = new TextEditingController();
  TextEditingController _inwdetid = new TextEditingController();
  TextEditingController _inwdettkid = new TextEditingController();
  TextEditingController _ordid = new TextEditingController();
  TextEditingController _orddetid = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _ordbalmtrs = new TextEditingController();
  TextEditingController _weight = new TextEditingController();
  TextEditingController _avgwt = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _beamitem = new TextEditingController();

  //var ordTaka = 0;
  double ordMeters = 0;

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
        _orderno.text = ItemDetails[length - 1]['orderno'].toString();
        //_folddate.text = ItemDetails[length - 1]['folddate'].toString();
        _ordbalmtrs.text = ItemDetails[length - 1]['ordbalmtrs'].toString();
        _ordid.text = ItemDetails[length - 1]['ordid'].toString();
        _orddetid.text = ItemDetails[length - 1]['orddetid'].toString();
        _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        _design.text = ItemDetails[length - 1]['design'].toString();
        _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
        _unit.text = ItemDetails[length - 1]['unit'].toString();
        _rate.text = ItemDetails[length - 1]['rate'].toString();
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
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;
    var branch = widget.xbranchid;
    var takano = _takano.text;
    var takachr = _takachr.text;

    fromdate = retconvdate(fromdate);
    todate = retconvdate(todate);

    fromdate = fromdate.toString();
    todate = todate.toString();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      for (int iCtr = 0; iCtr < length; iCtr++) {
        if ((ItemDetails[iCtr]['takano'] == takano) &&
            ((ItemDetails[iCtr]['takachr'] == takachr))) {
          showAlertDialog(context, 'Taka No Already Exists...');
          setState(() {
            _takano.text = '0';
            _takachr.text = '';
          });
          return true;
        }
      }
    }
//commonapi_gettakastock?partyfilter=N&takano=28430&takachr=AJ&branchid=(2)&getdata=Y&dbname=admin_looms
    uri =
        'https://looms.equalsoftlink.com/api/commonapi_gettakastock2?dbname=' +
            db +
            '&partyfilter=N&takachr=' +
            takachr +
            '&takano=' +
            takano +
            '&branchid=(' +
            branch +
            ')&getdata=Y';
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
      _itemname.text = jsonData['itemname'].toString();
      _folddate.text = jsonData['date'].toString();
      _design.text = jsonData['design'].toString();
      _machine.text = jsonData['machine'].toString();
      _pcs.text = jsonData['pcs'].toString();
      _meters.text = jsonData['meters'].toString();
      _tpmeters.text = jsonData['tpmtrs'].toString();
      _unit.text = jsonData['unit'].toString();
      _hsncode.text = jsonData['hsncode'].toString();
      _inwid.text = jsonData['inwid'].toString();
      _inwdetid.text = jsonData['inwdetid'].toString();
      _inwdettkid.text = jsonData['inwdettkid'].toString();
      _fmode.text = jsonData['fmode'].toString();
      _weight.text = jsonData['weight'].toString();
      _avgwt.text = jsonData['avgwt'].toString();
      _beamno.text = jsonData['beamno'].toString();
      _beamitem.text = jsonData['beamitem'].toString();

      if (_ordbalmtrs.text != '') {
        _ordbalmtrs.text =
            (double.parse(_ordbalmtrs.text) - double.parse(_meters.text))
                .toString();
      }

      double pcs = double.parse(_pcs.text);
      double meters = double.parse(_meters.text);
      String unit = _unit.text;
      double rate = 0;
      if (_rate.text != '') {
        rate = double.parse(_rate.text);
      }
      double amount = 0;
      if ((unit == 'P') || (unit == 'T')) {
        amount = pcs * rate;
      } else {
        amount = meters * rate;
      }
      _amount.text = amount.toString();
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
      _takachr.text = splitted[0];
      if (splitted.length > 1) {
        _takano.text = splitted[1];
      } else {
        _takano.text = '0';
      }

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

      var takachr = _takachr.text;
      var takano = _takano.text;
      var ctakano = _ctakano.text;
      var pcs = _pcs.text;
      var meters = _meters.text;
      var tpmtrs = _tpmeters.text;
      var itemname = _itemname.text;
      var design = _design.text;
      var rate = _rate.text;
      var unit = _unit.text;
      var amount = _amount.text;
      var machine = _machine.text;
      var inwid = _inwid.text;
      var inwdetid = _inwdetid.text;
      var inwdettkid = _inwdettkid.text;
      var fmode = _fmode.text;
      var orderno = _orderno.text;
      var ordid = _ordid.text;
      var orddetid = _orddetid.text;
      var ordbalmtrs = _ordbalmtrs.text;
      var hsncode = _hsncode.text;
      var folddate = _folddate.text;
      var weight = _weight.text;
      var avgwt = _avgwt.text;
      var beamno = _beamno.text;
      var beamitem = _beamitem.text;

      widget.xitemDet.add({
        'orderno': orderno,
        'takachr': takachr,
        'takano': takano,
        'pcs': pcs,
        'meters': meters,
        'tpmtrs': tpmtrs,
        'itemname': itemname,
        'hsncode': hsncode,
        'rate': rate,
        'unit': unit,
        'amount': amount,
        'design': design,
        'machine': machine,
        'ordid': ordid,
        'fmode': fmode,
        'inwid': inwid,
        'inwdettkid': inwdettkid,
        'inwdetid': inwdetid,
        'orddetid': orddetid,
        'ordbalmtrs': ordbalmtrs,
        'weight': weight,
        'avgwt': avgwt,
        'beamno': beamno,
        'beamitem': beamitem
      });

      Navigator.pop(context, widget.xitemDet);

      // var response = await http.post(Uri.parse(uri));

      // var jsonData = jsonDecode(response.body);
      // //print('4');

      // var jsonCode = jsonData['Code'];
      // var jsonMsg = jsonData['Message'];

      // if (jsonCode == '500') {
      //   showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      // } else {
      //   showAlertDialog(context, 'Saved !!!');
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (_) => LoomSalesChallanList(
      //                 companyid: widget.xcompanyid,
      //                 companyname: widget.xcompanyname,
      //                 fbeg: widget.xfbeg,
      //                 fend: widget.xfend,
      //               )));
      // }

      return true;
    }

    var items = [
      'PACKING',
      'DELIVERY',
    ];

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grey Job Issue Challan Item Details[ ] ',
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _orderno,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Job Order',
                      labelText: 'Order No',
                    ),
                    onTap: () {
                      gotoOrderScreen(context);
                    },
                    onChanged: (value) {
                      ;
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _folddate,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Fold Date',
                      labelText: 'Fold Date',
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _ordbalmtrs,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Order Balance',
                      labelText: 'Order Balance',
                    ),
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
                    controller: _takachr,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Taka ',
                      labelText: 'Takachr',
                    ),
                    onChanged: (value) {
                      _takachr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _takachr.selection);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _takano,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Taka No',
                      labelText: 'Taka No',
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
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _design,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Design',
                      labelText: 'Design',
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
                    controller: _pcs,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pcs / Taka',
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
                    controller: _tpmeters,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'TP Mtrs',
                      labelText: 'TP Meters',
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
                    controller: _hsncode,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'HSN Code',
                      labelText: 'HSN Code',
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
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _machine,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Machine No',
                      labelText: 'Machine',
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
                    controller: _weight,
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
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _avgwt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Avg Weight',
                      labelText: 'Avg Weight',
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
                    controller: _beamno,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam No',
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
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _beamitem,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam Item',
                      labelText: 'Beam Item',
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
                    enabled: false,
                    controller: _inwid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'InwId',
                      labelText: 'InwId',
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
                    enabled: false,
                    controller: _inwdetid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'InwDetid',
                      labelText: 'InwDetId',
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
                    enabled: false,
                    controller: _inwdettkid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'InwTkDetid',
                      labelText: 'InwTkDetId',
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
                    enabled: false,
                    controller: _fmode,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'FMode',
                      labelText: 'FMode',
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
            
          ],
        ),
      )),
      // bottomNavigationBar: BottomBar(
      //   companyname: widget.xcompanyname,
      //   fbeg: widget.xfbeg,
      //   fend: widget.xfend,
      // ),
    );
  }
}
