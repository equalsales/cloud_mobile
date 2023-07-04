import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/master/partymaster/add_partymaster';

class PartyMasterList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  PartyMasterList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _PartyMasterListPageState createState() => _PartyMasterListPageState();
}

class _PartyMasterListPageState extends State<PartyMasterList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;

    var response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=' +
            db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    //print(jsonData);

    this.setState(() {
      _companydetails = jsonData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Account',
            style: GoogleFonts.abel(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PartyMasterAdd(
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
          String name = this._companydetails[index]['party'];
          String id = this._companydetails[index]['id'].toString();
          String address = this._companydetails[index]['addr1'].toString() +
              ' ' +
              this._companydetails[index]['addr2'].toString() +
              ' ' +
              this._companydetails[index]['addr3'].toString() +
              '-' +
              this._companydetails[index]['city'].toString();
          String phoneno = this._companydetails[index]['phoneno'].toString();
          String mobileno = this._companydetails[index]['mobileno'].toString();
          String gstregno = this._companydetails[index]['gstregno'].toString();
          String acctype = this._companydetails[index]['acctype'].toString();
          String acchead = this._companydetails[index]['acchead'].toString();

          return Card(
              child: Center(
                  child: ListTile(
            title: Text(name + ' [ ' + id + ' ]',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
            subtitle: Text(
                'Type : ' +
                    acctype +
                    ' Schedule : ' +
                    acchead +
                    ' ' +
                    address +
                    ' Mobile No : ' +
                    phoneno +
                    ' ' +
                    mobileno,
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
            leading: Icon(Icons.select_all),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ///showAlertDialog(context, id);

              //var editInfo = {};
              //editInfo['id'] = id;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PartyMasterAdd(
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
