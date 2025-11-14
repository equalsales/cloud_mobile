import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:flutter/material.dart';

import 'package:cloud_mobile/dashboard.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';

//// import 'package:google_fonts/google_fonts.dart';

class YearSelection extends StatefulWidget {
  var xuser;
  var xpwd;
  YearSelection({Key? mykey, user, pwd}) : super(key: mykey) {
    xuser = user;
    xpwd = pwd;
  }

  @override
  _YearSelectionPageState createState() => _YearSelectionPageState();
}

class _YearSelectionPageState extends State<YearSelection> {
  List _companydetails = [];

  @override
  void initState() {
    super.initState();
    companydetails(widget.xuser, widget.xpwd);
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.xuser);
    //print(widget.xpwd);

    //companydetails(widget.xuser,widget.xpwd);
    return Scaffold(
      appBar: EqAppBar(AppBarTitle: 'Company Selection'),
      body: Center(
          child: ListView.builder(
        itemCount: _companydetails.length,
        itemBuilder: (context, index) {
          // print(this._companydetails[index]);
          String companyname = _companydetails[index]['company'];
          String companyid = _companydetails[index]['companyid'].toString();
          String yearid = _companydetails[index]['startdate'].toString() +
              ' - ' +
              _companydetails[index]['enddate'].toString();
          String fbeg = _companydetails[index]['startdate'];
          String fend = _companydetails[index]['enddate'];
          String startdate = _companydetails[index]['startdate'].toString();
          String enddate = _companydetails[index]['enddate'].toString();
          String companystate = _companydetails[index]['state'];
          return Card(
              child: Center(
                  child: ListTile(
            title: Text(companyname + ' [ ' + yearid + ' ]',
                style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'verdana')),
            subtitle: Text(companyid),
            leading: const Icon(Icons.select_all),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              showAlertDialog(context, companyid);

              globals.companyid = companyid;
              globals.companyname = companyname;
              globals.fbeg = fbeg;
              globals.fend = fend;
              globals.startdate = startdate;
              globals.enddate = enddate;
              globals.companystate = companystate;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Dashboard(
                          companyid: companyid,
                          companyname: companyname,
                          fbeg: fbeg,
                          fend: fend)));
            },
          )));
        },
      )
          //child: JobsListView()
          ),
    );
  }

  Future<bool> companydetails(_user, _pwd) async {
    var db = globals.dbname;
    //cdomain2

    var api =
        "${globals.cdomain2}/api/api_getcompanylist?dbname=$db&username=${widget.xuser}&password=${widget.xpwd}";

    print(api);

    var response = await http.get(Uri.parse(api));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    print(jsonData);

    setState(() {
      _companydetails = jsonData;
    });

    //Iterable list = jsonData[0];

    //print(jsonData);
    //print('dhaval');
    //print('dhruv');
    //print(jsonData.length);
    //print('in');
    // for (var ictr = 0; ictr < jsonData.length; ictr++) {
    //this._companydetails.add(jsonData[ictr]);
    //print(jsonData[ictr]);
    // }
    //print(this._companydetails);
    //print('out');
    //print(this.user);
    //print(this.);
    return true;
    // if (jsonData>0)
    // {
    //   print('Valid');
    //   this.isvaliduser = 'valid';
    //   return Future.value(true) ;
    // }
    // else
    // {
    //   print('In-Valid');
    //   this.isvaliduser = 'invalid';
    //   return Future.value(false) ;
    // }
  }
}
