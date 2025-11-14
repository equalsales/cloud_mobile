import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class machineid_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Machine List';
  machineid_list(
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
  machineIdListIdState createState() => machineIdListIdState();
}

class machineIdListIdState extends State<machineid_list> {
  List _machinelist = [];
  List _orgmachinelist = [];
  List _machineSelected = [];
  List _machineIdSelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getmachinelist();
  }

  Future<bool> getmachinelist() async {
    String clientid = globals.dbname;
    var response;
    String uri = '';
    uri =
        "${globals.cdomain}/api/api_getmachinelist?dbname=" +
            clientid;
    response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    this.setState(() {
      _machinelist = jsonData['Data'];
      _orgmachinelist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
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
              Navigator.pop(context, _machineSelected);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._machinelist.length,
            itemBuilder: (context, index) {
              int id = this._machinelist[index]['id'];
              String account = this._machinelist[index]['machine'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text('id :' + id.toString()),
                onTap: () {
                  _machineIdSelected.add(_machinelist[index]['id'].toString());
                  _machineIdSelected.add(_machinelist[index]['machine']);
                  if (_selected[index]) {
                    _machineSelected.remove(id);
                    _machineSelected.remove(account);
                  } else {
                    _machineSelected.add(id);
                    _machineSelected.add(account);
                  }
                  setState(() => _selected[index] = !_selected[index]);
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
      final machines = _orgmachinelist.where((machine) {
        final titlelower = machine.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._machinelist = machines;
      });
    }
  }
}
