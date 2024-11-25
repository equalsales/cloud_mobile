import 'package:cloud_mobile/module/master/partymaster/partymaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class partyid_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Party List';
  partyid_list({
    Key? mykey,
    companyid,
    companyname,
    fbeg,
    fend,
    acctype,
    caption = '',
  }) : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xacctype = acctype;
    Title = caption;
  }

  @override
  partyid_listState createState() => partyid_listState();
}

class partyid_listState extends State<partyid_list> {
  List _partylist = [];
  List _orgpartylist = [];
  List _partySelected = [];
  List _partyIdSelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    getPartyList();
  }

  Future<bool> getPartyList() async {
    var db = globals.dbname;
    var response;
    String uri = '';
    if (widget.xacctype != '') {
      response = await http.get(Uri.parse(
          'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=$db&acctype=${widget.xacctype}'));
    } else {
      response = await http.get(Uri.parse(
          'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=$db&acctype='));
    }

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['Data'];
      setState(() {
        _partylist = jsonData;
        _orgpartylist = jsonData;
        _selected = List.generate(jsonData.length, (i) => false);
      });
      print("Fetched Party List: $_partylist");
    } else {
      print("Failed to fetch data.");
    }
    return true;
  }

  Widget addButton() {
    if (query.isNotEmpty) {
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
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Title),
      ),
      body: Column(
        children: <Widget>[
          buildSearch(),
          addButton(),
          Text("${_partySelected}"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _partySelected);
            },
            child: Text('Select'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _partylist.length,
              itemBuilder: (context, index) {
                String account = _partylist[index]['party'];
                String aid = _partylist[index]['id'].toString();
                return ListTile(
                  tileColor: _selected[index] ? Colors.blue : null,
                  title: Text(account),
                  subtitle: Text('id: $aid'),
                  onTap: () {
                    setState(() {
                      if (_selected[index]) {
                        _partySelected.remove(aid);
                        _partySelected.remove(account);
                      } else {
                        _partySelected.add(aid);
                        _partySelected.add(account);
                      }
                      _selected[index] = !_selected[index];
                    });
                  },
                );
              },
            ),
          ),
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
    if (query.isNotEmpty) {
      final filteredParties = _orgpartylist.where((party) {
        final partyName = party['party'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return partyName.contains(searchLower);
      }).toList();

      setState(() {
        this.query = query;
        this._partylist = filteredParties;
      });
      print("Search Results: $filteredParties");
    } else {
      // Reset the party list if search query is empty
      setState(() {
        _partylist = _orgpartylist;
      });
    }
  }
}
