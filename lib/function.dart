import 'dart:convert';

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

Future<List<dynamic>> getPartyDetails(String Party, int Id) async {
  String uri = '';
  var db = globals.dbname;

  Party = getValue(Party, 'C');

  Id = int.parse(getValue(Id.toString(), 'N'));

  uri = 'https://www.cloud.equalsoftlink.com/api/api_getpartylist?dbname=' +
      db +
      '&party=' +
      Party.toString() +
      '&id=' +
      Id.toString();
  print(uri);
  var response = await http.get(Uri.parse(uri));

  var jsonData = jsonDecode(response.body);

  jsonData = jsonData['Data'];

  return jsonData;
}
