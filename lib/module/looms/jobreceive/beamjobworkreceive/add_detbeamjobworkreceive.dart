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

class BeamJobworkReceiveDetAdd extends StatefulWidget {
  BeamJobworkReceiveDetAdd(
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
  _BeamJobworkReceiveDetAddState createState() => _BeamJobworkReceiveDetAddState();
}

class _BeamJobworkReceiveDetAddState extends State<BeamJobworkReceiveDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _orderno = new TextEditingController();
  TextEditingController _issno = new TextEditingController();
  TextEditingController _isschr = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _beamchr = new TextEditingController();
  TextEditingController _taka = new TextEditingController();
  TextEditingController _itemid = new TextEditingController();
  TextEditingController _meters = new TextEditingController();
  TextEditingController _ends = new TextEditingController();
  TextEditingController _pipeno = new TextEditingController();
  TextEditingController _weight = new TextEditingController();
  TextEditingController _shtwt = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _actwt = new TextEditingController();
  TextEditingController _actmeters = new TextEditingController();
  TextEditingController _lnkid = new TextEditingController();
  TextEditingController _lnkdetid = new TextEditingController();
  TextEditingController _lnkdettkid = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();
  TextEditingController _beamid = new TextEditingController();
  TextEditingController _creelno = new TextEditingController();
  TextEditingController _machine = new TextEditingController();
  TextEditingController _cone = new TextEditingController();

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
        // _folddate.text = ItemDetails[length - 1]['folddate'].toString();
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

      // _orderno.text = selOrder;

      print('dhruv');
      print(result);
      setState(() {
        // _folddate.text = result[0]['date'];
        // _itemname.text = result[0]['itemname'];
        // _rate.text = result[0]['rate'];
        // _ordid.text = result[0]['ordid'].toString();
        // _orddetid.text = result[0]['orddetid'].toString();
        // ordMeters = double.parse(result[0]['balmeters'].toString());
        // _ordbalmtrs.text = result[0]['balmeters'].toString();
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
    // var takano = _takano.text;
    // var takachr = _takachr.text;
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
        // if ((ItemDetails[iCtr]['takano'] == takano) &&
        //     ((ItemDetails[iCtr]['takachr'] == takachr))) {
        //   showAlertDialog(context, 'Taka No Already Exists...');
        //   setState(() {
        //     _takano.text = '0';
        //     _takachr.text = '';
        //   });
        //   return true;
        // }
      }
    }

