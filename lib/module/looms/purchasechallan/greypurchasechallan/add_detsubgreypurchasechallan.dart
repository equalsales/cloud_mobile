// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';

class GreyPurchaseChallanSubDetAdd extends StatefulWidget {
  GreyPurchaseChallanSubDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      subitemDet,
      id,})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xSubItemDetails = subitemDet;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  List xsubitemDet = [];
  List xSubItemDetails = [];

  @override
  _GreyPurchaseChallanSubDetAddState createState() => _GreyPurchaseChallanSubDetAddState();
}

class _GreyPurchaseChallanSubDetAddState extends State<GreyPurchaseChallanSubDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
   
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController(text: '0');
  TextEditingController _meters = new TextEditingController(text: '0.00');
  TextEditingController _foldmtrs = new TextEditingController(text: '0');
  TextEditingController _diffmtrs = new TextEditingController(text: '0.00');
  TextEditingController _shtperc = new TextEditingController(text: '0.00');
  TextEditingController _tpmtrs = new TextEditingController();
  TextEditingController _weight = new TextEditingController(text: '0.000');
  TextEditingController _avgwt = new TextEditingController(text: '0.000');
  
  final _formKey = GlobalKey<FormState>();

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

    List ItemDetails = widget.xSubItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var takno = _takano.text;
      var takachr = _takachr.text;
      var meters = _meters.text;
      var foldmtrs = _foldmtrs.text;
      var diffmtrs = _diffmtrs.text;
      var shtperc = _shtperc.text;
      var tpmtrs = _tpmtrs.text;
      var weight = _weight.text;
      var avgwt = _avgwt.text;

      widget.xsubitemDet.add({
        'takno': takno,
        'takachr': takachr,
        'meters': meters,
        'foldmtrs': foldmtrs,
        'diffmtrs': diffmtrs,
        'shtperc': shtperc,
        'tpmtrs': tpmtrs,
        'weight': weight,
        'avgwt': avgwt,
      });

      Navigator.pop(context, widget.xsubitemDet);

      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grey Purchase Challan Sub Details[ ] ',
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
                    controller: _takano,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Sales Taka No',
                      labelText: 'Taka No',
                    ),
                    onTap: () {},
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == '' || value == '0') {
                        return 'Please enter takano';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _takachr,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select TakaChr ',
                      labelText: 'TakaChr',
                    ),
                    onChanged: (value) {
                      _takachr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _takachr.selection);
                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter takachr';
                      }
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
                      if (value == '' || 
                      value == '0' || 
                      value == '0.' || 
                      value == '0.0' || 
                      value == '0.00')
                      {
                        return 'Please enter foldmtrs';
                      }
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
                    controller: _diffmtrs,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Diffmtrs',
                      labelText: 'Diffmtrs',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _shtperc,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Shtperc',
                      labelText: 'Shtperc',
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
                    controller: _tpmtrs,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Tpmtrs',
                      labelText: 'Tpmtrs',
                    ),
                    onTap: () {},
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter tpmtrs';
                      }
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
                    controller: _weight,
                    enabled: true,
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
                    controller: _avgwt,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Avgwt',
                      labelText: 'Avgwt',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                )
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
