// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/eqtextfield.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import '../../../function.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;
import 'package:intl/intl.dart';


class SampleMaster extends StatefulWidget {
  SampleMaster({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var orderchr;
  double totmtrs = 0;
  double tottaka = 0;
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;

  @override
  _SampleMasterState createState() => _SampleMasterState();
}

class _SampleMasterState extends State<SampleMaster> {

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List ItemDetails = [];
 
  final _formKey = GlobalKey<FormState>();

  TextEditingController  _branch = new TextEditingController();
  TextEditingController _sampleno = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _reportbookno = new TextEditingController();
  TextEditingController _dyeingname = new TextEditingController();
  TextEditingController _fabricsname = new TextEditingController();
  TextEditingController _dyeingchallanno = new TextEditingController();
  TextEditingController _takachr = new TextEditingController();
  TextEditingController _takano = new TextEditingController();
  TextEditingController _fabricswidth = new TextEditingController();
  TextEditingController _pick = new TextEditingController();
  TextEditingController _fabricsweight = new TextEditingController();
  TextEditingController _totaltar = new TextEditingController();
  TextEditingController _warpingwidth = new TextEditingController();
  TextEditingController _weave = new TextEditingController();
  TextEditingController _fani = new TextEditingController();
  TextEditingController _warpdenierandfilament1 = new TextEditingController();
  TextEditingController _warpdenierandfilament2 = new TextEditingController();
  TextEditingController _warpdenierandfilament3 = new TextEditingController();
  TextEditingController _warpdenierandfilament4 = new TextEditingController();
  TextEditingController _warpdenierandfilament5 = new TextEditingController();
  TextEditingController _warpdenierandfilament6 = new TextEditingController();
  TextEditingController _warptpm1 = new TextEditingController();
  TextEditingController _warptpm2 = new TextEditingController();
  TextEditingController _warptpm3 = new TextEditingController();
  TextEditingController _warptpm4 = new TextEditingController();
  TextEditingController _warptpm5 = new TextEditingController();
  TextEditingController _warptpm6 = new TextEditingController();
  TextEditingController _note1 = new TextEditingController();
  TextEditingController _typeofyarnconame1 = new TextEditingController();
  TextEditingController _typeofyarnconame2 = new TextEditingController();
  TextEditingController _typeofyarnconame3 = new TextEditingController();
  TextEditingController _typeofyarnconame4 = new TextEditingController();
  TextEditingController _typeofyarnconame5 = new TextEditingController();
  TextEditingController _typeofyarnconame6 = new TextEditingController();
  TextEditingController _note2 = new TextEditingController();

  @override
  void initState() {
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = DateFormat("dd-MM-yyyy").format(curDate);
    super.initState();
    if (int.parse(widget.xid) > 0) {
      loadData();
    }
  }

  Future<bool> loadData() async {
    String uri = '';
    var companyid = widget.xcompanyid;
    var clientid = globals.dbname;
    var id = widget.xid;
    uri =
        "${globals.cdomain2}/api/api_designlist?dbname=$clientid&cno=$companyid&id=$id";
    print(" loadData : " + uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    // _design.text = getValue(jsonData['design'], 'C');
    // _itemname.text = getValue(jsonData['itemname'], 'C');
    // _printname.text = getValue(jsonData['printname'], 'C');
    id = jsonData['id'].toString();
    return true;
  }

  @override
  Widget build(BuildContext context) {

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
        var selBranch = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selBranch = selBranch + ',';
          }
          selBranch = selBranch + retResult[0][ictr].toString();
        }
        _branch.text = selBranch;
      });
    }

    void gotoItemnameScreen(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => item_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
    setState(() {
      var retResult = result;
      var newResult = result[1];
      var selItemname = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selItemname = selItemname + ',';
        }
        selItemname = selItemname + retResult[0][ictr];
      }
      setState(() {
        _dyeingname.text = newResult[0]['itemname'].toString();
      });
    });
  }

  void gotoDyeingnameScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => party_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'SALE PARTY',
                  )));

      if (result != null) {
        setState(() {
          var retResult = result;
          var selParty = '';
          for (var ictr = 0; ictr < retResult[0].length; ictr++) {
            if (ictr > 0) {
              selParty = selParty + ',';
            }
            selParty = selParty + retResult[0][ictr];
          }
          _dyeingname.text = selParty;
        });
      }
    }

    //  Future<bool> saveData() async {
    //   String uri = '';
    //   var companyid = widget.xcompanyid;
    //   var clientid = globals.dbname;
    //   var design = _design.text;
    //   var itemname = _itemname.text;
    //   var printname = _printname.text;
    //   var id = widget.xid;
    //   id = int.parse(id);
    //   uri =
    //       "${globals.cdomain2}/api/api_designstort?dbname=$clientid" +
    //           "&design=" +
    //           design +
    //           "&itemname=" +
    //           itemname +
    //           "&printname=" +
    //           printname +
    //           "&id=" +
    //           id.toString();
    //   print(" SaveData : " + uri);
    //   var response = await http.post(Uri.parse(uri));
    //   var jsonData = jsonDecode(response.body);
    //   var jsonCode = jsonData['Code'];
    //   var jsonMsg = jsonData['Message'];
    //   print(jsonCode);
    //   if (jsonCode == '500') {
    //     showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
    //   } else if (jsonCode == '100') {
    //     showAlertDialog(context, 'Error While Saving !!! ' + jsonMsg);
    //   } else {
    //     Navigator.pop(context);
    //     Fluttertoast.showToast(
    //     msg: "Saved !!!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.white,
    //     textColor: Colors.purple,
    //     fontSize: 16.0,
    //     );
    //   }
    //   return true;
    // }

    return Scaffold(
      appBar: EqAppBar(AppBarTitle: "Sample Master"),  
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _branch,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Select branch',
                    labelText: 'Select branch',
                    onTap: () {
                      gotoBranchScreen(context);
                    },
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _sampleno,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Sampleno',
                    labelText: 'Sampleno',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _date,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Date',
                    labelText: 'Date',
                    onTap: () {
                      _selectDate(context);
                    },
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _reportbookno,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Report Book No',
                    labelText: 'Report Book No',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _dyeingname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Dyeing Name',
                    labelText: 'Dyeing Name',
                    onTap: () {
                      gotoDyeingnameScreen(context);
                    },
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _fabricsname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    hintText: 'Farbrics Name',
                    labelText: 'Farbrics Name',
                    onTap: () {
                      gotoItemnameScreen(context);
                    },
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _dyeingchallanno,
                    textInputAction: TextInputAction.next,
                    hintText: 'Dyeing Challan No',
                    labelText: 'Dyeing Challan No',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _takachr,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Takachr',
                    labelText: 'Takachr',
                    onTap: () {},
                    onChanged: (value) {
                      _takachr.value = _takachr.value.copyWith(
                        text: value.toUpperCase(),
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _takano,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Takano',
                    labelText: 'Takano',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _fabricswidth,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Fabrics Width',
                    labelText: 'Fabrics Width',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _pick,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Pick',
                    labelText: 'Pick',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _fabricsweight,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Fabrics Weight',
                    labelText: 'Fabrics Weight',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _totaltar,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintText: 'Total Tar',
                    labelText: 'Total Tar',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warpingwidth,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Warping width',
                    labelText: 'Warping width',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _weave,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weave',
                    labelText: 'Weave',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _fani,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Fani',
                    labelText: 'Fani',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _warpdenierandfilament1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft Denier & Filament',
                    labelText: 'Weft Denier & Filament',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warpdenierandfilament2,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft Denier & Filament',
                    labelText: 'Weft Denier & Filament',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _warpdenierandfilament3,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft Denier & Filament',
                    labelText: 'Weft Denier & Filament',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warpdenierandfilament4,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft Denier & Filament',
                    labelText: 'Weft Denier & Filament',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _warpdenierandfilament5,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft Denier & Filament',
                    labelText: 'Weft Denier & Filament',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warpdenierandfilament6,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft Denier & Filament',
                    labelText: 'Weft Denier & Filament',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _warptpm1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft T.p.m.',
                    labelText: 'Weft T.p.m.',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warptpm2,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft T.p.m.',
                    labelText: 'Weft T.p.m.',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _warptpm3,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft T.p.m.',
                    labelText: 'Weft T.p.m.',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warptpm4,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft T.p.m.',
                    labelText: 'Weft T.p.m.',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _warptpm5,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft T.p.m.',
                    labelText: 'Weft T.p.m.',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _warptpm6,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Weft T.p.m.',
                    labelText: 'Weft T.p.m.',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _note1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Note',
                    labelText: 'Note',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _typeofyarnconame1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Type Of Yarn & Co.name',
                    labelText: 'Type Of Yarn & Co.name',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _typeofyarnconame2,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Type Of Yarn & Co.name',
                    labelText: 'Type Of Yarn & Co.name',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _typeofyarnconame3,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Type Of Yarn & Co.name',
                    labelText: 'Type Of Yarn & Co.name',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _typeofyarnconame4,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Type Of Yarn & Co.name',
                    labelText: 'Type Of Yarn & Co.name',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _typeofyarnconame5,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Type Of Yarn & Co.name',
                    labelText: 'Type Of Yarn & Co.name',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: EqTextField(
                    controller: _typeofyarnconame6,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Type Of Yarn & Co.name',
                    labelText: 'Type Of Yarn & Co.name',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: EqTextField(
                    controller: _note2,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Note',
                    labelText: 'Note',
                    onTap: () {},
                    onChanged: (value) {},
                  ),
                )
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
                      textStyle: TextStyle(fontSize: 25,color: const Color.fromARGB(231, 255, 255, 255),), // Text style
                      backgroundColor: Colors.green, 
                      // Background color
                    ),
                    onPressed: () {
                      // saveData();
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
            )
          ],
        ),
      )),
    );
  }
}
