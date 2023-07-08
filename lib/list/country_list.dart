import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class country_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Country List';
  country_list(
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
  CountryListState createState() => CountryListState();
}

class CountryListState extends State<country_list> {
  List _countrylist = [];
  List _orgcountrylist = [];
  List _countrySelected = [];
  List _countrySelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getcountrylist();
  }

  Future<bool> getcountrylist() async {
    //String username = userController.text;
    //String pwd = pwdController.text;

    //print('http://116.72.16.74:5000/api/usrcompanylist/admin&a');
    //print('http://116.72.16.74:5000/api/usrcompanylist/'+_user+'&'+_pwd);

    //var response  = await http.get(Uri.parse('http://116.72.16.74:5000/api/countrylist/'+widget.xcompanyid));
    var response;
    var db = globals.dbname;

    print(
        'https://www.cloud.equalsoftlink.com/api/getcountrylist?dbname=' + db);
    response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/getcountrylist?dbname=' + db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //print(jsonData);

    this.setState(() {
      _countrylist = jsonData;
      _orgcountrylist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Country List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_countrySelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, [_countrySelected, _countrySelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._countrylist.length,
            itemBuilder: (context, index) {
              int id = this._countrylist[index]['id'];
              String account = this._countrylist[index]['country'];
              String country = this._countrylist[index]['country'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(country),
                onTap: () {
                  //print(account);
                  //setState(() => _selected[i] = !_selected[i])
                  _countrySelected.add(account);
                  _countrySelected2.add(id);
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
        onChanged: searchcountry,
      );
  void searchcountry(String query) {
    if (query.length >= 2) {
      final countrys = _orgcountrylist.where((country) {
        final titlelower = country.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._countrylist = countrys;
      });
    }
  }
}
