import 'dart:collection';

import 'package:cloud_mobile/projFunction.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class city_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'City List';
  city_list(
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
  CityListState createState() => CityListState();
}

class CityListState extends State<city_list> {
  List _citylist = [];
  List _orgcitylist = [];
  List _citySelected = [];
  List _citySelected2 = [];
  List _state = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getcitylist();
  }

  Future<bool> getcitylist() async {
    //String username = userController.text;
    //String pwd = pwdController.text;

    //print('http://116.72.16.74:5000/api/usrcompanylist/admin&a');
    //print('http://116.72.16.74:5000/api/usrcompanylist/'+_user+'&'+_pwd);

    //var response  = await http.get(Uri.parse('http://116.72.16.74:5000/api/citylist/'+widget.xcompanyid));
    var response;
    var db = globals.dbname;

    print('https://www.cloud.equalsoftlink.com/api/getcitylist?dbname=' + db);
    response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/getcitylist?dbname=' + db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //print(jsonData);

    this.setState(() {
      _citylist = jsonData;
      _orgcitylist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'City List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_citySelected}"),
          add(),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              //print([_citySelected, _citySelected2]);
              Navigator.pop(context, [_citySelected, _citySelected2, _state]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._citylist.length,
            itemBuilder: (context, index) {
              int id = this._citylist[index]['id'];
              String account = this._citylist[index]['city'];
              String city = this._citylist[index]['city'];
              String state = this._citylist[index]['state'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(city),
                onTap: () {
                  _citySelected.add(account);
                  _citySelected2.add(id);
                  _state.add(state);
                  setState(() => _selected[index] = !_selected[index]);
                },
              );
            },
          ))
        ],

        //child: JobsListView()
      ),
    );
  }

  Widget add() {
    if (query.length >= 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    // Change your radius here
                    borderRadius: BorderRadius.circular(0),
                  ))),
              onPressed: () {
                cityMaster_Add(context, widget.xcompanyid, widget.xcompanyname,
                        widget.xfbeg, widget.xfend, query)
                    .then((result) {
                  _citySelected.add(result[0]);
                  _citySelected2.add(result[1]);

                  Navigator.pop(context, [_citySelected, _citySelected2]);
                  ;
                });
              },
              child: Text('Add'),
            ),
          ],
        ),
      );
    } else {
      print("Not add");
      return Container();
    }
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchcity,
      );
  void searchcity(String query) {
    if (query.length >= 2) {
      final citys = _orgcitylist.where((city) {
        final titlelower = city.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._citylist = citys;
      });
    }
  }
}
