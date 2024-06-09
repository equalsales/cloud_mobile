import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class item_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Branch List';
  item_list(
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
  itemListState createState() => itemListState();
}

class itemListState extends State<item_list> {
  List _itemlist = [];
  List _orgitemlist = [];
  List _itemSelected = [];
  List _itemSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getitemlist();
  }

  Future<bool> getitemlist() async {
    //String username = userController.text;
    //String pwd = pwdController.text;

    //print('http://116.72.16.74:5000/api/usrcompanylist/admin&a');
    //print('http://116.72.16.74:5000/api/usrcompanylist/'+_user+'&'+_pwd);

    //var response  = await http.get(Uri.parse('http://116.72.16.74:5000/api/branchlist/'+widget.xcompanyid));
    var response;
    var db = globals.dbname;

    print(
        '${globals.cdomain}/api/commonapi_getitemlist?dbname=' +
            db);
    response = await http.get(Uri.parse(
        '${globals.cdomain}/api/commonapi_getitemlist?dbname=' +
            db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //print(jsonData);

    this.setState(() {
      _itemlist = jsonData;
      _orgitemlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'ItemName List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_itemSelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, [_itemSelected, _itemSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._itemlist.length,
            itemBuilder: (context, index) {
              int id = this._itemlist[index]['id'];
              String item = this._itemlist[index]['itemname'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(item),
                onTap: () {
                  _itemSelected.add(item);
                  _itemSelected2.add(this._itemlist[index]); 
                  setState(() => _selected[index] = !_selected[index]);
                  print("12313213131313231313" + this._itemlist[index].toString());
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
      final items = _orgitemlist.where((items) {
        final titlelower = items.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._itemlist = items;
      });
    }
  }
}
