import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/report/account/report_ledger.dart';
//import 'package:myfirstapp/screens/account/ledger_report.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/state_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

import 'package:cloud_mobile/common/reportpdf.dart';

//import 'package:myfirstapp/screens/dashboard/sidebar.dart';

import 'package:cloud_mobile/common/pdf_api.dart';
import 'package:cloud_mobile/common/pdf_report_api.dart';
import 'package:cloud_mobile/main.dart';
import 'package:cloud_mobile/common/customer.dart';
import 'package:cloud_mobile/common/invoice.dart';
import 'package:cloud_mobile/common/supplier.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';

class PartyMasterAdd extends StatefulWidget {
  PartyMasterAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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

  @override
  _PartyMasterAddState createState() => _PartyMasterAddState();
}

class _PartyMasterAddState extends State<PartyMasterAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _citylist = [];
  List _statelist = [];

  String dropdownvalueType = '';
  String dropdownvalueBusiness = '';

  TextEditingController _acchead = new TextEditingController();
  TextEditingController _acctype = new TextEditingController();
  TextEditingController _addr1 = new TextEditingController();
  TextEditingController _addr2 = new TextEditingController();
  TextEditingController _addr3 = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _citysel = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _gstregno = new TextEditingController();
  var _jsonData = [];
  TextEditingController _mobileno = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');
  List _partylist = [];

  TextEditingController _phoneno = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _statesel = new TextEditingController();

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    if (int.parse(widget.xid) > 0) {
      loadData();
    }

    //print('====================================');
    //print(widget.xid);

    //_fromdate.text = fromDate.toString().split(' ')[0];

    //print('0');
    //_todate.text = toDate.toString().split(' ')[0];
  }

  Future<bool> loadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;

    uri = 'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=' +
        db +
        '&id=' +
        id;
    //print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);
    //print('4');

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    //print(jsonData);

    _party.text = getValue(jsonData['party'], 'C');
    _addr1.text = getValue(jsonData['addr1'], 'C');
    _addr2.text = getValue(jsonData['addr2'], 'C');
    _addr3.text = getValue(jsonData['addr3'], 'C');
    _city.text = getValue(jsonData['city'], 'C');
    _state.text = getValue(jsonData['state'], 'C');
    _pincode.text = getValue(jsonData['pincode'], 'C');
    _phoneno.text = getValue(jsonData['phoneno'], 'C');
    _mobileno.text = getValue(jsonData['mobileno'], 'C');
    _acchead.text = getValue(jsonData['acchead'], 'C');
    _acctype.text = getValue(jsonData['acctype'], 'C');
    _gstregno.text = getValue(jsonData['gstregno'], 'C');

    setState(() {
      dropdownvalueType = _acctype.text;
      dropdownvalueBusiness = _acchead.text;
    });

    //print(jsonData['acchead']);

    return true;
  }

  void setDefValue() {
    //_node.text = '0';
    //_amc.text = '0';
    //_amount.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    void gotoCityScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => city_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;
        _citylist = result[1];
        result = result[1];
        //print(retResult[0][0]);
        var selCity = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selCity = selCity + ',';
          }
          selCity = selCity + retResult[0][ictr];
        }
        //print(selCity);
        //_citysel.text = selCity;
        _city.text = selCity;
        //print(selCity);
        if (selCity != '') {
          getCityDetails(_city.text, 0).then((value) {
            setState(() {
              _state.text = value[0]['state'];
            });
          });
        }
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
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;
        _statelist = result[1];
        result = result[1];
        //print(retResult[0][0]);
        var selState = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selState = selState + ',';
          }
          selState = selState + retResult[0][ictr];
        }
        //print(selCity);
        _state.text = selState;
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var party = _party.text;
      var addr1 = _addr1.text;
      var addr2 = _addr2.text;
      var addr3 = _addr3.text;
      var city = _city.text;
      var state = _state.text;
      var pincode = _pincode.text;
      var phoneno = _phoneno.text;
      var mobileno = _mobileno.text;
      var acchead = _acchead.text;
      var acctype = _acctype.text;
      var gstregno = _gstregno.text;
      var agent = '';
      var transport = '';

      var id = widget.xid;
      id = int.parse(id);

      uri = 'https://www.cloud.equalsoftlink.com/api/api_addparty?dbname=' +
          db +
          '&party=' +
          party +
          '&acctype=' +
          acctype +
          '&acchead=' +
          acchead +
          '&accgroup=' +
          '&country=' +
          '&state=' +
          state +
          '&city=' +
          city +
          '&agent=' +
          agent +
          '&transport=' +
          transport +
          '&user=' +
          username +
          '&gstregno=' +
          gstregno +
          '&grpcode=' +
          '&grpcodeno=' +
          '&addr1=' +
          addr1 +
          '&addr2=' +
          addr2 +
          '&addr3=' +
          addr3 +
          '&pincode=' +
          pincode +
          '&phoneno=' +
          phoneno +
          '&mobileno=' +
          mobileno +
          '&email=' +
          '&duedays=0' +
          '&discper=0' +
          '&tdsper=0' +
          '&intper=0' +
          '&tcsper=0' +
          '&panno=' +
          '&rdurd=' +
          '&rcm=' +
          '&remarks=' +
          '&crlimit=0' +
          '&cno=' +
          cno +
          '&id=' +
          id.toString();

      //print(uri);
      var response = await http.post(Uri.parse(uri));

      var jsonData = jsonDecode(response.body);
      //print('4');

      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      //print('------------------------------');
      //print(jsonData);
      //print(jsonCode);

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        showAlertDialog(context, 'Saved !!!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PartyMasterList(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }

      return true;
    }

    //print('here2');
    //String dropdownvalueType = '';
    //print(_acchead.text);
    // if (_acchead.text != '') {
    //   dropdownvalueType = _acchead.text;
    // }
    var items = [
      '',
      'SALE PARTY',
      'PURCHASE PARTY',
      'BANK',
      'CASH',
      'PURCHASE BOOK',
      'SALE BOOK',
      'PURCHASE RETURN BOOK',
      'SALE RETURN BOOK',
      'ADD-LESS A/C',
      'AGENT',
      'CAPITAL',
      'EMB SALE PARTY',
      'EXPENSE BOOK',
      'GENERAL PURCHASE PARTY',
      'GENERAL SALE PARTY',
      'GENERAL PURCHASE BOOK',
      'GREY PARTY',
      'GREY PURCHASE BOOK',
      'GREY RETURN BOOK',
      'GREY SALE BOOK',
      'GREY SALE RETURN BOOK',
      'INCOME',
      'JOBWORK BOOK',
      'JOBWORK PARTY',
      'JOBWORK RETURN BOOK',
      'LOAN AND ADVANCE',
      'MILL',
      'PROCESS BOOK',
      'TDS',
      'TCS',
      'TRADING EXPENSE',
      'TRADING INCOME'
    ];

    //String dropdownvalueBusiness = 'TRADING';
    //String dropdownvalueBusiness = '';
    var itemsBusiness = [
      '',
      'SUNDRY CREDITORS',
      'SUNDRY DEBTOR',
      'TRADING EXPENSE',
      'TRADING INCOME',
      'CAPITAL A/C',
      'CASH & BANK',
      'CLOSING STOCK',
      'CREDITOR FOR BROKERAGE',
      'CREDITOR FOR EXPENSE',
      'CREDITOR FOR FINANCE',
      'CREDITOR FOR GOODS',
      'CREDITOR FOR OTHER',
      'CREDITOR FOR PROCESS',
      'CREDITORS FOR GREY',
      'DEBTOR FOR OTHER',
      'FIXED ASSET',
      'FURNITURE/OFFICE ASSET',
      'INVESTMENT',
      'LAND & BUILDINGS',
      'LOANS & ADVANCES',
      'MANUFACTURING EXPENSE',
      'MANUFACTURING INCOME',
      'OFFICE AND FURNITURE',
      'OPENING STOCK',
      'PROFIT & LOSS EXPENSE',
      'PROFIT & LOSS INCOME',
      'PURCHASE',
      'PURCHASE RETURN',
      'RESERVE & SURPLUSES',
      'SALES',
      'SALES RETURN'
    ];
    //itemsBusiness = [];

    setDefValue();

    print('1');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Party / Account [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ',
          style:
              GoogleFonts.abel(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {saveData()}),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.characters,
              controller: _party,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Name Of Account',
                labelText: 'Name Of Account',
              ),
              onChanged: (value) {
                _party.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _party.selection);
              },
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addr1,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address 1',
                labelText: 'Address',
              ),
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addr2,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address 2',
                labelText: '',
              ),
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addr3,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Address 3',
                labelText: '',
              ),
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'City',
                labelText: 'City',
              ),
              onTap: () {
                gotoCityScreen(context);
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _state,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'State',
                labelText: 'State',
              ),
              onTap: () {
                gotoStateScreen(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _phoneno,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Phone No',
                labelText: 'Phone No',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _mobileno,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Mobile',
                labelText: 'Mobile',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _gstregno,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'GSTIN',
                labelText: 'GSTIN',
              ),
              onTap: () {
                //_selecttoDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            DropdownButtonFormField(
                value: dropdownvalueType,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: 'Type',
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down_circle),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalueType = newValue!;
                    _acctype.text = dropdownvalueType;
                  });
                }),
            DropdownButtonFormField(
                value: dropdownvalueBusiness,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: 'Type Of Business',
                ),
                items: itemsBusiness.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down_circle),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalueBusiness = newValue!;
                    _acchead.text = dropdownvalueBusiness;
                    ;
                  });
                }),
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
