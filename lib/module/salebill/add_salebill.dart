import 'dart:convert';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/module/salebill/add_saledet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
class SalesBillAdd extends StatefulWidget {
  SalesBillAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _SalesBillAddState createState() => _SalesBillAddState();
}

class _SalesBillAddState extends State<SalesBillAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];

  List ItemDetails = [];

  String dropdownTrnType = 'REGULAR';

  var branchid = 0;
  var partyid = 0;
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _tottqty = new TextEditingController();
  TextEditingController _totnetamt = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);
    var curDate = getsystemdate();
    _date.text = curDate.toString().split(' ')[0];
    if (int.parse(widget.xid) > 0) {
      loadData();
      loadDetData();
    }
  }
 Future<bool> loadDetData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
  uri =
        'https://www.cloud.equalsoftlink.com/api/api_salebilldetlist?dbname=$clientid&cno=$companyid&id=$id';
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    print(uri);
    jsonData = jsonData['Data'];
    List ItemDet = [];
    ItemDetails = [];
    for (var iCtr = 0; iCtr < jsonData.length; iCtr++) {
      ItemDet.add({
        "controlid": jsonData[iCtr]['controlid'].toString(),
        "entryid": jsonData[iCtr]['entryid'].toString(),
        "barcode": jsonData[iCtr]['barcode'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "hsncode": jsonData[iCtr]['hsncode'].toString(),
        "pcs": jsonData[iCtr]['pcs'].toString(),
        "cut": jsonData[iCtr]['cut'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        "unit": jsonData[iCtr]['unit'].toString(),
        "amount": jsonData[iCtr]['amount'].toString(),
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
        "remarks": jsonData[iCtr]['remarks'].toString(),
        "catalog": jsonData[iCtr]['catalog'].toString(),
      });
    }
    setState(() {
      ItemDetails = ItemDet;
    });
    return true;
  }
 Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        'https://www.cloud.equalsoftlink.com/api/api_getsalebilllist?dbname=$clientid&cno=$companyid&id=$id&startdate=${fromDate.toString()}&enddate=${toDate.toString()}';
    print(uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'][0];
    _serial.text = jsonData['serial'].toString();
    _srchr.text = jsonData['srchr'].toString();
    String dt = jsonData['date'];
    _party.text = jsonData['party'];
    _remarks.text = getValue(jsonData['remarks'], 'C');
    return true;
  }
  Future<void> _selectDate(BuildContext context) async {
    if (_date.text != '') {
      fromDate = retconvdate(_date.text, 'yyyy-mm-dd');
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _date.text = picked.toString().split(' ')[0];
      });
  }
  void setDefValue() {}
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
      setState(() {
        var retResult = result;
        _partylist = result[1];
        result = result[1];
        partyid = _partylist[0];
        print(partyid);
        var selParty = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selParty = selParty + ',';
          }
          selParty = selParty + retResult[0][ictr];
        }
        obj.text = selParty;
        if (selParty != '') {
          getPartyDetails(obj.text, 0).then((value) {
            setState(() {});
          });
        }
      });
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
      });
    }
    void gotoChallanItemDet(BuildContext contex) async {
      print('in');
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SaleBillDetAdd(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    partyid: partyid,
                    itemDet: ItemDetails,
                    branchid: branchid,
                  )));
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
      var date = _date.text;
      var party = _party.text;
      var remarks = _remarks.text;
      var id = widget.xid;
      id = int.parse(id);
      print('In Save....');
      print(jsonEncode(ItemDetails));
      uri =
          "https://looms.equalsoftlink.com/api/api_storeloomsgreyjobissue?dbname=" +
              db +
              "&company=&cno=" +
              cno +
              "&user=" +
              username +
              "&party=" +
              party +
              "&srchr=" +
              srchr +
              "&serial=" +
              serial +
              "&date=" +
              date +
              "&remarks=" +
              remarks +
              "&id=" +
              id.toString() +
              "&parcel=1";
      print(uri);
      final headers = {
        'Content-Type': 'application/json', 
      };
      print(ItemDetails);
      var response = await http.post(Uri.parse(uri),
          headers: headers, body: jsonEncode(ItemDetails));
      var jsonData = jsonDecode(response.body);
      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else {
        showAlertDialog(context, 'Saved !!!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SalesBillAdd(
                      companyid: widget.xcompanyid,
                      companyname: widget.xcompanyname,
                      fbeg: widget.xfbeg,
                      fend: widget.xfend,
                    )));
      }
      return true;
    }
    setState(() {});
    void deleteRow(index) {
      setState(() {
        ItemDetails.removeAt(index);
      });
    }

      List<DataRow> _createRows() {
      List<DataRow> _datarow = [];

      widget.tottaka = 0;
      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {
        double nPcs = 0;
        if (ItemDetails[iCtr]['pcs'].toString() != '') {
          nPcs = nPcs + double.parse(ItemDetails[iCtr]['pcs']);
          widget.tottaka += nPcs;
        }
        _datarow.add(DataRow(cells: [
          DataCell(ElevatedButton.icon(
            onPressed: () => {
                 showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  //saveData();
                  return AlertDialog(
                    title: const Text('Do You Want To Remove is Item Details !!??'),
                    content: Container(
                      height: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('YES'),
                        onPressed: () {
                          setState(() {
                              deleteRow(iCtr);
                            });
                          Navigator.of(context).pop();
                        },
                        ),
                        TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('NO'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )
              },
            icon: Icon(
              // <-- Icon
              Icons.delete,
              size: 20.0,
            ),
            label: Text('',
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
          ) ),
          
          DataCell(Text(ItemDetails[iCtr]['itemname'].toString())),
          DataCell(Text(ItemDetails[iCtr]['hsncode'].toString())),
          DataCell(Text(ItemDetails[iCtr]['meters'].toString())),
          DataCell(Text(ItemDetails[iCtr]['rate'].toString())),
          DataCell(Text(ItemDetails[iCtr]['unit'].toString())),
          DataCell(Text(ItemDetails[iCtr]['remarks'].toString())),
          DataCell(
             Container( 
                child:Text(ItemDetails[iCtr]['cut'].toString()),
              ),
            ),
          DataCell(
             Container( 
                child:Text(ItemDetails[iCtr]['pcs'].toString()),
              ),
          ),
          

          DataCell(
             Container(
                child:Text(ItemDetails[iCtr]['amount'].toString()),
              ),
          ),
          DataCell(
            Container( 
                width:1, // Set the desired width
                child:Text(ItemDetails[iCtr]['discper'].toString()),
              ),
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['discamt'].toString()),
              ),
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['addamt'].toString()),
              ),
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['taxablevalue'].toString()),
              ),
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['sgstrate'].toString()),
              ),
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['sgstamt'].toString()),
              ),
            ),
          DataCell(
             Container( 
                child:Text(ItemDetails[iCtr]['cgstrate'].toString()),
              ),
            ),
          DataCell(
              Container( 
                child:Text(ItemDetails[iCtr]['cgstamt'].toString()),
              ),
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['igstrate'].toString()),
              ),
            
            ),
          DataCell(
            Container( 
                child:Text(ItemDetails[iCtr]['igstamt'].toString()),
              ),
            ),
          DataCell(
             Container( 
                child:Text(ItemDetails[iCtr]['finalamt'].toString()),
              ),
           
            ),
            DataCell(
             Container( // Wrap the content with a Container
                width:0, // Set the desired width
                child:Text(ItemDetails[iCtr]['barcode'].toString()),
              ),
            ),
            

          DataCell(
            Container( // Wrap the content with a Container
                width:1, // Set the desired width
                child:Text(ItemDetails[iCtr]['entryid'].toString()),
              ),
            //Text(ItemDetails[iCtr]['entryid'].toString())
            ),
        ]));
      }

      setState(() {
        _tottqty.text = widget.tottaka.toString();
      });

      return _datarow;
    }
    setDefValue();
    return Scaffold(
      appBar: EqAppBar(
        AppBarTitle: 'Sale Bill [ ' +
            (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
            ' ] ' +
            (int.parse(widget.xid) > 0
                ? 'Serial No : ' + widget.serial.toString()
                : ''),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  enabled: false,
                  controller: _tottqty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Qty',
                    labelText: 'Total Qty',
                  ),
                  onTap: () {
                    //gotoBranchScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                )),
                Expanded(
                    child: TextFormField(
                  enabled: false,
                  controller: _totnetamt,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Net Amt',
                    labelText: 'Net Amt',
                  ),
                  onTap: () {
                    //gotoBranchScreen(context);
                  },
                  validator: (value) {
                    return null;
                  },
                ))
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(231, 255, 255, 255),
                        ), // Text style
                        backgroundColor: Colors.green,
                        // Background color
                      ),
                      onPressed: () {
                        gotoChallanItemDet(context);
                      },
                      child: const Text(
                        'Add Item Details',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(231, 255, 255, 255),
                        ),
                      ),
                    )),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 25,color: const Color.fromARGB(231, 255, 255, 255),), // Text style
                      backgroundColor: Colors.green, 
                      // Background color
                    ),
                    onPressed: () {
                      saveData();
                    },
                    child: const Text('SAVE',style: TextStyle(fontSize: 20,color: Color.fromARGB(231, 255, 255, 255),),),
                  )),
                  SizedBox(
                   width: 10
                  ),
                  Expanded(
                    child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 25,color: Color.fromARGB(231, 255, 255, 255),), // Text style
                      backgroundColor: Colors.green, // Background color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                        Fluttertoast.showToast(
                        msg: "CANCEL !!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.purple,
                        fontSize: 16.0,
                        );
                    },
                    child: const Text('CANCEL',style: TextStyle(fontSize: 20,color: Color.fromARGB(231, 255, 255, 255),),),
                  ))
                ],
              ),
            ),
             SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: InkWell(
                    onDoubleTap: () {
                      if (_party.text == "") {
                      } else {
                        gotoChallanItemDet(context);
                      }
                    },
                    child: DataTable(columns: [
                      DataColumn(
                        label: Text("Action"),
                      ),
                      DataColumn(
                        label: Text("Item Name"),
                      ),
                      DataColumn(
                        label: Text("HSN Code"),
                      ),
                      DataColumn(
                        label: Text("Qty"),
                      ),
                      DataColumn(
                        label: Text("Rate"),
                      ),
                      DataColumn(
                        label: Text("Unit"),
                      ),
                      DataColumn(
                        label: Text("Remarks"),
                      ),
                      DataColumn(
                        //label: Text("Cut"),
                        label: SizedBox( 
                          child: Text('Cut'),
                        ), 
                      ),
                      DataColumn(
                         label: SizedBox( 
                          child: Text('Pcs'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('Amount'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('Disc Rate'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('Disc Amt'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('Add Amt'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Taxable Value'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('SGST Rate'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('SGST Amt'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('CGST Rate'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox( 
                          child: Text('CGST Amt'),
                        ),
                      ),
                      DataColumn(
                         label: SizedBox( 
                          child: Text('IGST Rate'),
                        ),
                      ),
                      DataColumn(
                         label: SizedBox( 
                          child: Text('IGST Amt'),
                        ),
                      ),
                      DataColumn(
                         label: SizedBox( 
                          child: Text('Final Amt'),
                        ),
                      ),
                       DataColumn(
                          label: SizedBox( // Wrap the label with SizedBox to set width
                          width: 1, // Set the desired width
                          child: Text('Barcode'),
                        ),
                      ),
                      DataColumn(
                          label: SizedBox( 
                          child: Text('EntryId'),
                        ),
                      ),
                    ], rows: _createRows()),
                  )),
          ],
        ),
      )),
    );
  }
}
