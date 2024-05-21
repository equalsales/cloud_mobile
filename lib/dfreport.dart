import 'package:cloud_mobile/show_dfreport.dart';
import 'package:cloud_mobile/show_dfreportNew.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/common/global.dart' as globals;

class dfReport {
  var xData;
  var xGrp;

  var cRptCaption = '';
  var calias = '';
  var cRptCaption2 = '';

  var aColnfo = [];

  Map Grp1Total = new Map();
  Map NetTotal = new Map();

  dfReport(Data, Grp) {
    xData = Data;
    xGrp = Grp;
  }

  addColumn(field, Heading, DataType, Width, Decimal, Align, Aggregate,
      [visible = true]) {
    this.aColnfo.add({
      'field': field,
      'heading': Heading,
      'datatype': DataType,
      'width': Width,
      'decimal': Decimal,
      'align': Align,
      'aggregate': Aggregate,
      'visible': visible,
    });

    NetTotal[field] = 0;
  }

  puttotal(iCtr, xData, Grp1Total) {
    var atotal = [];
    for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      if (aColnfo[colCtr]['aggregate'] == 'sum') {
        String field = aColnfo[colCtr]['field'];
        String decimal = aColnfo[colCtr]['decimal'];
        atotal.add(Grp1Total[field].toStringAsFixed(int.parse(decimal)));
      } else {
        atotal.add('');
      }
    }
    xData[iCtr]['grp1total'] = atotal;
    xData[iCtr]['nettotal'] = [];
  }

  putnettotal(xData, Grp1Total) {
    var atotal = {};
    atotal['auto'] = '';
    atotal['autoword'] = '';
    atotal['bold'] = '';
    for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      String field = aColnfo[colCtr]['field'];
      atotal[field.toString()] = '';
    }
    atotal['grp1total'] = [];
    atotal['nettotal'] = [];
    xData.add(atotal);

    var atotal2 = [];
    for (int colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      if (aColnfo[colCtr]['aggregate'] == 'sum') {
        String field = aColnfo[colCtr]['field'];
        String decimal = aColnfo[colCtr]['decimal'];
        atotal2.add(NetTotal[field].toStringAsFixed(int.parse(decimal)));
      } else {
        atotal2.add('');
      }
    }
    xData[xData.length - 1]['nettotal'] = atotal2;
  }

  prepareReport() {
    var iCtr;
    var colCtr;
    var cGrp1Total = '';

    //print(this.xGrp.length);
    if (this.xGrp.length == 1) {
      xData.sort((a, b) => a[xGrp[0]['field']]
          .toString()
          .compareTo(b[xGrp[0]['field']].toString()));
      var cValue = '';
      var chValue = '';
      var cOldValue = '';
      for (int iCtr = 0; iCtr < xData.length; iCtr++) {
        cValue = xData[iCtr][xGrp[0]['field']].toString();
        chValue = xGrp[0]['heading'].toString();

        xData[iCtr]['auto'] = '';
        xData[iCtr]['autoword'] = '';
        xData[iCtr]['bold'] = '';
        xData[iCtr]['grp1total'] = [];
        xData[iCtr]['nettotal'] = [];

        if ((((iCtr + 1) < xData.length) && (cValue != cOldValue)) ||
            iCtr == 0) {
          if ((iCtr + 1) < xData.length) {
            //cNextValue = _datalist[ictr + 1][xGroupBy].toString();
          }
          cOldValue = cValue;

          xData[iCtr]['auto'] = 'Y';
          xData[iCtr]['autoword'] =
          chValue.toString() + ' : ' + cValue.toString();
          xData[iCtr]['bold'] = 'Y';
          xData[iCtr]['grp1total'] = [];
          xData[iCtr]['nettotal'] = [];

          if (iCtr != 0) {
            puttotal(iCtr, xData, Grp1Total);
          }
          //Reset Group Total
          for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
            if (aColnfo[colCtr]['aggregate'] == 'sum') {
              String field = aColnfo[colCtr]['field'];
              Grp1Total[field] = 0;
            }
          }
        }

        //Start Group Total
        for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['aggregate'] == 'sum') {
            String field = aColnfo[colCtr]['field'];
            Grp1Total[field] =
                Grp1Total[field] + double.parse(xData[iCtr][field]);
            NetTotal[field] =
                NetTotal[field] + double.parse(xData[iCtr][field]);
          }
        }

        if (iCtr == (xData.length - 1)) {
          puttotal(iCtr, xData, Grp1Total);
        }
      }
      putnettotal(xData, Grp1Total);

      // //First Group Pattern Report
      // var cgroup = '';
      // var cNextGroup = '';
      // for (int iCtr = 0; iCtr < xData.length; iCtr++) {

      //   xData[iCtr]['auto'] = '';
      //   xData[iCtr]['autoword'] = '';
      //   xData[iCtr]['bold'] = '';

      //   if ((iCtr + 1) < xData.length) {
      //       cNextGroup = xData[iCtr + 1][xGrp[0]['field']].toString();

      //       if (cNextGroup != cgroup) {
      //         if (iCtr != 0) {
      //           xData[iCtr + 1]['auto'] = 'Y';

      //           // //Put Total
      //           // var total = {};
      //           // for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //           //   String field = aColnfo[colCtr]['field'];
      //           //   if(aColnfo[colCtr]['aggregate']== 'sum')
      //           //   {
      //           //     total[field] = Grp1Total[field];
      //           //   }
      //           //   else
      //           //   {
      //           //     total[field] = '';
      //           //   }
      //           // }
      //           // total['auto'] = '';
      //           // total['autoword'] = '';
      //           // total['bold'] = 'Y';
      //           // xData.add(total);

      //           //iCtr = iCtr + 1;

      //         } else {
      //           xData[iCtr]['auto'] = 'Y';
      //         }
      //         cgroup = xData[iCtr][xGrp[0]['field']].toString();
      //         xData[iCtr]['autoword'] = cgroup;
      //         xData[iCtr]['bold'] = 'Y';

      //         //Reset Group Total
      //         for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //             if(aColnfo[colCtr]['aggregate']== 'sum')
      //             {
      //               String field = aColnfo[colCtr]['field'];
      //               Grp1Total[field]= 0;
      //             }
      //         }
      //     }
      //     else
      //     {
      //       xData[iCtr]['auto'] = '';
      //       cgroup = xData[iCtr][xGrp[0]['field']].toString();
      //       xData[iCtr]['autoword'] = '';
      //       xData[iCtr]['bold'] = '';

      //       //Start Group Total
      //       for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
      //           if(aColnfo[colCtr]['aggregate']== 'sum')
      //           {
      //             String field = aColnfo[colCtr]['field'];
      //             Grp1Total[field]= Grp1Total[field] + double.parse(xData[iCtr][field]);
      //           }
      //       }
      //     }
      //   }

      //   cgroup = xData[iCtr][xGrp[0]['field']].toString();
      // }
      // print(xData);
    } else {
      //Start Net Total
      for (iCtr = 0; iCtr < xData.length; iCtr++) {
        for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['aggregate'] == 'sum') {
            String field = aColnfo[colCtr]['field'];
            NetTotal[field] =
                NetTotal[field] + double.parse(xData[iCtr][field].toString());
          }
        }
        xData[iCtr]['auto'] = '';
        xData[iCtr]['autoword'] = '';
        xData[iCtr]['bold'] = '';
        xData[iCtr]['grp1total'] = [];
        xData[iCtr]['nettotal'] = [];
      }

      //Put Net Total
      var total = {};
      for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
        String field = aColnfo[colCtr]['field'].toString();
        String decimal = aColnfo[colCtr]['decimal'];
        if (aColnfo[colCtr]['aggregate'] == 'sum') {
          total[field] = NetTotal[field].toStringAsFixed(int.parse(decimal));
        } else {
          total[field] = '';
        }
      }
      total['auto'] = '';
      total['autoword'] = '';
      total['bold'] = 'Y';
      total['grp1total'] = [];
      total['nettotal'] = [];
      xData.add(total);
    }
    print(xData);
  }

  prepareReport1() {
    var iCtr;
    var colCtr;
    var cGrp1Total = '';
    //print(this.xGrp.length);
    if (this.xGrp.length == 1) {
      xData.sort((a, b) => a[xGrp[0]['field']]
          .toString()
          .compareTo(b[xGrp[0]['field']].toString()));
      var cValue = '';
      var chValue = '';
      var cOldValue = '';
      for (int iCtr = 0; iCtr < xData.length; iCtr++) {
        cValue = xData[iCtr][xGrp[0]['field']].toString();
        chValue = xGrp[0]['heading'].toString();
        xData[iCtr]['auto'] = '';
        xData[iCtr]['autoword'] = '';
        xData[iCtr]['bold'] = '';
        if ((((iCtr + 1) < xData.length) && (cValue != cOldValue)) ||
            iCtr == 0) {
          if ((iCtr + 1) < xData.length) {
            //cNextValue = _datalist[ictr + 1][xGroupBy].toString();
          }
          cOldValue = cValue;
          xData[iCtr]['auto'] = 'Y';
          xData[iCtr]['autoword'] =
              chValue.toString() + ' : ' + cValue.toString();
          xData[iCtr]['bold'] = 'Y';
          if (iCtr != 0) {
            //puttotal(iCtr, xData, Grp1Total);
          }
          //Reset Group Total
          for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
            if (aColnfo[colCtr]['aggregate'] == 'sum') {
              String field = aColnfo[colCtr]['field'];
              Grp1Total[field] = 0;
            }
          }
        }
        //Start Group Total
        for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['aggregate'] == 'sum') {
            String field = aColnfo[colCtr]['field'];
            Grp1Total[field] =
                Grp1Total[field] + double.parse(xData[iCtr][field]);
            NetTotal[field] =
                NetTotal[field] + double.parse(xData[iCtr][field]);
          }
        }
        if (iCtr == (xData.length - 1)) {
          //puttotal(iCtr, xData, Grp1Total);
        }
      }
      putnettotal(xData, Grp1Total);
    } else {
      //Start Net Total
      for (iCtr = 0; iCtr < xData.length; iCtr++) {
        for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
          if (aColnfo[colCtr]['aggregate'] == 'sum') {
            String field = aColnfo[colCtr]['field'];
            NetTotal[field] =
                NetTotal[field] + double.parse(xData[iCtr][field]);
          }
        }
        xData[iCtr]['auto'] = '';
        xData[iCtr]['autoword'] = '';
        xData[iCtr]['bold'] = '';
      }

      //Put Net Total
      var total = {};
      for (colCtr = 0; colCtr < aColnfo.length; colCtr++) {
        String field = aColnfo[colCtr]['field'];
        String decimal = aColnfo[colCtr]['decimal'];
        if (aColnfo[colCtr]['aggregate'] == 'sum') {
          total[field] = NetTotal[field].toStringAsFixed(int.parse(decimal));
        } else {
          total[field] = '';
        }
      }
      total['auto'] = '';
      total['autoword'] = '';
      total['bold'] = 'Y';
      xData.add(total);
    }
    print(xData);
  }

  void GenerateReport1(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowdfReportNew(
                companyid: globals.companyid,
                companyname: globals.companyname,
                fbeg: globals.startdate,
                fend: globals.enddate,
                fromdate: globals.startdate,
                todate: globals.enddate,
                data: this.xData,
                colinfo: this.aColnfo,
                RptCaption: this.cRptCaption,
                RptCaption2: this.cRptCaption2,
                Rptalias: this.calias,
                aGroup: this.xGrp)));
  }

  void GenerateReport(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowdfReport(
                companyid: globals.companyid,
                companyname: globals.companyname,
                fbeg: globals.startdate,
                fend: globals.enddate,
                fromdate: globals.startdate,
                todate: globals.enddate,
                data: this.xData,
                colinfo: this.aColnfo,
                RptCaption: this.cRptCaption,
                RptCaption2: this.cRptCaption2,
                Rptalias: this.calias,
                aGroup: this.xGrp)));
  }
}

