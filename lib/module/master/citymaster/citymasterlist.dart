import 'package:cloud_mobile/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

//// import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_mobile/module/master/citymaster/add_citymaster.dart';

class CityMasterList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  CityMasterList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _CityMasterListPageState createState() => _CityMasterListPageState();
}

class _CityMasterListPageState extends State<CityMasterList> {
  List _companydetails = [];
  @override
  void initState() {
    loaddetails();
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;

    var response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/getcitylist?dbname=' + db));

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
        title: Text('List Of City',
            style: TextStyle(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CityMasterAdd(
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
          String name = this._companydetails[index]['city'];
          String state = this._companydetails[index]['state'];
          String distance = this._companydetails[index]['distance'].toString();

          state = getValue(state, 'C');
          distance = getValue(distance, 'C');

          String id = this._companydetails[index]['id'].toString();
          int newid = 0;
          newid = int.parse(id);

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
              subtitle: Text('State  : ' + state + ' Distance : ' + distance,
                  style:
                      TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.select_all),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CityMasterAdd(
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
      title: const Text('Delete City ??'),
      content: Text('Do you want to delete this City ' + name + ' ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            var db = globals.dbname;

            var response = await http.post(Uri.parse(
                'https://www.cloud.equalsoftlink.com/api/api_delcity?dbname=' +
                    db +
                    '&id=' +
                    id.toString()));

            print(
                'https://www.cloud.equalsoftlink.com/api/api_delcity?dbname=' +
                    db +
                    '&id=' +
                    id.toString());

            var jsonData = jsonDecode(response.body);
            var code = jsonData['Code'];
            if (code == '200') {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CityMasterList(
                          companyid: globals.companyid,
                          companyname: globals.companyname,
                          fbeg: globals.fbeg,
                          fend: globals.fend)));
            } else if (code == '500') {
              showAlertDialog(context, jsonData['Message']);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  return;
}

Future<bool> deleteCity(id) async {
  var db = globals.dbname;

  var response = await http.post(Uri.parse(
      'https://www.cloud.equalsoftlink.com/api/api_delcity?dbname=' +
          db +
          '&id=' +
          id.toString()));

  print('https://www.cloud.equalsoftlink.com/api/api_delcity?dbname=' +
      db +
      '&id=' +
      id.toString());

  var jsonData = jsonDecode(response.body);

  var code = jsonData['Code'];
  if (code == '200') {
  } else {}

  return true;
}

void doNothing(BuildContext context) {}
