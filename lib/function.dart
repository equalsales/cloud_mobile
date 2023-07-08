import 'dart:convert';

import 'package:http/http.dart' as http;

DateTime retconvdate(String dDate) {
  String startdate = dDate;

  String dd = startdate.substring(0, 2);
  String mm = startdate.toString().substring(3, 5);
  String yy = startdate.toString().substring(6);

  DateTime selectedDate = DateTime.parse(yy + '-' + mm + '-' + dd);
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
  City = getValue(City, 'C');

  Id = int.parse(getValue(Id.toString(), 'N'));

  uri =
      'https://www.cloud.equalsoftlink.com/api/getcitylist?dbname=admin_dhruv&city=' +
          City.toString() +
          '&id=' +
          Id.toString();

  var response = await http.get(Uri.parse(uri));

  var jsonData = jsonDecode(response.body);

  jsonData = jsonData['Data'];

  return jsonData;
}
