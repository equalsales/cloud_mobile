import 'dart:convert';

import 'package:cloud_mobile/module/looms/greyjobissue/orderlist_greyjobissue.dart';
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

class LoomGreyJobIssueDetAdd extends StatefulWidget {
  LoomGreyJobIssueDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partyid,
      itemDet,
      id,
      branchid,
      orderno,
      orderChr,
      ordid,
      orddetid,
      orditem,
      orddesign,
      ordmtrs,
      itemname
      })
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xbranchid = branchid;
    xorderno = orderno;
    xorderchr = orderChr;
    xordid = ordid;
    xorddetid = orddetid;
    xorditem = orditem;
    xorddesign = orddesign;
    xordmtrs = ordmtrs;
    xitemname = itemname;
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
  var xorderno;
  var xorderchr;
  var xordid;
  var xorddetid;
  var xorditem;
  var xorddesign;
  var xordmtrs;
  var xitemname;
  var xparty;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _LoomGreyJobIssueDetAddState createState() => _LoomGreyJobIssueDetAddState();
}

class _LoomGreyJobIssueDetAddState extends State<LoomGreyJobIssueDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController();
  TextEditingController _orderChr = new TextEditingController();
  TextEditingController _ordDate = new TextEditingController();
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
  TextEditingController _ordMtrs = new TextEditingController();
  TextEditingController _ordItem = new TextEditingController();
  TextEditingController _ordDesign = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _ordbalmtrs = new TextEditingController();
  TextEditingController _weight = new TextEditingController();
  TextEditingController _avgwt = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _beamitem = new TextEditingController();

  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  var visible = true;

  @override
  void initState() {
    super.initState();
     
    _orderno.text = widget.xorderno;
    _orderChr.text = widget.xorderchr;
    _ordid.text = widget.xordid;
    _orddetid.text = widget.xorddetid;
    _ordItem.text = widget.xorditem;
    _ordDesign.text = widget.xorddesign;
    _ordMtrs.text = widget.xordmtrs;

    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      setState(() {
        // _orderno.text = ItemDetails[length - 1]['orderno'].toString();
        // _orderChr.text = ItemDetails[length - 1]['orderchr'].toString();
        //_folddate.text = ItemDetails[length - 1]['folddate'].toString();
        // _ordbalmtrs.text = ItemDetails[length - 1]['ordbalmtrs'].toString();
        // _ordid.text = ItemDetails[length - 1]['ordid'].toString();
        // _orddetid.text = ItemDetails[length - 1]['orddetid'].toString();
        // _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        // _design.text = ItemDetails[length - 1]['design'].toString();
        // _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
        // _unit.text = ItemDetails[length - 1]['unit'].toString();
        // _rate.text = ItemDetails[length - 1]['rate'].toString();
      });
    }

    //_date.text = curDate.toString().split(' ')[0];

    // if (int.parse(widget.xid) > 0) {
    //   //loadData();
    // }
  }

  // void gotoOrderScreen(BuildContext contex) async {
  //   var result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => greyorder_list(
  //                 companyid: widget.xcompanyid,
  //                 companyname: widget.xcompanyname,
  //                 fbeg: widget.xfbeg,
  //                 fend: widget.xfend,
  //                 branch: widget.xbranch,
  //                 orderno: widget.xorderno,
  //               )));

  //   setState(() {
  //     var retResult = result;

  //     print(retResult);
  //     var _orderlist = result[1];
  //     result = result[1];
  //     var orderid = _orderlist[0];

  //     print(orderid);

  //     var selOrder = '';
  //     for (var ictr = 0; ictr < retResult[0].length; ictr++) {
  //       if (ictr > 0) {
  //         selOrder = selOrder + ',';
  //       }
  //       selOrder = selOrder + retResult[0][ictr];
  //     }

  //     _orderno.text = selOrder;

  //     setState(() {
  //       _orderno.text = result[0]['orderno'];
  //       _orderChr.text = result[0]['orderchr'];
  //       _itemname.text = result[0]['itemname'];
  //       _design.text = result[0]['design'];
  //       _unit.text = result[0]['unit'];
  //       _ordid.text = result[0]['ordid'].toString();
  //       _orddetid.text = result[0]['orddetid'].toString();
  //       ordMeters = double.parse(result[0]['balmeters'].toString());
  //       _ordbalmtrs.text = result[0]['balmeters'].toString();
  //     });
  //   });
  // }

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
    var cItem ='';

    fromdate = retconvdate(fromdate);
    todate = retconvdate(todate);

    fromdate = fromdate.toString();
    todate = todate.toString();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      for (int iCtr = 0; iCtr < length; iCtr++) {
        cItem= ItemDetails[iCtr]['itemname'].toString();
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
    uri = '${globals.cdomain}/api/commonapi_gettakastock2?dbname=' +
        db +
        '&partyfilter=N&takachr=' +
        takachr +
        '&takano=' +
        takano +
        '&branchid=('+ branch +')&getdata=Y&itemname=${widget.xitemname}';

    // uri = '${globals.cdomain}/api/commonapi_gettakastock2?dbname=' +
    //     db +
    //     '&partyfilter=N&takachr=' +
    //     takachr +
    //     '&takano=' +
    //     takano +
    //     '&branchid=('+ branch +')&getdata=Y&itemfilter=Y&itemid=$cItem';

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
      visible = false;
      _takano.text = jsonData['takano'].toString();
      _takachr.text = jsonData['takachr'].toString();
      _itemname.text = jsonData['itemname'].toString();
      _ordDate.text = jsonData['date'].toString();
      _design.text = jsonData['design'].toString();
      _machine.text = jsonData['machine'].toString();
      _pcs.text = jsonData['pcs'].toString();
      _meters.text = jsonData['meters'].toString();
      _ordMtrs.text = _meters.text;
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
      if(splitted.length>1)
      {
        _takano.text = splitted[1];
      }
      else
      {
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
      var orderChr = _orderChr.text;
      var ordid = _ordid.text;
      var orddetid = _orddetid.text;
      var orditem = _ordItem.text;
      var orddesign= _ordDesign.text;
      var ordmtr = _ordMtrs.text;
      var ordbalmtrs = _ordbalmtrs.text;
      var hsncode = _hsncode.text;
      var folddate = _ordDate.text;
      var weight = _weight.text;
      var avgwt = _avgwt.text;
      var beamno = _beamno.text;
      var beamitem = _beamitem.text;

      widget.xitemDet.add({
        'orderno': orderno,
        'orderchr': orderChr,
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
        'orddetid': orddetid,
        'orditem': orditem,
        'orddesign': orddesign,
        'ordmtr': ordmtr,
        'fmode': fmode,
        'inwid': inwid,
        'inwdettkid': inwdettkid,
        'inwdetid': inwdetid,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: visible,
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
                    enabled: visible,
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
                    enabled: false,
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
                    enabled: false,
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
                    enabled: false,
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
                    enabled: false,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _orderno,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrderNo',
                      labelText: 'OrderNo',
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _orderChr,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrderChr',
                      labelText: 'OrderChr',
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
                    controller: _ordid,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdId',
                      labelText: 'OrdId',
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _orddetid,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdDetId',
                      labelText: 'OrdDetId',
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
                    controller: _ordItem,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdItem',
                      labelText: 'OrdItem',
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _ordDesign,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdDesign',
                      labelText: 'OrdDesign',
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _ordMtrs,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdMtrs',
                      labelText: 'OrdMtrs',
                    ),
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
