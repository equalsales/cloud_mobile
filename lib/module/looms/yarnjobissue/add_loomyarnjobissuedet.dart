import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
//import 'package:cloud_mobile/list/party_list.dart';

import '../../../common/global.dart' as globals;
//import 'package:cloud_mobile/list/city_list.dart';
//import 'package:cloud_mobile/list/state_list.dart';
//import 'package:cloud_mobile/list/branch_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

//// import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:barcode_scan/barcode_scan.dart';

//import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';

class LoomYarnJobIssueDetAdd extends StatefulWidget {
  LoomYarnJobIssueDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      branch,
      partyid,
      itemDet,
      itemname,
      id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    xparty = partyid;
    xid = id;
    xItemDetails = itemDet;
    xitemname = itemname;
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
  var xitemname;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _LoomYarnJobIssueDetAddState createState() => _LoomYarnJobIssueDetAddState();
}

class _LoomYarnJobIssueDetAddState extends State<LoomYarnJobIssueDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  //TextEditingController _orderno = new TextEditingController();
  //TextEditingController _folddate = new TextEditingController();
  TextEditingController _Cartonchr = new TextEditingController();
  TextEditingController _Cartonno = new TextEditingController();
  TextEditingController _netwt = new TextEditingController();
  TextEditingController _cCartonno = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _lotno = new TextEditingController();
  TextEditingController _cops = new TextEditingController();
  TextEditingController _rolls= new TextEditingController();
  TextEditingController _box = new TextEditingController(text: '0');
  TextEditingController _cone = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  // TextEditingController _unit = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _cost = new TextEditingController(text: '0.00');
  TextEditingController _ychlndetid = new TextEditingController();
  TextEditingController _ychlnid = new TextEditingController();
  TextEditingController _ychlnsubdetid = new TextEditingController();
  TextEditingController _fmode = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _jsonData = [];

  String dropdownUnitType = 'W';

  var UnitType = [
    'W',
    'P',
    'M',
    'C'
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
      setState(() {});
    }

    // if("Edit Row" == xeditrow){
    //   setState(() {
    //     _Cartonchr.text = ItemDetails[length - 1]['cartonchr'].toString();
    //     _Cartonno.text = ItemDetails[length - 1]['cartonno'].toString();
    //     _itemname.text = ItemDetails[length - 1]['netwt'].toString();
    //     _itemname.text = ItemDetails[length - 1]['itemname'].toString();
    //     _itemname.text = ItemDetails[length - 1]['lotno'].toString();
    //     _itemname.text = ItemDetails[length - 1]['cops'].toString();
    //     _itemname.text = ItemDetails[length - 1]['rolls'].toString();
    //     _itemname.text = ItemDetails[length - 1]['box'].toString();
    //     _itemname.text = ItemDetails[length - 1]['cone'].toString();
    //     _itemname.text = ItemDetails[length - 1]['unit'].toString();
    //     _itemname.text = ItemDetails[length - 1]['rate'].toString();
    //     _itemname.text = ItemDetails[length - 1]['amount'].toString();
    //     _rate.text = ItemDetails[length - 1]['cost'].toString();
    //     _rate.text = ItemDetails[length - 1]['ychlnsubdetid'].toString();
    //     _rate.text = ItemDetails[length - 1]['ychlnid'].toString();
    //     _rate.text = ItemDetails[length - 1]['ychlndetid'].toString();
    //     _rate.text = ItemDetails[length - 1]['fmode'].toString();
    //   });
    // }

    //_date.text = curDate.toString().split(' ')[0];

    // if (int.parse(widget.xid) > 0) {
    //   //loadData();
    // }
  }

  // void gotoOrderScreen(BuildContext contex) async {
    // var result = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => loomsalesorder_list(
    //               companyid: widget.xcompanyid,
    //               companyname: widget.xcompanyname,
    //               fbeg: widget.xfbeg,
    //               fend: widget.xfend,
    //               partyid: widget.xparty,
    //             )));
    // setState(() {
    //   var retResult = result;
    //   print(retResult);
    //   var _orderlist = result[1];
    //   result = result[1];
    //   var orderid = _orderlist[0];
    //   print(orderid);
    //   var selOrder = '';
    //   for (var ictr = 0; ictr < retResult[0].length; ictr++) {
    //     if (ictr > 0) {
    //       selOrder = selOrder + ',';
    //     }
    //     selOrder = selOrder + retResult[0][ictr];
    //   }
    //   _orderno.text = selOrder;
    //   print('dhruv');
    //   print(result);
    //   setState(() {
    //     _folddate.text = result[0]['date'];
    //     _itemname.text = result[0]['itemname'];
    //     _design.text = result[0]['design'];
    //     _unit.text = result[0]['unit'];
    //     _rate.text = result[0]['rate'];
    //     _ordid.text = result[0]['ordid'].toString();
    //     _orddetid.text = result[0]['orddetid'].toString();
    //     ordMeters = double.parse(result[0]['balmeters'].toString());
    //     _ordbalmtrs.text = result[0]['balmeters'].toString();
    //   });
    // });
  // }


  Future<bool> fetchdetails() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;
    var branch = widget.xbranch;
    var item = widget.xitemname;
    var cartonno = _Cartonno.text;
    var cartonchr = _Cartonchr.text;


    fromdate = retconvdate(fromdate);
    todate = retconvdate(todate);

    fromdate = fromdate.toString();
    todate = todate.toString();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    if (length > 0) {
      for (int iCtr = 0; iCtr < length; iCtr++) {
        if ((ItemDetails[iCtr]['cartonno'] == cartonno) &&
            ((ItemDetails[iCtr]['cartonchr'] == cartonchr))) {
          showAlertDialog(context, 'Carton no Already Exists...');
          setState(() {
            _Cartonno.text = '0';
            _Cartonchr.text = '';
          });
          return true;
        }
      }
    } 
     
    uri =
        '${globals.cdomain}/cartoonstockqry?dbname=$db&cno=$cno&branch=$branch'
        '&itemname=$item&getdata=Y&itemfilter=Y&cartonno=$cartonno&cartonchr=$cartonchr';

    print(" fetchdetails  :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    print("hhhhhhhhhhhhhh");

    print(jsonData);

    if (jsonData == '[]') {
      print("1111111");
      showAlertDialog(context, 'Carton No Found...');
      return true;
    } else if (jsonData == ''){
      print("22222222");
      showAlertDialog(context, 'Carton No Found...');
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
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                                "Itemname : ${jsonData[index]['itemname'].toString()}  Balwt : ${jsonData[index]['balwt'].toString()}"),
                            subtitle: Text(
                                "Cartonchr : ${jsonData[index]['cartonchr'].toString()}  Cartonno : ${jsonData[index]['cartonno'].toString()}"),
                            onTap: () {
                                _Cartonno.text = jsonData[index]['cartonno'].toString();
                                _Cartonchr.text = jsonData[index]['cartonchr'].toString();
                                _itemname.text = jsonData[index]['itemname'].toString();
                                _netwt.text = jsonData[index]['balwt'].toString();
                                _cops.text = jsonData[index]['cops'].toString();
                                dropdownUnitType = jsonData[index]['unit'].toString();
                                if(dropdownUnitType == 'null'){
                                  dropdownUnitType = 'W';
                                }else if(dropdownUnitType == ''){
                                  dropdownUnitType = 'W';
                                }
                                _lotno.text = jsonData[index]['lotno'].toString();
                                _ychlndetid.text = jsonData[index]['detid'].toString();
                                _ychlnid.text = jsonData[index]['mstid'].toString();
                                _ychlnsubdetid.text = jsonData[index]['subdetid'].toString();
                                _fmode.text = jsonData[index]['fmode'].toString();
                                _rate.text = jsonData[index]['rate'].toString();
                                _amount.text = jsonData[index]['amount'].toString();
                                _cost.text = jsonData[index]['cost'].toString();
                                _cone.text = '0';

                                double netwt = double.parse(_netwt.text);
                                double cops = double.parse(_cops.text);

                                String unit = dropdownUnitType;
                                double rate = 0;
                                if (_rate.text != '') {
                                  rate = double.parse(_rate.text);
                                }
                                double amount = 0;
                                if ((unit == 'W') || (unit == '')) {
                                  amount = netwt * rate;
                                } else {
                                  amount = cops * rate;
                                }
                                _amount.text = amount.toString();

                                for (int iCtr = 0; iCtr < length; iCtr++) {
                                  if ((ItemDetails[iCtr]['cartonno'] ==
                                          _Cartonno.text) &&
                                      ((ItemDetails[iCtr]['cartonchr'] ==
                                          _Cartonchr.text))) {
                                    setState(() {
                                      _Cartonno.text = '0';
                                      _Cartonchr.text = '';
                                      _itemname.text = '';
                                      _netwt.text = '';
                                      _cops.text = '';
                                      _rolls.text = '';
                                      _box.text = '0';
                                      dropdownUnitType = 'W';
                                      _lotno.text = '';
                                      _ychlndetid.text = '';
                                      _ychlnid.text = '';
                                      _ychlnsubdetid.text = '';
                                      _fmode.text = '';
                                      _rate.text = '';
                                      _amount.text = '';
                                      _cost.text = '';
                                      _cone.text = '0';
                                      print("111111");
                                      Fluttertoast.showToast(
                                        msg: "Carton no Already Exists...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.purple,
                                        fontSize: 16.0,
                                      );
                                      print("2222222");
                                    });
                                  }
                                }
                                Navigator.pop(context);
                              }
                          ),
                          Divider()
                        ],
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
        _Cartonno.text = jsonData[0]['cartonno'].toString();
        _Cartonchr.text = jsonData[0]['cartonchr'].toString();
        _itemname.text = jsonData[0]['itemname'].toString();
        _netwt.text = jsonData[0]['balwt'].toString();
        _cops.text = jsonData[0]['cops'].toString();
        dropdownUnitType = jsonData[0]['unit'].toString();
        if (dropdownUnitType == 'null') {
          dropdownUnitType = 'W';
        } else if (dropdownUnitType == '') {
          dropdownUnitType = 'W';
        }
        _lotno.text = jsonData[0]['lotno'].toString();
        _ychlndetid.text = jsonData[0]['detid'].toString();
        _ychlnid.text = jsonData[0]['mstid'].toString();
        _ychlnsubdetid.text = jsonData[0]['subdetid'].toString();
        _fmode.text = jsonData[0]['fmode'].toString();
        _rate.text = jsonData[0]['rate'].toString();
        _amount.text = jsonData[0]['amount'].toString();
        _cone.text = '0';
      });

      double netwt = double.parse(_netwt.text);
      double cops = double.parse(_cops.text);

      String unit = dropdownUnitType;
      double rate = 0;
      if (_rate.text != '') {
        rate = double.parse(_rate.text);
      }
      double amount = 0;
      if ((unit == 'W') || (unit == '')) {
        amount = netwt * rate;
      } else {
        amount = cops * rate;
      }
      _amount.text = amount.toString();
    }
    return true;
  }
  
  void totCalUnit() {
    double netwt = 0.0;
    double cops = 0.0;
    double rate = 0.0;
    String unit = dropdownUnitType.toString();

    if (_netwt.text.isNotEmpty) {
      netwt = double.tryParse(_netwt.text) ?? 0.0;
    }

    if (_cops.text.isNotEmpty) {
      cops = double.tryParse(_cops.text) ?? 0.0;
    }

    if (_rate.text.isNotEmpty) {
      rate = double.tryParse(_rate.text) ?? 0.0;
    }

    double amount = 0.0;

    if (unit == 'W') {
      amount = netwt * rate;
    } else {
      amount = cops * rate;
    }

    setState(() {
      _amount.text = amount.toString();
    });
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
      _Cartonno.text = splitted[0];
      // if (splitted.length > 1) {
      //   _Cartonno.text = splitted[1];
      // } else {
      //   _Cartonno.text = '0';
      // }

      fetchdetails();
      // _scanBarcode = barcodeScanRes;
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
      var cartonchr = _Cartonchr.text;
      var cartonno = _Cartonno.text;
      // var ccartonno = _cCartonno.text;
      var netwt = _netwt.text;
      var lotno = _lotno.text;
      var cops = _cops.text;
      var rolls = _rolls.text;
      var box = _box.text;
      var cone = _cone.text;
      var itemname = _itemname.text;

      var rate = _rate.text;
      var unit = dropdownUnitType;
      var amount = _amount.text;
      var cost = _cost.text;
      var ychlndetid = _ychlndetid.text;
      var ychlnid = _ychlnid.text;
      var ychlnsubdetid = _ychlnsubdetid.text;
      var fmode = _fmode.text;

      print("jatin");
      widget.xitemDet.add({
        'cartonchr': cartonchr,
        'cartonno': cartonno,
        'netwt': netwt,
        'itemname': itemname,
        'lotno': lotno,
        'cops': cops,
        'rolls': rolls,
        'box': box,
        'cone': cone,
        'unit': unit,
        'rate': rate,
        'amount': amount,
        'cost': cost,
        'ychlnsubdetid': ychlnsubdetid.toString(),
        'ychlnid': ychlnid.toString(),
        'ychlndetid': ychlndetid.toString(),
        'fmode': fmode,
      });

      //print("tanshul");
      Navigator.pop(context, widget.xitemDet);
      // print("panshul");
      return true;
    }

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yarn Job JobWork Item Details [ ] ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          onPressed: () => {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Form submitted successfully')),
              ),
              saveData()
            }
          }
        ),
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
                    controller: _Cartonchr,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select carton ',
                      labelText: 'Cartonchr',
                    ),
                    onChanged: (value) {
                      _Cartonchr.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _Cartonchr.selection);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _Cartonno,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Carton No',
                      labelText: 'Carton No',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter cartonno';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.all(2)),
                ElevatedButton(
                  onPressed: () => {fetchdetails()},
                  child: Text('Fetch Details',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.all(2)),
                ElevatedButton(
                  onPressed: () => {barcodeScan()},
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
                    enabled: false,
                    controller: _itemname,
                    textInputAction: TextInputAction.next,
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
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _netwt,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Net Weight',
                      labelText: 'NetWt',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    onChanged: (value) {
                      totCalUnit();
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _cops,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cops',
                      labelText: 'Cops',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    onChanged: (value) {
                      totCalUnit();
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
                    controller: _rolls,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rolls',
                      labelText: 'Rolls',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _box,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Box',
                      labelText: 'Box',
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
                    controller: _cone,
                    textInputAction: TextInputAction.next,
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
                    controller: _lotno,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Lot No',
                      labelText: 'Lot No',
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Rate',
                      labelText: 'Rate',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    onChanged: (value) {
                      totCalUnit();
                    },
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
                          totCalUnit();
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Amount',
                      labelText: 'Amount',
                    ),
                    onTap: () {
                      //gotoBranchScreen(context);
                    },
                    onChanged: (value) {
                      totCalUnit();
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
                    controller: _cost,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Cost',
                      labelText: 'Cost',
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
                    enabled: false,
                    controller: _ychlndetid,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ychlndetid',
                      labelText: 'ychlndetid',
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
                    controller: _ychlnid,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ychlnid',
                      labelText: 'ychlnid',
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
                    controller: _ychlnsubdetid,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ychlnsubdetid',
                      labelText: 'ychlnsubdetid',
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
                    controller: _fmode,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'FMode',
                      labelText: 'FMode',
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
