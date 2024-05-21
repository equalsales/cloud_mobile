//ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/module/looms/purchasechallan/beampurchasechallan/beampurchasechallanlist.dart';
import 'package:cloud_mobile/module/looms/purchasechallan/greypurchasechallan/greypurchasechallanlist.dart';
import 'package:cloud_mobile/module/looms/purchasechallan/yarnpurchasechallan/yarnpurchasechallanlist.dart';
import 'package:flutter/material.dart';

class LoomPurchaseChallanMenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  LoomPurchaseChallanMenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _LoomPurchaseChallanMenuState createState() => _LoomPurchaseChallanMenuState();
}

class _LoomPurchaseChallanMenuState extends State<LoomPurchaseChallanMenu> {
  List _companydetails = [];
  List MenuList = [];

  @override
  void initState() {
    super.initState();
    MenuList.add({
      'name': 'Beam Purchase Challan',
      'callback': (Context) => gotoBeamPurchaseChallan(context),
    });
    MenuList.add({
      'name': 'Grey Purchase Challan',
      'callback': (Context) => gotoGreyPurchaseChallan(context),
    });
    MenuList.add({
      'name': 'Yarn Purchase Challan',
      'callback': (Context) => gotoYarnPurchaseChallan(context),
    });
  }

  void gotoBeamPurchaseChallan(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BeamPurchaseChallanList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoGreyPurchaseChallan(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => GreyPurchaseChallanList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoYarnPurchaseChallan(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => YarnPurchaseChallanList(
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
        AppBarTitle: 'Purchase Challan Menu',
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 1.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15),
            itemCount: MenuList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: Icon(Icons.view_module),
                    title: Text(MenuList[index]['name'],
                        style: TextStyle(
                            fontFamily: 'verdana',
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    onTap: () => {
                          print(MenuList[index]['callback']),
                          Function.apply(MenuList[index]['callback'], [context])
                        }),
              );
            }),
      ),
    );
  }
}
