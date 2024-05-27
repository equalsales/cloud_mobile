// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class design_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Design List';
  design_list(
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
  design_listState createState() => design_listState();
}

class design_listState extends State<design_list> {
  List _designlist = [];
  List _orgdesignlist = [];
  List _designSelected = [];
  List _designIdSelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getdesignlist();
  }

  Future<bool> getdesignlist() async {
    var response;
    var db = globals.dbname;
    
    String uri = 'https://www.looms.equalsoftlink.com/api/api_getdesignlist?dbname=' + db;
     
    print(" getdesignlist :" + uri);
    response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    this.setState(() {
      _designlist = jsonData;
      _orgdesignlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Design List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_designSelected}"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _designSelected);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._designlist.length,
            itemBuilder: (context, index) {
              String design = this._designlist[index]['design'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(design),
                onTap: () {
                  _designIdSelected.add(_designlist[index]['design']);
                  if (_selected[index]) {
                    _designSelected.remove(design);
                  } else {
                    _designSelected.add(design);
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
        onChanged: searchdesign,
      );
  void searchdesign(String query) {
    if (query.length >= 2) {
      final designs = _orgdesignlist.where((design) {
        final titlelower = design.toString().toLowerCase();
        final searchlower = query.toLowerCase();
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._designlist = designs;
      });
    }
  }
}
