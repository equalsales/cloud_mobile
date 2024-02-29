import 'package:cloud_mobile/list/state_list.dart';
import 'package:flutter/material.dart';

openState_List(context, companyid, companyname, startdate, enddate) async {
  var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => state_list(
                companyid: companyid,
                companyname: companyname,
                fbeg: startdate,
                fend: enddate,
              )));
  return result;
}
