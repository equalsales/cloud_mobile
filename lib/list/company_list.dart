import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class companyid_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Company List';
  companyid_list(
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
  companyid_listState createState() => companyid_listState();
}

class companyid_listState extends State<companyid_list> {
  List _companylist = [];
  List _orgcompanylist = [];
  List _companySelected = [];
  List _companyIdSelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getcompanylist();
  }

  Future<bool> getcompanylist() async {
    var response;
    var db = globals.dbname;
    
    String uri = '${globals.cdomain}/api/api_companylist?dbname=' + db ;
     
    print(" getcompanylist :" + uri);
    response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    this.setState(() {
      _companylist = jsonData;
      _orgcompanylist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Company List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_companySelected}"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _companySelected);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._companylist.length,
            itemBuilder: (context, index) {
              int id = this._companylist[index]['id'];
              String company = this._companylist[index]['company'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(company),
                subtitle: Text('id :' + id.toString()),
                onTap: () {
                  _companyIdSelected.add(_companylist[index]['id'].toString());
                  _companyIdSelected.add(_companylist[index]['company']);
                  if (_selected[index]) {
                    _companySelected.remove(id);
                    _companySelected.remove(company);
                  } else {
                    _companySelected.add(id);
                    _companySelected.add(company);
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
        onChanged: searchcompany,
      );
  void searchcompany(String query) {
    if (query.length >= 2) {
      final companys = _orgcompanylist.where((company) {
        final titlelower = company.toString().toLowerCase();
        final searchlower = query.toLowerCase();
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._companylist = companys;
      });
    }
  }
}
