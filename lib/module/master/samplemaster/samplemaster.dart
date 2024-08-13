// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_mobile/common/alert.dart';
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

  TextEditingController _branch = new TextEditingController();
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
        "${globals.cdomain}/api/api_samplemasterlist?dbname=$clientid&cno=$companyid&id=$id";

    print(" loadData : " + uri);
    var response = await http.get(Uri.parse(uri));
    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['Data'];
    jsonData = jsonData[0];
    print(jsonData);
    _branch.text = getValue(jsonData['branch'], 'C');
    _reportbookno.text = getValue(jsonData['bookno'].toString(), 'C');
    _dyeingchallanno.text = getValue(jsonData['chlnno'].toString(), 'C');
    _sampleno.text = getValue(jsonData['itemname'], 'C');
    _date.text = getValue(jsonData['date'], 'C');
    _reportbookno.text = getValue(jsonData['design'], 'C');
    _dyeingname.text = getValue(jsonData['itemname'], 'C');
    _fabricsname.text = getValue(jsonData['printname'], 'C');
    _dyeingchallanno.text = getValue(jsonData['chlnno'], 'C');
    _takachr.text = getValue(jsonData['takachr'], 'C');
    _takano.text = getValue(jsonData['takano'], 'C');
    _fabricswidth.text = getValue(jsonData['fabricwidth'], 'C');
    _pick.text = getValue(jsonData['pick'], 'C');
    _fabricsweight.text = getValue(jsonData['weight'], 'C');
    _totaltar.text = getValue(jsonData['tar'], 'C');
    _warpingwidth.text = getValue(jsonData['worpingwidth'], 'C');
    _weave.text = getValue(jsonData['weave'], 'C');
    _fani.text = getValue(jsonData['fani'], 'C');
    _warpdenierandfilament1.text = getValue(jsonData['denier1'], 'C');
    _warpdenierandfilament2.text = getValue(jsonData['denier2'], 'C');
    _warpdenierandfilament3.text = getValue(jsonData['denier3'], 'C');
    _warpdenierandfilament4.text = getValue(jsonData['denier4'], 'C');
    _warpdenierandfilament5.text = getValue(jsonData['denier5'], 'C');
    _warpdenierandfilament6.text = getValue(jsonData['denier6'], 'C');
    _warptpm1.text = getValue(jsonData['tpm1'], 'C');
    _warptpm2.text = getValue(jsonData['tpm2'], 'C');
    _warptpm3.text = getValue(jsonData['tpm3'], 'C');
    _warptpm4.text = getValue(jsonData['tpm4'], 'C');
    _warptpm5.text = getValue(jsonData['tpm5'], 'C');
    _warptpm6.text = getValue(jsonData['tpm6'], 'C');
    _note1.text = getValue(jsonData['note'], 'C');
    _typeofyarnconame1.text = getValue(jsonData['yarn1'], 'C');
    _typeofyarnconame2.text = getValue(jsonData['yarn2'], 'C');
    _typeofyarnconame3.text = getValue(jsonData['yarn3'], 'C');
    _typeofyarnconame4.text = getValue(jsonData['yarn4'], 'C');
    _typeofyarnconame5.text = getValue(jsonData['yarn5'], 'C');
    _typeofyarnconame6.text = getValue(jsonData['yarn6'], 'C');
    _note2.text = getValue(jsonData['note1'], 'C');
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
          _fabricsname.text = newResult[0]['itemname'].toString();
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

    Future<bool> saveData() async {
      String uri = '';
      var companyid = widget.xcompanyid;
      var clientid = globals.dbname;
      var user = globals.username;
      var branch = _branch.text;
      var sampleno = _sampleno.text;
      var date = _date.text;
      var reportbookno = _reportbookno.text;
      var dyeingname = _dyeingname.text;
      var fabricsname = _fabricsname.text;
      var dyeingchallanno = _dyeingchallanno.text;
      var takachr = _takachr.text;
      var takano = _takano.text;
      var fabricswidth = _fabricswidth.text;
      var pick = _pick.text;
      var fabricsweight = _fabricsweight.text;
      var totaltar = _totaltar.text;
      var warpingwidth = _warpingwidth.text;
      var weave = _weave.text;
      var fani = _fani.text;
      var warpdenierandfilament1 = _warpdenierandfilament1.text;
      var warpdenierandfilament2 = _warpdenierandfilament2.text;
      var warpdenierandfilament3 = _warpdenierandfilament3.text;
      var warpdenierandfilament4 = _warpdenierandfilament4.text;
      var warpdenierandfilament5 = _warpdenierandfilament5.text;
      var warpdenierandfilament6 = _warpdenierandfilament6.text;
      var warptpm1 = _warptpm1.text;
      var warptpm2 = _warptpm2.text;
      var warptpm3 = _warptpm3.text;
      var warptpm4 = _warptpm4.text;
      var warptpm5 = _warptpm5.text;
      var warptpm6 = _warptpm6.text;
      var note1 = _note1.text;
      var typeofyarnconame1 = _typeofyarnconame1.text;
      var typeofyarnconame2 = _typeofyarnconame2.text;
      var typeofyarnconame3 = _typeofyarnconame3.text;
      var typeofyarnconame4 = _typeofyarnconame4.text;
      var typeofyarnconame5 = _typeofyarnconame5.text;
      var typeofyarnconame6 = _typeofyarnconame6.text;
      var note2 = _note2.text;

      var id = widget.xid;
      id = int.parse(id);

DateTime parsedstartDate = DateFormat("dd-MM-yyyy").parse(globals.startdate);
      String newstartDate = DateFormat("yyyy-MM-dd").format(parsedstartDate);
DateTime parsedEndDate = DateFormat("dd-MM-yyyy").parse(globals.enddate);
      String newEndDate = DateFormat("yyyy-MM-dd").format(parsedEndDate);

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(_date.text);
      String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      uri = "${globals.cdomain}/api/api_storesamplemst?dbname=$clientid" +
          "&cno=$companyid" +
          "&id=${id.toString()}" +
          "&startdate=$newstartDate" +
          "&enddate=$newEndDate" +
          "&branch=$branch" +
          "&itemname=$fabricsname" +
          "&party=$dyeingname" +
          "&srchr&serial" +
          "&user=$user" +
          "&date=$newDate";

      //127.0.0.1:8000/api/?dbname=admin_looms&
      //cno=3&id=0&startdate=2024-04-01&enddate=2025-03-31&branch=5904&itemname=30*20 GERMAN&party=RAJ CREATION&srchr&serial&user=KRISHNA&date=2024-08-10
      //         "&design=" +
      //         // design +
      //         "&itemname=" +
      //         // itemname +
      //         "&printname=" +
      //         // printname +
      //         "&id=" +
      //         id.toString();

      print(" SaveData : " + uri);
      var response = await http.post(Uri.parse(uri));
      var jsonData = jsonDecode(response.body);
      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];
      print(jsonCode);
      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
      } else if (jsonCode == '100') {
        showAlertDialog(context, 'Error While Saving !!! ' + jsonMsg);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Saved !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.purple,
          fontSize: 16.0,
        );
      }
      return true;
    }

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
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: const Color.fromARGB(231, 255, 255, 255),
                      ), // Text style
                      backgroundColor: Colors.green,
                      // Background color
                    ),
                    onPressed: () {
                      saveData();
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ), // Text style
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
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(231, 255, 255, 255),
                      ),
                    ),
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
