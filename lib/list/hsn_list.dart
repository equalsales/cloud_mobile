import 'dart:collection';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/select.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class HSN_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  HSN_list({Key? mykey, companyid, companyname, fbeg, fend, acctype})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xacctype = acctype;
  }
  @override
  _HSN_listState createState() => _HSN_listState();
}
class _HSN_listState extends State<HSN_list> {
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
    String clientid = globals.dbname;
    var response;
    String uri = '';
    if (widget.xacctype != '') {
      uri =
          "https://www.cloud.equalsoftlink.com/api/api_gethsncodelist?dbname=" +
              clientid +
              '&acctype=' +
              widget.xacctype;
      response = await http.get(Uri.parse(uri));
    } else {
      uri =
          "https://www.cloud.equalsoftlink.com/api/api_gethsncodelist?dbname=" +
              clientid +
              "&acctype=";
      response = await http.get(Uri.parse(uri));
    }
    print(uri);
    var jsonData = jsonDecode(response.body);
    print(jsonData['Data']);
    this.setState(() {
      _partylist = jsonData['Data'];
      _orgpartylist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
    });
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EqAppBar(AppBarTitle:'HSNCode List',),
      body: Column(
        children: <Widget>[
          buildSearch(),
          SizedBox(
            height: 20,
          ),
          Text(
            "${_partySelected}",
            textAlign: TextAlign.center,
          ),
          SelectButton(
            buttonText: "Select",
            onPressed: () {
              Navigator.pop(context, _partySelected);
            },
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._partylist.length,
            itemBuilder: (context, index) {
              String account = this._partylist[index]['hsncode'];
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: ListTile(
                  tileColor: _selected[index] ? Colors.blue : null,
                  title: Text(account),
                  onTap: () {
                    print(account);
                    if (_selected[index]) {
                      _partySelected.remove(account);
                    } else {
                      _partySelected.add(account);
                    }
                    setState(() => _selected[index] = !_selected[index]);
                    print(_selected);
                    Navigator.pop(context, _partySelected);
                  },
                ),
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
        onChanged: searchParty,
      );
  void searchParty(String query) {
    if (query.length >= 2) {
      final partys = _orgpartylist.where((party) {
        final titlelower = party.toString().toLowerCase();
        final searchlower = query.toLowerCase();
        return titlelower.contains(searchlower);
      }).toList();
      setState(() {
        this.query = query;
        this._partylist = partys;
      });
    }
  }
}
