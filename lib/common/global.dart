import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
