import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/master/partymaster/add_partymaster.dart';

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
    void takeAction() {}

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
          int newid = 0;
          newid = int.parse(id);
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
                  style:
                      TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
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
            ))),
          );
          // return Dismissible(
          //   key: UniqueKey(),
          //   // only allows the user swipe from right to left
          //   direction: DismissDirection.endToStart,
          //   // Remove this product from the list
          //   // In production enviroment, you may want to send some request to delete it on server side
          //   onDismissed: (_) {
          //     setState(() {
          //       this._companydetails.removeAt(index);
          //     });
          //   },
          //   // This will show up when the user performs dismissal action
          //   // It is a red background and a trash icon
          //   background: Container(
          //     color: Colors.red,
          //     margin: const EdgeInsets.symmetric(horizontal: 15),
          //     alignment: Alignment.centerRight,
          //     child: const Icon(
          //       Icons.delete,
          //       color: Colors.white,
          //     ),
          //   ),
          //   child: Card(
          //       child: Center(
          //           child: ListTile(
          //     title: Text(name + ' [ ' + id + ' ]',
          //         style:
          //             TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
          //     subtitle: Text(
          //         'Type : ' +
          //             acctype +
          //             ' Schedule : ' +
          //             acchead +
          //             ' ' +
          //             address +
          //             ' Mobile No : ' +
          //             phoneno +
          //             ' ' +
          //             mobileno,
          //         style:
          //             TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
          //     leading: Icon(Icons.select_all),
          //     trailing: Icon(Icons.arrow_forward),
          //     onTap: () {
          //       ///showAlertDialog(context, id);

          //       //var editInfo = {};
          //       //editInfo['id'] = id;

          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (_) => PartyMasterAdd(
          //                     companyid: widget.xcompanyid,
          //                     companyname: widget.xcompanyname,
          //                     fbeg: widget.xfbeg,
          //                     fend: widget.xfend,
          //                     id: id,
          //                   )));
          //     },
          //   ))),
          // );
          // Card(
          //     child: Center(
          //         child: ListTile(
          //   title: Text(name + ' [ ' + id + ' ]',
          //       style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
          //   subtitle: Text(
          //       'Type : ' +
          //           acctype +
          //           ' Schedule : ' +
          //           acchead +
          //           ' ' +
          //           address +
          //           ' Mobile No : ' +
          //           phoneno +
          //           ' ' +
          //           mobileno,
          //       style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
          //   leading: Icon(Icons.select_all),
          //   trailing: Icon(Icons.arrow_forward),
          //   onTap: () {
          //     ///showAlertDialog(context, id);

          //     //var editInfo = {};
          //     //editInfo['id'] = id;

          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => PartyMasterAdd(
          //                   companyid: widget.xcompanyid,
          //                   companyname: widget.xcompanyname,
          //                   fbeg: widget.xfbeg,
          //                   fend: widget.xfend,
          //                   id: id,
          //                 )));
          //   },
          // )));
        },
      )),
    );
  }
}

void execDelete(BuildContext context, int index, int id, String name) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Account ??'),
      content: Text('Do you want to delete this account ' + name + ' ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            var db = globals.dbname;

            var response = await http.post(Uri.parse(
                'https://www.cloud.equalsoftlink.com/api/api_delparty?dbname=' +
                    db +
                    '&id=' +
                    id.toString()));

            var jsonData = jsonDecode(response.body);
            var code = jsonData['Code'];
            if (code == '200') {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PartyMasterList(
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
  // // set up the buttons
  // Widget cancelButton = ElevatedButton(
  //   child: Text("Cancel"),
  //   onPressed: () {
  //     Navigator.pop(context, 'Cancel');
  //   },
  // );
  // Widget continueButton = ElevatedButton(
  //   child: Text("Delete"),
  //   onPressed: () {
  //     deleteParty(id);
  //   },
  // );
  // // set up the AlertDialog
  // AlertDialog alert = AlertDialog(
  //   title: Text("Delete Dialog"),
  //   content: Text("Would you like to delet this account?"),
  //   actions: [
  //     cancelButton,
  //     continueButton,
  //   ],
  // );

  // // show the dialog
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  // );

  //showAlertDialog(context, index.toString() + '  ' + id.toString());
  return;
}

Future<bool> deleteParty(id) async {
  var db = globals.dbname;

  var response = await http.post(Uri.parse(
      'https://www.cloud.equalsoftlink.com/api/api_delparty?dbname=' +
          db +
          '&id=' +
          id.toString()));

  print('https://www.cloud.equalsoftlink.com/api/api_delparty?dbname=' +
      db +
      '&id=' +
      id.toString());

  print('here');
  var jsonData = jsonDecode(response.body);
  print('here2');
  print(jsonData);

  var code = jsonData['Code'];
  if (code == '200') {
    print('in....');
    // await Navigator.push(
    //     BuildContext context,
    //     MaterialPageRoute(
    //         builder: (_) => PartyMasterList(
    //             companyid: globals.companyid,
    //             companyname: globals.companyname,
    //             fbeg: globals.fbeg,
    //             fend: globals.fend)));
  } else {}

  return true;
}

void doNothing(BuildContext context) {}
