// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:cloud_mobile/common/PdfPreviewPagePrint.dart';
import 'package:cloud_mobile/list/salesman_list.dart';
import 'package:cloud_mobile/module/looms/saleschallan/add_loomsaleschallandet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/list/party_list.dart';
import 'package:path_provider/path_provider.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/branch_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:intl/intl.dart';
// import 'package:path/path.dart';
//CHIRAG

class LoomSalesChallanAdd extends StatefulWidget {
  LoomSalesChallanAdd({Key? mykey, companyid, companyname, fbeg, fend, id})
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
  _LoomSalesChallanAddState createState() => _LoomSalesChallanAddState();
}

class _LoomSalesChallanAddState extends State<LoomSalesChallanAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List _branchlist = [];
  List _partylist = [];
  List _delpartylist = [];
  List _booklist = [];
  List _agentlist = [];
  List _hastelist = [];
  List _transportlist = [];
  List _stationlist = [];

  List ItemDetails = [];

  String? dropdownTrnType;

  var items = [
    'PACKING',
    'DELIVERY',
  ];

  var branchid = 0;
  int? partyid;
  var bookid = 0;
  TextEditingController _branch = new TextEditingController();
  TextEditingController _packingtype = new TextEditingController();
  TextEditingController _packingsrchr = new TextEditingController();
  TextEditingController _packingserial = new TextEditingController();
  TextEditingController _serial = new TextEditingController();
  TextEditingController _srchr = new TextEditingController();
  TextEditingController _book = new TextEditingController();
  TextEditingController _bookno = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _party = new TextEditingController();
  TextEditingController _agent = new TextEditingController();
  TextEditingController _delparty = new TextEditingController();
  TextEditingController _haste = new TextEditingController();
  TextEditingController _salesman = new TextEditingController();
  TextEditingController _transport = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _parcel = new TextEditingController();
  TextEditingController _duedays = new TextEditingController();
  TextEditingController _station = new TextEditingController();
  TextEditingController _tottaka = new TextEditingController();
  TextEditingController _totmtrs = new TextEditingController();
  TextEditingController _branchid = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _gstregno = new TextEditingController();
  var _jsonData = [];

  bool isButtonActive = true;
  bool hasteenabled = true;

  late File Pfile;
  bool isLoading = false;
  
   var validcity= '';
  var crlimit = 0.0;
  dynamic clobl = 0;

  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _date.text = DateFormat("dd-MM-yyyy").format(curDate);


    if(globals.username == 'SACHIN' || globals.username == 'sachin'){
      hasteenabled = true;
    }else{
      hasteenabled = false;
    }

    _book.text = 'SALES A/C';

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

    // uri =
    //     'http://127.0.0.1:8000/api/api_getsalechallandetlist?dbname=' +
    //         db +
    //         '&cno=' +
    //         cno +
    //         '&id=' +
    //         id;

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
        "pcs": jsonData[iCtr]['pcs'].toString(),
        "meters": jsonData[iCtr]['meters'].toString(),
        "tpmtrs": jsonData[iCtr]['tpmtrs'].toString(),
        "itemname": jsonData[iCtr]['itemname'].toString(),
        "hsncode": jsonData[iCtr]['hsncode'].toString(),
        "rate": jsonData[iCtr]['rate'].toString(),
        'var': 0,
        "unit": jsonData[iCtr]['unit'].toString(),
        'varper': 0,
        "amount": jsonData[iCtr]['amount'].toString(),
        "design": jsonData[iCtr]['design'].toString(),
        "machine": jsonData[iCtr]['machine'].toString(),
        "orditem": jsonData[iCtr]['itemname'].toString(),
        "orddesign": jsonData[iCtr]['design'].toString(),
        "ordmtr": 0,
        'stdwt': 0,
        "ordid": jsonData[iCtr]['ordid'].toString(),
        "folddate": '',
        'type': '',
        'tkid': 0,
        'tkdetid': 0,
        "fmode": jsonData[iCtr]['fmode'].toString(),
        "inwid": jsonData[iCtr]['inwid'].toString(),
        "inwdetid": jsonData[iCtr]['inwdetid'].toString(),
        "inwdettkid": jsonData[iCtr]['inwdettkid'].toString(),
        'cost': 0,
        'tp': '',
        "orddetid": jsonData[iCtr]['orddetid'].toString(),
        'ordbalmtrs': 0,
        'remarks': _remarks.text,
        'duedays': _duedays.text,
        "netwt": jsonData[iCtr]['netwt'].toString(),
        "avgwt": jsonData[iCtr]['avgwt'].toString(),
        "beamno": jsonData[iCtr]['beamno'].toString(),
        "beamitem": jsonData[iCtr]['beamitem'].toString(),
      });
    }

    print("jsonData[iCtr]['ordno'].toString()" + jsonData[0]['orderno'].toString());

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


    // uri =
    //     'http://127.0.0.1:8000/api/api_getsalechallanlist?dbname=' +
    //         db +
    //         '&cno=' +
    //         cno +
    //         '&id=' +
    //         id +
    //         '&startdate=' +
    //         start +
    //         '&enddate=' +
    //         end;

    print(" loadData :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    jsonData = jsonData['Data'];
    jsonData = jsonData[0];

    print(jsonData);

    _branch.text = getValue(jsonData['branch'], 'C');
    _packingtype.text = getValue(jsonData['packingtype'], 'C');
    if(_packingtype.text == 'null'){
      _packingtype.text = 'DELIVERY';
    } else if(_packingtype.text == ''){
      _packingtype.text = 'DELIVERY';
    }
    _packingsrchr.text = getValue(jsonData['packingsrchr'], 'C');
    _packingserial.text = getValue(jsonData['packingserial'], 'C');
    _serial.text = getValue(jsonData['serial'], 'C');
    _srchr.text = getValue(jsonData['srchr'], 'C');
    _book.text = getValue(jsonData['book'], 'C');
    _bookno.text = getValue(jsonData['bookno'], 'C');
    String inputDateString = getValue(jsonData['date'], 'C');
    List<String> parts = inputDateString.split(' ')[0].split('-');
    String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
    _date.text = formattedDate.toString();
    _party.text = getValue(jsonData['party'], 'C');
    partyid = jsonData['partyid'];
    if (_party.text != '') {}
    _delparty.text = getValue(jsonData['delparty'], 'C');
    _agent.text = getValue(jsonData['agent'], 'C');
    _delparty.text = getValue(jsonData['delparty'], 'C');
    _haste.text = getValue(jsonData['haste'], 'C');
    print("22222222222222222222222222");
    print(_haste.text);
    _salesman.text = getValue(jsonData['salesman'], 'C');
    print(_salesman.text);
    _transport.text = getValue(jsonData['transport'], 'C');
    _remarks.text = getValue(jsonData['remarks'], 'C');
    _parcel.text = getValue(jsonData['parcel'], 'C');
    _duedays.text = getValue(jsonData['duedays'], 'C');
    _station.text = getValue(jsonData['station'], 'C');
    _branchid.text = getValue(jsonData['branchid'].toString(), 'N');

    widget.serial = jsonData['serial'].toString();
    widget.srchr = jsonData['srchr'].toString();

    setState(() {
      dropdownTrnType = _packingtype.text;
    });

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

  void gotoPartyScreen(acctype, TextEditingController obj) async {
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
  }

  void gotoHasteScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => party_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                  acctype: 'HASTE',
                )));

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
      _haste.text = selParty;
  }

  void gotoPartyScreen2(acctype, TextEditingController obj) async {
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
      // setState(() {
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
        _delparty.text = selParty;
        
        validcity = result[0]['city'].toString();
        crlimit = double.parse(result[0]['crlimit'].toString());
        partyid = int.parse(result[0]['id'].toString());
        _agent.text = result[0]['agent'].toString();
        _transport.text = result[0]['transport'].toString();
        var endDate = retconvdate(widget.xfend).toString();
        var startDate = retconvdate(widget.xfbeg).toString();
        var cno = int.parse(globals.companyid.toString());

        print("/////////////// validcity " + validcity.toString());

        if (selParty != '') {
          getPartyDetails(
                  obj.text, 0, crlimit, partyid, context, endDate, cno,startDate)
              .then((value) {
              clobl = value;
              print("chirag");
              print(clobl);
          });
        }
    }
  }

  void gotoBranchScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => branch_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

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
  }

  void gotoCityScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => city_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

      var retResult = result;
      _stationlist = result[1];
      result = result[1];

      var selStation = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selStation = selStation + ',';
        }
        selStation = selStation + retResult[0][ictr];
      }

      _station.text = selStation;
  }

  void gotoSalesmanScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => salesman_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

      var retResult = result;

      var selSalesman = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selSalesman = selSalesman + ',';
        }
        selSalesman = selSalesman + retResult[0][ictr];
      }

      _salesman.text = selSalesman;
  }

  void gotoChallanItemDet() async {
    var branch = _branch.text;
    var branchid = _branchid.text;
    var type = _packingtype.text;
    print("------------------------------------------------------------- : $branchid");
    print('in');
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LoomSalesChallanDetAdd(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend,
                branch: branch,
                partyid: partyid,
                itemDet: ItemDetails,
                branchid: branchid,
                haste:_haste.text,
                salesman:_salesman.text,
                type: type)));
    //print('out');
    //print(result);
    //print(result[0]['takachr']);
    setState(() {
      ItemDetails.add(result[0]);
      _remarks.text = result[0]['remarks'];
      _duedays.text = result[0]['duedays'];
      // ItemDetails = ItemDetails[0];
      print(ItemDetails);
    });
  }

  Future<bool> saveData() async {

    var id = widget.xid;
    id = int.parse(id);

    if (ItemDetails.isEmpty) {
      isButtonActive = true;
      showAlertDialog(context, 'ItemDetails cannot be blank.');
      // Return false if validation fails
      return true;
    }

     if (globals.username == 'SACHIN') {
      print("111111111111111111111111111111111111111");

      // Check for duplicate item names
      for (int i = 0; i < ItemDetails.length; i++) {
        for (int j = i + 1; j < ItemDetails.length; j++) {
          if (ItemDetails[i]['itemname'] != ItemDetails[j]['itemname']) {
            isButtonActive = true;
            print("Duplicate item name found.");
            showAlertDialog(context,'ItemName can not be different.',);
            return true; // Exit if duplicates are found
          }
        }
      }

      DialogBuilder(context).showLoadingIndicator('');
      String uri = await buildUri();
      print("2222222222222222222222222222222" + uri);

      final headers = {
        'Content-Type': 'application/json', // Set the appropriate content-type
      };

      var response = await http.post(Uri.parse(uri), headers: headers, body: jsonEncode(ItemDetails));
      var jsonData = jsonDecode(response.body);
      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];
      var jsonid = jsonData['id'];

      DialogBuilder(context).hideOpenDialog();

      if (jsonCode == '500') {
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
        return false;
      } else {
        print("id : " + id.toString());
        if (globals.username == 'SACHIN') {
          if (id == 0) {
            await sendSmsAndNotification(jsonid);
          }
        }

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
        return true;
      }
    } else {
      DialogBuilder(context).showLoadingIndicator('');
      String uri = await buildUri();
      print("3333333333333333333333333333" + uri);

      final headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.post(Uri.parse(uri), headers: headers, body: jsonEncode(ItemDetails));
      var jsonData = jsonDecode(response.body);
      var jsonCode = jsonData['Code'];
      var jsonMsg = jsonData['Message'];
      var jsonid = jsonData['id'];

      DialogBuilder(context).hideOpenDialog();

      if (jsonCode == '500') {
        isButtonActive = true;
        showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
        return false;
      } else {
        print("44444444444444444444444444 id : " + id.toString());
        if (globals.username == 'SACHIN') {
          if (id == 0) {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            await sendSmsAndNotification(jsonid);
          }
        }

        Fluttertoast.showToast(
          msg: "Saved !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.green,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return true;
      }
    }
  }

  Future<String> buildUri() async {
    var cno = globals.companyid;
    var db = globals.dbname;
    var username = globals.username;
    var packingtype = _packingtype.text;
    var packingsrchr = _packingsrchr.text;
    var packingserial = _packingserial.text;
    var serial = _serial.text;
    var srchr = _srchr.text;
    var book = _book.text;
    var bookno = _bookno.text;
    var branch = _branch.text;
    var date = _date.text;
    var party = _party.text;
    var agent = _agent.text;
    var delparty = _delparty.text;
    var haste = _haste.text;
    var salesman = _salesman.text;
    var transport = _transport.text;
    var remarks = _remarks.text;
    var parcel = _parcel.text;
    var duedays = _duedays.text;
    var station = _station.text;

    if (parcel == ' ') {
      parcel = ' ';
    }

    var id = widget.xid;
    id = int.parse(id);

    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);

    party = party.replaceAll('&', '_');

    return "${globals.cdomain}/api/api_storeloomssalechln?dbname=" +
        db +
        "&company=&cno=" +
        cno +
        "&user=" +
        username +
        "&branch=" +
        branch +
        "&packingtype=" +
        packingtype +
        "&party=" +
        party +
        "&book=" +
        book +
        "&haste=" +
        haste +
        '&salesman=' +
        salesman +
        "&transport=" +
        transport +
        "&station=" +
        station +
        "&packingsrchr=" +
        packingsrchr +
        "&packingserial=" +
        packingserial +
        "&bookno=" +
        bookno +
        "&srchr=" +
        srchr +
        "&serial=" +
        serial +
        "&date=" +
        newDate +
        "&remarks=" +
        remarks +
        "&duedays=" +
        duedays.toString() +
        "&id=" +
        id.toString() +
        "&parcel=" +
        parcel;
  }

  Future<void> sendSmsAndNotification(int jsonid) async {
    String uri = "${globals.cdomain}/sendmodulesms/$jsonid?WATxtApi=639b127a08175a3ef38f4367&call=4&email=&formatid=3&fromserial=0&mobile=&printid=49&srchr=&toserial=0&dbname=admin_looms&cno=3&user=KRISHNA";
    print("55555555555555555555555555  sendSmsAndNotification : " + uri);
    await http.get(Uri.parse(uri));
    SendWhatAppnwork(jsonid);
  }

