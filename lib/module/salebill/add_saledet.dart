import 'package:cloud_mobile/common/eqappbar.dart';
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
      partyid,
      itemDet,
      id,
      branchid})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xbranchid = branchid;
    xItemDetails = itemDet;

    print('in Item Details');
    print(xbranch);
    print(xparty);
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
  var xparty;
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

  //var ordTaka = 0;
  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  var _jsonData = [];
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');

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
        //_orderno.text = ItemDetails[length - 1]['orderno'].toString();
        //_folddate.text = ItemDetails[length - 1]['folddate'].toString();
        //_ordbalmtrs.text = ItemDetails[length - 1]['ordbalmtrs'].toString();
        //_ordid.text = ItemDetails[length - 1]['ordid'].toString();
        //_orddetid.text = ItemDetails[length - 1]['orddetid'].toString();
        _itemname.text = ItemDetails[length - 1]['itemname'].toString();
        //_design.text = ItemDetails[length - 1]['design'].toString();
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

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var itemname = _itemname.text;
      var rate = _rate.text;
      var unit = _unit.text;
      var amount = _amount.text;
      var pcs = _pcs.text;
      var meters = _meters.text;
      var hsncode = _hsncode.text;
      var remark = _remark.text;

      widget.xitemDet.add({
        'itemname': itemname,
        'hsncode': hsncode,
        'pcs': pcs,
        'meters': meters,
        'rate': rate,
        'unit': unit,
        'amount': amount,
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
                    controller: _pcs,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Qty',
                      labelText: 'Qty',
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
                    controller: _rate,
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
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                    controller: _discrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Disc Rate',
                      labelText: 'Disc Rate',
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
                    controller: _discamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Disc Amt',
                      labelText: 'Disc Amt',
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
                    controller: _addamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Add Amt',
                      labelText: 'Add Amt',
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
                    controller: _taxablevalue,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Taxable Value',
                      labelText: 'Taxable Value',
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
                    controller: _sgstrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGST Rate',
                      labelText: 'SGST Rate',
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
                    controller: _sgstamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'SGST Amt',
                      labelText: 'SGST Amt',
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
                    controller: _cgstrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGST Rate',
                      labelText: 'CGST Rate',
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
                    controller: _cgstamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'CGST Amt',
                      labelText: 'CGST Amt',
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
                    controller: _igstrate,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGST Rate',
                      labelText: 'IGST Rate',
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
                    controller: _igstamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'IGST Amt',
                      labelText: 'IGST Amt',
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
                    controller: _finalamt,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Final Amt',
                      labelText: 'Final Amt',
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
