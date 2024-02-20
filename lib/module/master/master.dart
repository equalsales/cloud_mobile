//ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/module/master/accounthead/accountheadlist.dart';
import 'package:cloud_mobile/module/master/bankmaster/bankmasterlist.dart';
import 'package:cloud_mobile/module/master/bookmaster/bookmasterlist.dart';
import 'package:cloud_mobile/module/master/citymaster/citymasterlist.dart';
import 'package:cloud_mobile/module/master/colormaster/colormasterlist.dart';
import 'package:cloud_mobile/module/master/country/countrymasterlist.dart';
import 'package:cloud_mobile/module/master/designmaster/designmasterlist.dart';
import 'package:cloud_mobile/module/master/hsnmaster/hsnmasterlist.dart';
import 'package:cloud_mobile/module/master/itemmaster/itemmasterlist.dart';
import 'package:cloud_mobile/module/master/partymaster/partymasterlist.dart';
import 'package:cloud_mobile/module/master/statemaster/statemasterlist.dart';
import 'package:cloud_mobile/module/master/unitmaster/unitmasterlist.dart';
import 'package:flutter/material.dart';


class MasterMenu extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  MasterMenu({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _MasterMenuState createState() => _MasterMenuState();
}

class _MasterMenuState extends State<MasterMenu> {
  List _companydetails = [];
  List MenuList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MenuList.add({
      'name': 'Item',
      'callback': (Context) => gotoItemMaster(context),
    });
    MenuList.add({
      'name': 'Design',
      'callback': (Context) => gotoDesignMaster(context),
    });
    MenuList.add({
      'name': 'Color',
      'callback': (Context) => gotoColorMaster(context),
    });
    MenuList.add({
      'name': 'Unit',
      'callback': (Context) => gotoUnitMaster(context),
    });

    MenuList.add({
      'name': 'Hsncode',
      'callback': (Context) => gotoHsncodeMaster(context),
    });

    MenuList.add({
      'name': 'Party ',
      'callback': (Context) => gotoPartyMaster(context),
    });

    MenuList.add({
      'name': 'City ',
      'callback': (Context) => gotoCityMaster(context),
    });
    MenuList.add({
      'name': 'State ',
      'callback': (Context) => gotoStateMaster(context),
    });
    MenuList.add({
      'name': 'Country ',
      'callback': (Context) => gotoCountryMaster(context),
    });

    MenuList.add({
      'name': 'Account Head',
      'callback': (Context) => gotoAccountHead(context),
    });
    MenuList.add({
      'name': 'Book ',
      'callback': (Context) => gotoBookMaster(context),
    });
    MenuList.add({
      'name': 'Bank',
      'callback': (Context) => gotoBankMaster(context),
    });
  }

  void gotoItemMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ItemMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }


 void gotoDesignMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DesignMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

   void gotoColorMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ColorMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoUnitMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => UnitMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

   void gotoHsncodeMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => HSNMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoPartyMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PartyMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoCityMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CityMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoStateMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => StateMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoCountryMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CountryMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoAccountHead(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AccountHeadList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoBookMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BookMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoHSNMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => HSNMasterList(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
  }

  void gotoBankMaster(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BankMasterList(
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
        AppBarTitle: 'Master Menu',
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 2.5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
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
