//ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/module/looms/stockreport/greyitemstocksummary.dart';
import 'package:cloud_mobile/module/looms/stockreport/takawisestockreport.dart';
import 'package:flutter/material.dart';

class StockReportMenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  StockReportMenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _StockReportMenuState createState() => _StockReportMenuState();
}

class _StockReportMenuState extends State<StockReportMenu> {
  List MenuList = [];

  @override
  void initState() {
    super.initState();
    MenuList.add({
      'name': 'Takawise Stock Report',
      'callback': (Context) => gotoTakawiseStockReport(context),
    });
    // MenuList.add({
    //   'name': 'Grey Item Stock Summary',
    //   'callback': (Context) => gotoGreyItemStockSummaryReport(context),
    // });
  }

  void gotoTakawiseStockReport(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TakawiseStockReport(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoGreyItemStockSummaryReport(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => GreyItemStockSummaryReport(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.xfbeg);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: EqAppBar(
        iconTheme: IconThemeData(color: Colors.black),
        AppBarTitle: 'Stock Report Menu',
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: MenuList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 100,
                child: Card(
                  child: ListTile(
                      leading: Icon(Icons.report,size: 25,),
                      title: Text(MenuList[index]['name'],
                          style: TextStyle(
                              fontFamily: 'verdana',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      onTap: () => {
                            print(MenuList[index]['callback']),
                            Function.apply(MenuList[index]['callback'], [context])
                          }),
                ),
              );
            }),
      ),
    );
  }
}
