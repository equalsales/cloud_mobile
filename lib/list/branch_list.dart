import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/search_widget.dart';
import '../common/global.dart' as globals;

class branch_list extends StatefulWidget {
  var xcompanyid, xcompanyname, xfbeg, xfend, xacctype;
  var Title = 'Branch List';

  branch_list({
    Key? key,
    companyid,
    companyname,
    fbeg,
    fend,
    acctype,
    caption = '',
  }) : super(key: key) {
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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getBranchList();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                buildSearch(),
                Text("${_branchSelected}"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, [_branchSelected, _branchSelected2]);
                  },
                  child: const Text('Select'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _branchlist.length,
                    itemBuilder: (context, index) {
                      String account = _branchlist[index]['branch'];
                      int id = _branchlist[index]['id'];
                      return ListTile(
                        tileColor: _selected[index] ? Colors.blue : null,
                        title: Text(account),
                        subtitle: Text(account),
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
                  ),
                )
              ],
            ),
    );
  }

  Future<bool> getBranchList() async {
    setState(() {
      _isLoading = true;
    });

    var db = globals.dbname;
    var api = "${globals.cdomain}/api/commonapi_getbranchlist?dbname=$db";
    print(api);
    var response = await http.get(Uri.parse(api));
    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    setState(() {
      _orgbranchlist = _branchlist = jsonData;
      _selected = List.generate(jsonData.length, (i) => false);
      _isLoading = false;
    });

    searchBranch(query);

    return true;
  }

  Widget buildSearch() =>
      SearchWidget(text: query, hintText: 'Search', onChanged: searchBranch);

  void searchBranch(String newQuery) {
    final searchLower = newQuery.toLowerCase();
    List branchs = [];

    if (searchLower.isEmpty) {
      branchs = _orgbranchlist;
    } else {
      branchs = _orgbranchlist.where((branch) {
        final branchName = branch['branch'].toString().toLowerCase();
        return branchName.contains(searchLower);
      }).toList();
    }

    setState(() {
      query = newQuery;
      _branchlist = branchs;
      _selected = List.generate(branchs.length, (i) => false);
    });
  }
}
