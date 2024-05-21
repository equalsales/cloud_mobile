// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BeamPurchaseChallanDetAdd extends StatefulWidget {
  BeamPurchaseChallanDetAdd(
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
  _BeamPurchaseChallanDetAddState createState() => _BeamPurchaseChallanDetAddState();
}

class _BeamPurchaseChallanDetAddState extends State<BeamPurchaseChallanDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController();
  TextEditingController _folddate = new TextEditingController();
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController();
  TextEditingController _ctakano = new TextEditingController();
  TextEditingController _ordbalmtrs = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _beamchr = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _beammtrs = new TextEditingController();
  TextEditingController _beamwt = new TextEditingController();
  TextEditingController _ends = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _bchlndetid = new TextEditingController();
  TextEditingController _discrate = new TextEditingController();
  TextEditingController _discamt = new TextEditingController();
  TextEditingController _addamt = new TextEditingController();
  TextEditingController _texavalue = new TextEditingController();
  TextEditingController _sgstrate = new TextEditingController();
  TextEditingController _sgstamt = new TextEditingController();
  TextEditingController _cgstrate = new TextEditingController();
  TextEditingController _cgstamt = new TextEditingController();
  TextEditingController _igstrate = new TextEditingController();
  TextEditingController _igstamt = new TextEditingController();
  TextEditingController _finalamt = new TextEditingController();

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
        _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
        _unit.text = ItemDetails[length - 1]['unit'].toString();
        _rate.text = ItemDetails[length - 1]['rate'].toString();
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
        dropdownUnitType = result[0]['unit'];
        _rate.text = result[0]['rate'];
        ordMeters = double.parse(result[0]['balmeters'].toString());
        _ordbalmtrs.text = result[0]['balmeters'].toString();
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
        '${globals.cdomain}/api/commonapi_gettakastock2?dbname=' +
            db +
            '&partyfilter=N&takachr=' +
            takachr +
            '&takano=' +
            takano +
            '&branchid=(' +
            branch +
            ')&getdata=Y';

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
                          _takachr.text = _jsonData[index]['takachr'].toString();
                          _takano.text = _jsonData[index]['takano'].toString();
                          _folddate.text = _jsonData[index]['date'].toString();
                          _itemname.text = _jsonData[index]['itemname'].toString();
                          _hsncode.text = _jsonData[index]['hsncode'].toString();
                          setState(() {
                            dropdownUnitType = _jsonData[index]['unit'].toString();
                          });
                          _fmode.text = _jsonData[index]['fmode'].toString();
                          _beamno.text = _jsonData[index]['beamno'].toString();
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
        setState(() {
          dropdownUnitType = jsonData[0]['unit'].toString();
        });
        _fmode.text = jsonData[0]['fmode'].toString();
        _beamno.text = jsonData[0]['beamno'].toString();
      });
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var takachr = _takachr.text;
      var takano = _takano.text;
      var orderno = _orderno.text;
      var folddate = _folddate.text;
      var ordbalmtrs = _ordbalmtrs.text;
      var ctakano = _ctakano.text;
      var itemname = _itemname.text;
      var hsncode = _hsncode.text;
      var beamchr = _beamchr.text;
      var beamno = _beamno.text;
      var beammtrs = _beammtrs.text;
      var beamwt = _beamwt.text;
      var ends = _ends.text;
      var rate = _rate.text;
      var unit = dropdownUnitType;
      var amount = _amount.text;
      var fmode = _fmode.text; 
      var bchlndetid = _bchlndetid.text;
      var discrate = _discrate.text;
      var discamt = _discamt.text;
      var addamt = _addamt.text;
      var texavalue = _texavalue.text;
      var sgstrate = _sgstrate.text;
      var sgstamt = _sgstamt.text;
      var cgstrate = _sgstrate.text;
      var cgstamt = _sgstamt.text;
      var igstrate = _sgstrate.text;
      var igstamt = _sgstamt.text;
      var finalamt = _finalamt.text;

      print(_orderno.text);

      widget.xitemDet.add({
        'orderno': orderno,
        'takachr': takachr,
        'takano': takano,
        'ordbalmtrs': ordbalmtrs,
        'folddate': folddate,
        'itemname': itemname,
        'hsncode': hsncode,
        'beamchr': beamchr,
        'beamno': beamno,
        'beammtrs': beammtrs,
        'beamwt': beamwt,
        'ends': ends,
        'rate': rate,
        'unit': unit,
        'amount': amount,
        'fmode': fmode,
        'bchlndetid': bchlndetid,
        'discrate': discrate,
        'discamt': discamt,
        'addamt': addamt,
        'texavalue': texavalue,
        'sgstrate': sgstrate,
        'sgstamt': sgstamt,
        'cgstrate': cgstrate,
        'cgstamt': cgstamt,
        'igstrate': igstrate,
        'igstamt': igstamt,
        'finalamt': finalamt,
      });

      Navigator.pop(context, widget.xitemDet);
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beam Purchase Challan Details[ ] ',
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
                    enabled: false,
                    controller: _beamchr,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beamchr',
                      labelText: 'Beamchr',
                    ),
                    onTap: () {},
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _beamno,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beamno',
                      labelText: 'Beamno',
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
                    controller: _beammtrs,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beammtrs',
                      labelText: 'Beammtrs',
                    ),
                    onTap: () {},
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _beamwt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beamwt',
                      labelText: 'Beamwt',
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
                    enabled: false,
                    keyboardType: TextInputType.number,
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
                    enabled: false,
                    controller: _fmode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Fmode',
                      labelText: 'Fmode',
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
                    controller: _bchlndetid,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Bchlndetid	',
                      labelText: 'Bchlndetid	',
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
                    controller: _rate,
                    enabled: false,
                    keyboardType: TextInputType.number,
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
                        });
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amount,
                    enabled: false,
                    keyboardType: TextInputType.number,
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
                    controller: _discrate,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'DiscRate',
                      labelText: 'DiscRate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _discamt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'DiscAmt',
                      labelText: 'DiscAmt',
                    ),
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
                    controller: _addamt,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'AddAmt',
                      labelText: 'AddAmt',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _texavalue,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'TexableValue',
                      labelText: 'TexableValue',
                    ),
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
                    controller: _sgstrate,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGSTRate',
                      labelText: 'SGSTRate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _sgstamt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGSTAmt',
                      labelText: 'SGSTAmt',
                    ),
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
                    controller: _cgstrate,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGSTRate',
                      labelText: 'CGSTRate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _cgstamt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGSTAmt',
                      labelText: 'CGSTAmt',
                    ),
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
                    controller: _igstrate,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGSTRate',
                      labelText: 'IGSTRate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _igstamt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGSTAmt',
                      labelText: 'IGSTAmt',
                    ),
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
                    controller: _finalamt,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'FinalAmt',
                      labelText: 'FinalAmt',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
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
