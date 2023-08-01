import 'package:cloud_mobile/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/looms/greyjobissue/add_loomgreyjobissue.dart';

class LoomGreyJobIssueList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  LoomGreyJobIssueList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _LoomGreyJobIssueListPageState createState() =>
      _LoomGreyJobIssueListPageState();
}

class _LoomGreyJobIssueListPageState extends State<LoomGreyJobIssueList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;
    var cno = globals.companyid;
    var startdate = globals.fbeg;
    var enddate = globals.fend;

    print(globals.enddate);

    var response = await http.get(Uri.parse(
        'https://www.looms.equalsoftlink.com/api/api_getgreyjobissuelist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            startdate +
            '&enddate=' +
            enddate));

    print(
        'https://www.looms.equalsoftlink.com/api/api_getgreyjobissuelist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            startdate +
            '&enddate=' +
            enddate);

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    this.setState(() {
      _companydetails = jsonData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grey Jobwork List',
            style: GoogleFonts.abel(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => GreyJobIssueAdd(
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
          String date = this._companydetails[index]['date2'].toString();
          //date = retconvdatestr(date);
          String serial = this._companydetails[index]['serial'].toString();
          String type =
              this._companydetails[index]['type'].toString();
          String party = this._companydetails[index]['party'].toString();
          String remarks = this._companydetails[index]['remarks'].toString();
          String totpcs = '0';//this._companydetails[index]['totpcs'].toString();
          String totmtrs = '0';//this._companydetails[index]['totmtrs'].toString();

          String id = this._companydetails[index]['id'].toString();

          int newid = 0;
          newid = int.parse(id);

          return Slidable(
            key: ValueKey(index),
            startActionPane:
                ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                  onPressed: (context) =>
                      {/*execDelete(context, index, int.parse(id), '')*/},
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
              title: Text(
                  'Dt :' +
                      date +
                      ' Type : ' +
                      type +
                      ' Serial No : ' +
                      serial +
                      ' [ ' +
                      id +
                      ' ]' +
                      ' Party : ' +
                      party,
                  style:
                      TextStyle(fontFamily: 'verdana',
                        fontSize: 10.0, fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Remarks :' +
                      remarks +
                      ' Pcs : ' +
                      totpcs +
                      ' Meters : ' +
                      totmtrs,
                  style:
                      TextStyle(fontFamily: 'verdana',fontSize: 10.0, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.select_all),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GreyJobIssueAdd(
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
      title: const Text('Delete Sales Challan Entry ??'),
      content: Text('Do you want to delete this entry ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // var db = globals.dbname;
            // var cno = globals.companyid;

            // var response = await http.post(Uri.parse(
            //     'https://www.cloud.equalsoftlink.com/api/api_deletecashbook?dbname=' +
            //         db +
            //         '&cno=' +
            //         cno +
            //         '&id=' +
            //         id.toString()));

            // print(
            //     'https://www.cloud.equalsoftlink.com/api/api_deletecashbook?dbname=' +
            //         db +
            //         '&id=' +
            //         id.toString());

            // var jsonData = jsonDecode(response.body);
            // var code = jsonData['Code'];
            // if (code == '200') {
            //   await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => LoomGreyJobIssueList(
            //               companyid: globals.companyid,
            //               companyname: globals.companyname,
            //               fbeg: globals.fbeg,
            //               fend: globals.fend)));
            // } else if (code == '500') {
            //   showAlertDialog(context, jsonData['Message']);
            // }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  return;
}

void doNothing(BuildContext context) {}
