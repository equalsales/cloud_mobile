import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class salesman_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Salesman List';
  salesman_list(
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
  SalesmanListIdState createState() => SalesmanListIdState();
}

class SalesmanListIdState extends State<salesman_list> {
  List _salesmanlist = [];
  List _orgsalesmanlist = [];
  List _salesmanSelected = [];
  List _salesmanSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getsalesmanlist();
  }

  Future<bool> getsalesmanlist() async {
    String clientid = globals.dbname;
    var response;
    String uri = '';
    uri =
        "https://www.cloud.equalsoftlink.com/api/api_getsalesmanlist?dbname=" +
            clientid;
    response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    this.setState(() {
      _salesmanlist = jsonData['Data'];
      _orgsalesmanlist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Salesman List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_salesmanSelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context,[ _salesmanSelected, _salesmanSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._salesmanlist.length,
            itemBuilder: (context, index) {
              int id = this._salesmanlist[index]['id'];
              String account = this._salesmanlist[index]['salesman'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text('id :' + id.toString()),
                onTap: () {
                    _salesmanSelected.add(account);
                    _salesmanSelected2.add(id);
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
        onChanged: searchsalesman,
      );
  void searchsalesman(String query) {
    if (query.length >= 2) {
      final salesmans = _orgsalesmanlist.where((salesman) {
        final titlelower = salesman.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._salesmanlist = salesmans;
      });
    }
  }
}