// Future<bool> saveData() async {
  //     if(ItemDetails.length == 0){
  //       showAlertDialog(context, 'ItemDetails can not be blank.');
  //       return false;
  //     }else{
  //       DialogBuilder(context).showLoadingIndicator('');
  //       String uri = '';
  //       var cno = globals.companyid;
  //       var db = globals.dbname;
  //       var username = globals.username;
  //       var packingtype = _packingtype.text;
  //       var packingsrchr = _packingsrchr.text;
  //       var packingserial = _packingserial.text;
  //       var serial = _serial.text;
  //       var srchr = _srchr.text;
  //       var book = _book.text;
  //       var bookno = _bookno.text;
  //       var branch = _branch.text;
  //       var date = _date.text;
  //       var party = _party.text;
  //       var agent = _agent.text;
  //       var delparty = _delparty.text;
  //       var haste = _haste.text;
  //       var salesman = _salesman.text;
  //       var transport = _transport.text;
  //       var remarks = _remarks.text;
  //       var parcel = _parcel.text;
  //       var duedays = _duedays.text;
  //       var station = _station.text;

  //       if (parcel == ' ') {
  //         parcel = ' ';
  //       }

  //       var id = widget.xid;
  //       id = int.parse(id);

  //       print(packingtype);
  //       print('In Save....');

  //       print(jsonEncode(ItemDetails));

  //       DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
  //       String newDate = DateFormat("yyyy-MM-dd").format(parsedDate);

  //       party = party.replaceAll('&', '_');

  //       uri = "${globals.cdomain}/api/api_storeloomssalechln?dbname=" +
  //           db +
  //           "&company=&cno=" +
  //           cno +
  //           "&user=" +
  //           username +
  //           "&branch=" +
  //           branch +
  //           "&packingtype=" +
  //           packingtype +
  //           "&party=" +
  //           party +
  //           "&book=" +
  //           book +
  //           "&haste=" +
  //           haste +
  //           '&salesman=' +
  //           salesman +
  //           "&transport=" +
  //           transport +
  //           "&station=" +
  //           station +
  //           "&packingsrchr=" +
  //           packingsrchr +
  //           "&packingserial=" +
  //           packingserial +
  //           "&bookno=" +
  //           bookno +
  //           "&srchr=" +
  //           srchr +
  //           "&serial=" +
  //           serial +
  //           "&date=" +
  //           newDate +
  //           "&remarks=" +
  //           remarks +
  //           "&duedays=" +
  //           duedays.toString() +
  //           "&id=" +
  //           id.toString() +
  //           "&parcel=" +
  //           parcel;

  //       print("/////////////////////////////////////////////" + uri);

  //       final headers = {
  //         'Content-Type':
  //             'application/json', // Set the appropriate content-type
  //         // Add any other headers required by your API
  //       };

  //       var response = await http.post(Uri.parse(uri),
  //           headers: headers, body: jsonEncode(ItemDetails));

  //       var jsonData = jsonDecode(response.body);
  //       //print('4');

  //       var jsonCode = jsonData['Code'];
  //       var jsonMsg = jsonData['Message'];
  //       var jsonid = jsonData['id']; 
  //       DialogBuilder(context).hideOpenDialog();

  //       if (jsonCode == '500') {
  //         showAlertDialog(context, 'Error While Saving Data !!! ' + jsonMsg);
  //       } else {
  //         print("....................");
  //         print("id : " + id.toString());
  //         if(globals.username == 'SACHIN'){
  //           if(id == 0){
              // uri = "${globals.cdomain}/sendmodulesms/$jsonid?WATxtApi=639b127a08175a3ef38f4367&call=4&email=&formatid=3&fromserial=0&mobile=&printid=49&srchr=&toserial=0&dbname=admin_looms&cno=3&user=KRISHNA";
  //             print("------------------- : " + uri);
  //             var response = await http.get(Uri.parse(uri));
  //             // var jsonData = jsonDecode(response.body);
  //             // jsonData = jsonData['data'];
  //             SendWhatAppnwork(jsonid);
  //           }
  //         }
  //         Fluttertoast.showToast(
  //           msg: "Saved !!!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.white,
  //           textColor: Colors.purple,
  //           fontSize: 16.0,
  //         );
  //         Navigator.pop(context);
  //       }
  //       return true;
  //     }
  //   }

  Future<void> SendWhatAppnwork(int id) async {
    setState(() {
      //setprintformet();
      isLoading = true;
    });
    // print("jatin"+formatid.toString());
    var companyid = globals.companyid;
    // var id = id;
    var formatid = 55;
    var printid = 49;
    // var url =
    //     'https://vansh.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=10&printid=1&call=1&mobile=&email=&noofcopy=1&cWAApi=&cEmail=&sendwhatsapp=PARTY&nemailtemplate=0&cno=$companyid';
    var url =
        '${globals.cdomain}/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=$formatid&printid=$printid&call=2&mobile=&email=&noofcopy=1&cWAApi=639b127a08175a3ef38f4367&sendwhatsapp=BOTH&cno=$companyid';
        print("SendWhatAppnwork : " + url);
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = (url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });
    print(Pfile);
    setState(() {
      isLoading = false;
    });
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
      print("!!!!!!!!!!!!!!!!!!!!!! : " + ItemDetails.toString());


      widget.tottaka = 0;
      widget.totmtrs = 0;

      for (int iCtr = 0; iCtr < ItemDetails.length; iCtr++) {

        double nMeters = 0;
        if (ItemDetails[iCtr]['meters'] != '') {
          nMeters = nMeters + double.parse(ItemDetails[iCtr]['meters']);
          widget.tottaka += 1;          
          widget.totmtrs += nMeters;
        }

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

        if(_haste.text != ''){
          print("1");                           
          ItemDetails[iCtr]['haste'] = _haste.text;
        } else if(_haste.text == '') {
          print("22");
          _haste.text = ItemDetails[iCtr]['haste'].toString();
          if(_haste.text == 'null'){
            _haste.text = '';
          }
          print(_haste.text);
          // ItemDetails[iCtr]['haste'] = '';
        }
        if(_salesman.text != ''){
          print("333");
          ItemDetails[iCtr]['salesman'] = _salesman.text;
        } else if(_salesman.text == '') {
          print("4");
          _salesman.text = ItemDetails[iCtr]['salesman'].toString();
          if(_salesman.text == 'null'){
            _salesman.text = '';
          }
          print(_salesman.text);
          // ItemDetails[iCtr]['salesman'] = '';
        }
       
          // _haste.text = ItemDetails[iCtr]['haste'].toString();
          // print("hastehastehastehastehaste");
          // print(_haste.text);
        
          // _salesman.text = ItemDetails[iCtr]['salesman'].toString();
          // print("salesmansalesmansalesmansalesman");
          // print(_salesman.text);

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
          DataCell(Text(ItemDetails[iCtr]['takachr'] +
              '-' +
              ItemDetails[iCtr]['takano'])),
          DataCell(Text(ItemDetails[iCtr]['pcs'])),
          DataCell(Text(ItemDetails[iCtr]['meters'])),
          DataCell(Text(ItemDetails[iCtr]['tpmtrs'])),
          DataCell(Text(ItemDetails[iCtr]['itemname'])),
          DataCell(Text(ItemDetails[iCtr]['design'])),
          DataCell(Text(ItemDetails[iCtr]['unit'])),
          DataCell(Text(ItemDetails[iCtr]['rate'])),
          DataCell(Text(ItemDetails[iCtr]['amount'])),
          DataCell(Text(ItemDetails[iCtr]['inwid'])),
          DataCell(Text(ItemDetails[iCtr]['inwdetid'])),
          DataCell(Text(ItemDetails[iCtr]['inwdettkid'])),
          DataCell(Text(ItemDetails[iCtr]['fmode'])),
          DataCell(Text(ItemDetails[iCtr]['ordid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['orddetid'].toString())),
          DataCell(Text(ItemDetails[iCtr]['netwt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['avgwt'].toString())),
          DataCell(Text(ItemDetails[iCtr]['beamno'].toString())),
          DataCell(Text(ItemDetails[iCtr]['beamitem'].toString())),
        ]));
      }

      setState(() {
        _tottaka.text = widget.tottaka.toString();
        _totmtrs.text = widget.totmtrs.toString();
      });

      return _datarow;
    }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Challan [ ' +
              (int.parse(widget.xid) > 0 ? 'EDIT' : 'ADD') +
              ' ] ' +
              'Packing Serial : ' +
              _packingserial.text +
              ' ' +
              (int.parse(widget.xid) > 0
                  ? 'Challan No : ' + widget.serial.toString()
                  : ''),
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        backgroundColor: isButtonActive? Colors.green : Colors.grey.shade500,
        // backgroundColor: Colors.green,
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
                  if (_formKey.currentState!.validate())
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data saving progressing...')),
                    );
                    _handleSaveData();
                  }
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
                    gotoBranchScreen();
                  },
                  validator: (value) {
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
                        _packingtype.text = dropdownTrnType!;
                        print(_packingtype.text);
                      });
                    }),
              )
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
                if(value == null || value.isEmpty){
                  return 'Please enter date.';
                }
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _book,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Book',
                      labelText: 'Book',
                    ),
                    onTap: () {
                      gotoPartyScreen('SALE BOOK', _book);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _party,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Party',
                      labelText: 'Party',
                    ),
                    onTap: () {
                      gotoPartyScreen2('SALE PARTY', _party);
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
                    controller: _delparty,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Delivery Party',
                      labelText: 'Delv Party',
                    ),
                    onTap: () {
                      gotoPartyScreen('SALE PARTY', _delparty);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _agent,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Agent',
                      labelText: 'Agent',
                    ),
                    onTap: () {
                      gotoPartyScreen('AGENT', _party);
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
                    controller: _haste,
                    enabled: hasteenabled,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Haste',
                      labelText: 'Haste',
                    ),
                    onTap: () {
                      gotoHasteScreen();
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _transport,
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Transport',
                      labelText: 'Transport',
                    ),
                    onTap: () {
                      gotoPartyScreen('TRANSPORT', _transport);
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
                    controller: _salesman,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Salesman',
                      labelText: 'Salesman',
                    ),
                    onTap: () {
                      gotoSalesmanScreen();
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
                  controller: _duedays,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Due Days',
                    labelText: 'Due Days',
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
                  controller: _parcel,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Parcel',
                    labelText: 'Parcel',
                  ),
                  onTap: () {
                    //gotoBranchScreen(context);
                  },
                  validator: (value) {
                    if(validcity != 'SURAT'){
                      if(value == null || value.isEmpty){
                        return 'Please enter parcel.';
                      }
                    }else{
                      _parcel.text = ' ';
                    }
                    return null;
                  },
                )),
                Expanded(
                    child: TextFormField(
                  controller: _bookno,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'BookNo',
                    labelText: 'BookNo',
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
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  enabled: false,
                  controller: _tottaka,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Taka',
                    labelText: 'Total Taka',
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
                  controller: _totmtrs,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Total Meters',
                    labelText: 'Total Meters',
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
                  gotoChallanItemDet();
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
                    label: Text("Taka No"),
                  ),
                  DataColumn(
                    label: Text("Pcs"),
                  ),
                  DataColumn(
                    label: Text("Meters"),
                  ),
                  DataColumn(
                    label: Text("TP Mtrs"),
                  ),
                  DataColumn(
                    label: Text("Item Name"),
                  ),
                  DataColumn(
                    label: Text("Design No"),
                  ),
                  DataColumn(
                    label: Text("Unit"),
                  ),
                  DataColumn(
                    label: Text("Rate"),
                  ),
                  DataColumn(
                    label: Text("Amount"),
                  ),
                  DataColumn(
                    label: Text("InwId"),
                  ),
                  DataColumn(
                    label: Text("InwDetId"),
                  ),
                  DataColumn(
                    label: Text("InwDetTkId"),
                  ),
                  DataColumn(
                    label: Text("FMode"),
                  ),
                  DataColumn(
                    label: Text("OrdId"),
                  ),
                  DataColumn(
                    label: Text("OrdDetId"),
                  ),
                  DataColumn(
                    label: Text("netwt"),
                  ),
                  DataColumn(
                    label: Text("avgwt"),
                  ),
                  DataColumn(
                    label: Text("beamno"),
                  ),
                  DataColumn(
                    label: Text("beamitem"),
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
