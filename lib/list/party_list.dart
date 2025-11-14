import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../common/global.dart' as globals;
import 'package:cloud_mobile/list/search_widget.dart';
import 'package:cloud_mobile/module/master/partymaster/partymaster.dart';

class party_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Party List';

  party_list(
      {Key? key, companyid, companyname, fbeg, fend, acctype, caption = ''})
      : super(key: key) {
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
  List _partySelected2 = [];
  List<bool> _selected = [];
  String query = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getpartylist();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                buildSearch(),
                add(),
                Text("${_partySelected}"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, [_partySelected, _partySelected2]);
                  },
                  child: Text('Select'),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: _partylist.length,
                  itemBuilder: (context, index) {
                    int id = _partylist[index]['id'];
                    String account = _partylist[index]['party'];
                    String city = _partylist[index]['city'];
                    return ListTile(
                      tileColor: _selected[index] ? Colors.blue : null,
                      title: Text(account),
                      subtitle: Text(city),
                      onTap: () {
                        //print(account);
                        //setState(() => _selected[i] = !_selected[i])

                        if (!_selected[index]) {
                          // If selected, add to selected lists
                          _partySelected.add(account);
                          _partySelected2.add(this._partylist[index]);
                          _partySelected2.add(id);
                        } else {
                          // If deselected, remove from selected lists
                          _partySelected.remove(account);
                          _partySelected2.remove(id);
                        }
                        // _partySelected2.add(this._partylist[index]);

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
            ),
    );
  }

  Future<bool> getpartylist() async {
    setState(() {
      _isLoading = true;
    });

    var response;
    var db = globals.dbname;

    var api =
        "${globals.cdomain2}/api/api_getpartylist?dbname=$db&acctype=${widget.xacctype}";
    print(api);

    if (widget.xacctype != '') {
      response = await http.get(Uri.parse(
          '${globals.cdomain2}/api/api_getpartylist?dbname=$db&acctype=${widget.xacctype}'));
    } else {
      response = await http.get(Uri.parse(
          '${globals.cdomain2}/api/api_getpartylist?dbname=$db&acctype='));
    }

    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];

    setState(() {
      _partylist = jsonData;
      _orgpartylist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
      _isLoading = false;
    });
    return true;
  }

  Widget add() {
    if (query.length >= 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartyMaster(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                      id: '0',
                      acctype: "SALE PARTY",
                      newParty: query,
                    ),
                  ),
                );
              },
              child: Text('Add'),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildSearch() =>
      SearchWidget(text: query, hintText: 'Search', onChanged: searchParty);

  void searchParty(String query) {
    setState(() {
      this.query = query;
      if (query.isEmpty) {
        _partylist = _orgpartylist;
      } else {
        final partys = _orgpartylist.where((party) {
          final titleLower = party['party'].toString().toLowerCase();
          final cityLower = party['city'].toString().toLowerCase();
          final searchLower = query.toLowerCase();

          return titleLower.contains(searchLower) ||
              cityLower.contains(searchLower);
        }).toList();

        _partylist = partys;
        _selected = List.generate(partys.length, (i) => false);
      }
    });
  }
}
