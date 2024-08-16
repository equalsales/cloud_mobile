// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:convert';
import 'package:cloud_mobile/list/design_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DyegreyJobworkReceivedDetAdd extends StatefulWidget {
  DyegreyJobworkReceivedDetAdd(
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
  _DyegreyJobworkReceivedDetAddState createState() =>
      _DyegreyJobworkReceivedDetAddState();
}

class _DyegreyJobworkReceivedDetAddState
    extends State<DyegreyJobworkReceivedDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _issno = new TextEditingController();
  TextEditingController _isschr = new TextEditingController();
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _takaPcs = new TextEditingController();
  TextEditingController _issmtr = new TextEditingController();
  TextEditingController _meters = new TextEditingController();
  TextEditingController _foldmtr = new TextEditingController();
  TextEditingController _tpmtrs = new TextEditingController();
  TextEditingController _shtmtrs = new TextEditingController();
  TextEditingController _shtPer = new TextEditingController();
  TextEditingController _design = new TextEditingController();
  TextEditingController _beamItem = new TextEditingController();
  TextEditingController _beamNo = new TextEditingController();
  TextEditingController _netWt = new TextEditingController();
  TextEditingController _avgWt = new TextEditingController();


  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _jsonData = [];

  String? dropdownUnitType;

  var UnitType = ['P', 'C', 'W', 'M'];

  @override
  void initState() {
    super.initState();
    // fromDate = retconvdate(widget.xfbeg);
    // toDate = retconvdate(widget.xfend);

    // var curDate = getsystemdate();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      setState(() {
        // _issno.text = ItemDetails[length - 1]['orderno'].toString();
        // _isschr.text = ItemDetails[length - 1]['orderno'].toString();
        // _takachr.text = ItemDetails[length - 1]['orderno'].toString();
        // _takano.text = ItemDetails[length - 1]['orderno'].toString();
        // _itemname.text = ItemDetails[length - 1]['orderno'].toString();
        // _takaPcs.text = ItemDetails[length - 1]['orderno'].toString();
        // _issmtr.text = ItemDetails[length - 1]['orderno'].toString();
        // _meters.text = ItemDetails[length - 1]['orderno'].toString();
        // _foldmtr.text = ItemDetails[length - 1]['orderno'].toString();
        // _tpmtrs.text = ItemDetails[length - 1]['orderno'].toString();
        // _shtmtrs.text = ItemDetails[length - 1]['orderno'].toString();
        // _shtPer.text = ItemDetails[length - 1]['orderno'].toString();
        // _design.text = ItemDetails[length - 1]['orderno'].toString();
        // _beamItem.text = ItemDetails[length - 1]['orderno'].toString();
        // _beamNo.text = ItemDetails[length - 1]['orderno'].toString();
        // _netWt.text = ItemDetails[length - 1]['orderno'].toString();
        // _avgWt.text = ItemDetails[length - 1]['orderno'].toString();
        // dropdownUnitType = ItemDetails[length - 1]['unit'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dyegrey Jobwork Received Details [ ] ',
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _issno,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Issno',
                        labelText: 'Issno',
                      ),
                      onChanged: (value) {
                        _takachr.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: _takachr.selection);
                      },
                      validator: (value) {
                        if (value == '' || value == '0') {
                          return 'Please enter issno';
                        } 
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _isschr,
                      // keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Iss Chr',
                        labelText: 'Iss Chr',
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
              // TextFormField(
              //   controller: isschr,
              //   autofocus: true,
              //   decoration: const InputDecoration(
              //     icon: const Icon(Icons.person),
              //     hintText: 'Enter Iss Chr',
              //     labelText: 'Enter Iss Chr',
              //   ),
              //   onTap: () {},
              //   validator: (value) {
              //     return null;
              //   },
              // ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _takachr,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Select Taka Chr',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                    child: ElevatedButton(
                        onPressed: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Form submitted successfully'))),
                                  // fetchdetails()
                                },
                            },
                        child: Text('Fetch Details',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                    child: ElevatedButton(
                        onPressed: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Form submitted successfully'))),
                                  // barcodeScan()
                                },
                            },
                        child: Text('Scan Barcode',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
              TextFormField(
                controller: _itemname,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Select Itemname',
                  labelText: 'Itemname',
                ),
                onTap: () {
                  gotoItemnameScreen(context);
                },
                validator: (value) {
                  if (value == '') {
                    return "Please enter Itemname";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _takaPcs,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Taka/Pcs',
                        labelText: 'Taka/Pcs',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _issmtr,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Iss Meters',
                        labelText: 'Iss Meters',
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
                      controller: _meters,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Meters',
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
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _foldmtr,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Fold Meters',
                        labelText: 'Fold Meters',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _tpmtrs,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Tp Meters',
                        labelText: 'Tp Meters',
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
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Sht Meters',
                        labelText: 'Sht Meters',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _shtPer,
                      autofocus: true,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Sht %',
                        labelText: 'Sht %',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField(
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
              TextFormField(
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
                  if (value == null || value.isEmpty) {
                    return "Please select Design";
                  }
                  return null;
                },
              ),
              TextFormField(
                enabled: true,
                controller: _beamItem,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter Beam Item',
                  labelText: 'Beam Item',
                ),
                onTap: () {
                  //gotoBranchScreen(context);
                },
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: _beamNo,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter Beam No',
                  labelText: 'Beam No',
                ),
                onTap: () {},
                validator: (value) {
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _netWt,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Net Wt',
                        labelText: 'Net Wt',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _avgWt,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Avg Wt',
                        labelText: 'Avg Wt',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     //..
              //     Expanded(
              //       child: TextFormField(
              //         controller: issno,
              //         autofocus: true,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Enter Issno',
              //           labelText: 'Issno',
              //         ),
              //         onTap: () {
              //           // gotoOrderScreen(context);
              //         },
              //         onChanged: (value) {},
              //         validator: (value) {
              //           print(widget.xtype);
              //           // if (widget.xtype == 'PACKING') {
              //           // } else if ('Delivery' == widget.xtype ||
              //           //     value == '0' ||
              //           //     value == '') {
              //           //   return 'Please enter order no';
              //           // }
              //           // if (value == null ||
              //           //     value.isEmpty ||
              //           //     value == "0" ||
              //           //     'Delivery' == widget.xtype) {
              //           //   return 'Please enter order no';
              //           // }
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
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _itemname,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Item Name',
              //           labelText: 'Item Name',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _hsncode,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'HSNCode',
              //           labelText: 'HSNCode',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _grade,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Grade',
              //           labelText: 'Grade',
              //         ),
              //         onTap: () {},
              //         onChanged: (value) {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _lotno,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'LotNo',
              //           labelText: 'LotNo',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _cops,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Cops',
              //           labelText: 'Cops',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _totcrtn,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Totcrtn',
              //           labelText: 'Totcrtn',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _actnetwt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Actnetwt',
              //           labelText: 'Actnetwt',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _netwt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Netwt',
              //           labelText: 'Netwt',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _cone,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Cone',
              //           labelText: 'Cone',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _fmode,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Fmode',
              //           labelText: 'Fmode',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _rate,
              //         enabled: false,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Rate',
              //           labelText: 'Rate',
              //         ),
              //         onTap: () {
              //           //gotoBranchScreen(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: DropdownButtonFormField(
              //           value: dropdownUnitType,
              //           decoration: const InputDecoration(
              //             labelText: 'Unit',
              //             hintText: "Unit",
              //             icon: const Icon(Icons.person),
              //           ),
              //           items: UnitType.map((String items) {
              //             return DropdownMenuItem(
              //               value: items,
              //               child: Text(items),
              //             );
              //           }).toList(),
              //           icon: const Icon(Icons.arrow_drop_down_circle),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               dropdownUnitType = newValue!;
              //             });
              //           }),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _amount,
              //         enabled: false,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Amount',
              //           labelText: 'Amount',
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
              //     Expanded(
              //       child: TextFormField(
              //         controller: _ordid,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'OrdId',
              //           labelText: 'OrdId',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _orddetid,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'OrdDetId',
              //           labelText: 'OrdDetId',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _discrate,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'DiscRate',
              //           labelText: 'DiscRate',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _discamt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'DiscAmt',
              //           labelText: 'DiscAmt',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _addamt,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'AddAmt',
              //           labelText: 'AddAmt',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _texavalue,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'TexableValue',
              //           labelText: 'TexableValue',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _sgstrate,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'SGSTRate',
              //           labelText: 'SGSTRate',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _sgstamt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'SGSTAmt',
              //           labelText: 'SGSTAmt',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _cgstrate,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'CGSTRate',
              //           labelText: 'CGSTRate',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _cgstamt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'CGSTAmt',
              //           labelText: 'CGSTAmt',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _igstrate,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'IGSTRate',
              //           labelText: 'IGSTRate',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: TextFormField(
              //         enabled: false,
              //         controller: _igstamt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'IGSTAmt',
              //           labelText: 'IGSTAmt',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         controller: _finalamt,
              //         enabled: false,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'FinalAmt',
              //           labelText: 'FinalAmt',
              //         ),
              //         onTap: () {},
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      )),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }

  Future<bool> saveData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var username = globals.username;

    // var folddate = _folddate.text;
    // var ordbalmtrs = _ordbalmtrs.text;

    // var orderno = _issno.text;
    // var ctakano = _ctakano.text;
    // var hsncode = _hsncode.text;
    // var grade = _grade.text;
    // var lotno = _lotno.text;
    // var cops = _cops.text;

    var issno = _issno.text;
    var isschr = _isschr.text;
    var takachr = _takachr.text;
    var takano = _takano.text;
    var itemname = _itemname.text;
    var unit = dropdownUnitType;
    var takaPcs = _takaPcs.text;
    var issmtr = _issmtr.text;
    var meters = _meters.text;
    var foldmtr = _foldmtr.text;
    var tpmtrs = _tpmtrs.text;
    var shtmtrs = _shtmtrs.text;
    var shtPer = _shtPer.text;
    var design = _design.text;
    var beamItem = _beamItem.text;
    var beamNo = _beamNo.text;
    var netWt = _netWt.text;
    var avgWt = _avgWt.text;

    // var igstrate = _igstrate.text;
    // var igstamt = _igstamt.text;
    // var finalamt = _finalamt.text;

    print(_issno.text);

    widget.xitemDet.add({
      "issno": issno,
      "isschr": isschr,
      "takachr": takachr,
      "takano": takano,
      "itemname": itemname,
      "unit": unit,
      "takaPcs": takaPcs,
      "issmtr": issmtr,
      "meters": meters,
      "foldmtr": foldmtr,
      "tpmtrs": tpmtrs,
      "shtmtrs": shtmtrs,
      "shtPer": shtPer,
      "design": design,
      "beamItem": beamItem,
      "beamNo": beamNo,
      "netWt": netWt,
      "avgWt": avgWt,
      // '': orderno,
      // 'takachr': takachr,
      // 'takano': takano,
      // 'ordbalmtrs': ordbalmtrs,
      // 'folddate': folddate,
      // 'itemname': itemname,
      // 'hsncode': hsncode,
      // 'grade': grade,
      // 'loordernotno': lotno,
      // 'cops': cops,
      // 'totcrtn': totcrtn,
      // 'actnetwt': actnetwt,
      // 'netwt': netwt,
      // 'cone': cone,
      // 'rate': rate,
      // 'unit': unit,
      // 'amount': amount,
      // 'fmode': fmode,
      // 'orditem': itemname,
      // 'ordid': ordid,
      // 'orddetid': orddetid,
      // 'discrate': discrate,
      // 'discamt': discamt,
      // 'addamt': addamt,
      // 'texavalue': texavalue,
      // 'sgstrate': sgstrate,
      // 'sgstamt': sgstamt,
      // 'cgstrate': cgstrate,
      // 'cgstamt': cgstamt,
      // 'igstrate': igstrate,
      // 'igstamt': igstamt,
      // 'finalamt': finalamt,
    });

    Navigator.pop(context, widget.xitemDet);

    return true;
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

      var _orderlist = result[1];
      result = result[1];
      var orderid = _orderlist[0];

      var selOrder = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selOrder = selOrder + ',';
        }
        selOrder = selOrder + retResult[0][ictr];
      }

      _issno.text = selOrder;

      setState(() {
        // _folddate.text = result[0]['date'];
        // itemanme.text = result[0]['itemname'];
        // _rate.text = result[0]['rate'];
        // _ordid.text = result[0]['ordid'].toString();
        // _orddetid.text = result[0]['orddetid'].toString();
        // ordMeters = double.parse(result[0]['balmeters'].toString());
        // _ordbalmtrs.text = result[0]['balmeters'].toString();
      });
    });
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
      setState(() {
        _itemname.text = newResult[0]['itemname'].toString();
      });
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

    uri = '${globals.cdomain}/api/commonapi_gettakastock2?dbname=' +
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
                          _takachr.text =
                              _jsonData[index]['takachr'].toString();
                          _takano.text = _jsonData[index]['takano'].toString();
                          // _folddate.text = _jsonData[index]['date'].toString();
                          // itemanme.text =
                          //     _jsonData[index]['itemname'].toString();
                          // _hsncode.text =
                          //     _jsonData[index]['hsncode'].toString();
                          setState(() {
                            dropdownUnitType =
                                _jsonData[index]['unit'].toString();
                          });
                          // _fmode.text = _jsonData[index]['fmode'].toString();
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
        _takachr.text = _jsonData[0]['takachr'].toString();
        _takano.text = _jsonData[0]['takano'].toString();
        // itemanme.text = jsonData[0]['itemname'].toString();
        // _folddate.text = jsonData[0]['date'].toString();
        // _hsncode.text = jsonData[0]['hsncode'].toString();
        setState(() {
          dropdownUnitType = jsonData[0]['unit'].toString();
        });
        // _fmode.text = jsonData[0]['fmode'].toString();
        // _netwt.text = jsonData[0]['netwt'].toString();
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

  void setDefValue() {}
}
