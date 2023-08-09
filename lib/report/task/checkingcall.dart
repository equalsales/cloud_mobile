import 'package:flutter/material.dart';

import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

// import 'package:google_fonts/google_fonts.dart';

class CheckingTask extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  CheckingTask({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _CheckingTaskPageState createState() => _CheckingTaskPageState();
}

class _CheckingTaskPageState extends State<CheckingTask> {
  List _companydetails = [];
  List _companydetails2 = [];
  @override
  void initState() {
    companydetails(
        widget.xcompanyid, widget.xcompanyname, widget.xfbeg, widget.xfend);
  }

  Future<bool> companydetails(_user, _pwd, _startdate, _enddate) async {
    var db = globals.dbname;
    //print('1');
    var response = await http
        .get(Uri.parse('https://task.equalsoftlink.com/getCheckingCall2'));
    //print('2');
    var jsonData = jsonDecode(response.body);
    //print('3');
    jsonData = jsonData['data'];

    //print(jsonData);

    this.setState(() {
      _companydetails = jsonData;
      _companydetails2 = jsonData;
    });

    return true;
  }

  void filterSearchResults(String query) {
    var filteredList = [];
    query = query.toLowerCase();
    //print(query);
    for (var ictr = 0; ictr < _companydetails2.length; ictr++) {
      var party = _companydetails2[ictr]['party'].toString();
      var task = _companydetails2[ictr]['task'].toString();
      var acgroup = _companydetails2[ictr]['acgroup'].toString();
      var givenby = _companydetails2[ictr]['username'].toString();
      var forwardto = _companydetails2[ictr]['forwardto'].toString();
      var date = _companydetails2[ictr]['date'].toString();
      if (date != '') {
        date = date.substring(0, 10);
      }
      party = party.toLowerCase();
      task = task.toLowerCase();
      acgroup = acgroup.toLowerCase();
      givenby = givenby.toLowerCase();
      forwardto = forwardto.toLowerCase();
      if (date.contains(query)) {
        filteredList.add(_companydetails2[ictr]);
      } else if (givenby.contains(query)) {
        filteredList.add(_companydetails2[ictr]);
      } else if (acgroup.contains(query)) {
        filteredList.add(_companydetails2[ictr]);
      } else if (party.contains(query)) {
        filteredList.add(_companydetails2[ictr]);
      } else if (task.contains(query)) {
        filteredList.add(_companydetails2[ictr]);
      } else if (forwardto.contains(query)) {
        filteredList.add(_companydetails2[ictr]);
      }
    }

    setState(() {
      _companydetails = filteredList;

      print(_companydetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Checking Task',
              style: TextStyle(
                  fontSize: 25.0, fontWeight: FontWeight.normal)),
        ),
        body: Container(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              //controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this._companydetails.length,
            itemBuilder: (context, index) {
              String date = this._companydetails[index]['date'].toString();
              date = date.substring(0, 10);
              String time = this._companydetails[index]['time'].toString();
              //print(this._companydetails[index]);
              String party = this._companydetails[index]['party'];
              String acgroup =
                  this._companydetails[index]['acgroup'].toString();
              String task = this._companydetails[index]['task'].toString();
              String givenby =
                  this._companydetails[index]['username'].toString();
              String days = this._companydetails[index]['days'].toString();
              String forwardto =
                  this._companydetails[index]['forwardto'].toString();

              return Card(
                  child: Center(
                      child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(party + ' [ ' + acgroup + ' ]',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    Text('Dt : ' + date + ' Time : ' + time + ' ',
                        style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900])),
                    Text(task,
                        style: TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: Text(
                    'Completed By :' +
                        givenby +
                        ' Forward To : ' +
                        forwardto +
                        ' Days : ' +
                        days,
                    style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.red)),
                leading: Icon(Icons.select_all),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  showAlertDialog(context, task);

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => Dashboard(
                  //             companyid: companyid,
                  //             companyname: companyname,
                  //             fbeg: fbeg,
                  //             fend: fend)));
                },
              )));
            },
          )
              //child: JobsListView()
              ),
        ])));
  }
}
