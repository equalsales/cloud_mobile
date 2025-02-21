// ignore_for_file: must_be_immutable

import 'package:cloud_mobile/list/design_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/machine_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';

class SaleOrderDetAdd extends StatefulWidget {
  SaleOrderDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      itemDet,
      id,})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xItemDetails = itemDet;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _SaleOrderDetAddState createState() => _SaleOrderDetAddState();
}

class _SaleOrderDetAddState extends State<SaleOrderDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _itemname = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _design = new TextEditingController();
  TextEditingController _pcs = new TextEditingController(text: '0');
  TextEditingController _meters = new TextEditingController(text: '0.00');
  TextEditingController _rate = new TextEditingController(text: '0.00');
  TextEditingController _amount = new TextEditingController(text: '0');
  TextEditingController _discPer1 = new TextEditingController(text: '0.00');
  TextEditingController _discAmt1 = new TextEditingController(text: '0.00');
  TextEditingController _addAmt1 = new TextEditingController(text: '0.00');
  TextEditingController _taxableValue = new TextEditingController(text: '0.00');
  TextEditingController _sgstRate = new TextEditingController(text: '0.00');
  TextEditingController _sgstAmt = new TextEditingController(text: '0.00');
  TextEditingController _cgstRate = new TextEditingController(text: '0.00');
  TextEditingController _cgstAmt = new TextEditingController(text: '0.00');
  TextEditingController _igstRate = new TextEditingController(text: '0.00');
  TextEditingController _igstAmt = new TextEditingController(text: '0.00');
  TextEditingController _finalAmt = new TextEditingController(text: '0.00');

  final _formKey = GlobalKey<FormState>();

  String? dropdownUnitType;

  var UnitType = [
    ''
    'P',
    'C',
    'W',
    'M',
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
    //     _itemname.text = ItemDetails[length - 1]['itemname'].toString();
    //     _design.text = ItemDetails[length - 1]['design'].toString();
    //     _unit.text = ItemDetails[length - 1]['unit'].toString();
    //     _rate.text = ItemDetails[length - 1]['rate'].toString();
      // });
    // }

    //_date.text = curDate.toString().split(' ')[0];

    // if (int.parse(widget.xid) > 0) {
    //   //loadData();
    // }
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
  
  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;

      var itemname = _itemname.text;
      var hsncode = _hsncode.text;
      var design = _design.text;
      var pcs = _pcs.text;
      var meters = _meters.text;
      var rate = _rate.text;
      var unit = dropdownUnitType;
      var amount = _amount.text;
      var discPer1 = _discPer1.text;
      var discAmt1 = _discAmt1.text;
      var addAmt1 = _addAmt1.text;
      var taxableValue = _taxableValue.text;
      var sgstRate = _sgstRate.text;
      var sgstAmt = _sgstAmt.text;
      var cgstRate = _cgstRate.text;
      var cgstAmt = _cgstAmt.text;
      var igstRate = _igstRate.text;
      var igstAmt = _igstAmt.text;
      var finalAmt = _finalAmt.text;

      widget.xitemDet.add({
        'itemname': itemname,
        'hsncode': hsncode,
        'design': design,
        'pcs': pcs,
        'meters': meters,
        'rate': rate,
        'unit': unit,
        'amount': amount,
        'discPer1': discPer1,
        'discAmt1': discAmt1,
        'addAmt1': addAmt1,
        'taxableValue': taxableValue,
        'sgstRate': sgstRate,
        'sgstAmt': sgstAmt,
        'cgstRate': cgstRate,
        'cgstAmt': cgstAmt,
        'igstRate': igstRate,
        'igstAmt': igstAmt,
        'finalAmt': finalAmt,

      });
      Navigator.pop(context, widget.xitemDet);
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sale Order [ ] ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {
            if(_formKey.currentState!.validate()){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Form submitted successfully')),
              ),
              saveData()
            }
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
                    enabled: false,
                    controller: _itemname,
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
              ],
            ),
            Row(
              children: [
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
                ),
                Expanded(
                  child: TextFormField(
                    enabled: true,
                    controller: _design,
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
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pcs / Taka',
                      labelText: 'Pcs',
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
                    controller: _meters,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Meters',
                      labelText: 'Meters',
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
                    controller: _discPer1,
                    enabled: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'DiscPer1',
                      labelText: 'DiscPer1',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _discAmt1,
                    enabled: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'DiscAmt1',
                      labelText: 'DiscAmt1',
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
                    controller: _addAmt1,
                    enabled: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'AddAmt1',
                      labelText: 'AddAmt1',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _taxableValue,
                    enabled: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'TaxableValue',
                      labelText: 'TaxableValue',
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
                    controller: _sgstRate,
                    enabled: true,
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
                    controller: _sgstAmt,
                    enabled: true,
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
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cgstRate,
                    enabled: true,
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
                    controller: _cgstAmt,
                    enabled: true,
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
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _igstRate,
                    enabled: true,
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
                    controller: _igstAmt,
                    enabled: true,
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
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _finalAmt,
                    enabled: true,
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
              height: 20,
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
