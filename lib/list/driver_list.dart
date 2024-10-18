// ignore_for_file: must_be_immutable

import 'package:cloud_mobile/projFunction.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class DriverList extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Driver List';
  DriverList(
      {Key? mykey, companyid, companyname, fbeg, fend, acctype, caption = ''})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xacctype = acctype;
    Title = caption;
  }
  @override
  DriverListState createState() => DriverListState();
}

class DriverListState extends State<DriverList> {
  List _driverlist = [];
  List _orgdriverlist = [];
  List _driverSelected = [];
  List _driverSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    getdriverlist();
  }

  Future<bool> getdriverlist() async {
    var response;
    var db = globals.dbname;
    var cno = globals.companyid;

    String url = '${globals.cdomain}/api/api_getdriverlist?dbname=$db&cno=$cno';

    print(" getdriverlist : " + url);

    response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];

    this.setState(() {
      _driverlist = jsonData;
      _orgdriverlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Driver List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          add(),
          buildSearch(),
          Text("${_driverSelected}"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, [_driverSelected, _driverSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._driverlist.length,
            itemBuilder: (context, index) {
              int id = this._driverlist[index]['id'];
              String account = this._driverlist[index]['driver'];
              String driver = this._driverlist[index]['driver'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(driver),
                onTap: () {
                  setState(() {
                    _selected[index] = !_selected[index];

                    String driver = _driverlist[index]['driver'];
                    int id = _driverlist[index]['id'];

                    if (_selected[index]) {
                      _driverSelected.add(driver);
                      _driverSelected2.add(id);
                    } else {
                      _driverSelected.remove(driver);
                      _driverSelected2.remove(id);
                    }
                  });
                },
              );
            },
          ))
        ],
      ),
    );
  }

  Widget add() {
    if (query.length >= 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    // Change your radius here
                    borderRadius: BorderRadius.circular(0),
                  ))),
              onPressed: () {
                driverMaster_Add(context, widget.xcompanyid,
                        widget.xcompanyname, widget.xfbeg, widget.xfend, query)
                    .then((result) {
                  _driverSelected.add(result[0]);
                  _driverSelected2.add(result[1]);
                  Navigator.pop(context, [_driverSelected, _driverSelected2]);
                });
              },
              child: Text('Add'),
            ),
          ],
        ),
      );
    } else {
      print("Not add");
      return Container();
    }
  }

  // Widget buildSearch() => SearchWidget(
  //       text: query,
  //       hintText: 'Search',
  //       onChanged: searchdriver,
  //     );
  // void searchdriver(String query) {
  //   if (query.length >= 2) {
  //     final drivers = _orgdriverlist.where((driver) {
  //       final titlelower = driver.toString().toLowerCase();
  //       final searchlower = query.toLowerCase();
  //       return titlelower.contains(searchlower);
  //     }).toList();

  //     setState(() {
  //       this.query = query;
  //       this._driverlist = drivers;
  //     });
  //   }
  // }


  Widget buildSearch() => SearchWidget(
      text: query,
      hintText: 'Search',
      onChanged: searchdriver,
    );

  void searchdriver(String query) {
    setState(() {
      this.query = query;
      if (query.length < 2) {
        _driverlist = _orgdriverlist;
        return;
      }
      final drivers = _orgdriverlist.where((driver) {
        final titleLower = driver['driver'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
      _driverlist = drivers;
    });
  }

}
