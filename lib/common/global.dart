import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String companyid = '';
String cno = '';
String companyname = '';
String fbeg = '';
String fend = '';
String startdate = '';
String enddate = '';
String dbname = '';
String username = '';
String companystate = '';
// String cdomain = 'https://www.looms.equalsoftlink.com';
// String cdomain2 = 'https://www.cloud.equalsoftlink.com';DDDDD
String cdomain = 'http://127.0.0.1:8000';
String cdomain2 = 'http://127.0.0.1:8000';

void alert(context, _title, _msg) {
  Alert(
    context: context,
    type: AlertType.error,
    title: _title,
    desc: _msg,
    buttons: [
      DialogButton(
        child: Text(
          "COOL",
          style: TextStyle(color: Colors.white, fontSize: 20),       
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}
