// ignore_for_file: must_be_immutable

import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import 'package:cloud_mobile/common/global.dart' as globals;

class orderno_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xbranch;
  var Title = 'Branch List';
  orderno_list(
      {Key? mykey, companyid, companyname, fbeg, fend, branch, caption = ''})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xbranch = branch;
    Title = caption;
  }
  @override
  orderno_ListState createState() => orderno_ListState();
}

class orderno_ListState extends State<orderno_list> {
  List _orderlist = [];
  List _orgorderlist = [];
  List _orderSelected = [];
  List _orderSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    getorderlist();
  }

  Future<bool> getorderlist() async {
    var response;
    var db = globals.dbname;
    var branch = widget.xbranch;
    var user = globals.username;


    String uri = '';
     
    uri = '${globals.cdomain}/getgreyjoborderlist/?branch=$branch&dbname=$db&user=$user&aorddetid=0&ordid=0';

    print(" ordernolist "+uri);

    //${globals.cdomain}/getgreyjoborderlist/?branch=5904&dbname=db&user=user&aorddetid=0&ordid=7
    print('ggg');
    response = await http.get(Uri.parse(uri));
    print("1");

    var jsonData = jsonDecode(response.body);
    print("2");

    jsonData = jsonData['data'];
    print("3");

    this.setState(() {
      _orderlist = jsonData;
      _orgorderlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    print("4");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Order List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_orderSelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, [_orderSelected, _orderSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._orderlist.length,
            itemBuilder: (context, index) {
              String orderno = this._orderlist[index]['orderno'].toString();
              String orderchr = this._orderlist[index]['orderchr'].toString();
              String ordid = this._orderlist[index]['ordid'].toString();
              String orddetid = this._orderlist[index]['orddetid'].toString();
              String itemid = this._orderlist[index]['itemid'].toString();
              String designid = this._orderlist[index]['designid'].toString();
              String unitid = this._orderlist[index]['unitid'].toString();
              String partyid = this._orderlist[index]['partyid'].toString();
              String branchid = this._orderlist[index]['branchid'].toString();
              String party = this._orderlist[index]['party'];
              String branch = this._orderlist[index]['branch'];
              String itemname = this._orderlist[index]['itemname'];
              String design = this._orderlist[index]['design'].toString();
              String unit = this._orderlist[index]['unit'];
              String meters = this._orderlist[index]['meters'].toString();
              String balmeters = this._orderlist[index]['balmeters'].toString();

              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text('Order No : ' +
                    orderno +
                    ' OrderChr : ' +
                    orderchr +
                    ' Date : '  +
                    '11-01-2025' + 
                    ' Item Name : ' +
                    itemname +
                    ' Design : ' +
                    design),
                subtitle: Text('Meters : ' +
                    meters +
                    ' BalMtrs :' +
                    balmeters +
                    ' Unit :' +
                    unit),
                onTap: () {
                  _orderSelected.add(orderno);
                  _orderSelected2.add(this._orderlist[index]);
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
        onChanged: searchorder,
      );
  void searchorder(String query) {
    if (query.length >= 2) {
      final orders = _orgorderlist.where((order) {
        final titlelower = order.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._orderlist = orders;
      });
    }
  }
}
