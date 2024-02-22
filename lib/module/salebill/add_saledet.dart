import 'dart:convert';

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/item_list2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;

class SaleBillDetAdd extends StatefulWidget {
  SaleBillDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partystate,
      itemDet,
      id,
      branchid})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xpartystate = partystate;
    xid = id;
    xbranchid = branchid;
    xItemDetails = itemDet;

    print('in Item Details');
    print(xbranch);
    print(xpartystate);
    print(xItemDetails);
    print(xbranchid);
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xbranch;
  var xbranchid;
  var xpartystate;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _SaleBillDetAddAddState createState() => _SaleBillDetAddAddState();
}

class _SaleBillDetAddAddState extends State<SaleBillDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _itemname = new TextEditingController();
  TextEditingController _hsncode = new TextEditingController();
  TextEditingController _meters = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _remark = new TextEditingController();
  TextEditingController _pcs = new TextEditingController();
  TextEditingController _cut = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _discrate = new TextEditingController();
  TextEditingController _discamt = new TextEditingController();
  TextEditingController _addamt = new TextEditingController();
  TextEditingController _taxablevalue = new TextEditingController();
  TextEditingController _sgstrate = new TextEditingController();
  TextEditingController _sgstamt = new TextEditingController();
  TextEditingController _cgstrate = new TextEditingController();
  TextEditingController _cgstamt = new TextEditingController();
  TextEditingController _igstrate = new TextEditingController();
  TextEditingController _igstamt = new TextEditingController();
  TextEditingController _finalamt = new TextEditingController();
  TextEditingController _ratetype = new TextEditingController();

  //var ordTaka = 0;
  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');


  var _jsonData = [];
  List _itemlist = [];

  
  var _alternative = 'NO';
  var partystate = '';


  List<Widget> ratelist = [];
  List<TextEditingController> ratecontroller = [];

  @override
  void initState() {
    _itemname.addListener(() {_itemname.text.toString();});
    _pcs.addListener(() {
      _pcs.text.toString();
    });
    _rate.addListener(() {
      _rate.text.toString();
    });
    _unit.addListener(() {_unit.text.toString();});
    _amount.addListener(() {_amount.text.toString();});
    _discrate.addListener(() {_discrate.text.toString();});
    _discamt.addListener(() {_discamt.text.toString();});
    _addamt.addListener(() {_addamt.text.toString();});
    _sgstamt.addListener(() {_sgstamt.text.toString();});
    _cgstamt.addListener(() {_cgstamt.text.toString();});
    _igstamt.addListener(() {_igstamt.text.toString();});
    _sgstrate.addListener(() {_sgstrate.text.toString();});
    _cgstrate.addListener(() {_cgstrate.text.toString();});
    _igstrate.addListener(() {_igstrate.text.toString();});
    _finalamt.addListener(() {_finalamt.text.toString();});
    _taxablevalue.addListener(() {_taxablevalue.text.toString();});
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      setState(() {
        _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        _hsncode.text = ItemDetails[length - 1]['hsncode'].toString();
        _unit.text = ItemDetails[length - 1]['unit'].toString();
        _rate.text = ItemDetails[length - 1]['rate'].toString();
      });
    }

    //_date.text = curDate.toString().split(' ')[0];

    // if (int.parse(widget.xid) > 0) {
    //   //loadData();
    // }
  }

    Future<bool> loadgst() async {
    String uri = '';
    double calcrate = 0;
    var companyid = globals.companyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    var companystate = globals.companystate;
    var partystate = widget.xpartystate;

    //var fromdate = widget.xfbeg;
    //var todate = widget.xfend;

    uri =
        'https://www.cloud.equalsoftlink.com/api/api_gethsndet?dbname=$clientid&hsncode=${_hsncode.text}&rate=${_rate.text}&statename=${widget.xpartystate}&costatename=GUJARAT';

    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    print("//////////////11112222" + uri);

      _sgstrate.text = jsonData['sgstrate'].toString();
      _cgstrate.text = jsonData['cgstrate'].toString();
      _igstrate.text = jsonData['igstrate'].toString();

    

    double cut = getValueN(_cut.text);
    double pcs = getValueN(_pcs.text);
    double meters = getValueN(_meters.text);
    double DiscRate = getValueN(_discrate.text);
    double Rate = getValueN(_rate.text);
    double amount = getValueN(_amount.text);
    double taxablevalue = getValueN(_taxablevalue.text);
    double sgstamt = getValueN(_sgstamt.text);
    double cgstamt = getValueN(_cgstamt.text);
    double igstamt = getValueN(_igstamt.text);
    double finalamt= getValueN(_finalamt.text);
    double discAmt = getValueN(_discamt.text);
    double addamt = getValueN(_addamt.text);
    
    amount= Rate*pcs;
     setState(() {
        if (DiscRate > 0) {
          _discamt.text = ((DiscRate * amount) / 100).toStringAsFixed(2);
        }
        discAmt = _discamt.text == ""
            ? 0
            : double.parse(_discamt.text);
        addamt =
        _addamt.text == "" ? 0 : double.parse(_addamt.text);
       taxablevalue = (amount - discAmt + addamt);
      _taxablevalue.text = taxablevalue.toStringAsFixed(2);
      print("sdjkchjksd");
      print(taxablevalue);
    });

    
    double sGstrate = getValueN(_sgstrate.text);
    double cGstrate = getValueN(_cgstrate.text);
    double iGstrate = getValueN(_igstrate.text);
    //print(taxable);
    setState(() {
      sgstamt = ((taxablevalue * sGstrate) / 100);
      cgstamt = ((taxablevalue * cGstrate) / 100);
      igstamt = ((taxablevalue * iGstrate) / 100);
      print(sgstamt);
      print("2222222");
      print(cgstamt);
      print("2222222");
      print(igstamt);
      print("2222222");
    });

    // double iGstAmt = getValueN(igstamt);
    // double cGstAmt = getValueN(cgstamt);
    // double sGstAmt = getValueN(sgstamt);
    finalamt = (taxablevalue + sgstamt + cgstamt + igstamt);

    setState(() {
      //_rate.text = calcrate.toStringAsFixed(2);
      _amount.text = amount.toStringAsFixed(2);
     _amount.text = amount.toStringAsFixed(2);
      _finalamt.text = finalamt.toStringAsFixed(2);
      _sgstamt.text = sgstamt.toStringAsFixed(2);
      _cgstamt.text = cgstamt.toStringAsFixed(2);
      _igstamt.text = igstamt.toStringAsFixed(2);
      //_finalamt.text = finalamt.toStringAsFixed(2);
    });
    return true;
  }


  void gotoItemScreen(BuildContext context,index) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => item_list2(
          companyid: widget.xcompanyid,
          companyname: widget.xcompanyname,
          fbeg: widget.xfbeg,
          fend: widget.xfend,
          itemtype: 'finish',
        ),
      ),
    );

    setState(() {    
      // var retResult = result;
      // _itemlist = result;
      // result = result;

      // var selItem = '';
      // selItem = _itemlist.firstOrNull;

      // _itemname.text = selItem;

      // if (selItem != '') {
      //   getItemDet();
      // }

      if (result != null && result.isNotEmpty) {
        var selItem = result.first;
        _itemlist = result;

        if (selItem != null && selItem['itemname'] != null) {
          _itemname.text = selItem['itemname'];
          _hsncode.text = selItem['hsncode']; // Fix the typo here
          _unit.text = selItem['unit'];
          _rate.text = selItem['salerate'];
          // getItemDet();
          loadgst();
        }
      }
    });
  }



  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var itemname = _itemname.text;
      var hsncode = _hsncode.text;
      var rate = _rate.text;
      var unit = _unit.text;
      var amount = _amount.text;
      var meters = _pcs.text;
      var remark = _remark.text;
      var discper = _discrate.text;
      var discamt = _discamt.text;
      var  addamt = _addamt.text;
      var  taxablevalue = _taxablevalue.text;
      var  sgstrate = _sgstrate.text;
      var  sgstamt = _sgstamt.text;
      var  cgstrate = _cgstrate.text;
      var  cgstamt = _cgstamt.text;
      var  igstrate = _igstrate.text;
      var  igstamt = _igstamt.text;
      var  finalamt = _finalamt.text;
      
      widget.xitemDet.add({
        'barcode':'',
        'itemname': itemname,
        'hsncode': hsncode,
        'pcs': '0',
        'cut':'0',
        'meters': meters,
        'rate': rate,
        'unit': unit,
        'amount': amount,
        'discper': discper,
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
        'remarks': remark,
        'catalog': '',
      });

      Navigator.pop(context, widget.xitemDet);

      return true;
    }

    setDefValue();

    return Scaffold(
      appBar: EqAppBar(AppBarTitle: 'Sale Bill Item Details[ ] '),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.done),
      //     backgroundColor: Colors.green,
      //     onPressed: () => {saveData()}),
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
                    enabled: true,
                    controller: _itemname,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Item Name',
                      labelText: 'Item Name',
                    ),
                    onTap: () {
                      gotoItemScreen(context,context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    // enabled: true,
                    controller: _hsncode,
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
                    keyboardType: TextInputType.number,
                    controller: _pcs,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Qty',
                      labelText: 'Qty',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
                    onTap: () {
                      loadgst();
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _rate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
                    onTap: () {
                      loadgst();
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
                    controller: _unit,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Unit',
                      labelText: 'Unit',
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
                    keyboardType: TextInputType.number,
                    controller: _amount,
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
                    keyboardType: TextInputType.number,
                    controller: _discrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Disc Rate',
                      labelText: 'Disc Rate',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
                    onTap: () {
                      loadgst();
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _discamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Disc Amt',
                      labelText: 'Disc Amt',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
                    onTap: () {
                      loadgst();
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
                    keyboardType: TextInputType.number,
                    controller: _addamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Add Amt',
                      labelText: 'Add Amt',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
                    onTap: () {
                      loadgst();
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.number,
                    controller: _taxablevalue,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Taxable Value',
                      labelText: 'Taxable Value',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _sgstrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGST Rate',
                      labelText: 'SGST Rate',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _sgstamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGST Amt',
                      labelText: 'SGST Amt',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _cgstrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGST Rate',
                      labelText: 'CGST Rate',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _cgstamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGST Amt',
                      labelText: 'CGST Amt',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _igstrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGST Rate',
                      labelText: 'IGST Rate',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _igstamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGST Amt',
                      labelText: 'IGST Amt',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    keyboardType: TextInputType.number,
                    controller: _finalamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Final Amt',
                      labelText: 'Final Amt',
                    ),
                    onChanged: (value) {
                      loadgst();
                    },
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
                    controller: _remark,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Remark',
                      labelText: 'Remark',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: const Color.fromARGB(231, 255, 255, 255),
                      ), // Text style
                      backgroundColor: Colors.green,
                      // Background color
                    ),
                    onPressed: () {
                      saveData();
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ), // Text style
                      backgroundColor: Colors.green, // Background color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "CANCEL !!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.purple,
                        fontSize: 16.0,
                      );
                    },
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      )),
      // bottomNavigationBar: BottomBar(
      //   companyname: widget.xcompanyname,
      //   fbeg: widget.xfbeg,
      //   fend: widget.xfend,
      // ),
    );
  }
}
