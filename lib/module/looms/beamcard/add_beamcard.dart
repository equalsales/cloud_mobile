// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/machine_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';

class BeamCardAdd extends StatefulWidget {
  BeamCardAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _BeamCardAddState createState() => _BeamCardAddState();
}

class _BeamCardAddState extends State<BeamCardAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  var _partylist = [];
  List ItemDetails = [];

  var branchid = 0;
  int? partyid;
  var bookid = 0;

  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _branch = new TextEditingController();
  TextEditingController _beamchr = new TextEditingController();
  TextEditingController _beamno = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _warpdate = new TextEditingController();
  TextEditingController _pipeno = new TextEditingController(text: '0');
  TextEditingController _denier1 = new TextEditingController(text: '0');
  TextEditingController _denier2 = new TextEditingController(text: '0');
  TextEditingController _denier3 = new TextEditingController(text: '0');
  TextEditingController _length = new TextEditingController(text: '0');
  TextEditingController _ends = new TextEditingController(text: '0');
  TextEditingController _oliweight = new TextEditingController(text: '0.000');
  TextEditingController _reed = new TextEditingController(text: '0');
  TextEditingController _beamweight = new TextEditingController(text: '0.000');
  TextEditingController _metersonbeam = new TextEditingController(text: '0');
  TextEditingController _metertaka = new TextEditingController();
  TextEditingController _machineno = new TextEditingController();
  TextEditingController _shortage = new TextEditingController(text: '0');
  TextEditingController _estimale = new TextEditingController();
  TextEditingController _estimale2 = new TextEditingController();
  TextEditingController _warpwttaka = new TextEditingController(text: '0');
  TextEditingController _weftdenier1 = new TextEditingController(text: '0');
  TextEditingController _weftdenier2 = new TextEditingController(text: '0');
  TextEditingController _width = new TextEditingController(text: '0.00');
  TextEditingController _pick = new TextEditingController(text: '0');
  TextEditingController _weftweight = new TextEditingController(text: '0.000');
  TextEditingController _jogname = new TextEditingController();
  TextEditingController _jograte = new TextEditingController(text: '0.00');
  TextEditingController _jogamount = new TextEditingController(text: '0.00');
  TextEditingController _jogdate = new TextEditingController();
  TextEditingController _droppingname = new TextEditingController();
  TextEditingController _droppingrate = new TextEditingController(text: '0.00');
  TextEditingController _droppingamount = new TextEditingController(text: '0.00');
  TextEditingController _beammakeer = new TextEditingController();
  TextEditingController _beamspreader = new TextEditingController();
  TextEditingController _makerrate = new TextEditingController(text: '0.00');
  TextEditingController _spreaderrate = new TextEditingController(text: '0.00');
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _nooftaka = new TextEditingController(text: '0');
  TextEditingController _installdate = new TextEditingController();
  TextEditingController _1meterswt = new TextEditingController(text: '0.000');
  TextEditingController _weftmeters = new TextEditingController(text: '0.00');
  TextEditingController _spreaderdate = new TextEditingController();
  TextEditingController _weighttaka = new TextEditingController(text: '0');
  TextEditingController _producemeters = new TextEditingController(text: '0.00');
  TextEditingController _producewt = new TextEditingController(text: '0.000');
  TextEditingController _weight100meters = new TextEditingController(text: '0.00');
  TextEditingController _completiondate = new TextEditingController();
  TextEditingController _shrinkage = new TextEditingController(text: '0');
  TextEditingController _balmeters = new TextEditingController(text: '0');
  TextEditingController _baltaka = new TextEditingController(text: '0');
  TextEditingController _droppingdate = new TextEditingController();
  TextEditingController _recserial = new TextEditingController(text: '0');
  TextEditingController _recpartyid = new TextEditingController(text: '0');
  TextEditingController _rectype = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var partystate = '';
  var party = '';
  var partyacctype = 'PURCHASE PARTY';

  bool isButtonActive = true;

  var crlimit = 0.0;
  dynamic clobl = 0;

  String dropdownTopMidLow = 'LOWER';

  var TopMidLows = [
    'TOP',
    'MIDDLE',
    'LOWER',
  ];

  String dropdownPer = 'BEAM';

  var Pers = [
    'BEAM',
    'CARD',
  ];

  String dropdownMasterBeam = 'N';

  var MasterBeam = [
    'N',                                                                                                                                                                                                                       
    'Y',
  ];

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _warpdate.text = DateFormat("dd-MM-yyyy").format(curDate);
    _jogdate.text = DateFormat("dd-MM-yyyy").format(curDate);
    _installdate.text = DateFormat("dd-MM-yyyy").format(curDate);
    _spreaderdate.text = DateFormat("dd-MM-yyyy").format(curDate);
    _completiondate.text = DateFormat("dd-MM-yyyy").format(curDate);
    _droppingdate.text = DateFormat("dd-MM-yyyy").format(curDate);

    // _book.text = 'PURCHASE A/C';

    if (int.parse(widget.xid) > 0) {
      // loadData();
    }
  }

  // Future<bool> loadData() async {
  //   String uri = '';
  //   String uri2 = '';
  //   var cno = globals.companyid;
  //   var db = globals.dbname;
  //   var id = widget.xid;
  //   var fromdate = widget.xfbeg;
  //   var todate = widget.xfend;
  //   DateTime date = DateFormat("dd-MM-yyyy").parse(fromdate);
  //   String start = DateFormat("yyyy-MM-dd").format(date);
  //   DateTime date2 = DateFormat("dd-MM-yyyy").parse(todate);
  //   String end = DateFormat("yyyy-MM-dd").format(date2);
  //   uri = '${globals.cdomain}/api/api_getbeampurchallanlist?cno=' +
  //       cno +
  //       '&startdate=' +
  //       start +
  //       '&enddate=' +
  //       end +
  //       '&dbname=' +
  //       db +
  //       '&id=' +
  //       id.toString();
  //   print(" loadData :" + uri);
  //   var response = await http.get(Uri.parse(uri));
  //   var jsonData = jsonDecode(response.body);
  //   jsonData = jsonData['Data'];
  //   jsonData = jsonData[0];
  //   print(jsonData);
  //   // String inputDateString = jsonData['date2'];
  //   // List<String> parts = inputDateString.split(' ')[0].split('-');
  //   // String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
  //   _date.text = jsonData['date2'];
  //   _branch.text = jsonData['branch'];
  //   _serial.text = jsonData['serial'];
  //   _srchr.text = jsonData['srchr'];
  //   _book.text = jsonData['book'];
  //   _party.text = jsonData['party'];
  //   // partystate = jsonData['station'];
  //   _chlndt.text = jsonData['chlndt'];
  //   _chlnno.text = jsonData['chlnno'];
  //   dropdownTrnType = jsonData['rdurd'].toString();
  //   if (dropdownTrnType == '') {
  //     dropdownTrnType = 'RD';
  //   }
  //   if (dropdownTrnType == 'null') {
  //     dropdownTrnType = 'RD';
  //   }
  //   _remarks.text = jsonData['remarks'];
  //   widget.serial = jsonData['serial'].toString();
  //   widget.srchr = jsonData['srchr'].toString();
  //   party = _party.text;
  //   uri2 = '${globals.cdomain}/api/api_getpartylist?dbname=' +
  //       db +
  //       '&id=' +
  //       '&acctype=' +
  //       partyacctype +
  //       '&party=' +
  //       party;
  //   print(" api_getpartylist :" + uri2);
  //   var response2 = await http.get(Uri.parse(uri2));
  //   var Data2 = jsonDecode(response2.body);
  //   var jsonData2 = Data2['Data'];
  //   partystate = jsonData2[0]['state'];
  //   print("  partystate :" + partystate);
  //   setState(() {});
  //   return true;
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _warpdate.text = DateFormat("dd-MM-yyyy").format(picked);
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
        _jogdate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  Future<void> _selectDate3(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _installdate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  Future<void> _selectDate4(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _spreaderdate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  Future<void> _selectDate5(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _completiondate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  Future<void> _selectDate6(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _droppingdate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
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
          _itemname.text = newResult[0]['itemname'].toString();
        });
      });
    }

    void gotoJognameScreen(BuildContext context) async {
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
        var selJogname = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selJogname = selJogname + ',';
          }
          selJogname = selJogname + retResult[0][ictr];
        }
        setState(() {
          _jogname.text = newResult[0]['itemname'].toString();
        });
      });
    }

    void gotoDroppingnameScreen(BuildContext context) async {
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
        var selDroppingname = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selDroppingname = selDroppingname + ',';
          }
          selDroppingname = selDroppingname + retResult[0][ictr];
        }
        setState(() {
          _droppingname.text = newResult[0]['itemname'].toString();
        });
      });
    }

    void gotoBeamSpreaderScreen(BuildContext context) async {
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
        var selBeamSpreader = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selBeamSpreader = selBeamSpreader + ',';
          }
          selBeamSpreader = selBeamSpreader + retResult[0][ictr];
        }
        setState(() {
          _droppingname.text = newResult[0]['itemname'].toString();
        });
      });
    }

    void gotoMachinenoScreen(BuildContext contex) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => machine_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend)));

      setState(() {
        var retResult = result;

        var selMachine = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selMachine = selMachine + ',';
          }
          selMachine = selMachine + retResult[0][ictr];
        }
        _machineno.text = selMachine;
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
        _branch.text = selBranch;
      });
    }

    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;
      var serial = _serial.text;
      var srchr = _srchr.text;
      var branch = _branch.text;
      var beamchr = _beamchr.text;
      var beamno = _beamno.text;
      var itemname = _itemname.text;
      var warpdate = _warpdate.text;
      var pipeno = _pipeno.text;
      var denier1 = _denier1.text;
      var denier2 = _denier2.text;
      var denier3 = _denier3.text;
      var length = _length.text;
      var ends = _ends.text;
      var oliweight = _oliweight.text;
      var reed = _reed.text;
      var beamweight = _beamweight.text;
      var metersonbeam = _metersonbeam.text;
      var metertaka = _metertaka.text;
      var machineno = _machineno.text;
      var shortage = _shortage.text;
      var estimale = _estimale.text;
      var estimale2 = _estimale2.text;
      var topmidlow = dropdownTopMidLow;
      var per = dropdownPer;
      var warpwttaka = _warpwttaka.text;
      var weftdenier1 = _weftdenier1.text;
      var weftdenier2 = _weftdenier2.text;
      var width = _width.text;
      var pick = _pick.text;
      var weftweight = _weftweight.text;
      var jogname = _jogname.text;
      var jograte = _jograte.text;
      var jogamount = _jogamount.text;
      var jogdate = _jogdate.text;
      var droppingname = _droppingname.text;
      var droppingrate = _droppingrate.text;
      var droppingamount = _droppingamount.text;
      var beammakeer = _beammakeer.text;
      var beamspreader = _beamspreader.text;
      var spreaderrate = _spreaderrate.text;
      var makerrate = _makerrate.text;
      var remarks = _remarks.text;
      var nooftaka = _nooftaka.text;
      var installdate = _installdate.text;
      var onemeterswt = _1meterswt.text;
      var weftmeters = _weftmeters.text;
      var spreaderdate = _spreaderdate.text;
      var weighttaka = _weighttaka.text;
      var producemeters = _producemeters.text;
      var producewt = _producewt.text;
      var weight100meters = _weight100meters.text;
      var completiondate = _completiondate.text;
      var shrinkage = _shrinkage.text;
      var balmeters = _balmeters.text;
      var baltaka = _baltaka.text;
      var droppingdate = _droppingdate.text;
      var masterbeam = dropdownMasterBeam;
      var recserial = _recserial.text;
      var recpartyid = _recpartyid.text;
      var rectype = _rectype.text;

      var id = widget.xid;
      id = int.parse(id);

      DateTime parsedDate1 = DateFormat("dd-MM-yyyy").parse(warpdate);
      String newwarpdate = DateFormat("yyyy-MM-dd").format(parsedDate1);
      DateTime parsedDate2 = DateFormat("dd-MM-yyyy").parse(jogdate);
      String newjogdate = DateFormat("yyyy-MM-dd").format(parsedDate2);
      DateTime parsedDate3 = DateFormat("dd-MM-yyyy").parse(installdate);
      String newinstalldate = DateFormat("yyyy-MM-dd").format(parsedDate3);
      DateTime parsedDate4 = DateFormat("dd-MM-yyyy").parse(spreaderdate);
      String newspreaderdate = DateFormat("yyyy-MM-dd").format(parsedDate4);
      DateTime parsedDate5 = DateFormat("dd-MM-yyyy").parse(completiondate);
      String newcompletiondate = DateFormat("yyyy-MM-dd").format(parsedDate5);
      DateTime parsedDate6 = DateFormat("dd-MM-yyyy").parse(droppingdate);
      String newdroppingdate = DateFormat("yyyy-MM-dd").format(parsedDate6);
    
    
      uri = "${globals.cdomain}/api/api_storebeamcard?dbname=" +
          db + "&company=&cno=" + cno + "&user=" + username + "&srchr=" + srchr + "&serial=" + serial + 
          "&branch=" + branch + "&beamchr=" +beamchr + "&beamno=" + beamno + "&itemname=" + itemname +
          '&warpdate=' + newwarpdate + '&pipeno=' + pipeno + '&denier1=' + denier1 + '&denier2=' + denier2 +
          '&denier3=' + denier3 + "&length=" + length + '&ends=' + ends + "&oliweight=" + oliweight +
          "&reed=" + reed + "&beamweight=" + beamweight + "&metersonbeam=" + metersonbeam + "&metertaka=" + metertaka +
          "&machineno=" + machineno + "&shortage=" + shortage + "&estimale=" + estimale + "&estimale2=" + estimale2 + 
          "&topmidlow=" + topmidlow.toString() + "&per=" + per.toString() + "&warpwttaka=" + warpwttaka + "&weftdenier1=" + weftdenier1 + 
          "&weftdenier2=" + weftdenier2 + "&width=" + width + "&pick=" + pick + "&weftweight=" + weftweight +
          "&jogname=" + jogname + "&jograte=" + jograte + "&jogamount=" + jogamount + "&newjogdate=" + newjogdate +
          "&droppingname=" + droppingname + "&droppingrate=" + droppingrate + "&droppingamount=" + droppingamount +
          "&beammakeer=" + beammakeer + "&beamspreader=" + beamspreader + "&spreaderrate=" + spreaderrate +
          "&makerrate=" + makerrate + "&remarks=" + remarks + "&nooftaka=" + nooftaka + "&newinstalldate=" + newinstalldate +
          "&onemeterswt=" + onemeterswt + "&weftmeters=" + weftmeters + "&newspreaderdate=" + newspreaderdate +
          "&weighttaka=" + weighttaka + "&producemeters=" + producemeters + "&producewt=" + producewt +
          "&weight100meters=" + weight100meters + "&newcompletiondate=" + newcompletiondate + "&shrinkage=" + shrinkage +
          "&balmeters=" + balmeters + "&baltaka=" + baltaka + "&newdroppingdate=" + newdroppingdate +
          "&masterbeam=" + masterbeam.toString() + "&recserial=" + recserial + "&recpartyid=" +recpartyid +
          "&rectype=" + rectype + "&id=" + id.toString();

      print(" saveData : " + uri);
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
        isButtonActive = false;
      });
      bool success = await saveData();
      setState(() {
        isButtonActive = success;
      });
    } 

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beam Card [ ' +
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
                _handleSaveData();
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
                    return null;
                  },
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _beamchr,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'BeamChr',
                      labelText: 'BeamChr',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _beamno,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam No.',
                      labelText: 'Beam No.',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _itemname,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Itemname',
                      labelText: 'Itemname',
                    ),
                    onTap: () {
                      gotoItemnameScreen(context);
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
                    controller: _warpdate,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Warp Date',
                      labelText: 'Warp Date',
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
                    controller: _pipeno,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pipe No.',
                      labelText: 'Pine No.',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _denier1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Denier1',
                      labelText: 'Denier1',
                    ),
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
                    controller: _denier2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Denier2',
                      labelText: 'Denier2',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _denier3,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Denier3',
                      labelText: 'Denier3',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _length,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Length',
                      labelText: 'Length',
                    ),
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
                    controller: _ends,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Ends',
                      labelText: 'Ends',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _oliweight,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Oli Weight',
                      labelText: 'Oli Weight',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _reed,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Reed',
                      labelText: 'Reed',
                    ),
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
                    controller: _beamweight,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam Weight',
                      labelText: 'Beam Weight',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _metersonbeam,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Meters On Beam',
                      labelText: 'Meters On Beam',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _metertaka,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Meters/Taka',
                      labelText: 'Meters/Taka',
                    ),
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
                    controller: _machineno,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Machine No.',
                      labelText: 'Machine No.',
                    ),
                    onTap: () {
                      gotoMachinenoScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _shortage,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Shortage',
                      labelText: 'Shortage',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _estimale,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Estimale',
                      labelText: 'Estimale',
                    ),
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
                    controller: _estimale2,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Estimale2',
                      labelText: 'Estimale2',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    value: dropdownTopMidLow,
                    decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Top/Middle/Low',
                        hintText: 'Top/Middle/Low'),
                    items: TopMidLows.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownTopMidLow = newValue!;
                        print(dropdownTopMidLow);
                      });
                    }
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    value: dropdownPer,
                    decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Per',
                        hintText: 'Per'),
                    items: Pers.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownPer = newValue!;
                        print(dropdownPer);
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
                    controller: _warpwttaka,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Warp Weight Taka',
                      labelText: 'Warp Weight Taka',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _weftdenier1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weft Denier1',
                      labelText: 'Weft Denier1',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _weftdenier2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weft Denier2',
                      labelText: 'Weft Denier2',
                    ),
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
                    controller: _width,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Width',
                      labelText: 'Width',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _pick,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pick',
                      labelText: 'Pick',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _weftweight,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weft Weight',
                      labelText: 'Weft Weight',
                    ),
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
                    controller: _jogname,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Jogname',
                      labelText: 'Jogname',
                    ),
                    onTap: () {
                      gotoJognameScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _jograte,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Jog Rate',
                      labelText: 'Jog Rate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _jogamount,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Jog Amount',
                      labelText: 'Jog Amount',
                    ),
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
                    controller: _jogdate,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Jog Date',
                      labelText: 'Jog Date',
                    ),
                    onTap: () {
                      _selectDate2(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _droppingname,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Droppingname',
                      labelText: 'Droppingname',
                    ),
                    onTap: () {
                      gotoDroppingnameScreen(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _droppingrate,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Droppingrate',
                      labelText: 'Droppingrate',
                    ),
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
                    controller: _droppingamount,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Droppingamount',
                      labelText: 'Droppingamount',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _beammakeer,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam Makeer',
                      labelText: 'Beam Makeer',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _beamspreader,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Beam Spreader',
                      labelText: 'Beam Spreader',
                    ),
                    onTap: () {
                      gotoBeamSpreaderScreen(context);
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
                    controller: _makerrate,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Maker Rate',
                      labelText: 'Maker Rate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _spreaderrate,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Spreader Rate',
                      labelText: 'Spreader Rate',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nooftaka,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'No Of Taka',
                      labelText: 'No Of Taka',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _installdate,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Install Date',
                      labelText: 'Install Date',
                    ),
                    onTap: () {
                      _selectDate3(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _1meterswt,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: '1 Meters Weight',
                      labelText: '1 Meters Weight',
                    ),
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
                    controller: _weftmeters,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weft/Meters',
                      labelText: 'Weft/Meters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _spreaderdate,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Spreader Date',
                      labelText: 'Spreader Date',
                    ),
                    onTap: () {
                      _selectDate4(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _weighttaka,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weight/Taka',
                      labelText: 'Weight/Taka',
                    ),
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
                    controller: _producemeters,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Produce Meters',
                      labelText: 'Produce Meters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _producewt,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Produce Weight',
                      labelText: 'Produce Weight',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _weight100meters,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Weight 100 Meter',
                      labelText: 'Weight 100 Meter',
                    ),
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
                    controller: _completiondate,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Completion Date',
                      labelText: 'Completion Date',
                    ),
                    onTap: () {
                      _selectDate5(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _shrinkage,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Shrinkage',
                      labelText: 'Shrinkage',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _balmeters,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Bal Meter',
                      labelText: 'Bal Meter',
                    ),
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
                    controller: _baltaka,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Bal Taka',
                      labelText: 'Bal Taka',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _droppingdate,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Dropping Date',
                      labelText: 'Dropping Date',
                    ),
                    onTap: () {
                      _selectDate6(context);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    value: dropdownMasterBeam,
                    decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'MasterBeam',
                        hintText: 'MasterBeam'),
                    items: MasterBeam.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownMasterBeam = newValue!;
                        print(dropdownMasterBeam);
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
                    controller: _recserial,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'RecSerial',
                      labelText: 'RecSerial',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _recpartyid,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'RecPartyId',
                      labelText: 'RecPartyId',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _rectype,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'RecType',
                      labelText: 'RecType',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            )
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
