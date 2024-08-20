import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class order_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xpartyid;
  var Title = 'Branch List';
  order_list(
      {Key? mykey, companyid, companyname, fbeg, fend, partyid, caption = ''})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xpartyid = partyid;
    Title = caption;
  }
  @override
  order_ListState createState() => order_ListState();
}

class order_ListState extends State<order_list> {
  List _orderlist = [];
  List _orgorderlist = [];
  List _orderSelected = [];
  List _orderSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getorderlist();
  }

  

  Future<bool> getorderlist() async {
    var response;
    var db = globals.dbname;
    var partyid = widget.xpartyid;


    String uri = '';

     uri =
        '${globals.cdomain}/api/commonapi_getsaleordpendinglist?dbname=' +
            db +
            '&partyid=' +
            partyid.toString();
    

    // uri =
    //     'http://127.0.0.1:8000/api/commonapi_getsaleordpendinglist?dbname=' +
    //         db +
    //         '&partyid=' +
    //         partyid.toString();
          
        print(partyid);
    response = await http.get(Uri.parse(uri));

    print(" getorderlist "+uri);

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    this.setState(() {
      _orderlist = jsonData;
      _orgorderlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Sales Order List';
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
              int id = this._orderlist[index]['orddetid'];
              String orderno = this._orderlist[index]['orderno'].toString();
              String date = this._orderlist[index]['date'];
              String itemname = this._orderlist[index]['itemname'];
              String salesman = this._orderlist[index]['salesman'].toString();
              if(salesman == 'null'){
                salesman = '';
              }
              String haste = this._orderlist[index]['haste'].toString();
              if(haste == 'null'){
                haste = '';
              }
              String design = this._orderlist[index]['design'].toString();
              String meters = this._orderlist[index]['balmeters'].toString();
              String taka = this._orderlist[index]['baltaka'].toString();
              String rate = this._orderlist[index]['rate'].toString();

              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text('Order No : ' +
                    orderno +
                    ' Dt : ' +
                    date +
                    ' Item Name : ' +
                    itemname +
                    ' Salesman : ' +
                    salesman +
                    ' Haste : ' +
                    haste),
                subtitle: Text('Pending Mts : ' +
                    meters +
                    ' Pending Taka :' +
                    taka +
                    ' Rate :' +
                    rate),
                onTap: () {
                  //print(account);
                  //setState(() => _selected[i] = !_selected[i])
                  _orderSelected.add(orderno);
                  //_orderSelected2.add(id);
                  _orderSelected2.add(this._orderlist[index]);
                  //setState(() => _selected[index] = !_selected[index]);
                  setState(() => _selected[index] = !_selected[index]);
                  //print(_selected);
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
