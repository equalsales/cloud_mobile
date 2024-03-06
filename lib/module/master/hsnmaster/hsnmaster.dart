// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/module/master/hsnmaster/addhsnmasterdet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/alert.dart';
import '../../../common/global.dart' as globals;

class HSNMaster extends StatefulWidget {
  HSNMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var orderno;
  var orderchr;
  double tottaka = 0;
  double totmtrs = 0;

  @override
  _HSNMasterState createState() => _HSNMasterState();
}

class _HSNMasterState extends State<HSNMaster> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _partylist = [];
  List _hastelist = [];
  List _transportlist = [];
  List _stationlist = [];
  List ItemDetails = [];
  var partyid = 0;
  var bookid = 0;
  double tottaka = 0;
  TextEditingController _hsn_sac = new TextEditingController();
  TextEditingController _printname = new TextEditingController();
  TextEditingController _type = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropdownActive = "YES";

  var Active = [
    'YES',
    'NO',
  ];

  String dropdownType = "LOCAL";

  var Type = [
    'LOCAL',
    'EXPORT',
  ];

  @override
  void initState() {
    super.initState();
    if (int.parse(widget.xid) > 0) {
      loadData();
      loadDetData();
    }
  }

  Future<bool> loadDetData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;

    uri =
        "https://www.cloud.equalsoftlink.com/api/api_hsncodedetlist?dbname=$clientid&cno=$companyid&controlid=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    List ItemDet = [];
    ItemDetails = [];
    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      ItemDet.add({
        "type": jsonData[iCtr]['type'].toString(),
        "fromrate": jsonData[iCtr]['fromrate'].toString(),
        "torate": jsonData[iCtr]['torate'].toString(),
        "sgstrate": jsonData[iCtr]['sgstrate'].toString(),
        "cgstrate": jsonData[iCtr]['cgstrate'].toString(),
        "igstrate": jsonData[iCtr]['igstrate'].toString(),
      });
    }
    setState(() {
      ItemDetails = ItemDet;
    });

    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_hsncodelist?dbname=$clientid&cno=$companyid&id=$id";
    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    print(jsonData);

    _hsn_sac.text = getValue(jsonData['hsncode'], 'C');
    _printname.text = getValue(jsonData['printname'], 'C');
    _type.text = getValue(jsonData['type'], 'C');
    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    void gotoChallanItemDet(BuildContext contex) async {
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => HSNMasterDetAdd(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    itemDet: ItemDetails,
                  )));
      setState(() {
        ItemDetails.add(result[0]);
        print(ItemDetails);
      });
    }

    Future<bool> saveData() async {
      tottaka = (widget.tottaka);
      print(tottaka);
      if (tottaka == 0) {
        print(widget.tottaka);
        showAlertDialog(context, 'Gst Rate Can Not be Blank !!!');
        return true;
      } else {
        String uri = '';
        var companyid = widget.xcompanyid;
        var clientid = globals.dbname;
        var hsn_sac = _hsn_sac.text;
        var printname = _printname.text;
        var type = _type.text;
        var id = widget.xid;
        id = int.parse(id);
        //print('In Save....');

        uri =
            "https://www.cloud.equalsoftlink.com/api/api_hsncodestort?dbname=$clientid" +
                "&hsncode=" +
                hsn_sac +
                "&type=" +
                dropdownType +
                "&printname=" +
                printname +
                "&id=" +
                id.toString() +
                "&GridData=" +
                jsonEncode(ItemDetails);
        print(uri);
        var response = await http.post(Uri.parse(uri));
        print(uri);
        var jsonData = jsonDecode(response.body);
        var jsonCode = jsonData['Code'];
        var jsonMsg = jsonData['Message'];
        print(jsonCode);
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
    }

    setState(() {
      //_packingtype.text = 'PACKING';
    });

    void deleteRow(index) {
      setState(() {
        ItemDetails.removeAt(index);
      });
    }

    List<DataRow> _createRows() {
      List<DataRow> _datarow = [];
      print(ItemDetails);

      widget.tottaka = 0;
      //widget.totmtrs=0;

      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        double nPcs = 0;
        if (ItemDetails[iCtr]['sgstrate'] != '') {
          nPcs = nPcs + double.parse(ItemDetails[iCtr]['sgstrate']);
          widget.tottaka += nPcs;
        }

        _datarow.add(DataRow(cells: [
          DataCell(ElevatedButton.icon(
            onPressed: () => {deleteRow(iCtr)},
            icon: Icon(
              // <-- Icon
              Icons.delete,
              size: 24.0,
            ),
            label: Text('',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          )),
          DataCell(Text(ItemDetails[iCtr]['type'])),
          DataCell(Text(ItemDetails[iCtr]['fromrate'])),
          DataCell(Text(ItemDetails[iCtr]['torate'])),
          DataCell(Text(ItemDetails[iCtr]['sgstrate'])),
          DataCell(Text(ItemDetails[iCtr]['cgstrate'])),
          DataCell(Text(ItemDetails[iCtr]['igstrate'])),
          // DataCell(Text(ItemDetails[iCtr]['entryid'].toString())),
        ]));
      }

      setState(() {
        //_tottaka.text = widget.tottaka.toString();
      });

      return _datarow;
    }

    setDefValue();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'HSN Master [ ' +
      //         (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
      //         ' ] ' +
      //         'Add : ' +
      //         _hsn_sac.text,
      //     style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
      //   ),
      // ),
      appBar: EqAppBar(AppBarTitle: "HSN Master EDIT/ADD"),
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
              Expanded(child: hsnTextField()),
              Expanded(
                child: EqTextField(
                  controller: _printname,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  hintText: 'Priny name',
                  labelText: 'Print name',
                  onTap: () {
                    //_selectDate(context);
                  },
                  onChanged: (value) {
                    _printname.value = _printname.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField(
                    value: dropdownType,
                    decoration: const InputDecoration(
                        labelText: 'Type', hintText: "Type"),
                    items: Type.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownType = newValue!;
                      });
                    }),
              ),
              Expanded(
                child: DropdownButtonFormField(
                    value: dropdownActive,
                    decoration: const InputDecoration(
                        labelText: 'Active', hintText: "Active"),
                    items: Active.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownActive = newValue!;
                      });
                    }),
              ),
            ]),
            Padding(padding: EdgeInsets.all(5)),
            // ElevatedButton(
            //   onPressed: () => {gotoChallanItemDet(context)},
            //   child: Text('Gst Rate',
            //       style:
            //           TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            // ),
            //Padding(padding: EdgeInsets.all(5)),
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
                      gotoChallanItemDet(context);
                    },
                    child: const Text(
                      'Gst Rate',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            //Padding(padding: EdgeInsets.all(5)),
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
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: [
                  DataColumn(
                    label: Text("Action"),
                  ),
                  DataColumn(
                    label: Text("Type"),
                  ),
                  DataColumn(
                    label: Text("From Rate"),
                  ),
                  DataColumn(
                    label: Text("ToRate"),
                  ),
                  DataColumn(
                    label: Text("SGSTRate"),
                  ),
                  DataColumn(
                    label: Text("CGSTRate"),
                  ),
                  DataColumn(
                    label: Text("IGSTRate"),
                  ),
                ], rows: _createRows())),
          ],
        ),
      )),
    );
  }

  EqTextField hsnTextField() {
    return EqTextField(
      controller: _hsn_sac,
      textInputAction: TextInputAction.next,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      autofocus: true,
      hintText: 'HSN/SAC',
      labelText: 'HSN/SAC',
      onTap: () {},
      onChanged: (value) {
        _hsn_sac.value = _hsn_sac.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }


  
}
