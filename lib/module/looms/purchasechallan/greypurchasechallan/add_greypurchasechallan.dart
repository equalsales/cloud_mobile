// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:cloud_mobile/module/looms/purchasechallan/greypurchasechallan/add_greypurchasechallandet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';

class GreyPurchaseChallanAdd extends StatefulWidget {
  GreyPurchaseChallanAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _GreyPurchaseChallanAddState createState() => _GreyPurchaseChallanAddState();
}

class _GreyPurchaseChallanAddState extends State<GreyPurchaseChallanAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];

  List ItemDetails = [];

  var branchid = 0;
  int? partyid;
  var bookid = 0;
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _branch = new TextEditingController();
  TextEditingController _branchid = new TextEditingController();
  TextEditingController _book = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _agent = new TextEditingController();
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
  var items = [
    'RD',
    'URD',
  ];

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = DateFormat("dd-MM-yyyy").format(curDate);
    _chlndt.text = DateFormat("dd-MM-yyyy").format(curDate);

    _book.text = 'PURCHASE A/C';

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


    uri = '${globals.cdomain}/api/api_getgreypurchallandetlist?cno=' +
        cno +
        '&id=' +
        id +
        '&dbname=' +
        db;

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
        "orderchr": jsonData[iCtr]['orderchr'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "design": jsonData[iCtr]['design'].toString(),
        "pcs": jsonData[iCtr]['pcs'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "weight": jsonData[iCtr]['weight'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "stdwt": jsonData[iCtr]['stdwt'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "foldmtrs": jsonData[iCtr]['foldmtrs'].toString(),
        "shtmtrs": jsonData[iCtr]['shtmtrs'].toString(),
        "shtprc": jsonData[iCtr]['shtprc'].toString(),
        "ordid": jsonData[iCtr]['ordid'].toString(),
        "orddetid": jsonData[iCtr]['orddetid'].toString(),
        "discper": jsonData[iCtr]['discper'].toString(),
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


    uri = '${globals.cdomain}/api/api_getgreyurchallanlist?cno=' +
        cno +
        '&startdate=' +
        start +
        '&enddate=' +
        end +
        '&dbname=' +
        db +
        '&id=' +
        id.toString();

    print(" loadData :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    print(jsonData);

    _branch.text = jsonData['branch'].toString();
    _book.text = jsonData['book'].toString();
    // String inputDateString = jsonData['date'];
    // List<String> parts = inputDateString.split(' ')[0].split('-');
    // String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
    _date.text = jsonData['date2'].toString();
    _party.text = jsonData['party'].toString();
    _agent.text = jsonData['agent'].toString();
    _chlnno.text = jsonData['chlnno'].toString();
    _chlndt.text = jsonData['chlndt'].toString();
    _agent.text = jsonData['agent'].toString();
    if(_agent.text == 'null'){
      _agent.text = '';
    }
    dropdownTrnType = jsonData['rdurd'].toString();
    if (dropdownTrnType == '') {
      dropdownTrnType = 'RD';
    }
    if (dropdownTrnType == 'null') {
      dropdownTrnType = 'RD';
    }
    _remarks.text = jsonData['remarks'].toString();
    _branchid.text = jsonData['branchid'].toString();

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();
    setState(() {});
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
          _agent.text = result[0]['agent'].toString();
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
              builder: (_) => GreyPurchaseChallanDetAdd(
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
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var serial = _serial.text;
      var srchr = _srchr.text;
      var book = _book.text;
      var branch = _branch.text;
      var date = _date.text;
      var party = _party.text;
      var agent = _agent.text;
      var rdurd = dropdownTrnType;
      var chlndt = _chlndt.text;
      var chlnno = _chlnno.text;
      var remarks = _remarks.text;

      var id = widget.xid;
      id = int.parse(id);

      print('In Save....');

      print(jsonEncode(ItemDetails));

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);
      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(chlndt);
      String newchlndt = DateFormat("yyyy-MM-dd").format(parsedDate2);

      party = party.replaceAll('&', '_');

      uri =
          uri = "${globals.cdomain}/api/api_storegreypurchallan?dbname=" +
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
          '&agent=' +
          agent +
          "&book=" +
          book +
          '&chlndt=' +
          newchlndt +
          '&chlnno=' +
          chlnno +
          '&rdurd=' +
          rdurd.toString() +
          "&haste=" +
          '&salesman=' +
          "&transport=" +
          "&station=" +
          "&packingsrchr=" +
          "&packingserial=" +
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
          DataCell(Text(ItemDetails[iCtr]['orderno'].toString())),
          DataCell(Text(ItemDetails[iCtr]['orderchr'].toString())),
          DataCell(Text(ItemDetails[iCtr]['itemname'].toString())),
          DataCell(Text(ItemDetails[iCtr]['design'].toString())),
          DataCell(Text(ItemDetails[iCtr]['pcs'].toString())),
          DataCell(Text(ItemDetails[iCtr]['meters'].toString())),
          DataCell(Text(ItemDetails[iCtr]['weight'].toString())),
          DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['stdwt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['unit'].toString())),
          DataCell(Text(ItemDetails[iCtr]['amount'].toString())),
          DataCell(Text(ItemDetails[iCtr]['fmode'].toString())),
          DataCell(Text(ItemDetails[iCtr]['foldmtrs'].toString())),
          DataCell(Text(ItemDetails[iCtr]['shtmtrs'].toString())),
          DataCell(Text(ItemDetails[iCtr]['shtprc'].toString())),
          DataCell(Text(ItemDetails[iCtr]['discper'].toString())),
          DataCell(Text(ItemDetails[iCtr]['discamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['addamt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['texavalue'].toString())),
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
          'Grey Purchase Challan [ ' +
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
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Select Branch',
                    labelText: 'Branch',
                  ),
                  onTap: () {
                    gotoBranchScreen(context);
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter branch';
                    }
                    return null;
                  },
                ),
              ),
            ]),
            TextFormField(
              controller: _date,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Date',
                labelText: 'Date',
              ),
              onTap: () {
                _selectDate(context);
              },
              validator: (value) {
                if (value == '') {
                  return 'Please enter date';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _book,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Book',
                      labelText: 'Book',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'SALE BOOK', _book);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _party,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Party',
                      labelText: 'Party',
                    ),
                    onTap: () {
                      gotoPartyScreen2(context, 'SALE PARTY', _party);
                    },
                    validator: (value) {
                      if (value == '') {
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Challan No',
                      labelText: 'Challan No',
                    ),
                    onTap: () {
                      // gotoPartyScreen(context, 'SALE PARTY', _delparty);
                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter challan no';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _chlndt,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Challan Date',
                      labelText: 'Challan Date',
                    ),
                    onTap: () {
                      _selectDate2(context);
                    },
                    validator: (value) {
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
                    controller: _agent,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Agent',
                      labelText: 'Agent',
                    ),
                    onTap: () {
                      gotoPartyScreen(context, 'AGENT', _party);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                      value: dropdownTrnType,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: 'RD/URD',
                          hintText: 'RD/URD'),
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
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _remarks,
                    textInputAction: TextInputAction.next,
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
                      return null;
                    },
                  ),
                )
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //       enabled: false,
            //       controller: _tottaka,
            //       keyboardType: TextInputType.number,
            //       decoration: const InputDecoration(
            //         icon: const Icon(Icons.person),
            //         hintText: 'Total Taka',
            //         labelText: 'Total Taka',
            //       ),
            //       onTap: () {
            //         //gotoBranchScreen(context);
            //       },
            //       validator: (value) {
            //         return null;
            //       },
            //     )),
            //     Expanded(
            //         child: TextFormField(
            //       enabled: false,
            //       controller: _totmtrs,
            //       keyboardType: TextInputType.number,
            //       decoration: const InputDecoration(
            //         icon: const Icon(Icons.person),
            //         hintText: 'Total Meters',
            //         labelText: 'Total Meters',
            //       ),
            //       onTap: () {
            //         //gotoBranchScreen(context);
            //       },
            //       validator: (value) {
            //         return null;
            //       },
            //     ))
            //   ],
            // ),
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
                    label: Text("Order No"),
                  ),
                  DataColumn(
                    label: Text("OrderChr"),
                  ),
                  DataColumn(
                    label: Text("Item Name"),
                  ),
                  DataColumn(
                    label: Text("Design"),
                  ),
                  DataColumn(
                    label: Text("Pcs"),
                  ),
                  DataColumn(
                    label: Text("Meters"),
                  ),
                  DataColumn(
                    label: Text("Weight"),
                  ),
                  DataColumn(
                    label: Text("Rate"),
                  ),
                  DataColumn(
                    label: Text("Stdwt"),
                  ),
                  DataColumn(
                    label: Text("Unit"),
                  ),
                  DataColumn(
                    label: Text("Amount"),
                  ),
                  DataColumn(
                    label: Text("Fmode"),
                  ),
                  DataColumn(
                    label: Text("Foldmtrs"),
                  ),
                  DataColumn(
                    label: Text("Shtmtrs"),
                  ),
                  DataColumn(
                    label: Text("ShtRate"),
                  ),
                  DataColumn(
                    label: Text("DiscRate"),
                  ),
                  DataColumn(
                    label: Text("DiscAmt"),
                  ),
                  DataColumn(
                    label: Text("AddAmt"),
                  ),
                  DataColumn(
                    label: Text("TexableValue"),
                  ),
                  DataColumn(
                    label: Text("SGST Rate"),
                  ),
                  DataColumn(
                    label: Text("SGST Amt"),
                  ),
                  DataColumn(
                    label: Text("CGST Rate"),
                  ),
                  DataColumn(
                    label: Text("CGST Amt"),
                  ),
                  DataColumn(
                    label: Text("IGST Rate"),
                  ),
                  DataColumn(
                    label: Text("IGST Amt"),
                  ),
                  DataColumn(
                    label: Text("Final Amt"),
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
