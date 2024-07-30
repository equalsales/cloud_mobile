// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:cloud_mobile/module/looms/jobreceive/beamjobworkreceive/add_detbeamjobworkreceive.dart';
import 'package:cloud_mobile/module/looms/purchasechallan/yarnpurchasechallan/add_yarnpurchasechallandet.dart';
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

class BeamJobworkReceiveAdd extends StatefulWidget {
  BeamJobworkReceiveAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _BeamJobworkReceiveAddState createState() => _BeamJobworkReceiveAddState();
}

class _BeamJobworkReceiveAddState extends State<BeamJobworkReceiveAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];

  List ItemDetails = [];

  var branchid = 0;
  int? partyid;
  var bookid = 0;
  TextEditingController _packingsrchr = new TextEditingController();
  TextEditingController _packingserial = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _branch = new TextEditingController();
  TextEditingController _branchid = new TextEditingController();
  TextEditingController _book = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _chlnno = new TextEditingController();
  TextEditingController _chlndt = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isButtonActive = true;

  var crlimit = 0.0;
  dynamic clobl = 0;

  String dropdownTrnType = 'RETURN';

  var items = [
    'REGULAR',
    'RETURN',
    'YARN',
    'MASTER BEAM',
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
      setState(() {
        loadData();
        loadDetData();
      });
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
        "issno": jsonData[iCtr]['issno'].toString(),
        "isschr": jsonData[iCtr]['isschr'].toString(),
        "beamno": jsonData[iCtr]['beamno'].toString(),
        "beamchr": jsonData[iCtr]['beamchr'].toString(),
        "taka": jsonData[iCtr]['taka'].toString(),
        "itemid": jsonData[iCtr]['itemid'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "ends": jsonData[iCtr]['ends'].toString(),
        "pipeno": jsonData[iCtr]['pipeno'].toString(),
        "weight": jsonData[iCtr]['weight'].toString(),
        "shtwt": jsonData[iCtr]['shtwt'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "actwt": jsonData[iCtr]['actwt'].toString(),
        "actmtrs": jsonData[iCtr]['actmtrs'].toString(),
        "lnkid": jsonData[iCtr]['lnkid'].toString(),
        "lnkdetid": jsonData[iCtr]['lnkdetid'].toString(),
        "lnkdettkid": jsonData[iCtr]['lnkdettkid'].toString(),
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "beamid": jsonData[iCtr]['beamid'].toString(),
        "creelno": jsonData[iCtr]['creelno'].toString(),
        "machine": jsonData[iCtr]['machine'].toString(),
        "cone": jsonData[iCtr]['cone'].toString(),
      });
    }

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
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BeamJobworkReceiveDetAdd(
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
      var challanno = _chlnno.text;
      var challandt = _chlndt.text;
      var rdurd = dropdownTrnType;
      var remarks = _remarks.text;

      var id = widget.xid;
      id = int.parse(id);

      print('In Save....');

      print(jsonEncode(ItemDetails));

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      party = party.replaceAll('&', '_');

      uri =
          "${globals.cdomain}/api/api_storeloomssalechln?dbname=" +
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
      print(" SaveData : " + uri);

      final headers = {
        'Content-Type': 'application/json',
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
        isButtonActive = false;
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

        for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
          
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
            DataCell(Text(ItemDetails[iCtr]['issno'].toString())),
            DataCell(Text(ItemDetails[iCtr]['isschr'].toString())),
            DataCell(Text(ItemDetails[iCtr]['beamno'].toString())),
            DataCell(Text(ItemDetails[iCtr]['beamchr'].toString())),
            DataCell(Text(ItemDetails[iCtr]['taka'].toString())),
            DataCell(Text(ItemDetails[iCtr]['itemid'].toString())),
            DataCell(Text(ItemDetails[iCtr]['meters'].toString())),
            DataCell(Text(ItemDetails[iCtr]['ends'].toString())),
            DataCell(Text(ItemDetails[iCtr]['pipeno'].toString())),
            DataCell(Text(ItemDetails[iCtr]['weight'].toString())),
            DataCell(Text(ItemDetails[iCtr]['shtwt'].toString())),
            DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
            DataCell(Text(ItemDetails[iCtr]['amount'].toString())),
            DataCell(Text(ItemDetails[iCtr]['actwt'].toString())),
            DataCell(Text(ItemDetails[iCtr]['actmtrs'].toString())),
            DataCell(Text(ItemDetails[iCtr]['lnkid'].toString())),
            DataCell(Text(ItemDetails[iCtr]['lnkdetid'].toString())),
            DataCell(Text(ItemDetails[iCtr]['lnkdettkid'].toString())),
            DataCell(Text(ItemDetails[iCtr]['fmode'].toString())),
            DataCell(Text(ItemDetails[iCtr]['beamid'].toString())),
            DataCell(Text(ItemDetails[iCtr]['creelno'].toString())),
            DataCell(Text(ItemDetails[iCtr]['machine'].toString())),
            DataCell(Text(ItemDetails[iCtr]['cone'].toString())),
          ]));
        }
        setState(() {});

      return _datarow;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beam Jobwork Receive [ ' +
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
              if (_formKey.currentState!.validate())
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form submitted successfully')),
                );
                _handleSaveData();
              }
            }
            : null,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
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
                    hintText: 'Select Branch',
                    labelText: 'Branch',
                  ),
                  onTap: () {
                    gotoBranchScreen(context);
                  },
                  validator: (value) {
                    if (value == ' ') {
                      return 'Please enter branch';
                    } 
                    return null;
                  },
                ),
              ),
            ]),
            TextFormField(
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                      if (value == ' ') {
                        return 'Please enter party';
                      } 
                      return null;
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _chlnno,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Challan No',
                      labelText: 'Challan No',
                    ),
                    onTap: () {
                     
                    },
                    validator: (value) {
                      if (value == ' ') {
                        return 'Please enter challanno';
                      } 
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    value: dropdownTrnType,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Type',
                      hintText: 'Type'
                    ),
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
                    }
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _remarks,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Remarks',
                      labelText: 'Remarks',
                    ),
                    onChanged: (value) {
                      _remarks.value = TextEditingValue(
                          text: value.toUpperCase(),
                          selection: _remarks.selection);
                    },
                    onTap: () {},
                    validator: (value) {
                      if (value == ' ') {
                        return 'Please enter remarks';
                      } 
                      return null;
                    },
                  ),
                )
              ],
            ),            
            Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
              onPressed: () {
                gotoChallanItemDet(context);
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
                    label: Text("Beamchr"),
                  ),
                  DataColumn(
                    label: Text("Beamno"),
                  ),
                  DataColumn(
                    label: Text("Taka"),
                  ),
                  DataColumn(
                    label: Text("ItemId"),
                  ),
                  DataColumn(
                    label: Text("Meters"),
                  ),
                  DataColumn(
                    label: Text("Ends"),
                  ),
                  DataColumn(
                    label: Text("Pipeno"),
                  ),
                  DataColumn(
                    label: Text("Weight"),
                  ),
                  DataColumn(
                    label: Text("Shtwt"),
                  ),
                  DataColumn(
                    label: Text("Rate"),
                  ),
                  DataColumn(
                    label: Text("Amount"),
                  ),
                  DataColumn(
                    label: Text("Actwt"),
                  ),
                  DataColumn(
                    label: Text("Actmetrs"),
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
                  DataColumn(
                    label: Text("Beamid"),
                  ),
                  DataColumn(
                    label: Text("Creelno"),
                  ),
                  DataColumn(
                    label: Text("Machine"),
                  ),
                  DataColumn(
                    label: Text("Cone"),
                  ),
                ], rows: _createRows())),
          ],
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
