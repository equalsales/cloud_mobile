// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/eqtextfield.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/head_list.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/list/state_list.dart';
import 'package:cloud_mobile/module/salebill/add_salebill.dart';
import 'package:cloud_mobile/projFunction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;

class PartyMaster extends StatefulWidget {
  PartyMaster(
      {Key? mykey, companyid, companyname, fbeg, fend, id, acctype, newParty})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xacctype = acctype;
    xnewParty = newParty;
  }

  var orderchr;
  double totmtrs = 0;
  double tottaka = 0;
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xacctype;
  var xnewParty;

  @override
  _PartyMasterState createState() => _PartyMasterState();
}

class _PartyMasterState extends State<PartyMaster> {
  List ItemDetails = [];
  List citylist = [];
  List statelist = [];
  List headlist = [];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _head = new TextEditingController();
  TextEditingController _partyname = new TextEditingController();
  TextEditingController _acctype = new TextEditingController();
  TextEditingController _address1 = new TextEditingController();
  TextEditingController _address2 = new TextEditingController();
  TextEditingController _address3 = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _mobileno = new TextEditingController();
  TextEditingController _gstno = new TextEditingController();
  TextEditingController _dhara = new TextEditingController();
  TextEditingController _openingBal = new TextEditingController();
  TextEditingController _pcspercentage = new TextEditingController();
  TextEditingController _tdspercentage = new TextEditingController();
  TextEditingController _rdurd = new TextEditingController();

  String dropdownDrCr = "Type";

  var drcr = [
    'Type',
    'DR',
    'CR',
  ];

  String dropdownRdurd = "TYPE";

  var rdurd = [
    'TYPE',
    'RD',
    'URD',
  ];

  String dropdownAccType = "ACCTYPE";

  var Acctype = [
    'ACCTYPE',
    'SALE PARTY',
    'PURCHASE PARTY',
    'GENERAL PURCHASE PARTY',
    'GENERAL SALE PARTY',
    'AGENT',
    'GREY PARTY',
    'EMB SALE PARTY',
    'JOBWORK PARTY',
    'YARN SALE PARTY',
  ];

  void gotoStationScreen(BuildContext context) async {
    var result = await openCity_List(context, widget.xcompanyid,
        widget.xcompanyname, widget.xfbeg, widget.xfend);

    var retResult = result[0];
    var retState = result[2];
    var selCity = '';
    var selState = '';

    citylist = result;
    result = result;

    for (var ictr = 0; ictr < retResult.length; ictr++) {
      if (ictr > 0) {
        selCity = selCity + ',';
      }
      selCity = selCity + retResult[ictr];
    }
    print(selCity);

    for (var ictr = 0; ictr < retState.length; ictr++) {
      if (ictr > 0) {
        selState = selState + ',';
      }
      selState = selState + retState[ictr];
    }
    print(selState);

    setState(() {
      _city.text = selCity;
      _state.text = selState;
    });
  }

