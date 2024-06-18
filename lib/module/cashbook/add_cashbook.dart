import 'dart:convert';
import 'dart:developer';

import 'package:cloud_mobile/module/cashbook/cashbooklist.dart';
import 'package:flutter/material.dart';

//import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/list/party_list.dart';

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/state_list.dart';

import 'package:cloud_mobile/common/bottombar.dart';

//// import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';



class CashBookAdd extends StatefulWidget {
  CashBookAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _CashBookAddState createState() => _CashBookAddState();
}

class _CashBookAddState extends State<CashBookAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _cashlist = [];
  List _partylist = [];

  String dropdownTrnType = 'DEPOSIT';

  TextEditingController _cash = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _trntype = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _narration = new TextEditingController();
  TextEditingController _amount = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _gstregno = new TextEditingController();
  var _jsonData = [];
  //TextEditingController _fromdatecontroller = new TextEditingController(text: 'dhaval');

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = curDate.toString().split(' ')[0];

    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> loadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = retconvdate(widget.xfbeg).toString();
    var todate = retconvdate(widget.xfend).toString();

    uri =
        'https://www.cloud.equalsoftlink.com/api/api_getcashbooklist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&id=' +
            id +
            '&startdate=' +
            fromdate +
            '&enddate=' +
            todate;
    print(uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    _cash.text = getValue(jsonData['book'], 'C');
    String inputDateString = getValue(jsonData['date'], 'C');
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String formattedDate = "${parts[0]}-${parts[1]}-${parts[2]}";
    _date.text = getValue(formattedDate, 'C');
    _trntype.text = getValue(jsonData['trntype'], 'C');
    _party.text = getValue(jsonData['party'], 'C');
    _narration.text = getValue(jsonData['narration'], 'C');
    _amount.text = getValue(jsonData['amount'], 'N');

    setState(() {
      dropdownTrnType = 'DEPOSIT';
      if (_trntype.text == 'PAYMENT') {
        dropdownTrnType = 'WITHDRAWL';
      }
    });

    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_date.text != '') {
      fromDate = retconvdate(_date.text, 'yyyy-mm-dd');
      //print(fromDate);
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _date.text = picked.toString().split(' ')[0];
      });
  }

  void setDefValue() {}

  @override
  Widget build(BuildContext context) {
    void gotoCashScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'CASH',
                  )));

      setState(() {
        var retResult = result;
        _cashlist = result[1];
        result = result[1];

        var selCash = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selCash = selCash + ',';
          }
          selCash = selCash + retResult[0][ictr];
        }

        _cash.text = selCash;
      });
    }

    void gotoPartyScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: '',
                  )));

      setState(() {
        var retResult = result;
        _partylist = result[1];
        result = result[1];

        var selParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }

        _party.text = selParty;
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var cash = _cash.text;
      var party = _party.text;
      var date = _date.text;
      var trntype = _trntype.text;
      var narration = _narration.text;
      var amount = _amount.text;

      var unadj = 'Y';

      var id = widget.xid;
      id = int.parse(id);

      uri =
          'https://www.cloud.equalsoftlink.com/api/api_storecashbook?dbname=' +
              db +
              '&date=' +
              date +
              '&cash=' +
              cash +
              '&trntype=' +
              trntype +
              '&party=' +
              party +
              '&narration=' +
              narration +
              '&amount=' +
              amount +
              '&user=' +
              username +
              '&cno=' +
              cno +
              '&id=' +
              id.toString();

      print(uri);
      var response = await http.post(Uri.parse(uri));

      var jsonData = jsonDecode(response.body);
      //print('4');

      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        showAlertDialog(context, 'Saved !!!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CashBookList(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }

      return true;
    }

    var items = [
      'DEPOSIT',
      'WITHDRAWL',
    ];

    setDefValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cash Book [ ' + (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') + ' ] ',
          style:
              TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
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
              controller: _date,
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Date',
                labelText: 'Date',
              ),
              onTap: () {
                _selectDate(context);
              },
              validator: (value) {
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cash,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Cash A/c',
                      labelText: 'Cash',
                    ),
                    onTap: () {
                      gotoCashScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print("You pressed Icon Elevated Button");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => PartyMasterAdd(
                      //               companyid: widget.xcompanyid,
                      //               companyname: widget.xcompanyname,
                      //               fbeg: widget.xfbeg,
                      //               fend: widget.xfend,
                      //               id: '0',
                      //             )));
                    },
                    icon: Icon(Icons.add), //icon data for elevated button
                    label: Text(""), //label text
                  ),
                ),
              ],
            ),
            DropdownButtonFormField(
                value: dropdownTrnType,
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
                    dropdownTrnType = newValue!;
                    _trntype.text = dropdownTrnType;
                  });
                }),
            TextFormField(
              controller: _party,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Select Party',
                labelText: 'Party',
              ),
              onTap: () {
                gotoPartyScreen(context);
              },
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              textCapitalization: TextCapitalization.characters,
              controller: _narration,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Narration',
                labelText: 'Narration',
              ),
              onChanged: (value) {
                _narration.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _narration.selection);
              },
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
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

