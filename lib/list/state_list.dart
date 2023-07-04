import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class state_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'State List';
  state_list(
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
  StateListState createState() => StateListState();
}

class StateListState extends State<state_list> {
  List _statelist = [];
  List _orgstatelist = [];
  List _stateSelected = [];
  List _stateSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getstatelist();
  }

  Future<bool> getstatelist() async {
    //String username = userController.text;
    //String pwd = pwdController.text;

    //print('http://116.72.16.74:5000/api/usrcompanylist/admin&a');
    //print('http://116.72.16.74:5000/api/usrcompanylist/'+_user+'&'+_pwd);

    //var response  = await http.get(Uri.parse('http://116.72.16.74:5000/api/statelist/'+widget.xcompanyid));
    var response;
    var db = globals.dbname;

    print('https://www.cloud.equalsoftlink.com/api/getstatelist?dbname=' + db);
    response = await http.get(Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/getstatelist?dbname=' + db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //print(jsonData);

    this.setState(() {
      _statelist = jsonData;
      _orgstatelist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'State List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_stateSelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, [_stateSelected, _stateSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._statelist.length,
            itemBuilder: (context, index) {
              int id = this._statelist[index]['id'];
              String account = this._statelist[index]['state'];
              String state = this._statelist[index]['state'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(state),
                onTap: () {
                  //print(account);
                  //setState(() => _selected[i] = !_selected[i])
                  _stateSelected.add(account);
                  _stateSelected2.add(id);
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
        onChanged: searchstate,
      );
  void searchstate(String query) {
    if (query.length >= 2) {
      final states = _orgstatelist.where((state) {
        final titlelower = state.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._statelist = states;
      });
    }
  }
}
