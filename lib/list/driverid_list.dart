import 'package:cloud_mobile/module/master/drivermaster/drivermaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class driverid_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend;
  var Title = 'Driver List';
  
  driverid_list({Key? mykey, companyid, companyname, fbeg, fend, caption = ''})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    Title = caption;
  }

  @override
  driverid_listState createState() => driverid_listState();
}

class driverid_listState extends State<driverid_list> {
  List _driverlist = [];
  List _orgdriverlist = [];
  List _driverSelected = [];
  List<bool> _selected = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    getDriverList();
  }

  Future<bool> getDriverList() async {
    var response;
    var db = globals.dbname;
    var cno = globals.companyid;

    String uri = '${globals.cdomain}/api/api_getdriverlist?dbname=$db&cno=$cno';

    response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];

    setState(() {
      _driverlist = jsonData;
      _orgdriverlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
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
                    builder: (context) => DriverMaster(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                      id: '0',
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
          add(),
          Text("${_driverSelected}"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _driverSelected);
            },
            child: Text('Select'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _driverlist.length,
              itemBuilder: (context, index) {
                String account = _driverlist[index]['driver'];
                String aid = _driverlist[index]['id'].toString();
                return ListTile(
                  tileColor: _selected[index] ? Colors.blue : null,
                  title: Text(account),
                  subtitle: Text('id: $aid'),
                  onTap: () {
                    setState(() {
                      if (_selected[index]) {
                        _driverSelected.remove(aid);
                        _driverSelected.remove(account);
                      } else {
                        _driverSelected.add(aid);
                        _driverSelected.add(account);
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
        onChanged: searchDriver,
      );

  void searchDriver(String query) {
    if (query.isNotEmpty) {
      final filteredDrivers = _orgdriverlist.where((driver) {
        final name = driver['driver'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower); 
      }).toList();

      setState(() {
        this.query = query;
        this._driverlist = filteredDrivers;
      });
    } else {
      setState(() {
        _driverlist = _orgdriverlist;
      });
    }
  }
}
