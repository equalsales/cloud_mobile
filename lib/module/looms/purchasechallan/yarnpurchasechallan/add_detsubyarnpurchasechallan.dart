// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';

class YarnPurchaseChallanDetAdd extends StatefulWidget {
  YarnPurchaseChallanDetAdd(
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
  _YarnPurchaseChallanDetAddState createState() => _YarnPurchaseChallanDetAddState();
}

class _YarnPurchaseChallanDetAddState extends State<YarnPurchaseChallanDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
   
  TextEditingController _cartonchr = new TextEditingController();
  TextEditingController _cartonno = new TextEditingController(text: '0');
  TextEditingController _cone = new TextEditingController(text: '0');
  TextEditingController _netwt = new TextEditingController(text: '0.000');
  
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

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var cartonno = _cartonno.text;
      var cartonchr = _cartonchr.text;
      var cone = _cone.text;
      var netwt = _netwt.text;

      widget.xitemDet.add({
        'cartonno': cartonno,
        'cartonchr': cartonchr,
        'cone': cone,
        'netwt': netwt,
      });

      Navigator.pop(context, widget.xitemDet);

      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yarn Purchase Challan Sub Details[ ] ',
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
                    controller: _cartonno,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Carton No',
                      labelText: 'Carton No',
                    ),
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _cartonchr,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cartonchr ',
                      labelText: 'Cartonchr',
                    ),
                    onChanged: (value) {
                      _cartonchr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _cartonchr.selection);
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
                    controller: _cone,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cone',
                      labelText: 'Cone',
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _netwt,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Netwt',
                      labelText: 'Netwt',
                    ),
                    onTap: () {},
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter netwt';
                      }
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
