import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/module/looms/yarnphysicalstock/add_loomyarnphysicalstock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/PdfPreviewPagePrint.dart';
import '../../../common/global.dart' as globals;


class Loomyarnphysicalstocklist extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  Loomyarnphysicalstocklist({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _LoomyarnphysicalstockListPageState createState() =>
      _LoomyarnphysicalstockListPageState();
}

class _LoomyarnphysicalstockListPageState extends State<Loomyarnphysicalstocklist> {
  List _companydetails = [];
  List PrintFormatDetails = [];
  List PrintidDetails = [];
  var Printid = '';
  var formatid = '';
  String dropdownPrintFormat = 'Print Format';
  @override
  void initState() {
    loaddetails();
    loadprintformet();
  }
   Future<bool> loadprintformet() async {
    var companyid = widget.xcompanyid;
    var db = globals.dbname;
    String uri = '';
    uri =
        "https://www.looms.equalsoftlink.com/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=YARNJOBISSUEMST";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    print(jsonData);
    //print(jsonData);
    List unitDet = [];

    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      unitDet.add({
        "caption": jsonData[iCtr]['caption'].toString(),
      });
    }
    setState(() {
      PrintFormatDetails = unitDet;
    });
    print(PrintFormatDetails);
    return true;
  }

   Future<bool> setprintformet(printformet)  async {
    var companyid = widget.xcompanyid;
    var db = globals.dbname;
    String uri = '';
    uri =
        "https://www.looms.equalsoftlink.com/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=YARNJOBISSUEMST&printformet=$printformet";
    var response = await http.get(Uri.parse(uri));
    print(uri);
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    this.setState(() {
      PrintidDetails = jsonData;
    });
    print(PrintidDetails);
    return true;
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;
    var cno = globals.companyid;
    var startdate = retconvdate(globals.startdate).toString();
    var enddate = retconvdate(globals.enddate).toString();

    print(globals.enddate);

    var response = await http.get(Uri.parse(
        'https://www.looms.equalsoftlink.com/api/api_getyarnphysicalstocklist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            startdate +
            '&enddate=' +
            enddate));

    print(
        'https://www.looms.equalsoftlink.com/api/api_getyarnphysicalstocklist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            startdate +
            '&enddate=' +
            enddate);

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];

    this.setState(() {
      _companydetails = jsonData;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yarn Physical Stock List',
            style: TextStyle(
                fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => YarnphysicalstockAdd(
                        companyid: widget.xcompanyid,
                        companyname: widget.xcompanyname,
                        fbeg: widget.xfbeg,
                        fend: widget.xfend,
                        id: '0',
                      )))
        },
      ),
      body: Center(
          child: ListView.builder(
        itemCount: this._companydetails.length,
        itemBuilder: (context, index) {
          String date = this._companydetails[index]['date2'].toString();
          //date = retconvdatestr(date);
          String serial = this._companydetails[index]['serial'].toString();
          String branch =this._companydetails[index]['branch'].toString();
          String party = this._companydetails[index]['party'].toString();
          String remarks = this._companydetails[index]['remarks'].toString();
          String totwt = this._companydetails[index]['totwt'].toString();
          String totcone = this._companydetails[index]['totcone'].toString();

          String id = this._companydetails[index]['id'].toString();

          int newid = 0;
          newid = int.parse(id);

          return Slidable(
            key: ValueKey(index),
            startActionPane:
                ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                  onPressed: (context) => {
                        //execExportPDF(int.parse(id))
                        //exeprint(context,PrintFormatDetails)
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Format To Print'),
                              content: Container(
                                height: 70,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField(
                                          //value: items.first,
                                          decoration: const InputDecoration(
                                              labelText: 'Print Format',
                                              hintText: "Print Format"),
                                          items: PrintFormatDetails.map<
                                                  DropdownMenuItem<String>>(
                                              (items) {
                                            return DropdownMenuItem<String>(
                                              value: items['caption'],
                                              child: Text(items['caption']),
                                            );
                                          }).toList(),
                                          icon: const Icon(
                                              Icons.arrow_drop_down_circle),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownPrintFormat = newValue!;
                                              setprintformet(dropdownPrintFormat);
                                            });
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text('PDF'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              PdfViewerPagePrint(
                                              companyid: widget.xcompanyid,
                                              companyname: widget.xcompanyname,
                                              fbeg: widget.xfbeg,
                                              fend: widget.xfend,
                                              id: id.toString(),
                                              cPW: "PDF",
                                              formatid: PrintidDetails[0]['formatid'],
                                              printid: PrintidDetails[0]['printid'],
                                            ),
                                          ));
                                    }),
                                    TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text('WhatsApp'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              PdfViewerPagePrint(
                                              companyid: widget.xcompanyid,
                                              companyname: widget.xcompanyname,
                                              fbeg: widget.xfbeg,
                                              fend: widget.xfend,
                                              id: id.toString(),
                                              cPW: "WhatsApp",
                                              formatid: PrintidDetails[0]['formatid'],
                                              printid: PrintidDetails[0]['printid'],
                                            ),
                                          ));
                                    }),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                          //onPressed: (context) => {execWhatsApp(int.parse(id))},
                        )
                      },
                  icon: Icons.print,
                  label: 'Print',
                  backgroundColor: Color(0xFFFE4A49)),
              SlidableAction(
                  onPressed: (context) => {},
                  icon: Icons.edit,
                  label: 'Edit',
                  backgroundColor: Colors.blue)
            ]),
            child: Card(
                child: Center(
                    child: ListTile(
              title: Text(
                      ' Dt :' +
                      date +
                      ' Branch : ' +
                      branch +
                      ' Serial No : ' +
                      serial +
                      ' [ ' +
                      id +
                      ' ]' +
                      ' Party : ' +
                      party,
                  style:
                      TextStyle(fontFamily: 'verdana',
                        fontSize: 10.0, fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Remarks :' +
                      remarks +
                      ' TotWt : ' +
                      totwt +
                      ' totcone : ' +
                      totcone,
                  style:
                      TextStyle(fontFamily: 'verdana',fontSize: 10.0, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.select_all),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => YarnphysicalstockAdd(
                              companyid: widget.xcompanyid,
                              companyname: widget.xcompanyname,
                              fbeg: widget.xfbeg,
                              fend: widget.xfend,
                              id: id,
                            )));
              },
            ))),
          );
        },
      )),
    );
  }
}

void execDelete(BuildContext context, int index, int id, String name) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Yarn Challan Entry ??'),
      content: Text('Do you want to delete this entry ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // var db = globals.dbname;
            // var cno = globals.companyid;

            // var response = await http.post(Uri.parse(
            //     'https://www.cloud.equalsoftlink.com/api/api_deletecashbook?dbname=' +
            //         db +
            //         '&cno=' +
            //         cno +
            //         '&id=' +
            //         id.toString()));

            // print(
            //     'https://www.cloud.equalsoftlink.com/api/api_deletecashbook?dbname=' +
            //         db +
            //         '&id=' +
            //         id.toString());

            // var jsonData = jsonDecode(response.body);
            // var code = jsonData['Code'];
            // if (code == '200') {
            //   await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => LoomGreyJobIssueList(
            //               companyid: globals.companyid,
            //               companyname: globals.companyname,
            //               fbeg: globals.fbeg,
            //               fend: globals.fend)));
            // } else if (code == '500') {
            //   showAlertDialog(context, jsonData['Message']);
            // }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  return;
}

void doNothing(BuildContext context) {}
