// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/moduleview.dart';
import 'package:cloud_mobile/module/master/samplemaster/samplemaster.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;
import 'package:intl/intl.dart';

class SampleMasterList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  SampleMasterList({Key? mykey, companyid, companyname, fbeg, fend})
    : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _SampleMasterListPageState createState() => _SampleMasterListPageState();
}

class _SampleMasterListPageState extends State<SampleMasterList> {

  List _companydetails = [];

  @override
  void initState() {
    super.initState();
    loaddetails();
  }

Future<bool> loaddetails() async {
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var startdate = globals.fbeg;
    var enddate = globals.fend;
    print(globals.enddate);

    DateTime parsedDate1 = DateFormat("dd-MM-yyyy").parse(startdate);
    String newstartdate = DateFormat("yyyy-MM-dd").format(parsedDate1); 

    DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(enddate);
    String newenddate = DateFormat("yyyy-MM-dd").format(parsedDate2); 

    String uri = '';
    uri =
        "${globals.cdomain}/api/api_samplemasterlist?dbname=$clientid&cno=$companyid&startdate=$newstartdate&enddate=$newenddate&list=true";
        
    var response = await http.get(Uri.parse(uri));
    print(' loaddetails : ' + uri);
    var jsonData = jsonDecode(response.body);
    this.setState(() {
      _companydetails = jsonData['Data'];
    });

    return true;
  }

  Future<bool> DeleteData(id) async {
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    String uri = '';
    uri =
        "${globals.cdomain}/api/api_masterdeletevld?dbname=$clientid&cno=$companyid&cfldkey=designmst&id=$id";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData['Code'];
    print(jsonData['Code']);
    if (jsonData['Code'].toString() != '100') {
      loaddetails();
      Fluttertoast.showToast(
        msg: "Sample Delete Successfully !!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.purple,
        fontSize: 16.0,
      );
    } else {
      loaddetails();
      Fluttertoast.showToast(
        msg: "Sample in Used !!!",
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

void onAdd() {
    print('You Clicked Add..');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SampleMaster(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  id: '0',
                ))).then((value) => loaddetails());
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
          title: const Text('Do You Want To Delete Sample Master !!??'),
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
                setState(() {
                  DeleteData(id);
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('NO'),
              onPressed: () {
                Navigator.pop(context);
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
            builder: (_) => SampleMaster(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  id: id.toString(),
                ))).then((value) => loaddetails());
  }

@override
  Widget build(BuildContext context) {
    return ModuleVIew(
      companyid: widget.xcompanyid,
      companyname: widget.xcompanyname,
      fbeg: widget.xfbeg,
      fend: widget.xfend,
      Data: this._companydetails,
      Title: 'List Of Sample',
      DataFormat: 'Date : #date#  Serial : #serial#  Branch : #branch#  Party : #party# ',
      onAdd: onAdd,
      onBack: onBack,
      onPDF: onPDF,
      onDel: onDel,
      onEdit: onEdit,
    );
  }
}

void doNothing(BuildContext context) {}
