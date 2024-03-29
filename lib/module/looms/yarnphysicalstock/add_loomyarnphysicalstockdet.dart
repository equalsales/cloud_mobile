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

class LoomYarnphysicalstockdetAdd extends StatefulWidget {
  LoomYarnphysicalstockdetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partyid,
      itemDet,
      id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xItemDetails = itemDet;
    //xitemDet = itemDet;

    print('in Item Details');
    print(xbranch);
    print(xparty);
    print(xItemDetails);
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xbranch;
  var xparty;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _LoomYarnphysicalstockdetAddState createState() => _LoomYarnphysicalstockdetAddState();
}

class _LoomYarnphysicalstockdetAddState extends State<LoomYarnphysicalstockdetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  //TextEditingController _orderno = new TextEditingController();
  //TextEditingController _folddate = new TextEditingController();
  TextEditingController _Cartonchr = new TextEditingController();
  TextEditingController _Cartonno = new TextEditingController();
  TextEditingController _netwt = new TextEditingController();
  TextEditingController _cCartonno = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _lotno = new TextEditingController();
  TextEditingController _cops = new TextEditingController();
  TextEditingController _cone = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _ychlndetid = new TextEditingController();
  TextEditingController _ychlnid = new TextEditingController();
  TextEditingController _ychlnsubdetid = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();

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
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;
    var branch = widget.xbranch;
    var cartonno = _Cartonno.text;
    var cartonchr = _Cartonchr.text;

    fromdate = retconvdate(fromdate);
    todate = retconvdate(todate);

    fromdate = fromdate.toString();
    todate = todate.toString();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      for (int iCtr = 0; iCtr < length; iCtr++) {
        if ((ItemDetails[iCtr]['cartonno'] == cartonno) &&
            ((ItemDetails[iCtr]['cartonchr'] == cartonchr))) {
          showAlertDialog(context, 'Carton no Already Exists...');
          setState(() {
            _Cartonno.text = '0';
            _Cartonchr.text = '';
          });
          return true;
        }
      }
    }

    uri = 'https://looms.equalsoftlink.com/api/commonapi_cartoonstock?dbname=' +
        db +
        '&cno=' +
        cno +
        '&fromdate=' +
        fromdate +
        '&todate=' +
        todate +
        '&branch=' + 
        branch + 
        '&itemname=&cartonchr=' +
        cartonchr +
        '&cartonno=' +
        cartonno;
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

    jsonData = jsonData['Data'];
    if (jsonData == null) {
      showAlertDialog(context, 'Carton no No Found...');
      return true;
    }

    jsonData = jsonData[0];

    setState(() {
      _itemname.text = jsonData['itemname'];
      _netwt.text = jsonData['balwt'].toString();
      _cops.text = jsonData['cops'].toString();
      _unit.text = jsonData['unit'];
      _lotno.text = jsonData['lotno'];
      _ychlndetid.text = jsonData['detid'].toString();
      _ychlnid.text = jsonData['mstid'].toString();
      _ychlnsubdetid.text = jsonData['subdetid'].toString();
      _fmode.text = jsonData['fmode'];
      _rate.text = jsonData['rate'];
      _amount.text = jsonData['amount'];
      _cone.text = '0';

      double netwt = double.parse(_netwt.text);
      double cops = double.parse(_cops.text);

      String unit = _unit.text;
      double rate = 0;
      if (_rate.text != '') {
        rate = double.parse(_rate.text);
      }
      double amount = 0;
      if ((unit == 'W') || (unit == '')) {
        amount = netwt * rate;
      } else {
        amount = cops * rate;
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
      _Cartonno.text = splitted[0];
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
      var cartonchr = _Cartonchr.text;
      var cartonno = _Cartonno.text;
      var ccartonno = _cCartonno.text;
      var netwt = _netwt.text;
      var lotno = _lotno.text;
      var cops = _cops.text;
      var cone = _cone.text;
      var itemname = _itemname.text;

      var rate = _rate.text;
      var unit = _unit.text;
      var amount = _amount.text;

      var ychlndetid = _ychlndetid.text;
      var ychlnid = _ychlnid.text;
      var ychlnsubdetid = _ychlnsubdetid.text;
      var fmode = _fmode.text;

      print("jatin");
      widget.xitemDet.add({
        'cartonchr': cartonchr,
        'cartonno': cartonno,
        'netwt': netwt,
        'itemname': itemname,
        'lotno': lotno,
        'cops': cops,
        'cone': cone,
        'unit': unit,
        'rate': rate,
        'amount': amount,
        'cost': '0',
        'ychlnsubdetid': ychlnsubdetid.toString(),
        'ychlnid': ychlnid.toString(),
        'ychlndetid': ychlndetid.toString(),
        'fmode': fmode,
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
          'Yarn Physical Stock Item Details [ ] ',
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
                    controller: _Cartonchr,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select carton ',
                      labelText: 'Cartonchr',
                    ),
                    onChanged: (value) {
                      _Cartonchr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _Cartonchr.selection);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _Cartonno,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Carton No',
                      labelText: 'Carton No',
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
                    controller: _netwt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Net Weight',
                      labelText: 'NetWt',
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
                    controller: _cops,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cops',
                      labelText: 'Cops',
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
                    controller: _cone,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cone',
                      labelText: 'Cone',
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
                    controller: _lotno,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Lot No',
                      labelText: 'Lot No',
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
                     enabled: false,
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
                     enabled: false,
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
                    controller: _ychlndetid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ychlndetid',
                      labelText: 'ychlndetid',
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
                    controller: _ychlnid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ychlnid',
                      labelText: 'ychlnid',
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
                    controller: _ychlnsubdetid,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ychlnsubdetid',
                      labelText: 'ychlnsubdetid',
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
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