  void gotoHeadScreen(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Head_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  acctype: "SALE PARTY",
                )));

    setState(() {
      var retResult = result;
      headlist = result;
      result = result;

      var selParty = '';
      for (var ictr = 0; ictr < retResult.length; ictr++) {
        if (ictr > 0) {
          selParty = selParty + ',';
        }

        selParty = selParty + retResult[ictr];
      }

      _head.text = selParty;
    });
  }

  void gotoStateScreen(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => state_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  acctype: "SALE PARTY",
                )));

    setState(() {
      var retResult = result;
      statelist = result;
      result = result;

      var selParty = '';
      for (var ictr = 0; ictr < retResult.length; ictr++) {
        if (ictr > 0) {
          selParty = selParty + ',';
        }

        selParty = selParty + retResult[ictr];
      }

      _state.text = selParty;
    });
  }

  @override
  void initState() {
    super.initState();
    // _partyname.text = widget.xnewParty ?? _partyname.text;
    if (widget.xnewParty != null && widget.xnewParty != '') {
      dropdownAccType = widget.xacctype.toString().toUpperCase();
      _partyname.text = widget.xnewParty.toString().toUpperCase();

      acctypeheadvld();
    } else {
      dropdownAccType = dropdownAccType;
    }
    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> acctypeheadvld() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_acctypeheadvld?dbname=$clientid&cno=$companyid&acctype=$dropdownAccType";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    _head.text = jsonData['acchead'].toString();
    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_partylist?dbname=$clientid&cno=$companyid&id=$id";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _head.text = jsonData['acchead'].toString();
    _partyname.text = jsonData['party'].toString();
    dropdownAccType = getValue(jsonData['acctype'], 'C');
    _address1.text = getValue(jsonData['addr1'], 'C');
    _address2.text = getValue(jsonData['addr2'], 'C');
    _address3.text = getValue(jsonData['addr3'], 'C');
    _pincode.text = getValue(jsonData['pincode'], 'C');
    _city.text = getValue(jsonData['city'], 'C');
    _gstno.text = getValue(jsonData['gstregno'], 'C');
    _state.text = getValue(jsonData['state'], 'C');
    _mobileno.text = getValue(jsonData['mobileno'], 'C');
    _pcspercentage.text = getValue(jsonData['tcsper'], 'N');
    _tdspercentage.text = getValue(jsonData['tdsper'], 'N');
    _dhara.text = getValue(jsonData['discper'], 'N');
    dropdownRdurd = getValue(jsonData['rdurd'], 'C');
    dropdownDrCr = getValue(jsonData['type'], 'C');
    if (dropdownAccType == '') {
      dropdownAccType = 'ACCTYPE';
    }
    if (dropdownRdurd == '') {
      dropdownRdurd = 'TYPE';
    }
    if (dropdownDrCr == '') {
      dropdownDrCr = 'TYPE';
    }
    print(dropdownDrCr);
    if (dropdownDrCr == 'DR') {
      _openingBal.text = getValue(jsonData['opening'], 'N');
    } else {
      _openingBal.text = getValue(jsonData['opening'], 'N');
    }
    id = jsonData['id'].toString();
    setState(() {});
    return true;
  }

  Future<bool> loadgstdata() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var gstno = _gstno.text;
    var id = widget.xid;
    uri = "https://task.equalsoftlink.com/fetchgstdata?gstin=$gstno";
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    _partyname.text = getValue(jsonData['lgnm'], 'C');
    _address1.text = getValue(
        jsonData['pradr']["addr"]["bno"] +
            ' ' +
            jsonData['pradr']["addr"]["flno"] +
            ' ' +
            jsonData['pradr']["addr"]["bnm"],
        'C');
    _address2.text = getValue(jsonData['pradr']["addr"]["st"], 'C');
    _address3.text = getValue(jsonData['pradr']["addr"]["loc"], 'C');
    _pincode.text = getValue(jsonData['pradr']["addr"]["pncd"], 'C');
    _city.text = getValue(jsonData['pradr']["addr"]["loc"], 'C');
    _state.text = getValue(jsonData['pradr']["addr"]["stcd"], 'C');
    dropdownRdurd = "RD";

    return true;
  }

  Future<bool> saveData() async {
    //UnitVld();
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var partyname = _partyname.text;
    var head = _head.text;
    var acctype = _acctype.text;
    var address1 = _address1.text;
    var address2 = _address2.text;
    var address3 = _address3.text;
    var pincode = _pincode.text;
    var city = _city.text;
    var gstno = _gstno.text;
    var state = _state.text;
    var mobileno = _mobileno.text;
    var tcsper = _pcspercentage.text;
    var tdsper = _tdspercentage.text;
    var discper = _dhara.text;
    var opbalance = _openingBal.text;
    var rdurd = _rdurd.text;
    var id = widget.xid;
    id = int.parse(id);
    //print('In Save....');
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_partystort?dbname=$clientid" +
            "&party=" +
            partyname +
            "&acchead=" +
            head +
            "&acctype=" +
            dropdownAccType +
            "&addr1=" +
            address1 +
            "&addr2=" +
            address2 +
            "&addr3=" +
            address3 +
            "&pincode=" +
            pincode +
            "&city=" +
            city +
            "&state=" +
            state +
            "&mobileno=" +
            mobileno +
            "&tcsper=" +
            tcsper +
            "&tdsper=" +
            tdsper +
            "&discper=" +
            discper +
            "&gstregno=" +
            gstno +
            "&rdurd=" +
            dropdownRdurd +
            "&type=" +
            dropdownDrCr +
            "&opbalance=" +
            opbalance +
            "&cno=" +
            companyid +
            "&id=" +
            id.toString();
    print(uri);
    var response = await http.post(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    var jsonCode = jsonData['Code'];
    var jsonMsg = jsonData['Message'];
    print(jsonCode);
    if (jsonCode == '500') {
      showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
    } else if (jsonCode == '100') {
      showAlertDialog(context, 'Error While Saving !!! ' + jsonMsg);
    } else {
      // Navigator.pop(context);
      if (widget.xnewParty == '') {
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
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesBillAdd(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  id: '0',
                  partyname: _partyname.text),
            ));
      }
    }
    return true;
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    setState(() {});

    setDefValue();
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "Party Master"),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(child: gstTextField()),
                SizedBox(),
                Container(
                    width: 150,
                    height: 70,
                    padding: EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: ElevatedButton(
                        child: Text(
                          'Fetch Gst',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        onPressed: () {
                          loadgstdata();
                        },
                      ),
                    )),
              ],
            ),
            Row(children: [
              Expanded(child: partyTextField()),
            ]),
            Row(children: [
              Expanded(
                child: acctypeDropDown(),
              )
            ]),
            Row(children: [
              Expanded(
                child: accheadTextField(),
              ),
            ]),
            Row(children: [
              Expanded(child: openingTextField()),
              SizedBox(),
              Expanded(child: typeDropDown())
            ]),
            Row(children: [
              Expanded(child: addr1TextField()),
            ]),
            Row(children: [
              Expanded(child: addr2TextField()),
            ]),
            Row(children: [
              Expanded(child: addr3TextField()),
            ]),
            Row(
              children: [
                Expanded(child: cityTextField()),
                Expanded(child: stateTextField()),
              ],
            ),
            Row(
              children: [
                Expanded(child: mobileTextField()),
                Expanded(child: pincodeTextField()),
              ],
            ),
            Row(
              children: [
                Expanded(child: dharaTextField()),
                Expanded(child: rdurdDropDown())
              ],
            ),
            Row(
              children: [
                Expanded(child: tcsrateTextField()),
                Expanded(
                  child: tdsrateTextField(),
                )
              ],
            ),
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

  EqTextField gstTextField() {
    return EqTextField(
      controller: _gstno,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      autofocus: true,
      hintText: 'GSTIN',
      labelText: 'GST No',
      onTap: () {
        //gotoPartyScreen2(context, 'SALE PARTY', _party);
      },
      onChanged: (value) {
        _gstno.value = _gstno.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField partyTextField() {
    return EqTextField(
      controller: _partyname,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'Party',
      labelText: 'Party',
      onTap: () {
        // gotoPartyScreen(context, 'SALE PARTY', _partyname);
      },
      onChanged: (value) {
        _partyname.value = _partyname.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  DropdownButtonFormField acctypeDropDown() {
    return DropdownButtonFormField(
      value: dropdownAccType,
      decoration: const InputDecoration(
        labelText: 'ACCTYPE',
      ),
      items: Acctype.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      icon: const Icon(Icons.arrow_drop_down_circle),
      onChanged: (newValue) {
        setState(() {
          dropdownAccType = newValue!;
          acctypeheadvld();
        });
      },
      // onChanged: (String? newValue) {
      //   setState(() {
      //     //dropdownAccType = newValue!;
      //     //acctypeheadvld();
      //   });
      // }
    );
  }

  EqTextField accheadTextField() {
    return EqTextField(
      controller: _head,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'Head',
      labelText: 'Head',
      onTap: () {
        gotoHeadScreen(context);
      },
      onChanged: (value) {
        _head.value = _head.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField openingTextField() {
    return EqTextField(
      controller: _openingBal,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      hintText: 'Op Balance',
      labelText: 'Op Balance',
      onTap: () {
        //_selectDate(context);
      },
      onChanged: (value) {},
    );
  }

  DropdownButtonFormField typeDropDown() {
    return DropdownButtonFormField(
        value: dropdownDrCr,
        decoration: const InputDecoration(
          labelText: 'Type',
        ),
        items: drcr.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down_circle),
        onChanged: (newValue) {
          setState(() {
            dropdownDrCr = newValue!;
          });
        });
  }

  EqTextField addr1TextField() {
    return EqTextField(
      controller: _address1,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'Address 1',
      labelText: 'Address 1',
      onTap: () {
        //_selectDate(context);
      },
      onChanged: (value) {
        _address1.value = _address1.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField addr2TextField() {
    return EqTextField(
      controller: _address2,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'Address 2',
      labelText: 'Address 2',
      onTap: () {
        //_selectDate(context);
      },
      onChanged: (value) {
        _address2.value = _address2.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField addr3TextField() {
    return EqTextField(
      controller: _address3,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'Address 3',
      labelText: 'Address 3',
      onTap: () {
        //_selectDate(context);
      },
      onChanged: (value) {
        _address3.value = _address3.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField cityTextField() {
    return EqTextField(
      controller: _city,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'City',
      labelText: 'City',
      onTap: () {
        gotoStationScreen(context);
      },
      onChanged: (value) {
        _city.value = _city.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField stateTextField() {
    return EqTextField(
      controller: _state,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      hintText: 'State',
      labelText: 'State',
      onTap: () {
        gotoStateScreen(context);
      },
      onChanged: (value) {
        _state.value = _state.value.copyWith(
          text: value.toUpperCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
    );
  }

  EqTextField mobileTextField() {
    return EqTextField(
      controller: _mobileno,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      hintText: 'Mobile',
      labelText: 'Mobile',
      onTap: () {
        //gotoAgentScreen(context);
      },
      onChanged: (value) {},
    );
  }

  EqTextField pincodeTextField() {
    return EqTextField(
      controller: _pincode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      hintText: 'Pincode',
      labelText: 'Pincode',
      onTap: () {
        //gotoBranchScreen(context);
      },
      onChanged: (value) {},
    );
  }

  EqTextField dharaTextField() {
    return EqTextField(
      controller: _dhara,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      hintText: 'Dhara',
      labelText: 'Dhara',
      onTap: () {
        //gotoAgentScreen(context);
      },
      onChanged: (value) {},
    );
  }

  DropdownButtonFormField rdurdDropDown() {
    return DropdownButtonFormField(
        value: dropdownRdurd,
        decoration: const InputDecoration(
          labelText: 'RD/URD',
        ),
        items: rdurd.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down_circle),
        onChanged: (newValue) {
          setState(() {
            dropdownRdurd = newValue!;
          });
        });
  }

  EqTextField tcsrateTextField() {
    return EqTextField(
      controller: _pcspercentage,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      hintText: 'TCS (%)',
      labelText: 'TCS (%)',
      onTap: () {
        //gotoPartyScreen2(context, 'SALE PARTY', _party);
      },
      onChanged: (value) {},
    );
  }

  EqTextField tdsrateTextField() {
    return EqTextField(
      controller: _tdspercentage,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      hintText: 'TdS(%)',
      labelText: 'TDS (%)',
      onTap: () {
        //gotoAgentScreen(context);
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
