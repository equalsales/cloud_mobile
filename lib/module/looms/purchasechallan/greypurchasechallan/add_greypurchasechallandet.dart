// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/list/design_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/order_list.dart';
import 'package:cloud_mobile/module/looms/purchasechallan/greypurchasechallan/add_detsubgreypurchasechallan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class GreyPurchaseChallanDetAdd extends StatefulWidget {
  GreyPurchaseChallanDetAdd(
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
  _GreyPurchaseChallanDetAddState createState() => _GreyPurchaseChallanDetAddState();
}

class _GreyPurchaseChallanDetAddState extends State<GreyPurchaseChallanDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController(text: '0');
  TextEditingController _orderchr = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _design= new TextEditingController();
  TextEditingController _pcs = new TextEditingController(text: '0.000');
  TextEditingController _meters = new TextEditingController(text: '0.000');
  TextEditingController _weight = new TextEditingController(text: '0.00');
  TextEditingController _rate = new TextEditingController(text: '0.00');
  TextEditingController _stdwt = new TextEditingController(text: '0.000');
  TextEditingController _amount = new TextEditingController(text: '0');
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _foldmtrs = new TextEditingController(text: '0.00');
  TextEditingController _shtmtrs = new TextEditingController(text: '0.000');
  TextEditingController _shtrate = new TextEditingController(text: '0.000');
  TextEditingController _ordid = new TextEditingController(text: '0');
  TextEditingController _orddetid = new TextEditingController(text: '0');
  TextEditingController _discrate = new TextEditingController(text: '0.00');
  TextEditingController _discamt = new TextEditingController(text: '0.00');
  TextEditingController _addamt = new TextEditingController(text: '0.00');
  TextEditingController _texavalue = new TextEditingController(text: '0.00');
  TextEditingController _sgstrate = new TextEditingController(text: '0.00');
  TextEditingController _sgstamt = new TextEditingController(text: '0.00');
  TextEditingController _cgstrate = new TextEditingController(text: '0.00');
  TextEditingController _cgstamt = new TextEditingController(text: '0.00');
  TextEditingController _igstrate = new TextEditingController(text: '0.00');
  TextEditingController _igstamt = new TextEditingController(text: '0.00');
  TextEditingController _finalamt = new TextEditingController(text: '0.00');

  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _jsonData = [];

  List SubItemDetails = [];

  String dropdownUnitType = 'M';

  var UnitType = [
    'M',
    'P',
  ];

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    // if (length > 0) {
    //   setState(() {
    //     _orderno.text = ItemDetails[length - 1]['orderno'].toString();
    //     _folddate.text = ItemDetails[length - 1]['folddate'].toString();
    //     _ordbalmtrs.text = ItemDetails[length - 1]['ordbalmtrs'].toString();
    //     _ordid.text = ItemDetails[length - 1]['ordid'].toString();
    //     _orddetid.text = ItemDetails[length - 1]['orddetid'].toString();
    //     _itemname.text = ItemDetails[length - 1]['itemname'].toString();
    //     _design.text = ItemDetails[length - 1]['design'].toString();
    //     _rate.text = ItemDetails[length - 1]['rate'].toString();
    //   });
    // }
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
        _itemname.text = result[0]['itemname'];
        _design.text = result[0]['design'];
        dropdownUnitType = result[0]['unit'];
        _rate.text = result[0]['rate'];
        _ordid.text = result[0]['ordid'].toString();
        _orddetid.text = result[0]['orddetid'].toString();
        ordMeters = double.parse(result[0]['balmeters'].toString());
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
    var takano = _orderno.text;
    var takachr = _orderchr.text;
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
            _orderno.text = '0';
            _orderchr.text = '';
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
                          print('changed');
                          _orderchr.text = _jsonData[index]['takachr'].toString();
                          _orderno.text = _jsonData[index]['takano'].toString();
                          _itemname.text = jsonData[index]['itemname'].toString();
                          _design.text = jsonData[index]['design'].toString();
                          _pcs.text = jsonData[index]['pcs'].toString();
                          _meters.text = jsonData[index]['meters'].toString();
                          _weight.text = jsonData[index]['weight'].toString();
                          _rate.text = jsonData[index]['rate'].toString();
                          _stdwt.text = jsonData[index]['stdwt'].toString();
                          setState(() {
                            dropdownUnitType = jsonData[index]['unit'].toString();
                          });
                          _amount.text = jsonData[index]['amount'].toString();
                          _fmode.text = jsonData[index]['fmode'].toString();
                          _foldmtrs.text = jsonData[index]['foldmtrs'].toString();
                          _shtmtrs.text = jsonData[index]['shtmtrs'].toString();
                          _shtrate.text = jsonData[index]['shtrate'].toString();
                          _ordid.text = jsonData[index]['ordid'].toString();
                          _orddetid.text = jsonData[index]['orddetid'].toString();
                          _discrate.text = jsonData[index]['discrate'].toString();
                          _discamt.text = jsonData[index]['discamt'].toString();
                          _addamt.text = jsonData[index]['addamt'].toString();
                          _texavalue.text = jsonData[index]['texavalue'].toString();
                          _sgstrate.text = jsonData[index]['sgstrate'].toString();
                          _sgstamt.text = jsonData[index]['sgstamt'].toString();
                          _cgstrate.text = jsonData[index]['cgstrate'].toString();
                          _cgstamt.text = jsonData[index]['cgstamt'].toString();
                          _igstrate.text = jsonData[index]['igstrate'].toString();
                          _igstamt.text = jsonData[index]['igstamt'].toString();
                          _finalamt.text = jsonData[index]['finalamt'].toString();


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
        _orderchr.text = _jsonData[0]['takachr'].toString();
        _orderno.text = _jsonData[0]['takano'].toString();
        _itemname.text = jsonData[0]['itemname'].toString();
        _design.text = jsonData[0]['design'].toString();
        _pcs.text = jsonData[0]['pcs'].toString();
        _meters.text = jsonData[0]['meters'].toString();
        _weight.text = jsonData[0]['weight'].toString();
        _rate.text = jsonData[0]['rate'].toString();
        _stdwt.text = jsonData[0]['stdwt'].toString();
        setState(() {
          dropdownUnitType = jsonData[0]['unit'].toString();
        });
        _amount.text = jsonData[0]['amount'].toString();
        _fmode.text = jsonData[0]['fmode'].toString();
        _foldmtrs.text = jsonData[0]['foldmtrs'].toString();
        _shtmtrs.text = jsonData[0]['shtmtrs'].toString();
        _shtrate.text = jsonData[0]['shtrate'].toString();
        _ordid.text = jsonData[0]['ordid'].toString();
        _orddetid.text = jsonData[0]['orddetid'].toString();
        _discrate.text = jsonData[0]['discrate'].toString();
        _discamt.text = jsonData[0]['discamt'].toString();
        _addamt.text = jsonData[0]['addamt'].toString();
        _texavalue.text = jsonData[0]['texavalue'].toString();
        _sgstrate.text = jsonData[0]['sgstrate'].toString();
        _sgstamt.text = jsonData[0]['sgstamt'].toString();
        _cgstrate.text = jsonData[0]['cgstrate'].toString();
        _cgstamt.text = jsonData[0]['cgstamt'].toString();
        _igstrate.text = jsonData[0]['igstrate'].toString();
        _igstamt.text = jsonData[0]['igstamt'].toString();
        _finalamt.text = jsonData[0]['finalamt'].toString();
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

      final splitted = barcodeScanRes.split('-');
      print(splitted); 
      print(splitted.length);
      print('dhruv');
      _orderchr.text = splitted[0];
      if (splitted.length > 1) {
        _orderno.text = splitted[1];
      } else {
        _orderno.text = '0';
      }
      fetchdetails();
      //_scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {

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
      var newResult = result[1];
      var selItemname = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selItemname = selItemname + ',';
        }
        selItemname = selItemname + retResult[0][ictr];
      }
        _itemname.text = newResult[0]['itemname'].toString();
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


    Future<bool> saveData() async {
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var orderno = _orderno.text;
      var orderchr = _orderchr.text;
      var itemname = _itemname.text;
      var design = _design.text;
      var pcs = _pcs.text;
      var meters = _meters.text;
      var weight = _weight.text;
      var rate = _rate.text;
      var stdwt = _stdwt.text;
      var unit = dropdownUnitType;
      var amount = _amount.text;
      var fmode = _fmode.text;
      var foldmtrs = _foldmtrs.text;
      var shtmtrs = _shtmtrs.text;
      var shtprc = _shtrate.text;
      var ordid = _ordid.text;
      var orddetid = _orddetid.text;
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
        'orderchr': orderchr,
        'itemname': itemname,
        'orddesign': design,
        'pcs': pcs,
        'meters': meters,
        'weight': weight,
        'rate': rate,
        'stdwt': stdwt,
        'unit': unit,
        'amount': amount,
        'fmode': fmode,
        'foldmtrs': foldmtrs,
        'shtmtrs': shtmtrs,
        'shtprc': shtprc,
        'ordid': ordid,
        'orddetid': orddetid,
        'discper': discrate,
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

    void gotoChallanItemSubDet(BuildContext contex) async {    
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => GreyPurchaseChallanSubDetAdd(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  subitemDet: SubItemDetails,
              )
          )
      );
      setState(() {
        SubItemDetails.add(result[0]);
        print(" SubItemDetails : " + SubItemDetails.toString());
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grey Purchase Challan Details[ ] ',
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
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
                    controller: _orderchr,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select OrderChr ',
                      labelText: 'OrderChr',
                    ),
                    onChanged: (value) {
                      _orderchr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _orderchr.selection);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
                    enabled: true,
                    controller: _itemname,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Item Name',
                      labelText: 'Item Name',
                    ),
                    onTap: () {
                      gotoItemnameScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
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
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pcs,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pcs / Taka',
                      labelText: 'Pcs',
                    ),
                    onTap: () {
                      gotoChallanItemSubDet(context);
                    },
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _meters,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Meters',
                      labelText: 'Meters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      if (value == '' || 
                      value == '0' || 
                      value == '0.' || 
                      value == '0.0' || 
                      value == '0.00')
                      {
                        return 'Please enter meters';
                      }
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
                    enabled: true,
                    controller: _weight,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weight',
                      labelText: 'Weight',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _rate,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
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
                    controller: _stdwt,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'StdWt',
                      labelText: 'StdWt',
                    ),
                    onTap: () {},
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Amount',
                      labelText: 'Amount',
                    ),
                    onTap: () {},
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
                    enabled: true,
                    controller: _fmode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Fmode',
                      labelText: 'Fmode',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _foldmtrs,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Foldmtrs',
                      labelText: 'Foldmtrs',
                    ),
                    onTap: () {},
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
                    controller: _shtmtrs,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Shtmtrs',
                      labelText: 'Shtmtrs',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _shtrate,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ShtRate',
                      labelText: 'ShtRate',
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
                    controller: _ordid,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdId',
                      labelText: 'OrdId',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _orddetid,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'OrdDetId',
                      labelText: 'OrdDetId',
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
                    controller: _discrate,
                    enabled: true,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    controller: _discamt,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    controller: _texavalue,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    controller: _sgstamt,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    controller: _cgstamt,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    controller: _igstamt,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
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
