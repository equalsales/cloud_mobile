import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;

import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/master/partygroupmaster/add_partygroupmaster.dart';

class PartyGroupMasterList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  PartyGroupMasterList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _PartyGroupMasterListPageState createState() =>
      _PartyGroupMasterListPageState();
}

class _PartyGroupMasterListPageState extends State<PartyGroupMasterList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;

    var response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/getpartygrplist?dbname=' +
            db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    this.setState(() {
      _companydetails = jsonData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    void takeAction() {}

    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Account Groups',
            style: GoogleFonts.abel(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PartyGroupMasterAdd(
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
          String name = this._companydetails[index]['acgroup'];
          String id = this._companydetails[index]['id'].toString();
          int newid = 0;
          newid = int.parse(id);
          String address = '';

          return Slidable(
            key: ValueKey(index),
            startActionPane:
                ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                  onPressed: (context) =>
                      {execDelete(context, index, int.parse(id), name)},
                  icon: Icons.delete,
                  label: 'Delete',
                  backgroundColor: Color(0xFFFE4A49)),
              SlidableAction(
                  onPressed: (context) => {},
                  icon: Icons.edit,
                  label: 'Edit',
                  backgroundColor: Colors.blue)
            ]),
            child: Card(
                child: Center(
                    child: ListTile(
              title: Text(name + ' [ ' + id + ' ]',
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
              subtitle: Text('',
                  style:
                      TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.select_all),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PartyGroupMasterAdd(
                              companyid: widget.xcompanyid,
                              companyname: widget.xcompanyname,
                              fbeg: widget.xfbeg,
                              fend: widget.xfend,
                              id: id,
                            )));
              },
            ))),
          );
        },
      )),
    );
  }
}

void execDelete(BuildContext context, int index, int id, String name) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Group ??'),
      content: Text('Do you want to delete this group ' + name + ' ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            var db = globals.dbname;

            var response = await http.post(Uri.parse(
                'https://www.cloud.equalsoftlink.com/api/api_delpartygrp?dbname=' +
                    db +
                    '&id=' +
                    id.toString()));

            var jsonData = jsonDecode(response.body);
            var code = jsonData['Code'];
            if (code == '200') {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PartyGroupMasterList(
                          companyid: globals.companyid,
                          companyname: globals.companyname,
                          fbeg: globals.fbeg,
                          fend: globals.fend)));
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return;
}

void doNothing(BuildContext context) {}
