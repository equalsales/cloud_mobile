import 'package:flutter/material.dart';
import 'package:cloud_mobile/report/account/view_ledger.dart';
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
            title: Text('Ledger'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Ledgerview(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Sale Bill'),
            onTap: () => {
              //Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Purchase Bill'),
            onTap: () => {
              //Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Grey Purchase'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => GreyPurchaseview(
              //               companyid: xcompanyid,
              //               companyname: xcompanyname,
              //               fbeg: xfbeg,
              //               fend: xfend,
              //             )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Mill GP'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => MillGpview(
              //               companyid: xcompanyid,
              //               companyname: xcompanyname,
              //               fbeg: xfbeg,
              //               fend: xfend,
              //             )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Finish Jobwork'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => FinishJobview(
              //               companyid: xcompanyid,
              //               companyname: xcompanyname,
              //               fbeg: xfbeg,
              //               fend: xfend,
              //             )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('General Purchase'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => GenPurcview(
              //               companyid: xcompanyid,
              //               companyname: xcompanyname,
              //               fbeg: xfbeg,
              //               fend: xfend,
              //             )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Outstanding'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => OsView(
              //               companyid: xcompanyid,
              //               companyname: xcompanyname,
              //               fbeg: xfbeg,
              //               fend: xfend,
              //             )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Sale Order'),
            onTap: () => {
              //Navigator.of(context).pop()
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => SaleOrderView()))
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
