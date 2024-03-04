import 'dart:io';
//import 'dart:js';
//import 'dart:js';
import 'package:cloud_mobile/common/pdf_api.dart';
//import 'package:cloud_mobile/common/customer.dart';
//import 'package:cloud_mobile/common/utils.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
//// import 'package:google_fonts/google_fonts.dart';

import '../../common/global.dart' as globals;

//import 'package:cloud_mobile/common/customer.dart';
//import 'package:cloud_mobile/common/invoice.dart';
//import 'package:cloud_mobile/common/supplier.dart';

class ReportPdf {
  var Data = [];
  var xGrp;
  var xColumns;
  var xGroupBy = 'acname';
  //var _datalist;
  var nLevel = 0;

  var ReportTitle = '';
  var ReportTitle2 = '';
  var landscape = 'N';

  List column = [];

  Map Grp1Total = new Map();
  Map NetTotal = new Map();

  ReportPdf(Title1, Title2) {
    ReportTitle = Title1;
    ReportTitle2 = Title2;
  }

  addColumn(field, caption, datatype, width, decimal, align, hide, aggr) {
    var colEle = {
      'field': field,
      'caption': caption,
      'datatype': datatype,
      'width': width,
      'decimal': decimal,
      'align': align,
      'hide': hide,
      'aggr': aggr,
    };
    column.add(colEle);
  }

