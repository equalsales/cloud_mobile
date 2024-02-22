import 'package:cloud_mobile/common/moduleview.dart';
import 'package:cloud_mobile/dashboard/sidebar.dart';
import 'package:cloud_mobile/module/salebill/add_salebill.dart';
import 'package:flutter/material.dart';


import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;


//// import 'package:google_fonts/google_fonts.dart';

//import 'package:cloud_mobile/module/looms/greyjobissue/add_loomgreyjobissue.dart';

class SalesBillList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  SalesBillList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _SalesBillListPageState createState() => _SalesBillListPageState();
}

class _SalesBillListPageState extends State<SalesBillList> {
  List _companydetails = [];
  
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var startdate = globals.startdate;
    var enddate = globals.enddate;
    //print(globals.enddate);

    String uri = '';
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_getsalebilllist?dbname=$clientid&cno=$companyid&startdate=${startdate.toString()}&enddate=${enddate.toString()}";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);

    //print(uri);

    this.setState(() {
      _companydetails = jsonData['Data'];
    });

    return true;
  }


void onAdd() {
    print('You Clicked Add..');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SalesBillAdd(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  id: '0',
                  partyname: ''
                )));
  }

  void onBack() {
    print('You Clicked Back..');
    Navigator.pop(context);
  }

  void onPDF(id) {
    print(id);
    print('Clicked PDF');
  }

  void onDel(id) {
    print('Del Clicked...');
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        //saveData();
        return AlertDialog(
          title: const Text('Do You Want To Delete Sale Bill Add !!??'),
          content: Container(
            height: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('YES'),
              onPressed: () {
                // setState(() {
                //   // deleteRow(iCtr);
                // });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onEdit(id) {
    print('Clicked Edit');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SalesBillAdd(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  id: id.toString(),
                  partyname: ''
                )));
  }

@override
  Widget build(BuildContext context) {
    return ModuleVIew(
      companyid: widget.xcompanyid,
      companyname: widget.xcompanyname,
      fbeg: widget.xfbeg,
      fend: widget.xfend,
      Data: this._companydetails,
      Title: 'List Of Sale Bill',
      DataFormat: 'Date : #date#  Serial : #serial#  Party : #party#  Agent : #agent#  Book : #book#  Remarks : #remarks#   TotalQty : #totmtrs#',
      onAdd: onAdd,
      onBack: onBack,
      onPDF: onPDF,
      onDel: onDel,
      onEdit: onEdit,
    );
  }
}

void doNothing(BuildContext context) {}