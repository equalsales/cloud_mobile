import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/select.dart';
import 'package:cloud_mobile/list/search_widget.dart';
import 'package:flutter/material.dart';
import '../common/global.dart' as globals;
import 'dart:convert';

import 'package:http/http.dart' as http;

class item_list2 extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xitemtype;
  item_list2({Key? mykey, companyid, companyname, fbeg, fend, itemtype})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xitemtype = itemtype;
  }
  @override
  ItemList2State createState() => ItemList2State();
}

class ItemList2State extends State<item_list2> {
  List _itemlist = [];
  List _orgitemlist = [];
  List _itemSelected = [];
  List _itemSelected2 = [];
  List<bool> _selected = [];
  String query = '';
  var multiselect = false;

  @override
  void initState() {
    getitemlist();
  }

  Future<bool> getitemlist() async {
    String clientid = globals.dbname;
    var response;
    String uri = '';
    if (widget.xitemtype != '') {
      uri = "https://www.cloud.equalsoftlink.com/api/api_getitemlist?dbname=" +
          clientid +
          '&itemtype=' +
          widget.xitemtype;
      response = await http.get(Uri.parse(uri));
    } else {
      uri = "https://www.cloud.equalsoftlink.com/api/api_getitemlist?dbname=" +
          clientid;
      response = await http.get(Uri.parse(uri));
    }
    print(uri);
    var jsonData = jsonDecode(response.body);
    print(jsonData);

    this.setState(() {
      _itemlist = jsonData['Data'];
      _orgitemlist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
    });
    return true;
  }

  Future<bool> getitemlikelist() async {
    String clientid = '';
    var response;
    String uri = '';
    if (widget.xitemtype != '') {
      uri = "https://www.cloud.equalsoftlink.com/api/api_getitemlist?dbname=" +
          clientid +
          '&itemtype=' +
          widget.xitemtype;
      response = await http.get(Uri.parse(uri));
    } else {
      uri = "https://www.cloud.equalsoftlink.com/api/api_getitemlist?dbname=" +
          clientid;
      response = await http.get(Uri.parse(uri));
    }
    print(uri);
    var jsonData = jsonDecode(response.body);
    // print(jsonData);

    this.setState(() {
      _itemlist = jsonData['Data'];
      _orgitemlist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //getitemlist();
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: 'Item List'),
      // appBar: AppBar(
      //   title: Text('Item List'),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           setState(() {
      //             multiselect = !multiselect;
      //           });
      //         },
      //         icon: (!multiselect)
      //             ? Icon(Icons.check_box_outline_blank)
      //             : Icon(Icons.check_box))
      //   ],
      // ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Visibility(
            child: Text("${_itemSelected}"),
            visible: false,
          ),
          SelectButton(
            buttonText: "Select",
            onPressed: () {
              Navigator.pop(context, _itemSelected);
            },
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._itemlist.length,
            itemBuilder: (context, index) {
              String itemname = this._itemlist[index]['itemname'];
              String unit = this._itemlist[index]['unit'].toString();
              String salerate = this._itemlist[index]['cut'].toString();
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(itemname),
                subtitle:
                    Text('Unit :' + unit.toString() + ' Cut : ' + salerate),
                onTap: () {
                  //setState(() => _selected[i] = !_selected[i])
                  _itemSelected.add(_itemlist[index]);
                  _itemSelected2.add(_itemlist[index]);

                  setState(() => _selected[index] = !_selected[index]);
                  if (multiselect) {
                  } else {
                    // Navigator.pop(context, _itemSelected);
                  }

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
        onChanged: searchItem,
      );
  void searchItem(String query) {
    if (query.length >= 2) {
      final items = _orgitemlist.where((item) {
        final titlelower = item.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print("jatin");
        //print("jatin1");
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._itemlist = items;
      });
    }
  }
}
