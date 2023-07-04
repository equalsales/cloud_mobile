import 'package:flutter/material.dart';
import 'package:cloud_mobile/report/salebill/salebillmenu.dart';
import 'package:cloud_mobile/module/enq/enqlist.dart';
import 'package:cloud_mobile/module/bankbook/bankbooklist.dart';
import 'package:cloud_mobile/mastermenu.dart';

//import 'package:cloud_mobile/report/task/pendingtask.dart';
//import 'package:cloud_mobile/report/task/pendingcall.dart';
//import 'package:cloud_mobile/report/task/checkingcall.dart';
//>>>>>>> 074aa7a8b52fbfcc81e98c791470e254ad6414e8
//import 'package:myfirstapp/screens/loginscreen/login_screen.dart';
//import 'package:myfirstapp/screens/purchase/purchaseview_screen.dart';
//import 'package:myfirstapp/screens/sales/saleview_screen.dart';
//import 'package:myfirstapp/screens/greypurchase/greypurchaseview_screen.dart';
//import 'package:myfirstapp/screens/millgp/millgpview_screen.dart';
//import 'package:myfirstapp/screens/finishjob/finishjobview_screen.dart';
//import 'package:myfirstapp/screens/genpurc/genpurcview_screen.dart';
//import 'package:myfirstapp/screens/saleos/osview_screen.dart';
//import 'package:myfirstapp/screens/transaction/saleorder/saleorderview_screen.dart';
//import 'package:myfirstapp/screens/saleos/saleosview_screen.dart';

import '../common/global.dart' as globals;

class SideDrawer extends StatelessWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  SideDrawer({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  Widget build(BuildContext context) {
    //print(xcompanyid);
    //print(xfbeg);
    //print('dhruv');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Equal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Master'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mastermenu(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Bank Book'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BankBookList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Enquiry'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EnqList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => LoginScreen()))
            },
          ),
        ],
      ),
    );
  }
}
