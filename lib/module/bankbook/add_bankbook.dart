import 'dart:convert';
import 'dart:developer';

import 'package:cloud_mobile/module/bankbook/bankbooklist.dart';
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

class BankBookAdd extends StatefulWidget {
  BankBookAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _BankBookAddState createState() => _BankBookAddState();
}

class _BankBookAddState extends State<BankBookAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _banklist = [];
  List _partylist = [];

  String dropdownTrnType = 'DEPOSIT';

  TextEditingController _bank = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _trntype = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _cheque = new TextEditingController();
  TextEditingController _chqdate = new TextEditingController();
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
    _chqdate.text = curDate.toString().split(' ')[0];

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
        '${globals.cdomain2}/api/api_getbankbooklist?dbname=' +
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

    _bank.text = getValue(jsonData['book'], 'C');
    String inputDateString = getValue(jsonData['date'], 'C');
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String formattedDate = "${parts[0]}-${parts[1]}-${parts[2]}";
    _date.text = getValue(formattedDate, 'C');
    _trntype.text = getValue(jsonData['trntype'], 'C');
    _party.text = getValue(jsonData['party'], 'C');
    _cheque.text = getValue(jsonData['cheque'], 'C');
    _chqdate.text = getValue(jsonData['chedate'], 'C');
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
    void gotoBankScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'BANK',
                  )));

      setState(() {
        var retResult = result;
        _banklist = result[1];
        result = result[1];

        var selBank = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selBank = selBank + ',';
          }
          selBank = selBank + retResult[0][ictr];
        }

        _bank.text = selBank;
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
      var bank = _bank.text;
      var party = _party.text;
      var date = _date.text;
      var trntype = _trntype.text;
      var cheque = _cheque.text;
      var chqdate = _chqdate.text;
      var narration = _narration.text;
      var amount = _amount.text;

      var unadj = 'Y';

      var id = widget.xid;
      id = int.parse(id);

      uri =
          '${globals.cdomain2}/api/api_storebankbook?dbname=' +
              db +
              '&date=' +
              date +
              '&bank=' +
              bank +
              '&trntype=' +
              trntype +
              '&party=' +
              party +
              '&cheque=' +
              cheque +
              '&chedate=' +
              chqdate +
              '&narration=' +
              narration +
              '&amount=' +
              amount +
              '&chqbank=' +
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
                builder: (_) => BankBookList(
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
          'Bank Book [ ' + (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') + ' ] ',
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
            TextFormField(
              controller: _bank,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Select Bank',
                labelText: 'Bank',
              ),
              onTap: () {
                gotoBankScreen(context);
              },
              validator: (value) {
                return null;
              },
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
              controller: _cheque,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Cheque No',
                labelText: 'Cheque',
              ),
              onChanged: (value) {
                _cheque.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _cheque.selection);
              },
              onTap: () {},
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _chqdate,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Cheque Date',
                labelText: 'Cheque Dt',
              ),
              onTap: () {
                _selectDate(context);
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
