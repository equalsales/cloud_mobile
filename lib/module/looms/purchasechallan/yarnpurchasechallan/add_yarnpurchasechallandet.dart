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

class YarnJobworkReceiveDetAdd extends StatefulWidget {
  YarnJobworkReceiveDetAdd(
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
  _YarnJobworkReceiveDetAddState createState() => _YarnJobworkReceiveDetAddState();
}

class _YarnJobworkReceiveDetAddState extends State<YarnJobworkReceiveDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController();
  TextEditingController _orderchr = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _grade = new TextEditingController();
  TextEditingController _lotno = new TextEditingController();
  TextEditingController _cops = new TextEditingController(text: '0');
  TextEditingController _totcrtn = new TextEditingController(text: '0');
  TextEditingController _actnetwt = new TextEditingController(text: '0.000');
  TextEditingController _netwt = new TextEditingController(text: '0.000');
  TextEditingController _cone = new TextEditingController(text: '0');
  TextEditingController _rate = new TextEditingController(text: '0.00');
  TextEditingController _amount = new TextEditingController(text: '0.00');
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _ordid = new TextEditingController(text: '0');
  TextEditingController _orddetid = new TextEditingController(text: '0');
  TextEditingController _discrate = new TextEditingController(text: '0.00');
  TextEditingController _discamt= new TextEditingController(text: '0.00');
  TextEditingController _addamt = new TextEditingController(text: '0.00');
  TextEditingController _texavalue = new TextEditingController(text: '0.00');
  TextEditingController _sgstrate= new TextEditingController(text: '0.00');
  TextEditingController _sgstamt= new TextEditingController(text: '0.00');
  TextEditingController _cgstrate= new TextEditingController(text: '0.00');
  TextEditingController _cgstamt= new TextEditingController(text: '0.00');
  TextEditingController _igstrate = new TextEditingController(text: '0.00');
  TextEditingController _igstamt = new TextEditingController(text: '0.00');
  TextEditingController _finalamt = new TextEditingController(text: '0.00');

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
    //     _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
    //     dropdownUnitType = ItemDetails[length - 1]['unit'].toString();
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
    var orderno = _orderno.text;
    var orderchr = _orderchr.text;
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
        if ((ItemDetails[iCtr]['takano'] == orderno) &&
            ((ItemDetails[iCtr]['takachr'] == orderchr))) {
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
            orderchr +
            '&takano=' +
            orderno +
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
                          _orderchr.text = _jsonData[index]['takachr'].toString();
                          _orderno.text = _jsonData[index]['takano'].toString();
                          _itemname.text = _jsonData[index]['itemname'].toString();
                          _hsncode.text = _jsonData[index]['hsncode'].toString();
                          setState(() {
                            dropdownUnitType = _jsonData[index]['unit'].toString();
                          });
                          _fmode.text = _jsonData[index]['fmode'].toString();
                          _netwt.text = _jsonData[index]['netwt'].toString();
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
        _hsncode.text = jsonData[0]['hsncode'].toString();
        setState(() {
          dropdownUnitType = jsonData[0]['unit'].toString();
        });
        _fmode.text = jsonData[0]['fmode'].toString();
        _netwt.text = jsonData[0]['netwt'].toString();
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

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var orderchr = _orderchr.text;
      var orderno = _orderno.text;
      var itemname = _itemname.text;
      var hsncode = _hsncode.text;
      var grade = _grade.text;
      var lotno = _lotno.text;
      var cops = _cops.text;
      var totcrtn = _totcrtn.text;
      var actnetwt = _actnetwt.text;
      var netwt = _netwt.text;
      var cone = _cone.text;
      var rate = _rate.text;
      var unit = dropdownUnitType;
      var amount = _amount.text;
      var fmode = _fmode.text;
      var ordid = _ordid.text;
      var orddetid = _orddetid.text;
      var discrate = _discrate.text;
      var discamt = _discamt.text;
      var addamt = _addamt.text;
      var texavalue = _texavalue.text;
      var sgstrate = _sgstrate.text;
      var sgstamt = _sgstamt.text;
      var cgstrate = _cgstrate.text;
      var cgstamt = _cgstamt.text;
      var igstrate = _igstrate.text;
      var igstamt = _igstamt.text;
      var finalamt = _finalamt.text;
  
      print(_orderno.text);

      widget.xitemDet.add({
        'orderno': orderno,
        'orderchr': orderchr,
        'itemname': itemname,
        'hsncode': hsncode,
        'grade': grade,
        'lotno': lotno,
        'cops': cops,
        'totcrtn': totcrtn,
        'actnetwt': actnetwt,
        'netwt': netwt,
        'cone': cone,
        'rate': rate,
        'unit': unit,
        'amount': amount,
        'fmode': fmode,
        'ordid': ordid,
        'orddetid': orddetid,
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


    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yarn Purchase Challan Details[ ] ',
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
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Orderno',
                      labelText: 'Orderno',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _orderchr,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter Orderchr ',
                      labelText: 'Orderchr',
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
                    enabled: true,
                    controller: _hsncode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'HSNCode',
                      labelText: 'HSNCode',
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
                    controller: _grade,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Grade',
                      labelText: 'Grade',
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
                    enabled: true,
                    controller: _lotno,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'LotNo',
                      labelText: 'LotNo',
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
                    enabled: true,
                    controller: _cops,
                    keyboardType: TextInputType.number,
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
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _totcrtn,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Totcrtn',
                      labelText: 'Totcrtn',
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
                    enabled: true,
                    controller: _actnetwt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Actnetwt',
                      labelText: 'Actnetwt',
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
                    enabled: true,
                    controller: _netwt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Netwt',
                      labelText: 'Netwt',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      if (value == '' || 
                      value == '0' || 
                      value == '0.' || 
                      value == '0.0' || 
                      value == '0.00' || 
                      value == '0.000')
                      {
                        return 'Please enter netwt';
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
                    controller: _cone,
                    keyboardType: TextInputType.number,
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
                    enabled: true,
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
                    controller: _rate,
                    enabled: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      if (value == '' || 
                      value == '0' || 
                      value == '0.' || 
                      value == '0.0' || 
                      value == '0.00')
                      {
                        return 'Please enter rate';
                      }
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
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter unit';
                        }
                        return null;
                      },
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
                    controller: _ordid,
                    enabled: true,
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
