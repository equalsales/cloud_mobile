//ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/module/looms/customreport/dyegreystockreport.dart';
import 'package:cloud_mobile/module/looms/customreport/saleorderpendingreport.dart';
import 'package:flutter/material.dart';

class CustomReportMenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  CustomReportMenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _CustomReportMenuState createState() => _CustomReportMenuState();
}

class _CustomReportMenuState extends State<CustomReportMenu> {
  List MenuList = [];

  @override
  void initState() {
    super.initState();
    MenuList.add({
      'name': 'Dyegrey Jobwork Issue Stock Report',
      'callback': (Context) => gotoDyegreyJobworkIssueStockReport(context),
    });
    MenuList.add({
      'name': 'Sale Order Pending Report',
      'callback': (Context) => gotoSaleOrderPendingReport(context),
    });
  }

  void gotoDyegreyJobworkIssueStockReport(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DyegreyJobworkIssueStockReport(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoSaleOrderPendingReport(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SaleOrderPendingReport(
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
        AppBarTitle: 'Custom Report Menu',
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