// var response = await http.get(Uri.parse(uri));
//         var jsonData = jsonDecode(response.body);
//         var aGroup = [];
//         jsonData = jsonData['data'];
//         print(jsonData);
//         DialogBuilder(context).hideOpenDialog();

//         if (dropdownTrnType.toLowerCase() == 'partywise') {
//           aGroup = [
//             {'field': 'party', 'heading': 'Party'}
//           ];
//           jsonData.sort(
//               (a, b) => a['party'].toString().compareTo(b['party'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'agentwise') {
//           aGroup = [
//             {'field': 'agent', 'heading': 'agent'}
//           ];
//           jsonData.sort(
//               (a, b) => a['agent'].toString().compareTo(b['agent'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'hastewise') {
//           aGroup = [
//             {'field': 'haste', 'heading': 'haste'}
//           ];
//           jsonData.sort(
//               (a, b) => a['haste'].toString().compareTo(b['haste'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'transportwise') {
//           aGroup = [
//             {'field': 'Transport', 'heading': 'Transport'}
//           ];
//           jsonData.sort((a, b) =>
//               a['Transport'].toString().compareTo(b['Transport'].toString()));
//         }
//         if (dropdownTrnType.toLowerCase() == 'stationwise') {
//           aGroup = [
//             {'field': 'Station', 'heading': 'Station'}
//           ];
//           jsonData.sort((a, b) =>
//               a['Station'].toString().compareTo(b['Station'].toString()));
//         }

        
//         String calias = 'sale';
//         String cRptCaption = 'Sale Bill Report';
//         String cRptCaption2 = 'Period Between ' + fromdate + ' and ' + todate;
//         dfReport oReport = new dfReport(jsonData, aGroup);
//         oReport.addColumn('date', 'Date', 'D', '10', '0', 'l', '', true);
//         oReport.addColumn('serial', 'Serial', 'C', '8', '0', 'l', '');
//         oReport.addColumn('srchr', 'Srchr', 'C', '8', '0', 'l', '');
//         oReport.addColumn('party', 'Party', 'C', '20', '0', 'l', '');
//         oReport.addColumn('itemname', 'itemname', 'C', '20', '0', 'l', '');
//         oReport.addColumn('agent', 'Agent', 'C', '15', '0', 'l', '');
//         oReport.addColumn('pcs', 'Pcs', 'N', '12', '2', 'r', 'sum');
//         oReport.addColumn('cut', 'cut', 'N', '12', '2', 'r', '');
//         oReport.addColumn('meters', 'Meters', 'N', '12', '2', 'r', 'sum');
//         oReport.addColumn('foldmtr', 'foldmtr', 'N', '12', '2', 'r', 'sum');
//         oReport.addColumn('rate', 'rate', 'N', '12', '2', 'r', '');
//         oReport.addColumn('amount', 'amount', 'N', '12', '2', 'r', '');
//         oReport.prepareReport();
//         oReport.calias = calias;
//         oReport.cRptCaption = cRptCaption;
//         oReport.cRptCaption2 = cRptCaption2;
//         oReport.GenerateReport(context);