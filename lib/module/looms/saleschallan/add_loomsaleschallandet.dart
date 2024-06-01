// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LoomSalesChallanDetAdd extends StatefulWidget {
  LoomSalesChallanDetAdd(
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
      ordno,
      type})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xbranchid = branchid;
    xordno = ordno;
    xItemDetails = itemDet;
    xtype = type;
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
  var xbranchid;
  var xordno;
  var xtype;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _LoomSalesChallanDetAddState createState() => _LoomSalesChallanDetAddState();
}

class _LoomSalesChallanDetAddState extends State<LoomSalesChallanDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController();
  TextEditingController _folddate = new TextEditingController();
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController();
  TextEditingController _ctakano = new TextEditingController();
  TextEditingController _haste = new TextEditingController();
  TextEditingController _salesman = new TextEditingController();
  TextEditingController _pcs = new TextEditingController();
  TextEditingController _meters = new TextEditingController();
  TextEditingController _tpmeters = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _design = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  // TextEditingController _unit = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _machine = new TextEditingController();
  TextEditingController _inwid = new TextEditingController();
  TextEditingController _inwdetid = new TextEditingController();
  TextEditingController _inwdettkid = new TextEditingController();
  TextEditingController _ordid = new TextEditingController();
  TextEditingController _orddetid = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _ordbalmtrs = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _duedays = new TextEditingController();
  TextEditingController _netwt = new TextEditingController();
  TextEditingController _avgwt = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _beamitem = new TextEditingController();

  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _jsonData = [];

  String? dropdownUnitType;

  var UnitType = [
    'M',
    'P',
  ];

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
        _folddate.text = ItemDetails[length - 1]['folddate'].toString();
        _ordbalmtrs.text = ItemDetails[length - 1]['ordbalmtrs'].toString();
        _ordid.text = ItemDetails[length - 1]['ordid'].toString();
        _orddetid.text = ItemDetails[length - 1]['orddetid'].toString();
        _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        _design.text = ItemDetails[length - 1]['design'].toString();
        _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
        dropdownUnitType = ItemDetails[length - 1]['unit'].toString();
        _rate.text = ItemDetails[length - 1]['rate'].toString();
        _duedays.text = ItemDetails[length - 1]['duedays'].toString();
        _remarks.text = ItemDetails[length - 1]['remarks'].toString();
      });
    }
  }

  void gotoOrderScreen(BuildContext contex) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => order_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  partyid: widget.xparty,
                )));

    setState(() {
      var retResult = result;

      print(retResult);
      var _orderlist = result[1];
      result = result[1];
      var orderid = _orderlist[0];

      print(orderid);

      var selOrder = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selOrder = selOrder + ',';
        }
        selOrder = selOrder + retResult[0][ictr];
      }

      _orderno.text = selOrder;

      print('dhruv');
      print(result);
      setState(() {
        _folddate.text = result[0]['date'];
        _itemname.text = result[0]['itemname'];
        _design.text = result[0]['design'];
        dropdownUnitType = result[0]['unit'];
        _haste.text = result[0]['haste'].toString();
        if (_haste.text == "null") {
          _haste.text = '';
        }
        _salesman.text = result[0]['salesman'].toString();
        if (_salesman.text == "null") {
          _salesman.text = '';
        }
        print(_haste.text);
        _rate.text = result[0]['rate'];
        _ordid.text = result[0]['ordid'].toString();
        _orddetid.text = result[0]['orddetid'].toString();
        ordMeters = double.parse(result[0]['balmeters'].toString());
        _ordbalmtrs.text = result[0]['balmeters'].toString();
        _remarks.text = result[0]['remarks'].toString();
        _duedays.text = result[0]['duedays'].toString();
      });
    });
  }

  Future<bool> fetchdetails() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;
    var takano = _takano.text;
    var takachr = _takachr.text;
    var branch = widget.xbranchid;

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

    // uri =
    //     'http://127.0.0.1:8000/api/commonapi_gettakastock2?dbname=' +
    //         db +
    //         '&partyfilter=N&takachr=' +
    //         takachr +
    //         '&takano=' +
    //         takano +
    //         '&branchid=(' +
    //         branch +
    //         ')&getdata=Y';

    print(" fetchdetails  :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    if (jsonData == null) {
      showAlertDialog(context, 'Taka No Found...');
      return true;
    }

    _jsonData = List<Map<String, dynamic>>.from(jsonData);

    print(_jsonData);

    if (1 < _jsonData.length) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Select Item"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.sizeOf(context).height / 2,
                  child: ListView.builder(
                    itemCount: _jsonData.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: false,
                        subtitle: Text(_jsonData[index]['itemname'].toString()),
                        title: Text(_jsonData[index]['meters'].toString()),
                        onChanged: (bool? value) {
                          print('changed');
                          print(_jsonData[index]['itemname'].toString());

                          _takachr.text = _jsonData[index]['takachr'].toString();
                          _takano.text = _jsonData[index]['takano'].toString();
                          _folddate.text = _jsonData[index]['date'].toString();
                          // _ordbalmtrs.text = _jsonData[index]['balmeters'].toString();
                          _itemname.text = _jsonData[index]['itemname'].toString();
                          _design.text = _jsonData[index]['design'].toString();
                          _pcs.text = _jsonData[index]['pcs'].toString();
                          _meters.text = _jsonData[index]['meters'].toString();
                          _tpmeters.text = _jsonData[index]['tpmtrs'].toString();
                          _hsncode.text = _jsonData[index]['hsncode'].toString();
                          // _unit.text = _jsonData[index]['unit'].toString();
                          setState(() {
                            dropdownUnitType = _jsonData[index]['unit'].toString();
                          });
                          // _rate.text = _jsonData[index]['rate'].toString();
                          // _amount.text = _jsonData[index]['amount'].toString();
                          _machine.text = _jsonData[index]['machine'].toString();
                          _inwid.text = _jsonData[index]['inwid'].toString();
                          _inwdetid.text = _jsonData[index]['inwdetid'].toString();
                          _inwdettkid.text = _jsonData[index]['inwdettkid'].toString();
                          _fmode.text = _jsonData[index]['fmode'].toString();
                          _avgwt.text = _jsonData[index]['avgwt'].toString();
                          _netwt.text = _jsonData[index]['netwt'].toString();
                          _beamno.text = _jsonData[index]['beamno'].toString();
                          _beamitem.text = _jsonData[index]['beamitem'].toString();

                          double pcs = double.parse(_pcs.text);
                          double meters = double.parse(_meters.text);
                          // String unit = _unit.text;
                          String unit = dropdownUnitType.toString();
                          double rate = 0;
                          if (_rate.text != '') {
                            rate = double.parse(_rate.text);
                          }
                          double amount = 0;
                          if ((unit == 'P') || (unit == 'T')) {
                            amount = pcs * rate;
                            print("amount $amount");
                          } else {
                            amount = meters * rate;
                            print("=================" + _amount.text);
                          }
                          _amount.text = amount.toString();
                          print(jsonData);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      setState(() {
        _takachr.text = _jsonData[0]['takachr'].toString();
        _takano.text = _jsonData[0]['takano'].toString();
        _itemname.text = jsonData[0]['itemname'].toString();
        _folddate.text = jsonData[0]['date'].toString();
        // _ordbalmtrs.text = _jsonData[0]['balmeters'].toString();
        _design.text = jsonData[0]['design'].toString();
        _pcs.text = jsonData[0]['pcs'].toString();
        _meters.text = jsonData[0]['meters'].toString();
        _tpmeters.text = jsonData[0]['tpmtrs'].toString();
        _hsncode.text = jsonData[0]['hsncode'].toString();
        // _unit.text = jsonData[0]['unit'].toString();
        setState(() {
          dropdownUnitType = jsonData[0]['unit'].toString();
        });
        // _rate.text = jsonData[0]['rate'].toString();
        // _amount.text = jsonData[0]['amount'].toString();
        _machine.text = jsonData[0]['machine'].toString();
        _inwid.text = jsonData[0]['inwid'].toString();
        _inwdetid.text = jsonData[0]['inwdetid'].toString();
        _inwdettkid.text = jsonData[0]['inwdettkid'].toString();
        _fmode.text = jsonData[0]['fmode'].toString();
        _avgwt.text = jsonData[0]['avgwt'].toString();
        _netwt.text = jsonData[0]['netwt'].toString();
        _beamno.text = jsonData[0]['beamno'].toString();
        _beamitem.text = jsonData[0]['beamitem'].toString();
      });

      double pcs = double.parse(_pcs.text);
      double meters = double.parse(_meters.text);
      // String unit = _unit.text;
      String unit = dropdownUnitType.toString();
      double rate = 0;
      if (_rate.text != '') {
        rate = double.parse(_rate.text);
      }
      double amount = 0;
      if (unit == 'P') {
        amount = pcs * rate;
        print("amount $amount");
      } else {
        amount = meters * rate;
        print("=================" + _amount.text);
      }
      _amount.text = amount.toString();

      print(jsonData);
    }
    return true;
  }

  void totCalUnit() {
    double pcs = 0.0;
    double meters = 0.0;
    double rate = 0.0;
    String unit = dropdownUnitType.toString();

    if (_pcs.text.isNotEmpty) {
      pcs = double.tryParse(_pcs.text) ?? 0.0;
    }

    if (_meters.text.isNotEmpty) {
      meters = double.tryParse(_meters.text) ?? 0.0;
    }

    if (_rate.text.isNotEmpty) {
      rate = double.tryParse(_rate.text) ?? 0.0;
    }

    double amount = 0.0;

    if (unit == 'P') {
      amount = pcs * rate;
    } else if (unit == 'M') {
      amount = rate * meters;
    } else {
      amount = meters * rate;
    }

    setState(() {
      _amount.text = amount.toString();
    });
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
      var haste = _haste.text;
      var salesman = _salesman.text;
      var pcs = _pcs.text;
      var meters = _meters.text;
      var tpmtrs = _tpmeters.text;
      var itemname = _itemname.text;
      var design = _design.text;
      var rate = _rate.text;
      var unit = dropdownUnitType;
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
      var remarks = _remarks.text;
      var duedays = _duedays.text;
      var netwt = _netwt.text;
      var avgwt = _avgwt.text;
      var beamno = _beamno.text;
      var beamitem = _beamitem.text;

      print(_orderno.text);

      widget.xitemDet.add({
        'orderno': orderno,
        'takachr': takachr,
        'takano': takano,
        'haste': haste,
        'salesman': salesman,
        'pcs': pcs,
        'meters': meters,
        'tpmtrs': tpmtrs,
        'itemname': itemname,
        'hsncode': hsncode,
        'rate': rate,
        'var': 0,
        'unit': unit,
        'varper': 0,
        'amount': amount,
        'design': design,
        'machine': machine,
        'orditem': itemname,
        'orddesign': design,
        'ordmtr': ordbalmtrs,
        'stdwt': 0,
        'ordid': ordid,
        'folddate': folddate,
        'type': '',
        'tkid': 0,
        'tkdetid': 0,
        'fmode': fmode,
        'inwid': inwid,
        'inwdettkid': inwdettkid,
        'cost': 0,
        'inwdetid': inwdetid,
        'tp': '',
        'orddetid': orddetid,
        'ordbalmtrs': ordbalmtrs,
        'remarks': remarks,
        'duedays': duedays,
        'netwt': netwt,
        'avgwt': avgwt,
        'beamno': beamno,
        'beamitem': beamitem,
      });

      Navigator.pop(context, widget.xitemDet);

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
          'Sales Challan Item Details[ ] ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {
                if (_formKey.currentState!.validate())
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Form submitted successfully')),
                    ),
                    saveData()
                  },
              }),
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
                      hintText: 'Select Sales Order',
                      labelText: 'Order No',
                    ),
                    onTap: () {
                      gotoOrderScreen(context);
                    },
                    onChanged: (value) {},
                    validator: (value) {
                      print(widget.xtype);
                      if (widget.xtype == 'PACKING') {
                      } else if ('Delivery' == widget.xtype ||
                          value == '0' ||
                          value == '') {
                        return 'Please enter order no';
                      }
                      // if (value == null ||
                      //     value.isEmpty ||
                      //     value == "0" ||
                      //     'Delivery' == widget.xtype) {
                      //   return 'Please enter order no';
                      // }
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
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Form submitted successfully')),
                        ),
                        fetchdetails()
                      },
                  },
                  child: Text('Fetch Details',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.all(2)),
                ElevatedButton(
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Form submitted successfully')),
                        ),
                        barcodeScan()
                      },
                  },
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
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pcs / Taka',
                      labelText: 'Pcs',
                    ),
                    onTap: () {
                      setState(() {
                        totCalUnit();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        totCalUnit();
                      });
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
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.number,
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
                    enabled: false,
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
                  child: DropdownButtonFormField(
                      value: dropdownUnitType,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        hintText: "Unit",
                        icon: const Icon(Icons.person),
                      ),
                      items: UnitType.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownUnitType = newValue!;
                          totCalUnit();
                        });
                      }),
                ),
                // Expanded(
                //   child: TextFormField(
                //     controller: _unit,
                //     decoration: const InputDecoration(
                //       icon: const Icon(Icons.person),
                //       hintText: 'Unit',
                //       labelText: 'Unit',
                //     ),
                //     onTap: () {
                //       //gotoBranchScreen(context);
                //     },
                //     validator: (value) {
                //       return null;
                //     },
                //   ),
                // )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amount,
                    enabled: false,
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
                    controller: _netwt,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'netwt',
                      labelText: 'netwt',
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
                    controller: _avgwt,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'avgwt',
                      labelText: 'avgwt',
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
                    enabled: false,
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
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
