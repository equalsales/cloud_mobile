import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/function.dart';

import '../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/bankbook/add_bankbook.dart';

class BankBookList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  BankBookList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _BankBookListPageState createState() => _BankBookListPageState();
}

class _BankBookListPageState extends State<BankBookList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;
    var cno = widget.xcompanyid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;

    var response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/api_getbankbooklist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            fromdate +
            '&enddate=' +
            todate));

    print(
        'https://www.cloud.equalsoftlink.com/api/api_getbankbooklist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            fromdate +
            '&enddate=' +
            todate);
    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    print(jsonData);

    this.setState(() {
      _companydetails = jsonData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Book List',
            style: GoogleFonts.abel(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BankBookAdd(
                        companyid: widget.xcompanyid,
                        companyname: widget.xcompanyname,
                        fbeg: widget.xfbeg,
                        fend: widget.xfend,
                        id: '0',
                      )))
        },
      ),
      body: Center(
          child: ListView.builder(
        itemCount: this._companydetails.length,
        itemBuilder: (context, index) {
          print(this._companydetails[index]);
          String date = this._companydetails[index]['date2'].toString();
          //date = retconvdatestr(date);
          String serial = this._companydetails[index]['serial'].toString();
          String trntype = this._companydetails[index]['trntype'].toString();
          String bank = this._companydetails[index]['book'].toString();
          String party = this._companydetails[index]['party'].toString();
          String cheque = this._companydetails[index]['cheque'].toString();
          String narration =
              this._companydetails[index]['narration'].toString();
          String amount = this._companydetails[index]['amount'].toString();

          String id = this._companydetails[index]['id'].toString();
          if (trntype == 'RECEIPT') {
            trntype = 'DEPOSIT';
          } else {
            trntype = 'WITHDRAWL';
          }

          return Card(
              child: Center(
                  child: ListTile(
            title: Text(
                'Dt :' +
                    date +
                    ' Bank : ' +
                    bank +
                    ' [ ' +
                    id +
                    ' ]' +
                    ' Party : ' +
                    party,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
            subtitle: Text(
                'Type :' +
                    trntype +
                    ' Cheque : ' +
                    cheque +
                    ' Amount : ' +
                    amount +
                    ' Narration :' +
                    narration,
                style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),
            leading: Icon(Icons.select_all),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ///showAlertDialog(context, id);

              //var editInfo = {};
              //editInfo['id'] = id;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BankBookAdd(
                            companyid: widget.xcompanyid,
                            companyname: widget.xcompanyname,
                            fbeg: widget.xfbeg,
                            fend: widget.xfend,
                            id: id,
                          )));
            },
          )));
        },
      )),
    );
  }
}
