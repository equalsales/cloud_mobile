import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/search_widget.dart';

import '../common/global.dart' as globals;

class party_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Party List';
  party_list(
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
  PartyListState createState() => PartyListState();
}

class PartyListState extends State<party_list> {
  List _partylist = [];
  List _orgpartylist = [];
  List _partySelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    getpartylist();
  }

  Future<bool> getpartylist() async {
    //String username = userController.text;
    //String pwd = pwdController.text;

    //print('http://116.72.16.74:5000/api/usrcompanylist/admin&a');
    //print('http://116.72.16.74:5000/api/usrcompanylist/'+_user+'&'+_pwd);

    //var response  = await http.get(Uri.parse('http://116.72.16.74:5000/api/partylist/'+widget.xcompanyid));
    var response;
    if (widget.xacctype != '') {
      response = await http.get(Uri.parse(
          'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=admin_neel&acctype=' +
              widget.xacctype));
    } else {
      response = await http.get(Uri.parse(
          'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=admin_neel&acctype='));
    }

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //print(jsonData);

    this.setState(() {
      _partylist = jsonData;
      _orgpartylist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Title == '') {
      widget.Title = 'Party List';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          Text("${_partySelected}"),
          ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context, _partySelected);
            },
            child: Text('Select'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._partylist.length,
            itemBuilder: (context, index) {
              String account = this._partylist[index]['party'];
              String city = this._partylist[index]['city'];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : null,
                title: Text(account),
                subtitle: Text(city),
                onTap: () {
                  //print(account);
                  //setState(() => _selected[i] = !_selected[i])
                  _partySelected.add(account);
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
        onChanged: searchParty,
      );
  void searchParty(String query) {
    if (query.length >= 2) {
      final partys = _orgpartylist.where((party) {
        final titlelower = party.toString().toLowerCase();
        final searchlower = query.toLowerCase();

        //print(titlelower);
        //print(searchlower);
        return titlelower.contains(searchlower);
      }).toList();

      setState(() {
        this.query = query;
        this._partylist = partys;
      });
    }
  }
}
