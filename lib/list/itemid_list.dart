import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class itemid_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Branch List';
  itemid_list(
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
  itemIdListState createState() => itemIdListState();
}

class itemIdListState extends State<itemid_list> {
  List _itemlist = [];
  List _orgitemlist = [];
  List _itemSelected = [];
  List _itemIdSelected = [];
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
              Navigator.pop(context, _itemSelected);
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
                subtitle: Text('id :' + id.toString()),
                onTap: () {
                  _itemIdSelected.add(_itemlist[index]['id'].toString());
                  _itemIdSelected.add(_itemlist[index]['itemname']);
                  if (_selected[index]) {
                    _itemSelected.remove(id);
                    _itemSelected.remove(item);
                  } else {
                    _itemSelected.add(id);
                    _itemSelected.add(item);
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
