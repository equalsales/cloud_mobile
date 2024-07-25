// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/machine_list.dart';
import 'package:cloud_mobile/list/worker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/global.dart' as globals;
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

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
  TextEditingController _metertaka =
      new TextEditingController(text: 100.toString());
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
  TextEditingController _droppingamount =
      new TextEditingController(text: '0.00');
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
  TextEditingController _producemeters =
      new TextEditingController(text: '0.00');
  TextEditingController _producewt = new TextEditingController(text: '0.000');
  TextEditingController _weight100meters =
      new TextEditingController(text: '0.00');
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
      setState(() {
        loadData();
      });
    }
  }

  Future<bool> loadData() async {
    String uri = '';
    String uri2 = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var fromdate = widget.xfbeg;
    var todate = widget.xfend;
    DateTime date = DateFormat("dd-MM-yyyy").parse(fromdate);
    String start = DateFormat("yyyy-MM-dd").format(date);
    DateTime date2 = DateFormat("dd-MM-yyyy").parse(todate);
    String end = DateFormat("yyyy-MM-dd").format(date2);
    uri = '${globals.cdomain}/api/api_editbeamcard?cno=' +
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
    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();
    _branch.text = jsonData['branch'];
    _beamchr.text = jsonData['beamchr'];
    _beamno.text = jsonData['beamno'];
    _itemname.text = jsonData['itemanme'].toString();
    String inputDateString = jsonData['date'].toString();
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
    _warpdate.text = formattedDate.toString();
    _pipeno.text = jsonData['pipeno'].toString();
    _denier1.text = jsonData['den1'].toString();
    _denier2.text = jsonData['den2'].toString();
    _denier3.text = jsonData['den3'].toString();
    _length.text = jsonData['length'].toString();
    _ends.text = jsonData['ends'].toString();
    _oliweight.text = jsonData['oilwt'].toString();
    _reed.text = jsonData['reeds'].toString();
    _beamweight.text = jsonData['beamwt'].toString();
    _metersonbeam.text = jsonData['beammtrs'].toString();
    _metertaka.text = jsonData['mtrspertaka'].toString();
    _machineno.text = jsonData['machine'].toString();
    if (_machineno.text == 'null') {
      _machineno.text = '';
    }
    _shortage.text = jsonData['shtperc'].toString();
    _estimale.text = jsonData['estimate1'].toString();
    _estimale2.text = jsonData['estimate2'].toString();
    dropdownTopMidLow = jsonData['tml'].toString();
    if (dropdownTopMidLow == '') {
      dropdownTopMidLow = 'LOWER';
    } else if (dropdownTopMidLow == 'null') {
      dropdownTopMidLow = 'LOWER';
    }
    dropdownPer = jsonData['per'].toString();
    if (dropdownPer == '') {
      dropdownPer = 'BEAM';
    } else if (dropdownPer == 'null') {
      dropdownPer = 'BEAM';
    }
    _warpwttaka.text = jsonData['warpwtpertaka'].toString();
    _weftdenier1.text = jsonData['weftden1'].toString();
    _weftdenier2.text = jsonData['weftden2'].toString();
    _width.text = jsonData['width'].toString();
    _pick.text = jsonData['pick'].toString();
    _weftweight.text = jsonData['weftwt'].toString();
    _jogname.text = jsonData['jogname'].toString();
    _jograte.text = jsonData['jograte'].toString();
    _jogamount.text = jsonData['jogamount'].toString();
    String inputDateString2 = jsonData['jogdate'].toString();
    List<String> parts2 = inputDateString2.split(' ')[0].split('-');
    String jogdate = "${parts2[2]}-${parts2[1]}-${parts2[0]}";
    _jogdate.text = jogdate.toString();
    _droppingname.text = jsonData['droppingname'].toString();
    if (_droppingname.text == 'null') {
      _droppingname.text = '';
    }
    _droppingrate.text = jsonData['droppingrate'].toString();
    _droppingamount.text = jsonData['droppingamount'].toString();
    _beammakeer.text = jsonData['maker'].toString();
    if (_beammakeer.text == 'null') {
      _beammakeer.text = '';
    }
    _beamspreader.text = jsonData['spreader'].toString();
    _makerrate.text = jsonData['makerrate'].toString();
    _spreaderrate.text = jsonData['spreadrate'].toString();
    _remarks.text = jsonData['remarks'].toString();
    _nooftaka.text = jsonData['taka'].toString();
    String inputDateString3 = jsonData['installdate'].toString();
    List<String> parts3 = inputDateString3.split(' ')[0].split('-');
    String installdate = "${parts3[2]}-${parts3[1]}-${parts3[0]}";
    _installdate.text = installdate.toString();
    _1meterswt.text = jsonData['mtrswt'].toString();
    _weftmeters.text = jsonData['weftmtrs'].toString();
    String inputDateString4 = jsonData['spreaddate'].toString();
    List<String> parts4 = inputDateString4.split(' ')[0].split('-');
    String spreaddate = "${parts4[2]}-${parts4[1]}-${parts4[0]}";
    _spreaderdate.text = spreaddate.toString();
    _weighttaka.text = jsonData['wefttaka'].toString();
    _producemeters.text = jsonData['prodmeters'].toString();
    _producewt.text = jsonData['prodweight'].toString();
    _weight100meters.text = jsonData['wtmtrs'].toString();
    String inputDateString5 = jsonData['completiondate'].toString();
    List<String> parts5 = inputDateString5.split(' ')[0].split('-');
    String completiondate = "${parts5[2]}-${parts5[1]}-${parts5[0]}";
    _completiondate.text = completiondate.toString();
    _shrinkage.text = jsonData['shrinkage'].toString();
    _balmeters.text = jsonData['balmtr'].toString();
    _baltaka.text = jsonData['baltaka'].toString();
    String inputDateString6 = jsonData['droppingdate'].toString();
    List<String> parts6 = inputDateString6.split(' ')[0].split('-');
    String droppingdate = "${parts6[2]}-${parts6[1]}-${parts6[0]}";
    _droppingdate.text = droppingdate;
    dropdownMasterBeam = jsonData['masterbeam'].toString();
    if (dropdownMasterBeam == '') {
      dropdownMasterBeam = 'N';
    } else if (dropdownMasterBeam == 'null') {
      dropdownMasterBeam = 'N';
    }
    _recserial.text = jsonData['recserial'].toString();
    _recpartyid.text = jsonData['recpartyid'].toString();
    _rectype.text = jsonData['rectype'].toString();
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
              builder: (_) => worker_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'JOG',
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
          _jogname.text = newResult[0]['worker'].toString();
        });
      });
    }

    void gotoDroppingnameScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => worker_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'DROPIN',
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
          _droppingname.text = newResult[0]['worker'].toString();
        });
      });
    }

    void gotoBeamSpreaderScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => worker_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'SPREADER',
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
          _beamspreader.text = newResult[0]['worker'].toString();
        });
      });
    }

    void gotoMakerScreen(BuildContext context) async {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => worker_list(
                    companyid: widget.xcompanyid,
                    companyname: widget.xcompanyname,
                    fbeg: widget.xfbeg,
                    fend: widget.xfend,
                    acctype: 'MAKER',
                  )));
      setState(() {
        var retResult = result;
        var newResult = result[1];
        var selMaker = '';
        for (var ictr = 0; ictr < retResult[0].length; ictr++) {
          if (ictr > 0) {
            selMaker = selMaker + ',';
          }
          selMaker = selMaker + retResult[0][ictr];
        }
        setState(() {
          _beammakeer.text = newResult[0]['worker'].toString();
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
      var fromdate = widget.xfbeg;
      var todate = widget.xfend;
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

      // print(" _jogamount.text " + jogamount);
      // print(" droppingname " + droppingname);
      // print(" droppingrate " + droppingrate);
      // print(" droppingamount " + droppingamount);
      // print(" beammakeer " + beammakeer);
      // print(" beamspreader " + beamspreader);
      // print(" makerrate " + makerrate);
      // print(" remarks " + remarks);
      // print(" nooftaka " + nooftaka);
      // print(" weftmeters " + weftmeters);
      // print(" weighttaka " + weighttaka);
      // print(" producemeters " + producemeters);


      var id = widget.xid;
      id = int.parse(id);

      DateTime start = DateFormat("dd-MM-yyyy").parse(fromdate);
      String startdate = DateFormat("yyyy-MM-dd").format(start);
      DateTime end = DateFormat("dd-MM-yyyy").parse(todate);
      String enddate = DateFormat("yyyy-MM-dd").format(end);
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
          db +
          "&company=&cno=" +
          cno +
          "&user=" +
          username +
          "&srchr=" +
          srchr +
          "&serial=" +
          serial +
          '&startdate=' +
          startdate.toString() +
          '&enddate=' +
          enddate.toString() +
          "&branch=" +
          branch +
          "&beamchr=" +
          beamchr +
          "&beamno=" +
          beamno +
          "&itemname=" +
          itemname +
          '&date=' +
          newwarpdate +
          '&pipeno=' +
          pipeno +
          '&den1=' +
          denier1 +
          '&den2=' +
          denier2 +
          '&den3=' +
          denier3 +
          "&length=" +
          length +
          '&ends=' +
          ends +
          "&oilwt=" +
          oliweight +
          "&reeds=" +
          reed +
          "&beamwt=" +
          beamweight +
          "&beammtrs=" +
          metersonbeam +
          "&mtrspertaka=" +
          metertaka +
          "&machine=" +
          machineno +
          "&shtperc=" +
          shortage +
          "&estimate1=" +
          estimale +
          "&estimate2=" +
          estimale2 +
          "&tml=" +
          topmidlow.toString() +
          "&per=" +
          per.toString() +
          "&warpwtpertaka=" +
          warpwttaka +
          "&weftden1=" +
          weftdenier1 +
          "&weftden2=" +
          weftdenier2 +
          "&width=" +
          width +
          "&pick=" +
          pick +
          "&weftwt=" +
          weftweight +
          "&jogname=" +
          jogname +
          "&jograte=" +
          jograte +
          "&jogamount=" +
          jogamount +
          "&jogdate=" +
          newjogdate +
          "&droppingname=" +
          droppingname +
          "&droppingrate=" +
          droppingrate +
          "&droppingamount=" +
          droppingamount +
          "&maker=" +
          beammakeer +
          "&spreader=" +
          beamspreader +
          "&spreadrate=" +
          spreaderrate +
          "&makerrate=" +
          makerrate +
          "&remarks=" +
          remarks +
          "&taka=" +
          nooftaka +
          "&installdate=" +
          newinstalldate +
          "&mtrswt=" +
          onemeterswt +
          "&weftmtrs=" +
          weftmeters +
          "&spreaddate=" +
          newspreaderdate +
          "&wefttaka=" +
          weighttaka +
          "&prodmeters=" +
          producemeters +
          "&prodweight=" +
          producewt +
          "&wtmtrs=" +
          weight100meters +
          "&completiondate=" +
          newcompletiondate +
          "&shrinkage=" +
          shrinkage +
          "&balmtr=" +
          balmeters +
          "&baltaka=" +
          baltaka +
          "&droppingdate=" +
          newdroppingdate +
          "&masterbeam=" +
          masterbeam.toString() +
          "&recserial=" +
          recserial +
          "&recpartyid=" +
          recpartyid +
          "&rectype=" +
          rectype +
          "&id=" +
          id.toString();

      print(" saveData : " + uri);

      // final file = File('D:/log.txt');
      // file.writeAsString(uri.toString(), mode: FileMode.write);

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

    calnooftaka() {
      var metersonbeam = double.parse(_metersonbeam.text);
      var metertaka = double.parse(_metertaka.text);

      var nooftaka = metersonbeam / metertaka;

      setState(() {
        _nooftaka.text = nooftaka.toStringAsFixed(2);
      });
    }

    calbeamweight() {
      var denier1 = double.parse(_denier1.text);
      var length = double.parse(_length.text);
      var ends = double.parse(_ends.text);
      var beamweight = 0.0;

      beamweight = denier1 * length * ends / 9000000;

      setState(() {
        _beamweight.text = beamweight.toStringAsFixed(3);
      });
    }

    cal1meterweight() {
      var beamweight = double.parse(_beamweight.text);
      var length = double.parse(_length.text);
      var onemeterweight = 0.0;

      onemeterweight = beamweight / length;

      setState(() {
        _1meterswt.text = onemeterweight.toStringAsFixed(3);
        print("!!!!!!!!!!!!!!!!!!!!!!!!" + _1meterswt.text);
      });
    }

    caljogamount() {
      var ends = double.parse(_ends.text);
      var jograte = double.parse(_jograte.text);
      var jogamount = 0.0;

      jogamount = ends * jograte / 1000;

      setState(() {
        _jogamount.text = jogamount.toStringAsFixed(2);
      });
    }

    caldroppingamount() {
      var ends = double.parse(_ends.text);
      var droppingrate = double.parse(_droppingrate.text);
      var droppingamount = 0.0;

      droppingamount = ends * droppingrate / 1000;

      setState(() {
        _droppingamount.text = droppingamount.toStringAsFixed(2);
      });
    }

    calweftweight() {
      var length = double.parse(_length.text);
      var weftden1 = double.parse(_weftdenier1.text);
      var width = double.parse(_width.text);
      var pick = double.parse(_pick.text);
      var weftwt = 0.0;

      weftwt = length * weftden1 * width * pick / 9000000;

      setState(() {
        _weftweight.text = weftwt.toStringAsFixed(3);
      });
    }

    calweftmeters() {
      var weftweight = double.parse(_weftweight.text);
      var beammeters = double.parse(_metersonbeam.text);
      var weftmeters = 0.0;

      weftmeters = (weftweight / beammeters) * 100;

      setState(() {
        _weftmeters.text = weftmeters.toStringAsFixed(3);
      });
    }

    calweftwttaka() {
      var beamweight = double.parse(_beamweight.text);
      var nooftaka = double.parse(_nooftaka.text);
      var weftwttaka = 0.0;

      weftwttaka = beamweight / nooftaka;

      setState(() {
        _warpwttaka.text = weftwttaka.toStringAsFixed(3);
      });
    }

    calweight100meters() {
      var beamweight = double.parse(_beamweight.text);
      var weftweight = double.parse(_weftweight.text);
      var beammeters = double.parse(_metersonbeam.text);
      var weight100meters = 0.0;

      weight100meters = ((beamweight + weftweight) / beammeters) * 100;

      setState(() {
        _weight100meters.text = weight100meters.toStringAsFixed(3);
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
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
                    controller: _denier2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Denier2',
                      labelText: 'Denier2',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      setState(() {
                        _metersonbeam.text = _length.text;
                        calnooftaka();
                        calbeamweight();
                        cal1meterweight();
                        caljogamount();
                        caldroppingamount();
                        calweftweight();
                        calweftmeters();
                        calweftwttaka();
                        calweight100meters();
                      });
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
                    controller: _ends,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Ends',
                      labelText: 'Ends',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                      }),
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
                      }),
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
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
                    controller: _width,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Width',
                      labelText: 'Width',
                    ),
                    onTap: () {},
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
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
                    onTap: () {
                      gotoMakerScreen(context);
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                    onChanged: (value) {
                      calnooftaka();
                      calbeamweight();
                      cal1meterweight();
                      caljogamount();
                      caldroppingamount();
                      calweftweight();
                      calweftmeters();
                      calweftwttaka();
                      calweight100meters();
                    },
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
                      }),
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
