import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class branch_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Branch List';
  branch_list(
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
  BranchListState createState() => BranchListState();
}

class BranchListState extends State<branch_list> {
  List _branchlist = [];
  List _orgbranchlist = [];
  List _branchSelected = [];
  List _branchSelected2 = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getbranchlist();
  }

  Future<bool> getbranchlist() async {
    //String username = userController.text;
    //String pwd = pwdController.text;

    //print('http://116.72.16.74:5000/api/usrcompanylist/admin&a');
    //print('http://116.72.16.74:5000/api/usrcompanylist/'+_user+'&'+_pwd);

    //var response  = await http.get(Uri.parse('http://116.72.16.74:5000/api/branchlist/'+widget.xcompanyid));
    var response;
    var db = globals.dbname;

    print(
        'https://www.looms.equalsoftlink.com/api/commonapi_getbranchlist?dbname=' +
            db);
    response = await http.get(Uri.parse(
        'https://www.looms.equalsoftlink.com/api/commonapi_getbranchlist?dbname=' +
            db));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //print(jsonData);

    this.setState(() {
      _branchlist = jsonData;
      _orgbranchlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Branch List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_branchSelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, [_branchSelected, _branchSelected2]);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._branchlist.length,
            itemBuilder: (context, index) {
              int id = this._branchlist[index]['id'];
              String account = this._branchlist[index]['branch'];
              String branch = this._branchlist[index]['branch'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(branch),
                // onTap: () {
                //   //print(account);
                //   //setState(() => _selected[i] = !_selected[i])
                //   _branchSelected.add(account);
                //   _branchSelected2.add(id);
                //   //setState(() => _selected[index] = !_selected[index]);
                //   setState(() => _selected[index] = !_selected[index]);
                //   //print(_selected);
                //   //showAlertDialog(context, companyid);
                //   // Navigator.push(context, MaterialPageRoute(builder: (_) => Dashboard(
                //   //   companyid: companyid,
                //   //   companyname: companyname,
                //   //   fbeg: fbeg,
                //   //   fend: fend
                //   //   )));
                // },
                onTap: () {
                  setState(() {
                    // Toggle selection state
                    _selected[index] = !_selected[index];

                    // Get the account and id for the current item
                    String branch = _branchlist[index]['branch'];
                    int id = _branchlist[index]['id'];

                    if (_selected[index]) {
                      // If selected, add to selected lists
                      _branchSelected.add(branch);
                      _branchSelected2.add(id);
                    } else {
                      // If deselected, remove from selected lists
                      _branchSelected.remove(branch);
                      _branchSelected2.remove(id);
                    }
                  });
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
        onChanged: searchbranch,
      );
  void searchbranch(String query) {
    if (query.length >= 2) {
      final branchs = _orgbranchlist.where((branch) {
        final titlelower = branch.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._branchlist = branchs;
      });
    }
  }
}
