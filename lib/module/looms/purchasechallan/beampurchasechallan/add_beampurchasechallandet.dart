// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cloud_mobile/list/item_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:http/http.dart' as http;

class BeamPurchaseChallanDetAdd extends StatefulWidget {
  BeamPurchaseChallanDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      partystate,
      itemDet,})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xpartystate = partystate;
    xItemDetails = itemDet;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xpartystate;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _BeamPurchaseChallanDetAddState createState() => _BeamPurchaseChallanDetAddState();
}

class _BeamPurchaseChallanDetAddState extends State<BeamPurchaseChallanDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _itemname = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _beamchr = new TextEditingController();
  TextEditingController _beamno = new TextEditingController(text: '0');
  TextEditingController _beammtrs = new TextEditingController(text: '0.00');  
  TextEditingController _beamwt = new TextEditingController(text: '0.00');
  TextEditingController _ends = new TextEditingController(text: '0.000');
  TextEditingController _rate = new TextEditingController(text: '0.00');
  TextEditingController _amount = new TextEditingController(text: '0.00');
  TextEditingController _fmode = new TextEditingController();
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

  String? dropdownUnitType;

  var UnitType = [
    'M',
    'W',
    'P',
    'C',
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
    if (length > 0) {
      setState(() {
        // _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        // _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
        // _unit.text = ItemDetails[length - 1]['unit'].toString();
      });
    }
  }

  Future<bool> loadgst() async {
    String uri = '';
    var companyid = globals.companyid;
    var clientid = globals.dbname;
    var companystate = globals.companystate;

    uri = '${globals.cdomain2}/api/api_gethsndet?dbname=$clientid&hsncode=${_hsncode.text}&rate=${_rate.text}&statename=${widget.xpartystate}&costatename=${companystate}';

    var response = await http.get(Uri.parse(uri));
    print(uri);

    var jsonData = jsonDecode(response.body);
    
    var data = jsonData;

    setState(() {
      _sgstrate.text = data['sgstrate'].toString();
      _cgstrate.text = data['cgstrate'].toString();
      _igstrate.text = data['igstrate'].toString();
      print(_sgstrate.text);
      print(_cgstrate.text);
      print(_igstrate.text);
    });

    return true;
  }
  
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
      // _itemname.text = selItemname;
      setState(() {
        _itemname.text = newResult[0]['itemname'].toString();
        _hsncode.text = newResult[0]['hsncode'].toString();
        dropdownUnitType = newResult[0]['unit'].toString();
        if(dropdownUnitType == 'null'){
          dropdownUnitType = 'P';
        }
        if(dropdownUnitType == ''){
          dropdownUnitType = 'P';
        }
      });
    });
  }
  
  void gstcalculate() {
    double rate = getValueN(_rate.text);
    double beammtrs = getValueN(_beammtrs.text);
    double beamwt = getValueN(_beamwt.text);
    double DiscRate = getValueN(_discrate.text);
    String unit = dropdownUnitType.toString();

    if (unit == 'W') {
      _amount.text = (rate * beamwt).toStringAsFixed(2);
    } else if (unit == 'M') {
      _amount.text = (rate * beammtrs).toStringAsFixed(2);
    } else if (unit == 'P'){
      _amount.text = '0';
    } else if (unit == 'C'){
      _amount.text = '0';
    }

    double amt = _amount.text == "" ? 0 : double.parse(_amount.text);

    if (DiscRate > 0) {
      _discamt.text = ((DiscRate * amt) / 100).toStringAsFixed(2);
    }

    double DiscAmt = _discamt.text == "" ? 0 : double.parse(_discamt.text);
    double AddAmt = _addamt.text == "" ? 0 : double.parse(_addamt.text);

    _texavalue.text = (amt - DiscAmt + AddAmt).toStringAsFixed(2);

    double taxable = getValueN(_texavalue.text);
    double sGstrate = getValueN(_sgstrate.text);
    double cGstrate = getValueN(_cgstrate.text);
    double iGstrate = getValueN(_igstrate.text);

    _sgstamt.text = ((taxable * sGstrate) / 100).toStringAsFixed(2);
    _cgstamt.text = ((taxable * cGstrate) / 100).toStringAsFixed(2);
    _igstamt.text = ((taxable * iGstrate) / 100).toStringAsFixed(2);

    double iGstAmt = getValueN(_igstamt.text);
    double cGstAmt = getValueN(_cgstamt.text);
    double sGstAmt = getValueN(_sgstamt.text);

    _finalamt.text = (taxable + sGstAmt + cGstAmt + iGstAmt).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
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
      var discrate = _discrate.text;
      var discamt = _discamt.text;
      var addamt = _addamt.text;
      var taxablevalue = _texavalue.text;
      var sgstrate = _sgstrate.text;
      var sgstamt = _sgstamt.text;
      var cgstrate = _sgstrate.text;
      var cgstamt = _sgstamt.text;
      var igstrate = _sgstrate.text;
      var igstamt = _sgstamt.text;
      var finalamt = _finalamt.text;

      widget.xitemDet.add({
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
        'discper': discrate,
        'discamt': discamt,
        'addamt': addamt,
        'taxablevalue': taxablevalue,
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
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         controller: _orderno,
            //         autofocus: true,
            //         decoration: const InputDecoration(
            //           icon: const Icon(Icons.person),
            //           hintText: 'Select Sales Order',
            //           labelText: 'Order No',
            //         ),
            //         onTap: () {
            //           gotoOrderScreen(context);
            //         },
            //         onChanged: (value) {},
            //         validator: (value) {
            //           print(widget.xtype);
            //           if (widget.xtype == 'PACKING') {
            //           } else if ('Delivery' == widget.xtype ||
            //               value == '0' ||
            //               value == '') {
            //             return 'Please enter order no';
            //           }
            //           return null;
            //         },
            //       ),
            //     ),
            //     Expanded(
            //       child: TextFormField(
            //         controller: _folddate,
            //         enabled: false,
            //         decoration: const InputDecoration(
            //           icon: const Icon(Icons.person),
            //           hintText: 'Fold Date',
            //           labelText: 'Fold Date',
            //         ),
            //         validator: (value) {
            //           return null;
            //         },
            //       ),
            //     ),
            //     Expanded(
            //       child: TextFormField(
            //         controller: _ordbalmtrs,
            //         enabled: false,
            //         decoration: const InputDecoration(
            //           icon: const Icon(Icons.person),
            //           hintText: 'Order Balance',
            //           labelText: 'Order Balance',
            //         ),
            //         validator: (value) {
            //           return null;
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         controller: _takachr,
            //         autofocus: true,
            //         decoration: const InputDecoration(
            //           icon: const Icon(Icons.person),
            //           hintText: 'Select Taka ',
            //           labelText: 'Takachr',
            //         ),
            //         onChanged: (value) {
            //           _takachr.value = TextEditingValue(
            //               text: value.toUpperCase(),
            //               selection: _takachr.selection);
            //         },
            //         validator: (value) {
            //           return null;
            //         },
            //       ),
            //     ),
            //     Expanded(
            //       child: TextFormField(
            //         controller: _takano,
            //         keyboardType: TextInputType.number,
            //         decoration: const InputDecoration(
            //           icon: const Icon(Icons.person),
            //           hintText: 'Select Taka No',
            //           labelText: 'Taka No',
            //         ),
            //         onTap: () {
            //           //gotoBranchScreen(context);
            //         },
            //         validator: (value) {
            //           return null;
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Padding(padding: EdgeInsets.all(2)),
            //     ElevatedButton(
            //       onPressed: () => {
            //         if (_formKey.currentState!.validate())
            //           {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                   content: Text('Form submitted successfully')),
            //             ),
            //             fetchdetails()
            //           },
            //       },
            //       child: Text('Fetch Details',
            //           style: TextStyle(
            //               fontSize: 15.0, fontWeight: FontWeight.bold)),
            //     ),
            //     Padding(padding: EdgeInsets.all(2)),
            //     ElevatedButton(
            //       onPressed: () => {
            //         if (_formKey.currentState!.validate())
            //           {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                   content: Text('Form submitted successfully')),
            //             ),
            //             barcodeScan()
            //           },
            //       },
            //       child: Text('Scan Barcode',
            //           style: TextStyle(
            //               fontSize: 15.0, fontWeight: FontWeight.bold)),
            //     ),
            //   ],
            // ),
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
                    controller: _hsncode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'HSN Code',
                      labelText: 'HSN Code',
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
                    enabled: true,
                    controller: _beamchr,
                    textInputAction: TextInputAction.next,
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
                    enabled: true,
                    controller: _beamno,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beamno',
                      labelText: 'Beamno',
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
                    enabled: true,
                    controller: _beammtrs,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beammtrs',
                      labelText: 'Beammtrs',
                    ),
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
                    },
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
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _beamwt,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beamwt',
                      labelText: 'Beamwt',
                    ),
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    validator: (value) {
                      if (value == '' || 
                      value == '0' || 
                      value == '0.' || 
                      value == '0.0' || 
                      value == '0.00') 
                      {
                        return 'Please enter Beamwt';
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
                    controller: _ends,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Ends',
                      labelText: 'Ends',
                    ),
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
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
                    textInputAction: TextInputAction.next,
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
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rate,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
                    ),
                    onTap: () {
                      setState(() {
                        loadgst();
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        loadgst();
                        gstcalculate();
                      });
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
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownUnitType = newValue!;
                          gstcalculate();
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
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
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
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'DiscRate',
                      labelText: 'DiscRate',
                    ),
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
                    },
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
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
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
                    controller: _addamt,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'AddAmt',
                      labelText: 'AddAmt',
                    ),
                    onTap: () {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        gstcalculate();
                      });
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
