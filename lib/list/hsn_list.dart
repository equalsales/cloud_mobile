import 'dart:collection';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/common/select.dart';
import 'package:cloud_mobile/projFunction.dart';
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
  List _hsnlist = [];
  List _orgpartylist = [];
  List _hsnSelected = [];
  List _hsnSelected2 = [];
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
      _hsnlist = jsonData['Data'];
      _orgpartylist = jsonData['Data'];
      _selected = List.generate(jsonData['Data'].length, (i) => false);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EqAppBar(
        AppBarTitle: 'HSNCode List',
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          SizedBox(
            height: 20,
          ),
          Text(
            "${_hsnSelected}",
            textAlign: TextAlign.center,
          ),
          add(),
          SelectButton(
            buttonText: "Select",
            onPressed: () {
              Navigator.pop(context, _hsnSelected);
            },
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._hsnlist.length,
            itemBuilder: (context, index) {
              String account = this._hsnlist[index]['hsncode'];
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: ListTile(
                  tileColor: _selected[index] ? Colors.blue : null,
                  title: Text(account),
                  onTap: () {
                    print(account);
                    if (_selected[index]) {
                      _hsnSelected.remove(account);
                    } else {
                      _hsnSelected.add(account);
                    }
                    //_hsnSelected2.add(id);
                    setState(() => _selected[index] = !_selected[index]);
                    print(_selected);
                    Navigator.pop(context, _hsnSelected);
                  },
                ),
              );
            },
          ))
        ],
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
                hsnMaster_Add(context, widget.xcompanyid, widget.xcompanyname,
                        widget.xfbeg, widget.xfend, query)
                    .then((result) {
                  _hsnSelected.add(result[0]);
                  _hsnSelected.add(result[1]);
                  //_state.add(result[2]);

                  Navigator.pop(context, [_hsnSelected, _hsnSelected]);
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
        this._hsnlist = partys;
      });
    }
  }
}
