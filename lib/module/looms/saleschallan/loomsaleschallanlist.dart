// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:cloud_mobile/common/PdfPreviewPagePrint.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/module/looms/saleschallan/add_loomsaleschallan.dart';
import 'package:intl/intl.dart';

class LoomSalesChallanList extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;

  LoomSalesChallanList({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _LoomSalesChallanListPageState createState() =>
      _LoomSalesChallanListPageState();
}

class _LoomSalesChallanListPageState extends State<LoomSalesChallanList> {
  List _companydetails = [];
  List PrintFormatDetails = [];
  List PrintidDetails = [];
  var Printid = '';
  var formatid = '';
  //TextEditingController _printid = new TextEditingController();
  //TextEditingController _formatid = new TextEditingController();
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
        "${globals.cdomain}/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=SALECHLNMST";


    // uri =
    //     "http://127.0.0.1:8000/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=SALECHLNMST";

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

  Future<bool> setprintformet(printformet) async {
    var companyid = widget.xcompanyid;
    var db = globals.dbname;
    String uri = '';
    uri =
        "${globals.cdomain}/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=SALECHLNMST&printformet=$printformet";
    
    // uri =
    //     "http://127.0.0.1:8000/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=SALECHLNMST&printformet=$printformet";

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

  void execExportPDF(id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PdfViewerPagePrint(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  id: id.toString(),
                  cPW: "PDF",
                )));
  }

  void execWhatsApp(id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPagePrint(
            companyid: widget.xcompanyid,
            companyname: widget.xcompanyname,
            fbeg: widget.xfbeg,
            fend: widget.xfend,
            id: id.toString(),
            cPW: "WhatsApp",
            formatid: 55,
            printid: 49,
          ),
        ));
  }

  Future<bool> loaddetails() async {
    var db = globals.dbname;
    var cno = globals.companyid;
    var startdate = globals.fbeg;
    var enddate = globals.fend;

    print(globals.enddate);

    DateTime date = DateFormat("dd-MM-yyyy").parse(startdate);
    String start = DateFormat("yyyy-MM-dd").format(date);

    DateTime date2 = DateFormat("dd-MM-yyyy").parse(enddate);
    String end = DateFormat("yyyy-MM-dd").format(date2);

    String uri = '${globals.cdomain}/api/api_getsalechallanlist?dbname=' +
            db +
            '&cno=' +
            cno +
            '&startdate=' +
            start +
            '&enddate=' +
            end;

    // String uri = 'http://127.0.0.1:8000/api/api_getsalechallanlist?dbname=' +
    //     db +
    //     '&cno=' +
    //     cno +
    //     '&startdate=' +
    //     start +
    //     '&enddate=' +
    //     end;

    var response = await http.get(Uri.parse(uri));

    print(" loaddetails " + uri);

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
        title: Text('Sales Challan  List',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LoomSalesChallanAdd(
                        companyid: widget.xcompanyid,
                        companyname: widget.xcompanyname,
                        fbeg: widget.xfbeg,
                        fend: widget.xfend,
                        id: '0',
                      ))).then((value) => loaddetails())
        },
      ),
      body: Center(
          child: ListView.builder(
        itemCount: this._companydetails.length,
        itemBuilder: (context, index) {
          String date = this._companydetails[index]['date2'].toString();
          //date = retconvdatestr(date);
          String serial = this._companydetails[index]['serial'].toString();
          String packingserial =
              this._companydetails[index]['packingserial'].toString();
          String packingtype =
              this._companydetails[index]['packingtype'].toString();
          String party = this._companydetails[index]['party'].toString();
          String remarks = this._companydetails[index]['remarks'].toString();
          String totpcs = this._companydetails[index]['totpcs'].toString();
          String totmtrs = this._companydetails[index]['totmtrs'].toString();

          String id = this._companydetails[index]['id'].toString();

          int newid = 0;
          newid = int.parse(id);

          return Slidable(
            key: ValueKey(index),
            startActionPane:
                ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                  onPressed: (context) => {execWhatsApp(int.parse(id))},
                  icon: Icons.sms_sharp,
                  label: 'WhatsApp',
                  backgroundColor: Color.fromARGB(226, 73, 254, 197)),
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
                                              setprintformet(
                                                  dropdownPrintFormat);
                                              Timer(Duration(seconds: 2), () {
                                                CircularProgressIndicator();
                                              });
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
                                      if(PrintidDetails.isNotEmpty){
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PdfViewerPagePrint(
                                            companyid: widget.xcompanyid,
                                            companyname:
                                                widget.xcompanyname,
                                            fbeg: widget.xfbeg,
                                            fend: widget.xfend,
                                            id: id.toString(),
                                            cPW: "PDF",
                                            formatid: PrintidDetails[0]
                                                ['formatid'],
                                            printid: PrintidDetails[0]
                                                ['printid'],
                                          ),
                                        ));
                                      }
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
                                              formatid: PrintidDetails[0]
                                                  ['formatid'],
                                              printid: PrintidDetails[0]
                                                  ['printid'],
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
                  'Dt :' +
                      date +
                      ' Packing Type : ' +
                      packingtype +
                      ' Packing No : ' +
                      packingserial +
                      ' Challan No : ' +
                      serial +
                      ' [ ' +
                      id +
                      ' ]' +
                      ' Party : ' +
                      party,
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Remarks :' +
                      remarks +
                      ' Pcs : ' +
                      totpcs +
                      ' Meters : ' +
                      totmtrs,
                  style:
                      TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.select_all),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LoomSalesChallanAdd(
                              companyid: widget.xcompanyid,
                              companyname: widget.xcompanyname,
                              fbeg: widget.xfbeg,
                              fend: widget.xfend,
                              id: id,
                            ))).then((value) => loaddetails());
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
      title: const Text('Delete Sales Challan Entry ??'),
      content: Text('Do you want to delete this entry ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => {Navigator.pop(context, 'Cancel')},
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            var db = globals.dbname;
            var cno = globals.companyid;

            String uri = '';

            uri = '${globals.cdomain}/api/api_deletecashbook?dbname=' +
                  db +
                  '&id=' +
                  id.toString();
                
            // uri = 'http://127.0.0.1:8000/api/api_deletecashbook?dbname=' +
            //       db +
            //       '&id=' +
            //       id.toString();
            
            print(uri);

            var response = await http.post(Uri.parse(uri));
            var jsonData = jsonDecode(response.body);
            var code = jsonData['Code'];
            if (code == '200') {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoomSalesChallanList(
                          companyid: globals.companyid,
                          companyname: globals.companyname,
                          fbeg: globals.fbeg,
                          fend: globals.fend)));
            } else if (code == '500') {
              showAlertDialog(context, jsonData['Message']);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  return;
}

void doNothing(BuildContext context) {}