  Future<File> generate() async {
    //addColumn('_autoword_', '_autoword_', 'C', 10, 0, 'left', 'Y');

    // final pw.Document doc = pw.Document();
    // doc.addPage(pw.MultiPage(
    //   pageTheme: pw.PageTheme(margin: pw.EdgeInsets.zero),
    //   header: _buildHeader,
    //   build: (context)=>_buildContent(context)))

    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: landscape == 'Y'
          ? PdfPageFormat.a4.landscape
          : PdfPageFormat.a4.portrait,
      maxPages: 99999,
      header: (context) {
        return buildTitle(ReportTitle, ReportTitle2, column);
      },
      footer: (context) {
        return Center(
            child: Text(
                'Page No : ' +
                    context.pageNumber.toString() +
                    ' / ' +
                    context.pagesCount.toString(),
                style: TextStyle(
                    fontSize: 9,
                    color: PdfColors.black,
                    fontWeight: FontWeight.bold)));
      },
      build: (context) => [
        //buildHeader(invoice),
        //SizedBox(height: 3 * PdfPageFormat.cm),
        //buildTitle('DHRUV FITWALA', ''),
        buildTitle2(context, Data, column, xGroupBy),
        //buildInvoice(column, Data),
        Divider(),
        //buildTotal(invoice),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    //PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf)
    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildTitle(ReportTitle, ReportTitle2, column) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(globals.companyname,
              style: TextStyle(
                  fontSize: 18,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Text(ReportTitle,
              style: TextStyle(
                  fontSize: 16,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Text(ReportTitle2,
              style: TextStyle(
                  fontSize: 13,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Container(
              width: double.infinity,
              height: 25,
              decoration:
                  BoxDecoration(border: Border.all(color: PdfColors.black)),
              child: Row(children: <Widget>[
                for (int colCtr = 0; colCtr < column.length; colCtr++) ...[
                  Container(
                      color: PdfColors.grey200,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: PdfColors.green)),
                      width:
                          double.parse(column[colCtr]['width'].toString()) * 8,
                      child: Align(
                          alignment:
                              column[colCtr]['align'].toString() == 'right'
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Column(children: [
                            Text(column[colCtr]['caption'].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: PdfColors.black,
                                    fontWeight: FontWeight.bold)),
                          ])))
                ]
              ]))
        ],
      );

  static Widget buildTitle2(context, reportdata, column, groupby) {
    final List items = [];

    var count = reportdata.length;
    //print(reportdata);
    var colCount = column.length;

    //Total Array
    var netTotal = [];
    var grpTotal1 = [];

    var iCtr = 0;

    for (iCtr = 0; iCtr < colCount; iCtr++) {
      print(column[iCtr]['field']);
      netTotal.add(0);
      grpTotal1.add(0);
      //grpTotal1[column[iCtr]['field']] = 0;
    }
    print(netTotal);

    //var nCtr = 0;
    // Start First Grouping !!!!
    if (groupby != '') {
      var cgroup = '';
      var cNextGroup = '';
      for (iCtr = 0; iCtr < reportdata.length; iCtr++) {
        print(iCtr);
        if ((iCtr + 1) < reportdata.length) {
          cNextGroup = reportdata[iCtr + 1][groupby].toString();
        }
        if (cNextGroup != cgroup) {
          if (iCtr != 0) {
            print('------');
            print(iCtr);
            if ((iCtr + 1) < reportdata.length) {
              reportdata[iCtr + 1]['auto'] = 'Y';
            }

            for (var jCtr = 0; jCtr < colCount; jCtr++) {
              //field = column[jCtr]['field'].toString();
              if (column[jCtr]['aggr'] == 'SUM') {
                grpTotal1[jCtr] = grpTotal1[jCtr] +
                    double.parse(
                        reportdata[iCtr][column[jCtr]['field']].toString());

                netTotal[jCtr] = netTotal[jCtr] +
                    double.parse(
                        reportdata[iCtr][column[jCtr]['field']].toString());
              } else if (column[jCtr]['aggr'] == 'COUNT') {
                grpTotal1[jCtr] += 1;
                netTotal[jCtr] += 1;
              }
            }

            var newRow = {};
            for (var jCtr = 0; jCtr < colCount; jCtr++) {
              if ((column[jCtr]['aggr'] == 'SUM') ||
                  (column[jCtr]['aggr'] == 'COUNT')) {
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
              //grpTotal1[column[iCtr]['field']] = 0;
            }

            cgroup = reportdata[iCtr][groupby].toString();
            reportdata[iCtr]['autoword'] = cgroup;
            //reportdata[iCtr]['bold'] = 'Y';

            reportdata.insert(iCtr + 1, newRow);
            iCtr = iCtr + 1;

            print(iCtr);
            print(reportdata.length);
            //print(reportdata[iCtr + 2]);
            //break;
            // if ((iCtr + 1) < reportdata.length) {
            //   iCtr = iCtr + 1;
            // }

            //newRow[groupby] = cgroup;
          } else {
            reportdata[iCtr]['auto'] = 'Y';

            cgroup = reportdata[iCtr][groupby].toString();
            reportdata[iCtr]['autoword'] = cgroup;
            reportdata[iCtr]['bold'] = 'Y';

            for (var jCtr = 0; jCtr < colCount; jCtr++) {
              //field = column[jCtr]['field'].toString();
              if (column[jCtr]['aggr'] == 'SUM') {
                grpTotal1[jCtr] = grpTotal1[jCtr] +
                    double.parse(
                        reportdata[iCtr][column[jCtr]['field']].toString());

                netTotal[jCtr] = netTotal[jCtr] +
                    double.parse(
                        reportdata[iCtr][column[jCtr]['field']].toString());
              } else if (column[jCtr]['aggr'] == 'COUNT') {
                grpTotal1[jCtr] += 1;
                netTotal[jCtr] += 1;
              }
            }
          }
        } else {
          reportdata[iCtr]['auto'] = '';
          cgroup = reportdata[iCtr][groupby].toString();
          reportdata[iCtr]['autoword'] = '';
          reportdata[iCtr]['bold'] = '';

          for (var jCtr = 0; jCtr < colCount; jCtr++) {
            //field = column[jCtr]['field'].toString();
            if (column[jCtr]['aggr'] == 'SUM') {
              grpTotal1[jCtr] = grpTotal1[jCtr] +
                  double.parse(
                      reportdata[iCtr][column[jCtr]['field']].toString());

              netTotal[jCtr] = netTotal[jCtr] +
                  double.parse(
                      reportdata[iCtr][column[jCtr]['field']].toString());
            } else if (column[jCtr]['aggr'] == 'COUNT') {
              grpTotal1[jCtr] += 1;
              netTotal[jCtr] += 1;
            }
          }
          //print(grpTotal1);
        }

        //cgroup = reportdata[iCtr][groupby].toString();
      }
    }

    //print(reportdata);
    //var field = '';
    //Calculate Net Total !!!!
    // for (iCtr = 0; iCtr < count; iCtr++) {
    //   for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //     //field = column[jCtr]['field'].toString();
    //     if (column[jCtr]['aggr'] == 'SUM') {
    //       //print(column[jCtr]['field']);
    //       netTotal[jCtr] = netTotal[jCtr] +
    //           double.parse(reportdata[iCtr][column[jCtr]['field']].toString());
    //     } else if (column[jCtr]['aggr'] == 'COUNT') {
    //       netTotal[jCtr] += 1;
    //     }
    //   }
    // }

    // if (groupby != '') {
    //   var newRow = {};
    //   for (var jCtr = 0; jCtr < colCount; jCtr++) {
    //     if ((column[jCtr]['aggr'] == 'SUM') ||
    //         (column[jCtr]['aggr'] == 'COUNT')) {
    //       newRow[column[jCtr]['field']] = grpTotal1[jCtr];
    //     } else {
    //       newRow[column[jCtr]['field']] = '';
    //     }
    //   }
    //   newRow['bold'] = 'Y';
    //   reportdata.add(newRow);
    // }
    //Put Net Total !!!!
    var newRow = {};
    for (var jCtr = 0; jCtr < colCount; jCtr++) {
      if ((column[jCtr]['aggr'] == 'SUM') ||
          (column[jCtr]['aggr'] == 'COUNT')) {
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

    //print(count);

    // var dataCtr = 0;
    // int size = column.length;
    // final data = items.map((item) {
    //   final x = List.empty(growable: true);
    //   var field = '';
    //   var decimal = 0;
    //   for (var iCtr = 0; iCtr < column.length; iCtr++) {
    //     field = column[iCtr]['field'];
    //     decimal = column[iCtr]['decimal'];
    //     x.add(reportdata[dataCtr][field].toString());
    //   }
    //   dataCtr++;

    //   return x;
    // }).toList();

    //print(reportdata);
    // List<Widget> obj = [];
    // List colObj = [];
    // var field;
    // for (var iCtr = 0; iCtr < count; iCtr++) {
    //   colObj = [];
    //   for (var xCtr = 0; xCtr < colCount; xCtr++) {
    //     field = column[xCtr]['field'];
    //     colObj.add(Container(
    //         width: 100,
    //         child: Column(children: [
    //           Text(reportdata[iCtr][field]),
    //         ])));
    //   }
    //   obj.add(colObj);
    // }

    //return Column(children: obj);
    // Container(
    //     decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
    //     width: double.infinity,
    //     child: Row(
    //         children: List.generate(column.length, (index) {
    //       return Container(
    //           width: 100,
    //           child: Column(children: [
    //             Text(column[index]['caption']),
    //           ]));
    //     })));

    // var newList = [for (var i = 0; i < items.length; i++) {
    //   return Container(
    //               width: 100,
    //               child: Column(children: [
    //                 Text('xxxx'),
    //               ]))

    // }];

    //var groupby = ;
    //var cgroup = '';
    //var cNextGroup = '';
    //var cnextgroup = '';

    print(groupby);
    print(reportdata);
    return Column(children: <Widget>[
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
          Container(
              width: double.infinity,
              //decoration:
              //BoxDecoration(border: Border.all(color: PdfColors.black)),
              child: Text(reportdata[i][groupby].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: PdfColors.red,
                      fontWeight: FontWeight.bold))),
        ],

        // if (i < (items.length - 1)) ...[
        //   cnextgroup = reportdata[i + 1]['acname']
        // ],
        // if (cnextgroup != cgroup)
        //   Container(
        //       width: double.infinity,
        //       decoration:
        //           BoxDecoration(border: Border.all(color: PdfColors.black)),
        //       child: Text('DHRUV FITWALA')),
        Container(
            width: double.infinity,
            // decoration:
            //     BoxDecoration(border: Border.all(color: PdfColors.black)),
            child: Row(children: <Widget>[
              for (int colCtr = 0; colCtr < column.length; colCtr++) ...[
                Container(
                    padding: const EdgeInsets.all(4),
                    //color: i % 2 == 0 ? PdfColors.white : PdfColors.grey100,
                    // `decoration: BoxDecoration(
                    //     border: Border(top: BorderSide(width: 1))),`
                    width: double.parse(column[colCtr]['width'].toString()) * 8,
                    child: Align(
                        alignment: column[colCtr]['align'].toString() == 'right'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(children: [
                          Text(
                              reportdata[i][column[colCtr]['field']].toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: (reportdata[i]['bold']
                                                  .toString() ==
                                              'Y' &&
                                          reportdata[i]['auto'].toString() !=
                                              'Y')
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ])))
              ]
            ])),
      ]
    ]);
    // return Column(
    //     children: List.generate(items.length, (index) {
    //   //cgroup = reportdata[index]['acname'];
    //   if (index < (items.length - 1)) {
    //     cnextgroup = reportdata[index + 1]['acname'];
    //   }
    //   if (cgroup != cnextgroup) {
    //     // cgroup = reportdata[index]['acname'];
    //     // index = index - 1;
    //     // return Container(
    //     //     width: double.infinity,
    //     //     decoration:
    //     //         BoxDecoration(border: Border.all(color: PdfColors.black)),
    //     //     child: Text('DHRUV FITWALA'));
    //   }
    //   return (Container(
    //       decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
    //       width: double.infinity,
    //       child: Row(
    //           children: List.generate(column.length, (colIndex) {
    //         cgroup = reportdata[index]['acname'];
    //         if (column[colIndex]['hide'] == 'N') {
    //           return (Container(
    //               width: 100,
    //               child: Column(children: [
    //                 Text(reportdata[index][column[colIndex]['field']]),
    //               ])));
    //         } else {
    //           return Container(
    //               width: 0,
    //               child: Column(children: [
    //                 Text(''),
    //               ]));
    //         }
    //       }))));
    // }));
    return Column(children: [
      Container(
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          width: double.infinity,
          child: Row(
              children: List.generate(items.length, (index) {
            return Container(
                width: 100,
                child: Column(children: [
                  Text('dddd'),
                ]));
          }))),
      Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          child: Text('DHRUV FITWALA')),
      Container(
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          width: double.infinity,
          child: Row(children: [
            Container(
                width: 100,
                child: Column(children: [
                  Text('dddd'),
                ])),
            Container(
                width: 100,
                child: Column(children: [
                  Text('xxxx'),
                ])),
          ])),
    ]);
    return Column(children: [
      Container(
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          width: double.infinity,
          child: Row(children: [
            Container(
                width: 100,
                child: Column(children: [
                  Text('dddd'),
                ])),
            Container(
                width: 100,
                child: Column(children: [
                  Text('xxxx'),
                ])),
            Container(
                width: 100,
                child: Column(children: [
                  Text('xxxx'),
                ])),
            Container(
                width: 100,
                child: Column(children: [
                  Text('xxxx'),
                ])),
            Container(
                width: 100,
                child: Column(children: [
                  Text('xxxx'),
                ])),
          ])),
      Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          child: Text('DHRUV FITWALA')),
      Container(
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          width: double.infinity,
          child: Row(children: [
            Container(
                width: 100,
                child: Column(children: [
                  Text('dddd'),
                ])),
            Container(
                width: 100,
                child: Column(children: [
                  Text('xxxx'),
                ])),
          ])),
      Container(
        margin: EdgeInsets.all(20),
        child: Table(
          defaultColumnWidth: FixedColumnWidth(120.0),
          //border: TableBorder.all(style: BorderStyle.solid, width: 2),
          children: [
            TableRow(children: [
              Column(
                children: [
                  Text(
                    'Webxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ]),
            TableRow(children: [
              Column(
                children: [
                  Text('https://flutter.dev/'),
                ],
              ),
              Column(
                children: [
                  Text('Flutter'),
                ],
              ),
              Column(
                children: [
                  Text('5*'),
                ],
              ),
            ]),
            TableRow(children: [
              Column(
                children: [
                  Text('https://dart.dev/'),
                ],
              ),
              Column(
                children: [
                  Text('Dart'),
                ],
              ),
              Column(
                children: [
                  Text('5*'),
                ],
              ),
            ]),
            TableRow(children: [
              Column(
                children: [
                  Text('https://pub.dev/'),
                ],
              ),
              Column(
                children: [
                  Text('Flutter Packages'),
                ],
              ),
              Column(
                children: [
                  Text('5*'),
                ],
              ),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget buildInvoice(column, reportdata) {
    final headers = [];

    Map<int, TableColumnWidth> col = new Map<int, TableColumnWidth>();
    Map<int, Alignment> cellAlign = new Map<int, Alignment>();

    for (var iCtr = 0; iCtr < column.length; iCtr++) {
      headers.add(column[iCtr]['caption']);
      //print(column[iCtr]['width']);
      double width = double.parse(column[iCtr]['width'].toString());
      col[iCtr] = FixedColumnWidth(width);
      //colWidth.add(FixedColumnWidth(width));
      if (column[iCtr]['align'] == 'left') {
        cellAlign[iCtr] = Alignment.centerLeft;
      } else {
        cellAlign[iCtr] = Alignment.centerRight;
        //cellAlign.add(Alignment.centerRight);
      }
    }
    //print(cellAlign);
    //Map cellAlignment = cellAlign.asMap();
    //Map cellWidth = colWidth.asMap();
    //print(col);
    //print(cellAlignment);

    //print(reportdata);

//final data = reportdata.map((item)=>['1','2','3','4']).toList();

    // final List items = [
    //   {'1', '2', '3', '4'},
    //   {'1', '2', '3', '4'},
    //   {'1', '2', '3', '4'},
    //   {'1', '2', '3', '4'},
    //   {'1', '2', '3', '4'},
    //   {'1', '2', '3', '4'}
    // ];
    final List items = [];

    var count = reportdata.length;
    for (var iCtr = 0; iCtr < count; iCtr++) {
      items.add({'1', '2', '3', '4'});
    }

    //print('xxxxxxx');
    //print(reportdata.length);
    // final data2 = reportdata.map((item) {
    //   print('m here');
    //   return ['xx', 'xx', 'xx', 'xx'];
    // }).toList();

    var dataCtr = 0;
    //print(column.length);
    //int size = column.length;
    final data = items.map((item) {
      //List x = [];
      //List x = new List.filled(size, null, growable: false);
      final x = List.empty(growable: true);
      //x.add('1');
      //x.add('2');
      //x.add('2');
      //x.add('2');
      var field = '';
      var decimal = 0;
      for (var iCtr = 0; iCtr < column.length; iCtr++) {
        field = column[iCtr]['field'];
        decimal = column[iCtr]['decimal'];
        x.add(reportdata[dataCtr][field].toString());
        //print(reportdata[dataCtr][field]);
        //print(reportdata[dataCtr][field].runtimeType);
        // if (decimal > 0) {
        //   x.add(reportdata[dataCtr][field].toStringAsFixed(decimal));
        // } else {
        //   x.add(reportdata[dataCtr][field].toString());
        // }
      }
      dataCtr++;

      return x;
      // return [
      //   reportdata[1]['date2'].toString(),
      //   reportdata[1]['refacname'].toString(),
      //   reportdata[1]['dramt'].toString(),
      //   reportdata[1]['cramt'].toString()
      // ];
    }).toList();

    return Table.fromTextArray(
        headers: headers,
        data: [
          ['1', '2', '3', '4', '5'],
          ['1111111111111111111111111111111111111', '2', '3', '4', '5']
        ],
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        columnWidths: col,
        cellAlignments: cellAlign
        /*columnWidths: { 
        0: const FixedColumnWidth(80),
        1: const FlexColumnWidth(2),
        2: const FractionColumnWidth(.2),
      },*/
        /*cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },*/
        );
  }
}
