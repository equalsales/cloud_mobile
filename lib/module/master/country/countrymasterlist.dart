// ignore_for_file: must_be_immutable

import 'package:cloud_mobile/module/master/country/countrymaster.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/moduleview.dart';
import '../../../common/global.dart' as globals;


class CountryMasterList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  CountryMasterList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _CountryMasterListPageState createState() => _CountryMasterListPageState();
}

class _CountryMasterListPageState extends State<CountryMasterList> {
  List _companydetails = [];
  
  @override
  void initState() {
    super.initState();
    loaddetails();
  }


Future<bool> loaddetails() async {
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    print(globals.enddate);

    String uri = '';
    uri = "https://www.cloud.equalsoftlink.com/api/api_countrylist?dbname=$clientid&cno=$companyid";
    print(uri);
    var response = await http.get(Uri.parse(uri));
  
    var jsonData = jsonDecode(response.body);

    print(jsonData);

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
        "https://www.cloud.equalsoftlink.com/api/api_masterdeletevld?dbname=$clientid&cno=$companyid&cfldkey=countrymst&id=$id";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData['Code'];
    print(jsonData['Code']);
    if (jsonData['Code'].toString() != '100') {
      loaddetails();
      Fluttertoast.showToast(
        msg: "Country Delete Successfully !!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: const Color.fromRGBO(156, 39, 176, 1),
        fontSize: 16.0,
      );
    } else {
      loaddetails();
      Fluttertoast.showToast(
        msg: "Country in Used !!!",
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
            builder: (_) => CountryMaster(
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
          title: const Text('Do You Want To Delete Country Master !!??'),
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
            builder: (_) => CountryMaster(
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
      Title: 'List Of Country',
      DataFormat: 'Country : #country#  ',
      onAdd: onAdd,
      onBack: onBack,
      onPDF: onPDF,
      onDel: onDel,
      onEdit: onEdit,
    );
  }
}

void doNothing(BuildContext context) {}
