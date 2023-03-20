//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

//import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/xreport.dart';

import 'package:pluto_grid/pluto_grid.dart';
import '../../common/global.dart' as globals;

import 'package:cloud_mobile/common/bottombar.dart';
//import 'package:myfirstapp/screens/dashboard/sidebar.dart';

//import 'package:cloud_mobile/widget/button_widget.dart';
//import 'package:cloud_mobile/widget/title_widget.dart';

class LedgerReport extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xData;
  DateTime xfromDate = DateTime.now();
  DateTime xtoDate = DateTime.now();
  List _xpartylist = [];

  List _datalist = [];

  LedgerReport(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      fromDate,
      toDate,
      partylist,
      data})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xfromDate = fromDate;
    xtoDate = toDate;
    _xpartylist = partylist;
    xData = data;
  }
  @override
  _LedgerReport createState() => _LedgerReport();
}

class _LedgerReport extends State<LedgerReport> {
  List _datalist = [];
  var apptitle = 'Ledger Report';
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  List<PlutoRow> rows2 = [];

  @override
  void initState() {
    getreportdata();
    /*
    var colinfo = [];
    colinfo.add({
      'title': 'Date',
      'field': 'date2',
      'type': 'C',
      'aggregate': '',
      'visible': 'Y'
    });
    colinfo.add({
      'title': 'Description',
      'field': 'refacname',
      'type': 'C',
      'aggregate': '',
      'visible': 'Y'
    });
    colinfo.add({
      'title': 'Debit',
      'field': 'dramt',
      'type': 'C',
      'aggregate': '',
      'visible': 'Y'
    });
    colinfo.add({
      'title': 'Credit',
      'field': 'cramt',
      'type': 'C',
      'aggregate': '',
      'visible': 'Y'
    });
    colinfo.add({
      'title': 'Party',
      'field': 'acname',
      'type': 'C',
      'aggregate': '',
      'visible': 'Y'
    });

    var groupBy = '';
    groupBy = 'acname';

    var xReport = Report(widget.xData, 1, colinfo, groupBy);
    columns = xReport.createcolumn();

    rows = xReport.createrows();*/
  }

  Future<bool> getreportdata() async {
    var companyid = widget.xcompanyid;
    var fromdate = widget.xfromDate.toString().split(' ')[0];
    var todate = widget.xtoDate.toString().split(' ')[0];
    var partylist = '';
    if (widget._xpartylist.length > 0) {
      partylist = widget._xpartylist[0].toString();
    }

    partylist = partylist.replaceAll('/', '{{}}');

    String uri = '';

    print('1');
    uri =
        'https://www.cloud.equalsoftlink.com/api/api_genledger?dbname=admin_neel&party=6288&fromdate=2022-04-01&todate=2023-03-31&cfromdate=2022-04-01&ctodate=2023-03-31&cno=1';
    print('2');
    var response = await http.get(Uri.parse(uri));
    print('3');
    var jsonData = jsonDecode(response.body);
    print('4');

    jsonData = jsonData['Data'];
    print('5');

    print(jsonData);
    //print(uri);

    //http.Response response = await http.get(Uri.parse(Uri.encodeFull(uri)));
    //var response = await http.get(Uri.parse(uri));

    //print('1');
    //var Data = jsonDecode(response.body);
    //print('2');
    //Data = Data['Data'];
    //print('3');
    //print(Data);

    setState(() {
      _datalist = jsonData;
    });
    return true;
  }

  DataTable _createDataTable() {
    print('xx');
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Date')),
      //DataColumn(label: Text('Voucher')),
      DataColumn(label: Text('Description')),
      DataColumn(label: Text('Debit')),
      DataColumn(label: Text('Credit')),
      DataColumn(label: Text('Balance')),
      DataColumn(label: Text('Code'))
    ];
  }

  List<DataRow> _createRows() {
    double balance = 0;
    double totdramt = 0;
    double totcramt = 0;
    List<DataRow> _datarow = [];

    if (_datalist.length > 0) {
      _datarow.add(DataRow(cells: [
        DataCell(Text('Party : ' + _datalist[0]['acname'].toString())),
        //DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text(''))
      ]));
    }
    for (var ictr = 0; ictr < _datalist.length; ictr++) {
      var data = _datalist[ictr];
      var code = '';
      double dramt = 0;
      double cramt = 0;

      //print(data['dramt'].toString());
      if (data['dramt'].toString() != '') {
        dramt = double.parse(data['dramt'].toString());
      }
      if (data['cramt'].toString() != '') {
        cramt = double.parse(data['cramt'].toString());
      }
      balance = balance + dramt - cramt;
      totdramt = totdramt + dramt;
      totcramt = totcramt + cramt;

      if (balance > 0) {
        code = 'Dr';
      } else {
        code = 'Cr';
      }

      _datarow.add(DataRow(cells: [
        DataCell(Text(data['date2'].toString())),
        //DataCell(Text(data['serial'].toString())),
        DataCell(Text(data['refacname'].toString())),
        DataCell(Text(data['dramt'].toString())),
        DataCell(Text(data['cramt'].toString())),
        //DataCell(Text(data['dramt'].toStringAsFixed(2))),
        //DataCell(Text(data['cramt'].toStringAsFixed(2))),
        DataCell(Text(balance.toStringAsFixed(2))),
        DataCell(Text(code))
      ]));
    }

    _datarow.add(DataRow(cells: [
      DataCell(Text('')),
      //DataCell(Text('')),
      DataCell(Text('Total')),
      DataCell(Text(totdramt.toStringAsFixed(2))),
      DataCell(Text(totcramt.toStringAsFixed(2))),
      DataCell(Text('')),
      DataCell(Text(''))
    ]));
    if ((totdramt - totcramt) > 0) {
      _datarow.add(DataRow(cells: [
        DataCell(Text('')),
        //DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text((totdramt - totcramt).toStringAsFixed(2))),
        DataCell(Text('')),
        DataCell(Text(''))
      ]));

      _datarow.add(DataRow(cells: [
        DataCell(Text('')),
        //DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text((totdramt).toStringAsFixed(2))),
        DataCell(Text((totdramt).toStringAsFixed(2))),
        DataCell(Text('')),
        DataCell(Text(''))
      ]));
    } else {
      _datarow.add(DataRow(cells: [
        DataCell(Text('')),
        //DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text((totcramt - totdramt).toStringAsFixed(2))),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text(''))
      ]));

      _datarow.add(DataRow(cells: [
        DataCell(Text('')),
        //DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text((totcramt).toStringAsFixed(2))),
        DataCell(Text((totcramt).toStringAsFixed(2))),
        DataCell(Text('')),
        DataCell(Text(''))
      ]));
    }

    setState(() {
      apptitle = '';
    });

    print('out...');
    return _datarow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apptitle),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _createDataTable(),
        ),
      ),
      // body: Container(
      //   child: PlutoGrid(
      //     columns: columns,
      //     rows: rows,
      //     configuration: PlutoGridConfiguration(
      //       enableColumnBorder: true,
      //     ),
      //     onLoaded: (PlutoGridOnLoadedEvent event) {
      //       //print('loaded');
      //     },
      //   ),
      // ),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
