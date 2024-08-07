// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:cloud_mobile/module/looms/jobreceive/yarnjobworkreceive/add_detyarnjobworkreceive.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_mobile/common/global.dart' as globals;

class YarnJobworkReceiveAdd extends StatefulWidget {
  YarnJobworkReceiveAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var serial;
  var srchr;
  double tottaka = 0;
  double totmtrs = 0;

  @override
  _YarnJobworkReceiveAddState createState() => _YarnJobworkReceiveAddState();
}

class _YarnJobworkReceiveAddState extends State<YarnJobworkReceiveAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  // ignore: unused_field
  List _partylist = [];

  List ItemDetails = [];

  var branchid = 0;
  int? partyid;
  var bookid = 0;

  TextEditingController _branch = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _packingsrchr = new TextEditingController();
  TextEditingController _packingserial = new TextEditingController();
  TextEditingController _branchid = new TextEditingController();
  TextEditingController _book = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _chlnno = new TextEditingController();
  TextEditingController _chlndt = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _tottaka = new TextEditingController();
  TextEditingController _totmtrs = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isButtonActive = true;

  var crlimit = 0.0;
  dynamic clobl = 0;

  String? dropdownTrnType;
  String? dropdownYarnType;
    String? dropdownWasteType;


  var items = [
    'REGULAR',
    'RETURN',
  ];

  var yarnItems = [
    'NORMAL',
    'RETURN',
  ];
  
  var westItems = [
    'YES',
    'NO',
  ];

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = DateFormat("dd-MM-yyyy").format(curDate);
    _chlndt.text = DateFormat("dd-MM-yyyy").format(curDate);

    _book.text = 'SALES A/C';
    // dropdownTrnType = 'PACKING';

    if (int.parse(widget.xid) > 0) {
      loadData();
      loadDetData();
    }
  }

  Future<bool> loadDetData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;

    uri = '${globals.cdomain}/api/api_getsalechallandetlist?dbname=' +
        db +
        '&cno=' +
        cno +
        '&id=' +
        id;

    print(" loadDetData :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    //jsonData = jsonData[0];

    print(jsonData);
    List ItemDet = [];
    ItemDetails = [];

    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      ItemDet.add({
        "controlid": jsonData[iCtr]['controlid'].toString(),
        "id": jsonData[iCtr]['id'].toString(),
        "orderno": jsonData[iCtr]['orderno'].toString(),
        "takano": jsonData[iCtr]['takano'].toString(),
        "takachr": jsonData[iCtr]['takachr'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "hsncode": jsonData[iCtr]['hsncode'].toString(),
        "grade": jsonData[iCtr]['grade'].toString(),
        "lotno": jsonData[iCtr]['lotno'].toString(),
        "cops": jsonData[iCtr]['cops'].toString(),
        "totcrtn": jsonData[iCtr]['totcrtn'].toString(),
        "actnetwt": jsonData[iCtr]['actnetwt'].toString(),
        "netwt": jsonData[iCtr]['netwt'].toString(),
        "cone": jsonData[iCtr]['cone'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "ordid": jsonData[iCtr]['ordid'].toString(),
        "orddetid": jsonData[iCtr]['orddetid'].toString(),
        "discrate": jsonData[iCtr]['discrate'].toString(),
        "discamt": jsonData[iCtr]['discamt'].toString(),
        "addamt": jsonData[iCtr]['addamt'].toString(),
        "taxablevalue": jsonData[iCtr]['taxablevalue'].toString(),
        "sgstrate": jsonData[iCtr]['sgstrate'].toString(),
        "sgstamt": jsonData[iCtr]['sgstamt'].toString(),
        "cgstrate": jsonData[iCtr]['cgstrate'].toString(),
        "cgstamt": jsonData[iCtr]['cgstamt'].toString(),
        "igstrate": jsonData[iCtr]['igstrate'].toString(),
        "igstamt": jsonData[iCtr]['igstamt'].toString(),
        "finalamt": jsonData[iCtr]['finalamt'].toString(),
      });
    }

    print("jsonData[iCtr]['ordno'].toString()" +
        jsonData[0]['orderno'].toString());

    setState(() {
      ItemDetails = ItemDet;
    });

    return true;
  }

  Future<bool> loadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;

    DateTime date = DateFormat("dd-MM-yyyy").parse(fromdate);
    String start = DateFormat("yyyy-MM-dd").format(date);

    DateTime date2 = DateFormat("dd-MM-yyyy").parse(todate);
    String end = DateFormat("yyyy-MM-dd").format(date2);

    uri = '${globals.cdomain}/api/api_getsalechallanlist?dbname=' +
        db +
        '&cno=' +
        cno +
        '&id=' +
        id +
        '&startdate=' +
        start +
        '&enddate=' +
        end;

    print(" loadData :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    print(jsonData);

    _branch.text = getValue(jsonData['branch'], 'C');
    _book.text = getValue(jsonData['book'], 'C');
    String inputDateString = getValue(jsonData['date'], 'C');
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
    _date.text = formattedDate.toString();
    _party.text = getValue(jsonData['party'], 'C');
    partyid = jsonData['partyid'];
    _chlnno.text = getValue(jsonData['challanno'], 'C');
    _chlndt.text = getValue(jsonData['challandt'], 'C');
    dropdownTrnType = getValue(jsonData['rdurd'], 'C');
    _remarks.text = getValue(jsonData['remarks'], 'C');
    _branchid.text = getValue(jsonData['branchid'], 'C');

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _date.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _chlndt.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    
    void gotoPartyScreen(
        BuildContext context, acctype, TextEditingController obj) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: acctype,
                  )));

      setState(() {
        var retResult = result;
        _partylist = result[1];
        result = result[1];

        var selParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }

        obj.text = selParty;
        print("121212111111111111111");
        print(obj.text);
      });
    }

    void gotoPartyScreen2(
        BuildContext context, acctype, TextEditingController obj) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: acctype,
                  )));

      if (result != null) {
        setState(() {
          var retResult = result;
          _partylist = result[1];
          result = result[1];

          var selParty = '';
          for (var ictr = 0; ictr < retResult[0].length; ictr++) {
            if (ictr > 0) {
              selParty = selParty + ',';
            }
            selParty = selParty + retResult[0][ictr];
          }

          obj.text = selParty;

          crlimit = double.parse(result[0]['crlimit'].toString());
          partyid = int.parse(result[0]['id'].toString());
          var endDate = retconvdate(widget.xfend).toString();
          var cno = int.parse(globals.companyid.toString());

          if (selParty != '') {
            getPartyDetails(
                    obj.text, 0, crlimit, partyid, context, endDate, cno)
                .then((value) {
              setState(() {
                clobl = value;
                print("chirag");
                print(clobl);
              });
            });
          }
        });
      }
    }

    void gotoBranchScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => branch_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;

        print(retResult);
        _branchlist = result[1];
        result = result[1];
        branchid = _branchlist[0];
        print(branchid);

        var selBranch = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selBranch = selBranch + ',';
          }
          selBranch = selBranch + retResult[0][ictr];
        }
        _branchid.text = branchid.toString();
        _branch.text = selBranch;
      });
    }

    void gotoChallanItemDet(BuildContext contex) async {
      var branch = _branch.text;
      var branchid = _branchid.text;
      var type = dropdownTrnType;
      print("type : $type");
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => YarnJobwokReceiveDetAdd(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  branch: branch,
                  partyid: partyid,
                  itemDet: ItemDetails,
                  branchid: branchid,
                  type: type)));
      setState(() {
        ItemDetails.add(result[0]);
        _remarks.text = result[0]['remarks'];
        print(ItemDetails);
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var packingsrchr = _packingsrchr.text;
      var packingserial = _packingserial.text;
      var serial = _serial.text;
      var srchr = _srchr.text;
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var book = _book.text;
      var branch = _branch.text;
      var date = _date.text;
      var party = _party.text;
      var remarks = _remarks.text;

      var id = widget.xid;
      id = int.parse(id);

      print('In Save....');

      print(jsonEncode(ItemDetails));

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      party = party.replaceAll('&', '_');

      uri = "${globals.cdomain}/api/api_storeloomssalechln?dbname=" +
          db +
          "&company=&cno=" +
          cno +
          "&user=" +
          username +
          "&branch=" +
          branch +
          "&packingtype=" +
          "&party=" +
          party +
          "&book=" +
          book +
          "&haste=" +
          "&transport=" +
          "&station=" +
          "&packingsrchr=" +
          packingsrchr +
          "&packingserial=" +
          packingserial +
          "&bookno=" +
          "&srchr=" +
          srchr +
          "&serial=" +
          serial +
          "&date=" +
          newDate +
          "&remarks=" +
          remarks +
          "&duedays=" +
          "&id=" +
          id.toString() +
          "&parcel=1";
      print("/////////////////////////////////////////////" + uri);

      final headers = {
        'Content-Type': 'application/json', // Set the appropriate content-type
        // Add any other headers required by your API
      };

      var response = await http.post(Uri.parse(uri),
          headers: headers, body: jsonEncode(ItemDetails));

      var jsonData = jsonDecode(response.body);
      //print('4');

      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        // var url = '${globals.cdomain}/printsaleorderdf/' +
        //     id.toString() +
        //     '?fromserial=0&toserial=0&srchr=&formatid=55&printid=49&call=2&mobile=&email=&noofcopy=1&cWAApi=639b127a08175a3ef38f4367&sendwhatsapp=BOTH&cno=2';

        Fluttertoast.showToast(
          msg: "Saved !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.purple,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
      return true;
    }

    Future<void> _handleSaveData() async {
      setState(() {
        isButtonActive = false; // Disable the button
      });

      bool success = await saveData();
      setState(() {
        isButtonActive = success;
      });
    }

    void deleteRow(index) {
      setState(() {
        ItemDetails.removeAt(index);
      });
    }

    List<DataRow> _createRows() {
      List<DataRow> _datarow = [];
      print(ItemDetails);

      widget.tottaka = 0;
      widget.totmtrs = 0;

      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        double nMeters = 0;
        if (ItemDetails[iCtr]['meters'] != '') {
          nMeters = nMeters + double.parse(ItemDetails[iCtr]['meters']);
          widget.tottaka += 1;
          widget.totmtrs += nMeters;
        }
        print(nMeters);

        var tot;
        var ordmtr = ItemDetails[iCtr]['ordmtr'].toString();
        var ordmtrAsDouble = double.tryParse(ordmtr);

        if (ordmtrAsDouble != null) {
          tot = ordmtrAsDouble - nMeters;
          print(tot);
          ItemDetails[iCtr]['ordbalmtrs'] = tot.toString();
          print(ItemDetails[iCtr]['ordbalmtrs']);
        } else {
          print('Error: Invalid format for ordmtr');
        }

        _datarow.add(DataRow(cells: [
          DataCell(ElevatedButton.icon(
            onPressed: () => {deleteRow(iCtr)},
            icon: Icon(
              // <-- Icon
              Icons.delete,
              size: 24.0,
            ),
            label: Text('',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          )),
          DataCell(Text(ItemDetails[iCtr]['itemname'].toString())),
          DataCell(Text(ItemDetails[iCtr]['hsncode'].toString())),
          DataCell(Text(ItemDetails[iCtr]['grade'].toString())),
          DataCell(Text(ItemDetails[iCtr]['lotno'].toString())),
          DataCell(Text(ItemDetails[iCtr]['cops'].toString())),
          DataCell(Text(ItemDetails[iCtr]['totcrtn'].toString())),
          DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['actnetwt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['netwt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['cone'].toString())),
          DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['unit'].toString())),
          DataCell(Text(ItemDetails[iCtr]['amount'].toString())),
          DataCell(Text(ItemDetails[iCtr]['fmode'].toString())),
          DataCell(Text(ItemDetails[iCtr]['ordid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['orddetid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['discrate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['discamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['addamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['taxablevalue'].toString())),
          DataCell(Text(ItemDetails[iCtr]['sgstrate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['sgstamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['cgstrate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['cgstamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['igstrate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['igstamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['finalamt'].toString())),
        ]));
      }

      setState(() {
        _tottaka.text = widget.tottaka.toString();
        _totmtrs.text = widget.totmtrs.toString();
      });

      return _datarow;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yarn Jobwork Receive [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ' +
              (int.parse(widget.xid) > 0
                  ? 'Challan No : ' + widget.serial.toString()
                  : ''),
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        backgroundColor: Colors.green,
        enableFeedback: isButtonActive,
        onPressed: isButtonActive
            ? () {
                if (crlimit < clobl) {
                  Fluttertoast.showToast(
                      msg: "CrLimit limit exceed!!!.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.white,
                      textColor: Colors.purple,
                      fontSize: 16.0);
                } else {
                  _handleSaveData();
                }
              }
            : null,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     int.parse(widget.xid) > 0
              //         ? Expanded(
              //             child: Center(
              //                 child: Text(
              //             'Challan No : ' + widget.serial.toString(),
              //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //           )))
              //         : Container(),
              //     Container(
              //       width: 300,
              //       child: TextFormField(
              //         textAlign: TextAlign.center,
              //         controller: _date,
              //         decoration: const InputDecoration(
              //           icon: const Icon(Icons.person),
              //           hintText: 'Date',
              //           labelText: 'Date',
              //         ),
              //         onTap: () {
              //           _selectDate(context);
              //         },
              //         validator: (value) {
              //           return null;
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 20,)
              //   ],
              // ),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _branch,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Branch Name',
                      labelText: 'Branch Name',
                    ),
                    onTap: () {
                      gotoBranchScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ]),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _chlnno,
                      // keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Srchr',
                        labelText: 'Srchr',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _serial,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter Serial',
                        labelText: 'Serial',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _date,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Date',
                        labelText: 'Date',
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _chlnno,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Challan No',
                        labelText: 'Challan No',
                      ),
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: _party,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Select Party',
                  labelText: 'Party',
                ),
                onTap: () {
                  gotoPartyScreen2(context, 'SALE PARTY', _party);
                },
                validator: (value) {
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                        value: dropdownTrnType,
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Type',
                            hintText: 'Type'),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownTrnType = newValue!;
                            print(dropdownTrnType);
                          });
                        }),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: dropdownYarnType,
                        decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Yarntype',
                            hintText: 'Yarntype'),
                        items: yarnItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownYarnType = newValue!;
                            print(dropdownYarnType);
                          });
                        }),
                  ),
                ],
              ),
              DropdownButtonFormField(
                  value: dropdownWasteType,
                  decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Waste',
                      hintText: 'Waste'),
                  items: westItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down_circle),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownWasteType = newValue!;
                      print(dropdownWasteType);
                    });
                  }),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                onPressed: () {
                  print("clobl");
                  print(clobl);
                  print("crlimit");
                  print(crlimit);
                  if (crlimit < clobl) {
                    Fluttertoast.showToast(
                      msg: "Crlimit exceed!!!.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.white,
                      textColor: Colors.purple,
                      fontSize: 16.0,
                    );
                  } else {
                    gotoChallanItemDet(context);
                  }
                },
                child: Text('Add Item Details',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(columns: [
                    DataColumn(
                      label: Text("Action"),
                    ),
                    DataColumn(
                      label: Text("Issno"),
                    ),
                    DataColumn(
                      label: Text("Isschr"),
                    ),
                    DataColumn(
                      label: Text("Cartonchr"),
                    ),
                    DataColumn(
                      label: Text("Cartonno"),
                    ),
                    DataColumn(
                      label: Text("Lotno"),
                    ),
                    DataColumn(
                      label: Text("Lotchr"),
                    ),
                    DataColumn(
                      label: Text("Item Name"),
                    ),
                    DataColumn(
                      label: Text("Type"),
                    ),
                    DataColumn(
                      label: Text("Cops"),
                    ),
                    DataColumn(
                      label: Text("Rolls"),
                    ),
                    DataColumn(
                      label: Text("Box"),
                    ),
                    DataColumn(
                      label: Text("Weight"),
                    ),
                    DataColumn(
                      label: Text("Netwt"),
                    ),
                    DataColumn(
                      label: Text("Rate"),
                    ),
                    DataColumn(
                      label: Text("Unit"),
                    ),
                    DataColumn(
                      label: Text("Amount"),
                    ),
                    DataColumn(
                      label: Text("Cone"),
                    ),
                    DataColumn(
                      label: Text("New Item"),
                    ),
                    DataColumn(
                      label: Text("Clothcost"),
                    ),
                    DataColumn(
                      label: Text("Cost"),
                    ),
                    DataColumn(
                      label: Text("Actwt"),
                    ),
                    DataColumn(
                      label: Text("Actmtrs"),
                    ),
                    DataColumn(
                      label: Text("Lnkid"),
                    ),
                    DataColumn(
                      label: Text("Lnkdetid"),
                    ),
                    DataColumn(
                      label: Text("Lnkdettkid"),
                    ),
                    DataColumn(
                      label: Text("Fmode"),
                    ),
                  ], rows: _createRows())),
            ],
          ),
        ),
      )),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
