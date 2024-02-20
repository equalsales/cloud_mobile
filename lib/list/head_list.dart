import 'dart:collection';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/select.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

// ignore: must_be_immutable
class Head_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  Head_list({Key? mykey, companyid, companyname, fbeg, fend, acctype})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xacctype = acctype;
  }
  @override
  _Head_listState createState() => _Head_listState();
}

class _Head_listState extends State<Head_list> {
  List _headlist = [];
  List _orgheadlist = [];
  List _headSelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getheadlist();
  }

  Future<bool> getheadlist() async {
    String clientid = globals.dbname;
    var response;
    String uri='';

      uri = "https://www.cloud.equalsoftlink.com/api/api_getheadlist?dbname=" +
          clientid;
      response = await http.get(Uri.parse(uri));

    print(uri);

    var jsonData = jsonDecode(response.body);

    this.setState(() {
      _headlist = jsonData['Data'];
      _orgheadlist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: 'Head List'),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_headSelected}"),
          SelectButton(
            buttonText: "Select",
            onPressed: () {
              Navigator.pop(context, _headSelected);
            },
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._headlist.length,
            itemBuilder: (context, index) {
              String head = this._headlist[index]['head'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(head),
                subtitle: Text(''),
                onTap: () {
                  print(head);
                  //setState(() => _selected[i] = !_selected[i])
                  _headSelected.add(head);
                  setState(() => _selected[index] = !_selected[index]);
                  print(_selected);
                  //showAlertDialog(context, companyid);
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => Dashboard(
                  //   companyid: companyid,
                  //   companyname: companyname,
                  //   fbeg: fbeg,
                  //   fend: fend
                  //   )));
                },
              );
            },
          ))
        ],

        //child: JobsListView()
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchHead,
      );
  void searchHead(String query) {
    if (query.length >= 2) {
      final heads = _orgheadlist.where((head) {
        final titlelower = head.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._headlist = heads;
      });
    }
  }
}
