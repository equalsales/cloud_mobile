import 'package:cloud_mobile/list/country_list.dart';
import 'package:cloud_mobile/list/state_list.dart';
import 'package:cloud_mobile/module/master/country/countrymaster.dart';
import 'package:cloud_mobile/module/master/partymaster/partymaster.dart';
import 'package:cloud_mobile/module/master/statemaster/statemaster.dart';
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

partyMaster_Add(
    context, companyid, companyname, startdate, enddate, cValue, acctype) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PartyMaster(
        companyid: companyid,
        companyname: companyname,
        fbeg: startdate,
        fend: enddate,
        id: '0',
        acctype: acctype,
        newParty: cValue,
      ),
    ),
  );
}

stateMaster_Add(context, companyid, companyname, startdate, enddate, cValue) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StateMaster(
        companyid: companyid,
        companyname: companyname,
        fbeg: startdate,
        fend: enddate,
        id: '0',
        onlineValue: cValue,
      ),
    ),
  );
}

openCountry_List(context, companyid, companyname, startdate, enddate) async {
  var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => country_list(
                companyid: companyid,
                companyname: companyname,
                fbeg: startdate,
                fend: enddate,
              )));
  return result;
}

countryMaster_Add(context, companyid, companyname, startdate, enddate, cValue) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CountryMaster(
        companyid: companyid,
        companyname: companyname,
        fbeg: startdate,
        fend: enddate,
        id: '0',
        onlineValue: cValue,
      ),
    ),
  );
}
