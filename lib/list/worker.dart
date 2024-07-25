import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class worker_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Branch List';
  worker_list(
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
  workerListState createState() => workerListState();
}

class workerListState extends State<worker_list> {
  List _workerlist = [];
  List _orgworkerlist = [];
  List _workerSelected = [];
  List _workerSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getworkerlist();
  }

  Future<bool> getworkerlist() async {
    var response;
    var db = globals.dbname;
    var acctype = widget.xacctype;

    String uri = '${globals.cdomain}/api/api_getworkerlist?dbname=$db&division=$acctype';

    print(" getworkerlist : " + uri);

    response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    this.setState(() {
      _workerlist = jsonData;
      _orgworkerlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'workerName List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_workerSelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, [_workerSelected, _workerSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._workerlist.length,
            itemBuilder: (context, index) {
              int id = this._workerlist[index]['id'];
              String worker = this._workerlist[index]['worker'].toString();
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(worker),
                onTap: () {
                  _workerSelected.add(worker);
                  _workerSelected2.add(this._workerlist[index]);
                  setState(() => _selected[index] = !_selected[index]);
                  print("12313213131313231313" +
                      this._workerlist[index].toString());
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
        onChanged: searchbranch,
      );
  void searchbranch(String query) {
    if (query.length >= 2) {
      final workers = _orgworkerlist.where((workers) {
        final titlelower = workers.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._workerlist = workers;
      });
    }
  }
}