    uri =
        '${globals.cdomain}/api/commonapi_gettakastock2?dbname=' +
            db +
            '&partyfilter=N&takachr=' +
            // takachr +
            '&takano=' +
            // takano +
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
                          // _takachr.text = _jsonData[index]['takachr'].toString();
                          // _takano.text = _jsonData[index]['takano'].toString();
                          // _folddate.text = _jsonData[index]['date'].toString();
                          // _itemname.text = _jsonData[index]['itemname'].toString();
                          // _hsncode.text = _jsonData[index]['hsncode'].toString();
                          setState(() {
                            dropdownUnitType = _jsonData[index]['unit'].toString();
                          });
                          _fmode.text = _jsonData[index]['fmode'].toString();
                          // _netwt.text = _jsonData[index]['netwt'].toString();
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
        // _takachr.text = _jsonData[0]['takachr'].toString();
        // _takano.text = _jsonData[0]['takano'].toString();
        // _itemname.text = jsonData[0]['itemname'].toString();
        // _folddate.text = jsonData[0]['date'].toString();
        // _hsncode.text = jsonData[0]['hsncode'].toString();
        setState(() {
          dropdownUnitType = jsonData[0]['unit'].toString();
        });
        _fmode.text = jsonData[0]['fmode'].toString();
        // _netwt.text = jsonData[0]['netwt'].toString();
      });
      Navigator.pop(context);
    }
    return true;
  }

  Future<void> barcodeScan() async {
    String barcodeScanRes;
    try {

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#000000', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      print(barcodeScanRes);

      final splitted = barcodeScanRes.split('-');
      print(splitted); // [Hello, world!];
      print(splitted.length);
      print('dhruv');
      // _takachr.text = splitted[0];
      // if (splitted.length > 1) {
      //   _takano.text = splitted[1];
      // } else {
      //   _takano.text = '0';
      // }

      fetchdetails();
    });
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      var issno = _issno.text;
      var isschr = _isschr.text;
      var beamno = _beamno.text;
      var beamchr = _beamchr.text;
      var taka = _taka.text;
      var itemid = _itemid.text;
      var meters = _meters.text;
      var ends = _ends.text;
      var pipeno = _pipeno.text;
      var weight = _weight.text;
      var shtwt = _shtwt.text;
      var rate = _rate.text;
      var amount = _amount.text;
      var actwt = _actwt.text;
      var actmtrs = _actmeters.text;
      var lnkid = _lnkid.text;
      var lnkdetid = _lnkdetid.text;
      var lnkdettkid = _lnkdettkid.text;
      var fmode = _fmode.text;
      var beamid = _beamid.text;
      var creelno = _creelno.text;
      var machine = _machine.text;
      var cone = _cone.text;
  
      widget.xitemDet.add({
        'issno': issno,
        'isschr': isschr,
        'beamno': beamno,
        'beamchr': beamchr,
        'taka': taka,
        'itemid': itemid,
        'meters': meters,
        'ends': ends,
        'pipeno': pipeno,
        'weight': weight,
        'shtwt': shtwt,
        'rate': rate,
        'amount': amount,
        'actwt': actwt,
        'actmtrs': actmtrs,
        'lnkid': lnkid,
        'lnkdetid': lnkdetid,
        'lnkdettkid': lnkdettkid,
        'fmode': fmode,
        'beamid': beamid,
        'creelno': creelno,
        'sgstrate': machine,
        'cone': cone,
      });

      Navigator.pop(context, widget.xitemDet);

      return true;
    }


    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beam Jobwork Receive Details[ ] ',
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
      // body: SingleChildScrollView(
      //     child: Form(
      //   key: _formKey,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _orderno,
      //               autofocus: true,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Select Sales Order',
      //                 labelText: 'Order No',
      //               ),
      //               onTap: () {
      //                 gotoOrderScreen(context);
      //               },
      //               onChanged: (value) {},
      //               validator: (value) {
      //                 if (value == ' ') {
      //                 } 
      //                   return 'Please enter order no';
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               controller: _folddate,
      //               enabled: false,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Fold Date',
      //                 labelText: 'Fold Date',
      //               ),
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               controller: _ordbalmtrs,
      //               enabled: false,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Order Balance',
      //                 labelText: 'Order Balance',
      //               ),
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _takachr,
      //               autofocus: true,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Select Taka ',
      //                 labelText: 'Takachr',
      //               ),
      //               onChanged: (value) {
      //                 _takachr.value = TextEditingValue(
      //                     text: value.toUpperCase(),
      //                     selection: _takachr.selection);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               controller: _takano,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Select Taka No',
      //                 labelText: 'Taka No',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Padding(padding: EdgeInsets.all(2)),
      //           ElevatedButton(
      //             onPressed: () => {
      //               if (_formKey.currentState!.validate())
      //                 {
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     SnackBar(
      //                         content: Text('Form submitted successfully')),
      //                   ),
      //                   fetchdetails()
      //                 },
      //             },
      //             child: Text('Fetch Details',
      //                 style: TextStyle(
      //                     fontSize: 15.0, fontWeight: FontWeight.bold)),
      //           ),
      //           Padding(padding: EdgeInsets.all(2)),
      //           ElevatedButton(
      //             onPressed: () => {
      //               if (_formKey.currentState!.validate())
      //                 {
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     SnackBar(
      //                         content: Text('Form submitted successfully')),
      //                   ),
      //                   barcodeScan()
      //                 },
      //             },
      //             child: Text('Scan Barcode',
      //                 style: TextStyle(
      //                     fontSize: 15.0, fontWeight: FontWeight.bold)),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _itemname,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Item Name',
      //                 labelText: 'Item Name',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _hsncode,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'HSNCode',
      //                 labelText: 'HSNCode',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _grade,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Grade',
      //                 labelText: 'Grade',
      //               ),
      //               onTap: () {},
      //               onChanged: (value) {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _lotno,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'LotNo',
      //                 labelText: 'LotNo',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _cops,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Cops',
      //                 labelText: 'Cops',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _totcrtn,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Totcrtn',
      //                 labelText: 'Totcrtn',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _actnetwt,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Actnetwt',
      //                 labelText: 'Actnetwt',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _netwt,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Netwt',
      //                 labelText: 'Netwt',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _cone,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Cone',
      //                 labelText: 'Cone',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _fmode,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Fmode',
      //                 labelText: 'Fmode',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _rate,
      //               enabled: false,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Rate',
      //                 labelText: 'Rate',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: DropdownButtonFormField(
      //                 value: dropdownUnitType,
      //                 decoration: const InputDecoration(
      //                   labelText: 'Unit',
      //                   hintText: "Unit",
      //                   icon: const Icon(Icons.person),
      //                 ),
      //                 items: UnitType.map((String items) {
      //                   return DropdownMenuItem(
      //                     value: items,
      //                     child: Text(items),
      //                   );
      //                 }).toList(),
      //                 icon: const Icon(Icons.arrow_drop_down_circle),
      //                 onChanged: (String? newValue) {
      //                   setState(() {
      //                     dropdownUnitType = newValue!;
      //                   });
      //                 }),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _amount,
      //               enabled: false,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'Amount',
      //                 labelText: 'Amount',
      //               ),
      //               onTap: () {
      //                 //gotoBranchScreen(context);
      //               },
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _ordid,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'OrdId',
      //                 labelText: 'OrdId',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _orddetid,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'OrdDetId',
      //                 labelText: 'OrdDetId',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _discrate,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'DiscRate',
      //                 labelText: 'DiscRate',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _discamt,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'DiscAmt',
      //                 labelText: 'DiscAmt',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _addamt,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'AddAmt',
      //                 labelText: 'AddAmt',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _texavalue,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'TexableValue',
      //                 labelText: 'TexableValue',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _sgstrate,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'SGSTRate',
      //                 labelText: 'SGSTRate',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _sgstamt,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'SGSTAmt',
      //                 labelText: 'SGSTAmt',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //        Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _cgstrate,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'CGSTRate',
      //                 labelText: 'CGSTRate',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _cgstamt,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'CGSTAmt',
      //                 labelText: 'CGSTAmt',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _igstrate,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'IGSTRate',
      //                 labelText: 'IGSTRate',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               enabled: false,
      //               controller: _igstamt,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'IGSTAmt',
      //                 labelText: 'IGSTAmt',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           )
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               controller: _finalamt,
      //               enabled: false,
      //               keyboardType: TextInputType.number,
      //               decoration: const InputDecoration(
      //                 icon: const Icon(Icons.person),
      //                 hintText: 'FinalAmt',
      //                 labelText: 'FinalAmt',
      //               ),
      //               onTap: () {},
      //               validator: (value) {
      //                 return null;
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 30,
      //       )
      //     ],
      //   ),
      // )),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
