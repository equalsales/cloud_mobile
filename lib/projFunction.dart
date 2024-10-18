import 'package:cloud_mobile/list/city_list.dart';
import 'package:cloud_mobile/list/country_list.dart';
import 'package:cloud_mobile/list/state_list.dart';
import 'package:cloud_mobile/module/master/citymaster/citymaster.dart';
import 'package:cloud_mobile/module/master/country/countrymaster.dart';
import 'package:cloud_mobile/module/master/drivermaster/drivermaster.dart';
import 'package:cloud_mobile/module/master/hsnmaster/hsnmaster.dart';
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

stateMaster_Add(
    context, companyid, companyname, startdate, enddate, cValue) async {
  var result = await Navigator.push(
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
  return result;
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

countryMaster_Add(
    context, companyid, companyname, startdate, enddate, cValue) async {
  print('in');
  var result = await Navigator.push(
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
  print('out');
  print(result);
  return result;
}

driverMaster_Add(
    context, companyid, companyname, startdate, enddate, cValue) async {
  print('in');
  var result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DriverMaster(
        companyid: companyid,
        companyname: companyname,
        fbeg: startdate,
        fend: enddate,
        id: '0',
        onlineValue: cValue,
      ),
    ),
  );
  print('out');
  print(result);
  return result;
}

cityMaster_Add(
    context, companyid, companyname, startdate, enddate, cValue) async {
  var result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CityMaster(
        companyid: companyid,
        companyname: companyname,
        fbeg: startdate,
        fend: enddate,
        id: '0',
        onlineValue: cValue,
      ),
    ),
  );
  return result;
}

openCity_List(context, companyid, companyname, startdate, enddate) async {
  var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => city_list(
                companyid: companyid,
                companyname: companyname,
                fbeg: startdate,
                fend: enddate,
              )));
  return result;
}

hsnMaster_Add(
    context, companyid, companyname, startdate, enddate, cValue) async {
  var result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HSNMaster(
        companyid: companyid,
        companyname: companyname,
        fbeg: startdate,
        fend: enddate,
        id: '0',
        onlineValue: cValue,
      ),
    ),
  );
  return result;
}
