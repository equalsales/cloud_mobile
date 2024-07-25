import 'dart:convert';

import 'package:cloud_mobile/common/alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;

DateTime retconvdate(String dDate, [format = 'dd-mm-yyyy']) {
  String startdate = dDate;

  String dd = '';
  String mm = '';
  String yy = '';
  DateTime selectedDate;
  if (format == 'yyyy-mm-dd') {
    selectedDate = DateTime.parse(startdate);
  } else {
    dd = startdate.substring(0, 2);
    mm = startdate.toString().substring(3, 5);
    yy = startdate.toString().substring(6);
    print(yy + '-' + mm + '-' + dd);
    selectedDate = DateTime.parse(yy + '-' + mm + '-' + dd);
  }

  return selectedDate;
}

String retconvdatestr(String dDate) {
  String startdate = dDate;

  String dd = startdate.substring(0, 2);
  String mm = startdate.toString().substring(3, 5);
  String yy = startdate.toString().substring(6);

  return yy + '-' + mm + '-' + dd;
  //DateTime selectedDate = DateTime.parse(yy + '-' + mm + '-' + dd);
  //return selectedDate;
}

DateTime getsystemdate() {
  DateTime now = new DateTime.now();
  DateTime newDate = DateTime.parse(now.toString().substring(0, 10));
  return newDate;
}

String getValue(xValue, DataType) {
  if (DataType == 'C') {
    if (xValue == null) {
      xValue = '';
    } else if (xValue == 'null') {
      xValue = '';
    }
  } else if (DataType == 'N') {
    if (xValue == null) {
      xValue = 0;
    } else if (xValue == 'null') {
      xValue = 0;
    }
  }
  return xValue;
}

getValueN(xValue) {
  if (xValue == null) {
    xValue = double.parse('0');
  } else if (xValue == 'null') {
    xValue = double.parse('0');
  } else if (xValue == '') {
    xValue = double.parse('0');
  } else {
    xValue = double.parse(xValue);
  }
  return xValue;
}


StringToStr(_list) {
  var partylist = '';
  for (var ictr = 0; ictr < _list.length; ictr++) {
    if (ictr > 0) {
      partylist = partylist + ',';
    }
    partylist = partylist + _list[ictr].toString();
  }
  return partylist.replaceAll('/', '{{}}');
}

Future<List<dynamic>> getCityDetails(String City, int Id) async {
  String uri = '';
  var db = globals.dbname;
  City = getValue(City, 'C');

  Id = int.parse(getValue(Id.toString(), 'N'));

  uri = 'https://www.cloud.equalsoftlink.com/api/getcitylist?dbname=' +
      db +
      '&city=' +
      City.toString() +
      '&id=' +
      Id.toString();

  var response = await http.get(Uri.parse(uri));

  var jsonData = jsonDecode(response.body);

  jsonData = jsonData['Data'];

  return jsonData;
}

List<dynamic> listdata = [];

Future getPartyDetails(String Party, int Id,
    [double crlimit = 0,
    int? partyid,
    dynamic context,
    String? endDate,  
    int? cno,
    String? startDate,
]) async {
  String uri = '';
  var db = globals.dbname;

  Party = getValue(Party, 'C');

  Id = int.parse(getValue(Id.toString(), 'N'));
  print(partyid);
  double closingbal = 0;
  if (crlimit > 0) {
    uri =
        '${globals.cdomain}/getpartyledbal?partyid=$partyid&acgroupid=&dbname=' +
            db +
            '&cno=$cno' +
            '&fromdate=$startDate'+
            '&todate=$endDate' +
            '&lmulticompany=N' +
            '&id=' +
            Id.toString();

    print(uri);

    print("123123" + uri);

    DialogBuilder(context).showLoadingIndicator('');

    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);

    // if(response == '200'){
    //   print("gni");
    //   // DialogBuilder(context).showLoadingIndicator('');
    // } else {
    //   print("cni");
    // }

    jsonData = jsonData['data'];
    print(jsonData);
    DialogBuilder(context).hideOpenDialog();

    closingbal = double.parse(jsonData[0]['actclosingbal'].toString());
    print("closingbal" + closingbal.toString());
    if (crlimit < closingbal) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Credit limit exceed Crlimit [${crlimit}] && Pending Limit [$closingbal].",
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        },
      );
    }
  }
   return closingbal;
}
