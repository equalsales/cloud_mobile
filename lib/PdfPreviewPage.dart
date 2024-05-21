import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPreviewPage extends StatelessWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xfromDate;
  var xtoDate;
  var xData;
  var xColInfo;
  var xRptCaption;
  var xRptCaption2;
  var xRptalias;
  var xGroup;
  var xgrp;
  PdfPreviewPage(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      fromdate,
      todate,
      data,
      colinfo,
      RptCaption,
      RptCaption2,
      Rptalias,
      aGroup,grp})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xfromDate = fromdate;
    xtoDate = todate;
    xData = data;
    xColInfo = colinfo;
    xRptCaption = RptCaption;
    xRptCaption2 = RptCaption2;
    xRptalias = Rptalias;
    xGroup = aGroup;
    xgrp=grp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      // body: PDFView(
      //   build: (context) => makePdf(),
      // ),
    );
  }

  static Widget xxx(context) {
    return Column(children: <Widget>[
      Text('ddd'),
      Text('ddd'),
    ]);
  }


  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    //final ByteData bytes = await rootBundle.load('assets/phone.png');
    //final Uint8List byteList = bytes.buffer.asUint8List();

    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(8),
        pageFormat: PdfPageFormat.a4,
        maxPages: 9999,
             //buildTitle(ReportTitle, ReportTitle2, column);
             header: (context) {
               return buildTitle(xRptCaption, xRptCaption2, xColInfo);
              },
           footer: (context) {
        return pw.Center(
            child: pw.Text(
                'Page No : ' +
                    context.pageNumber.toString() +
                    ' / ' +
                    context.pagesCount.toString(),
                style: pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold)));
              },
            build: (context) => [
              buildReportDetails(context,xData,xColInfo,xgrp),
            ]));
    return pdf.save(); 
  }

  buildReportDetails(context,reportdata, column, groupby)  {

    final List items = [];

    print(reportdata);

     var grp = '';
    // if(groupby.length>0){
    //     grp = groupby.xGroup[0]['field'];
    //     print(grp);
    // }
    grp = groupby;
    var count = reportdata.length;
  
    var colCount = column.length;

    
    var netTotal = [];
    var grpTotal1 = [];

    var iCtr = 0;

    for (iCtr = 0; iCtr < colCount; iCtr++) {
      netTotal.add(0);
      grpTotal1.add(0);
    }
    

    var nCtr = 0;
 
    if (grp != '') {
      var cgroup = '';
      var cNextGroup = '';
      for (iCtr = 0; iCtr < reportdata.length; iCtr++) {
        print(iCtr);
        if ((iCtr + 1) < reportdata.length) {
          cNextGroup = reportdata[iCtr + 1][grp].toString();
        }
        if (cNextGroup != cgroup) {
          if (iCtr != 0) {
            if ((iCtr + 1) < reportdata.length) {
              reportdata[iCtr + 1]['auto'] = 'Y';
            }

            for (var jCtr = 0; jCtr < colCount; jCtr++) {
              //field = column[jCtr]['field'].toString();
              if (column[jCtr]['aggregate'] == 'sum') {
                // grpTotal1[jCtr] = grpTotal1[jCtr] +
                //     double.parse(
                //         reportdata[iCtr][column[jCtr]['field']].toString());

                // netTotal[jCtr] = netTotal[jCtr] +
                //     double.parse(
                //         reportdata[iCtr][column[jCtr]['field']].toString());
              } else if (column[jCtr]['aggregate'] == 'COUNT') {
                grpTotal1[jCtr] += 1;
                netTotal[jCtr] += 1;
              }
            }

            var newRow = {};
            for (var jCtr = 0; jCtr < colCount; jCtr++) {
              if ((column[jCtr]['aggregate'] == 'sum') ||
                  (column[jCtr]['aggregate'] == 'COUNT')) {
                newRow[column[jCtr]['field']] = grpTotal1[jCtr];
              } else {
                newRow[column[jCtr]['field']] = '';
              }
            }
            newRow['bold'] = 'Y';
            newRow['line'] = 'Y';

            grpTotal1 = [];
            for (var xCtr = 0; xCtr < colCount; xCtr++) {
              grpTotal1.add(0);
             
            }

            cgroup = reportdata[iCtr][grp].toString();
            reportdata[iCtr]['autoword'] = cgroup;
           
            reportdata.insert(iCtr + 1, newRow);
            iCtr = iCtr + 1;

            print(iCtr);
            print(reportdata.length);
           
          } else {
            reportdata[iCtr]['auto'] = 'Y';

            cgroup = reportdata[iCtr][grp].toString();
            reportdata[iCtr]['autoword'] = cgroup;
            reportdata[iCtr]['bold'] = 'Y';

            for (var jCtr = 0; jCtr < colCount; jCtr++) {
             
              if (column[jCtr]['aggregate'] == 'sum') {
                // grpTotal1[jCtr] = grpTotal1[jCtr] +
                //     double.parse(
                //         reportdata[iCtr][column[jCtr]['field']].toString());

                // netTotal[jCtr] = netTotal[jCtr] +
                //     double.parse(
                //         reportdata[iCtr][column[jCtr]['field']].toString());
              } else if (column[jCtr]['aggregate'] == 'COUNT') {
                grpTotal1[jCtr] += 1;
                netTotal[jCtr] += 1;
              }
            }
          }
        } else {
          reportdata[iCtr]['auto'] = '';
          cgroup = reportdata[iCtr][grp].toString();
          reportdata[iCtr]['autoword'] = '';
          reportdata[iCtr]['bold'] = '';

          for (var jCtr = 0; jCtr < colCount; jCtr++) {
            
            if (column[jCtr]['aggregate'] == 'sum') {
              // grpTotal1[jCtr] = grpTotal1[jCtr] +
              //     double.parse(
              //         reportdata[iCtr][column[jCtr]['field']].toString());

              // netTotal[jCtr] = netTotal[jCtr] +
              //     double.parse(
              //         reportdata[iCtr][column[jCtr]['field']].toString());
            } else if (column[jCtr]['aggregate'] == 'COUNT') {
              grpTotal1[jCtr] += 1;
              netTotal[jCtr] += 1;
            }
          }
          
        }
      }
    }

    
    var newRow = {};
    for (var jCtr = 0; jCtr < colCount; jCtr++) {
      if ((column[jCtr]['aggregate'] == 'sum') ||
          (column[jCtr]['aggregate'] == 'COUNT')) {
        newRow[column[jCtr]['field']] = netTotal[jCtr];
      } else {
        newRow[column[jCtr]['field']] = '';
      }
    }
    newRow['bold'] = 'Y';
    //print(newRow);

    reportdata.add(newRow);

    //print(netTotal);
    count = reportdata.length;
    for (var iCtr = 0; iCtr < count; iCtr++) {
      items.add({'1', '2', '3', '4'});
    }

    
    var cgroup = '';
    var cNextGroup = '';
    var cnextgroup = '';

    //print(grp);
    print(reportdata);

     return pw.Column(children: <pw.Widget>[
      for (int i = 0; i < items.length; i++) ...[
        if (reportdata[i]['auto'] == 'Y') ...[
          // if (i != 0) ...[
          //   Container(
          //       width: double.infinity,
          //       child: Text('xxxx',
          //           style: TextStyle(
          //               fontSize: 16,
          //               color: PdfColors.blue,
          //               fontWeight: FontWeight.bold))),
          // ],
          pw.Container(
              width: double.infinity,
              decoration:
              pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
              child: pw.Text(reportdata[i][grp].toString(),
                  style: pw.TextStyle(
                      fontSize: 13,
                      //color: PdfColors.red,
                      fontWeight: pw.FontWeight.bold))),
        ],
        pw.Container(
            width: double.infinity,
            
            child: pw.Row(children: <pw.Widget>[
              for (int colCtr = 0; colCtr < column.length; colCtr++) ...[
                if (column[colCtr]['visible'].toString()=='true')...[
                pw.Container(
                    padding: const pw.EdgeInsets.all(4),
                    width: double.parse(column[colCtr]['width'].toString()) * 8,
                    child: pw.Align(
                        child: pw.Column(children: [
                          pw.Text(
                              reportdata[i][column[colCtr]['field']].toString(),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                       fontWeight: (reportdata[i]['bold'].toString() =='Y' &&reportdata[i]['auto'].toString() !='Y')
                                      ? pw.FontWeight.bold
                                      : pw.FontWeight.normal)),
                        ])))
                   ]
                ]
            ])),
      ]
    ]);
  }

  buildTitle(ReportTitle, ReportTitle2, column) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(xcompanyname,
              style: pw.TextStyle(
                  fontSize: 18,
                  //color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold)),
          pw.Text(ReportTitle,
              style: pw.TextStyle(
                  fontSize: 16,
                  //: PdfColors.black,
                  fontWeight: pw.FontWeight.bold)),
          pw.Text(ReportTitle2,
              style: pw.TextStyle(
                  fontSize: 13,
                  //color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold)),
          pw.Container(
              width: double.infinity,
              height: 25,
              decoration:
              pw.BoxDecoration(border: pw.Border.all()
              ),
              child: pw.Row(children: <pw.Widget>[
              for (int colCtr = 0; colCtr < column.length; colCtr++) ...[
              if (column[colCtr]['visible'].toString()=='true')...[
                  pw.Container(
                      //color: PdfColors.grey200,
                      //decoration: pw.BoxDecoration(
                      //border: pw.Border.all(color: PdfColors.green)),
                      width:
                      double.parse(column[colCtr]['width'].toString()) * 8,
                      child: pw.Align(
                              alignment:
                              column[colCtr]['align'].toString() == 'r'
                                  ? pw.Alignment.centerRight
                                  : pw.Alignment.centerLeft,
                          child: pw.Column(children: [
                            pw.Text(column[colCtr]['heading'].toString(),
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                    fontSize: 16,
                                    //color: PdfColors.black,
                                    fontWeight: pw.FontWeight.bold)),
                          ])))
                     ]
                ]
              ]))
        ],
      );
}
