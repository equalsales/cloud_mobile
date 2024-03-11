// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/list/hsn_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/alert.dart';
import '../../../common/global.dart' as globals;

class ItemMaster extends StatefulWidget {
  ItemMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var orderchr;
  double totmtrs = 0;
  double tottaka = 0;
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;

  @override
  _ItemMasterState createState() => _ItemMasterState();
}

class _ItemMasterState extends State<ItemMaster> {
  List ItemDetails = [];
  var bookid = 0;
  DateTime fromDate = DateTime.now();
  var partyid = 0;
  DateTime toDate = DateTime.now();

  String dropdownItemtype = "FINISH";

  var Itemtype = [
    'FINISH',
    'JOBWORK',
    'EXPENSE',
  ];

  final _formKey = GlobalKey<FormState>();

  List _hsnlist = [];
  List unitDetails = [];

  String dropdownUNIT = 'P';

  void gotoHSN(BuildContext context, acctype, TextEditingController obj) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => HSN_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  acctype: acctype,
                )));

    setState(() {
      var retResult = result;
      _hsnlist = result;
      result = result;

      var selParty = '';
      selParty = _hsnlist.firstOrNull;

      _HSNCode.text = selParty;
    });
  }

  TextEditingController _itemname = new TextEditingController();
  TextEditingController _itemtype = new TextEditingController();
  TextEditingController _HSNCode = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _id = new TextEditingController();

  @override
  void initState() {
    super.initState();
    loadunitdetails();
    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> loadunitdetails() async {
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    String uri = '';
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_unitlist?dbname=$clientid&cno=$companyid";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    print(jsonData);
    //print(jsonData);
    List unitDet = [];

    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      unitDet.add({
        "unit": jsonData[iCtr]['unit'].toString(),
      });
    }
    setState(() {
      unitDetails = unitDet;
    });
    print(unitDetails);
    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_itemlist?dbname=$clientid&cno=$companyid&id= " +
            id;
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _itemname.text = jsonData['itemname'].toString();
    //_itemtype.text = jsonData['type'].toString();
    _HSNCode.text = getValue(jsonData['hsncode'], 'C');
    _unit.text = getValue(jsonData['unit'], 'C');
    _rate.text = getValue(jsonData['salerate'], 'N');
    dropdownItemtype = getValue(jsonData['type'], 'C');
    dropdownUNIT = getValue(jsonData['unit'], 'C');
    id = jsonData['id'].toString();
    ;
    setState(() {});
    return true;
  }

  void setDefValue() {}

  Future<bool> saveData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var itemname = _itemname.text;
    var type = _itemtype.text;
    var unit = _unit.text;
    var salerate = _rate.text;
    var hsncode = _HSNCode.text;
    var id = widget.xid;
    id = int.parse(id);

    print('In Save....');
    //print(dropdownItemtype);
    //print(dropdownUNIT);
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_itemststort?dbname=$clientid" +
            "&itemname=" +
            itemname +
            "&type=" +
            dropdownItemtype +
            "&salerate=" +
            salerate +
            "&unit=" +
            dropdownUNIT +
            "&hsncode=" +
            hsncode +
            "&id=" +
            id.toString();
    print(uri);
    var response = await http.post(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    var jsonCode = jsonData['Code'];
    var jsonMsg = jsonData['Message'];

    if (jsonCode == '500') {
      showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
    } else if (jsonCode == '100') {
      showAlertDialog(context, 'Error While Saving !!! ' + jsonMsg);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Saved !!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.purple,
        fontSize: 16.0,
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    setDefValue();
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "Item Master"),
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
            Row(children: [
              Expanded(
                child: itemTextBox(),
              ),
            ]),
            itemtypeDropDown(),
            Row(
              children: [
                Expanded(
                  child: hsnTextField(),
                ),
                Expanded(
                  child: unitDropDown(),
                ),
              ],
            ),
            Row(children: [
              Expanded(child: rateTextField()),
            ]),
            Padding(padding: EdgeInsets.all(5)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: saveTextButton()),
                  SizedBox(width: 10),
                  Expanded(child: cancelTextButton())
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  EqTextField itemTextBox() {
    return EqTextField(
      controller: _itemname,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autofocus: true,
      hintText: 'Item Name',
      labelText: 'Item Name',
      onTap: () {
        //_selectDate(context);
      },
      onChanged: (value) {
        _itemname.value = _itemname.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  DropdownButtonFormField itemtypeDropDown() {
    return DropdownButtonFormField(
        value: dropdownItemtype,
        decoration:
            const InputDecoration(labelText: 'ItemType', hintText: "ItemType"),
        items: Itemtype.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down_circle),
        onChanged: (newValue) {
          setState(() {
            dropdownItemtype = newValue!;
          });
        });
  }

  EqTextField hsnTextField() {
    return EqTextField(
      controller: _HSNCode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      hintText: 'HSN Code',
      labelText: 'HSN Code',
      onTap: () {
        gotoHSN(context, 'SALE PARTY', _HSNCode);
      },
      onChanged: (value) {},
    );
  }

  DropdownButtonFormField unitDropDown() {
    return DropdownButtonFormField(
        value: dropdownUNIT,
        decoration: const InputDecoration(labelText: 'UNIT', hintText: "UNIT"),
        items: unitDetails.map<DropdownMenuItem<String>>((items) {
          return DropdownMenuItem<String>(
            value: items['unit'],
            child: Text(items['unit']),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down_circle),
        onChanged: (newValue) {
          setState(() {
            dropdownUNIT = newValue!;
          });
        });
  }

  EqTextField rateTextField() {
    return EqTextField(
      controller: _rate,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      hintText: 'Rate',
      labelText: 'Rate',
      onTap: () {
        //gotoPartyScreen2(context, 'SALE PARTY', _party);
      },
      onChanged: (value) {},
    );
  }

  TextButton saveTextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),

        textStyle: TextStyle(
          fontSize: 25,
          color: const Color.fromARGB(231, 255, 255, 255),
        ), // Text style
        backgroundColor: Colors.green,
        // Background color
      ),
      onPressed: () {
        this.saveData();
      },
      child: const Text(
        'SAVE',
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(231, 255, 255, 255),
        ),
      ),
    );
  }

  TextButton cancelTextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),

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
    );
  }
}
