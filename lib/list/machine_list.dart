import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class machine_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Machine List';
  machine_list(
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
  machineListState createState() => machineListState();
}

class machineListState extends State<machine_list> {
  List _machinelist = [];
  List _orgmachinelist = [];
  List _machineSelected = [];
  List _machineSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getmachinelist();
  }

  Future<bool> getmachinelist() async {
    var response;
    var db = globals.dbname;
    print(
        'https://www.looms.equalsoftlink.com/api/api_getmachinelist?dbname=' +
            db);
    response = await http.get(Uri.parse(
        'https://www.looms.equalsoftlink.com/api/api_getmachinelist?dbname=' +
            db));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
      print(jsonData);
    this.setState(() {
      _machinelist = jsonData;
      _orgmachinelist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Machine List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_machineSelected}"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, [_machineSelected, _machineSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._machinelist.length,
            itemBuilder: (context, index) {
              int id = this._machinelist[index]['id'];
              String account = this._machinelist[index]['machine'];
              String machine = this._machinelist[index]['machine'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(machine),
                // onTap: () {
                //   _machineSelected.add(account);
                //   _machineSelected2.add(id);
                //   setState(() => _selected[index] = !_selected[index]);
                // },
                  onTap: () {
                  setState(() {
                    // Toggle selection state
                    _selected[index] = !_selected[index];

                    // Get the account and id for the current item
                    String account = _machinelist[index]['machine'];
                    int id = _machinelist[index]['id'];

                    if (_selected[index]) {
                      // If selected, add to selected lists
                      _machineSelected.add(account);
                      _machineSelected2.add(id);
                    } else {
                      // If deselected, remove from selected lists
                      _machineSelected.remove(account);
                      _machineSelected2.remove(id);
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

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchmachine,
        
      );
  void searchmachine(String query) {
    if (query.length >= 2) {
        final items = _orgmachinelist.where((items) {
        final titlelower = items.toString().toLowerCase();
        final searchlower = query.toLowerCase();
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._machinelist = items;
      });
    }
  }
}
