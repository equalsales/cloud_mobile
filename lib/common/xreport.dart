import 'package:flutter/material.dart';

import 'package:pluto_grid/pluto_grid.dart';
//import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Report {
  var xData;
  var xGrp;
  var xColumns;
  var xGroupBy = '';
  var _datalist;
  var nLevel = 0;
  Map Grp1Total = new Map();
  Map NetTotal = new Map();

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  Report(Data, Grp, Columns, GroupBy) {
    xData = Data;
    xGrp = Grp;
    xColumns = Columns;
    xGroupBy = GroupBy;
    _datalist = xData;
  }

  List<PlutoColumn> createcolumn() {
    columns = [];
    for (var ictr = 0; ictr < xColumns.length; ictr++) {
      var colttype;
      var hide = false;

      //print(xGroupBy);

      if (xColumns[ictr]['field'] == xGroupBy) {
        hide = true;
      }
      if (xColumns[ictr]['type'] == 'C') {
        colttype = PlutoColumnType.text();
      } else if (xColumns[ictr]['type'] == 'N') {
        //colttype = PlutoColumnType.number();
        colttype = PlutoColumnType.text();
      } else {
        colttype = PlutoColumnType.text();
      }

      if (xColumns[ictr]['type'] == 'N') {
        columns.add(PlutoColumn(
            title: xColumns[ictr]['title'],
            field: xColumns[ictr]['field'],
            type: colttype,
            readOnly: true,
            hide: hide,
            textAlign: PlutoColumnTextAlign.right,
            titleTextAlign: PlutoColumnTextAlign.right));
      } else {
        columns.add(PlutoColumn(
            title: xColumns[ictr]['title'],
            field: xColumns[ictr]['field'],
            type: colttype,
            readOnly: true,
            hide: hide,
            textAlign: PlutoColumnTextAlign.left,
            titleTextAlign: PlutoColumnTextAlign.left));
      }
    }
    return columns;
  }

  List<PlutoRow> createrows() {
    if (xGroupBy == '') {
      nLevel = 0;
    } else {
      //print(xGroupBy);
      var groupByArr = xGroupBy.split('#');
      nLevel = (groupByArr.length);
    }
    print('dddd');
    print(nLevel);
    if (nLevel == 1) {
      rows = generatefirstgroupreport();
    } else {
      rows = generateregister();
    }
    return rows;
  }

  //Generate Simple Register
  List<PlutoRow> generateregister() {
    rows = [];

    var cValue = '';
    var cNextValue = '';

    starttotal(0);
    for (var ictr = 0; ictr < _datalist.length; ictr++) {
      Map<String, PlutoCell> xcell = new Map();
      for (var colctr = 0; colctr < xColumns.length; colctr++) {
        //print(_datalist[ictr][xColumns[colctr]['field']]);
        if (xColumns[colctr]['type'] == 'N') {
          xcell[xColumns[colctr]['field']] = PlutoCell(
              value: _datalist[ictr][xColumns[colctr]['field']]
                  .toStringAsFixed(2));
        } else {
          xcell[xColumns[colctr]['field']] =
              PlutoCell(value: _datalist[ictr][xColumns[colctr]['field']]);
        }
      }
      rows.add(PlutoRow(cells: xcell));

      calculateTotal(ictr);
    }
    print(NetTotal);
    putTotal(0);

    return rows;
  }

  //First Group Report
  List<PlutoRow> generatefirstgroupreport() {
    rows = [];

    var cValue = '';
    var cOldValue = '';

    //print('xxx');

    starttotal(0);
    for (var ictr = 0; ictr < _datalist.length; ictr++) {
      var data = _datalist[ictr];
      var code = '';

      cValue = data[xGroupBy].toString();
      //print(cValue);

      if ((((ictr + 1) < _datalist.length) && (cValue != cOldValue)) ||
          ictr == 0) {
        if ((ictr + 1) < _datalist.length) {
          //cNextValue = _datalist[ictr + 1][xGroupBy].toString();
        }
        cOldValue = cValue;
        //Add Group
        starttotal(1);
        print('m here');
        autoWord(ictr, xGroupBy);
      }

      Map<String, PlutoCell> xcell = new Map();
      for (var colctr = 0; colctr < xColumns.length; colctr++) {
        //print(_datalist[ictr][xColumns[colctr]['field']]);
        if (xColumns[colctr]['type'] == 'N') {
          xcell[xColumns[colctr]['field']] = PlutoCell(
              value: _datalist[ictr][xColumns[colctr]['field']]
                  .toStringAsFixed(2));
        } else {
          xcell[xColumns[colctr]['field']] =
              PlutoCell(value: _datalist[ictr][xColumns[colctr]['field']]);
        }
      }
      rows.add(PlutoRow(cells: xcell));

      calculateTotal(ictr);

      //Add First Group Total
      if (((ictr + 1) < _datalist.length) &&
          (cValue != _datalist[ictr + 1][xGroupBy].toString())) {
        putTotal(1);
      }
    }
    putTotal(0);
    return rows;
  }

  void autoWord(rowIndex, cGroupByFld) {
    var colIndex = -1;
    for (var colctr = 0; colctr < xColumns.length; colctr++) {
      if (xColumns[colctr]['field'] == cGroupByFld) {
        colIndex = colctr;
        break;
      }
    }
    //print(colIndex);

    Map<String, PlutoCell> xcell = new Map();
    for (var colctr = 0; colctr < xColumns.length; colctr++) {
      if (colIndex == colctr) {
        //xcell[xColumns[colctr]['field']] = PlutoCell(value:_datalist[RowIndex][xColumns[colctr]['field']]);
        xcell[xColumns[0]['field']] =
            PlutoCell(value: _datalist[rowIndex][xColumns[colctr]['field']]);
        xcell[xColumns[colctr]['field']] = PlutoCell(value: '');
      } else {
        if (xColumns[colctr]['type'] == 'N') {
          xcell[xColumns[colctr]['field']] = PlutoCell(value: '');
        } else {
          xcell[xColumns[colctr]['field']] = PlutoCell(value: '');
        }
      }
    }
    rows.add(PlutoRow(cells: xcell));
  }

  void starttotal(level) {
    for (var ictr = 0; ictr < xColumns.length; ictr++) {
      if (xColumns[ictr]['aggregate'] == 'SUM') {
        NetTotal[xColumns[ictr]['field']] = 0;
        if (level == 1) {
          Grp1Total[xColumns[ictr]['field']] = 0;
        }
      }
    }
    print(NetTotal);
  }

  void calculateTotal(rowIndex) {
    for (var ictr = 0; ictr < xColumns.length; ictr++) {
      if (xColumns[ictr]['aggregate'] == 'SUM') {
        NetTotal[xColumns[ictr]['field']] = NetTotal[xColumns[ictr]['field']] +
            _datalist[rowIndex][xColumns[ictr]['field']];
        if (nLevel == 1) {
          Grp1Total[xColumns[ictr]['field']] =
              Grp1Total[xColumns[ictr]['field']] +
                  _datalist[rowIndex][xColumns[ictr]['field']];
        }
      }
    }
  }

  void putTotal(lvl) {
    Map<String, PlutoCell> xcell = new Map();

    for (var colctr = 0; colctr < xColumns.length; colctr++) {
      if (xColumns[colctr]['type'] == 'N') {
        xcell[xColumns[colctr]['field']] = PlutoCell(value: '');
      } else {
        xcell[xColumns[colctr]['field']] = PlutoCell(value: '');
      }
    }
    NetTotal.keys.forEach((key) {
      if (lvl == 1) {
        xcell[key] = PlutoCell(value: Grp1Total[key].toStringAsFixed(2));
      } else {
        xcell[key] = PlutoCell(value: NetTotal[key].toStringAsFixed(2));
      }
    });
    if (lvl == 1) {
      xcell[xColumns[0]['field']] = PlutoCell(value: 'Sub Total');
    } else {
      xcell[xColumns[0]['field']] = PlutoCell(value: 'Net Total');
    }
    rows.add(PlutoRow(cells: xcell));
  }
}
