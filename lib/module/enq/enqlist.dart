import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

//// import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/enq/add_enq.dart';

class EnqList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  EnqList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _EnqListPageState createState() => _EnqListPageState();
}

class _EnqListPageState extends State<EnqList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;
    var response = await http.get(Uri.parse(
        '${globals.cdomain2}/api/api_enqlist?dbname=' + db));

    print('${globals.cdomain2}/api/api_enqlist?dbname=' + db);
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
        title: Text('List Of Enquiry',
            style: TextStyle(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EnqAdd(
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
          String name = this._companydetails[index]['name'];
          String id = this._companydetails[index]['id'].toString();
          String address = this._companydetails[index]['address'].toString() +
              '-' +
              this._companydetails[index]['city'].toString();
          String amount = this._companydetails[index]['amount'].toString();
          String amc = this._companydetails[index]['amc'].toString();

          return Card(
              child: Center(
                  child: ListTile(
            title: Text(name + ' [ ' + id + ' ]',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
            subtitle: Text(address),
            leading: Icon(Icons.select_all),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ///showAlertDialog(context, id);

              //var editInfo = {};
              //editInfo['id'] = id;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EnqAdd(
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
