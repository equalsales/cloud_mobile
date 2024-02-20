import 'package:cloud_mobile/module/master/master.dart';
import 'package:cloud_mobile/module/purchase/purchasebilllist.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_mobile/report/salebill/salebillmenu.dart';
import 'package:cloud_mobile/module/enq/enqlist.dart';
import 'package:cloud_mobile/module/bankbook/bankbooklist.dart';
import 'package:cloud_mobile/module/cashbook/cashbooklist.dart';
import 'package:cloud_mobile/module/purchase/purchasebilllist.dart';
import 'package:cloud_mobile/report/account/view_ledger.dart';

//import 'package:cloud_mobile/report/salebill/salebillmenu.dart';

import 'package:cloud_mobile/transactionmenu.dart';
import 'package:cloud_mobile/main.dart';

// For Looms
import 'package:cloud_mobile/module/looms/saleschallan/loomsaleschallanlist.dart';
import 'package:cloud_mobile/module/looms/greyjobissue/loomgreyjobissuelist.dart';
import 'package:cloud_mobile/module/looms/yarnjobissue/loomyarnjobissuelist.dart';
import 'package:cloud_mobile/module/looms/beamjobissue/loombeamjobissuelist.dart';

import 'package:cloud_mobile/report/salebill/salebillmenu.dart';
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
                      builder: (_) => MasterMenu(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.shopping_cart),
          //   title: Text('Transaction'),
          //   onTap: () => {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => Transactionmenu(
          //                   companyid: xcompanyid,
          //                   companyname: xcompanyname,
          //                   fbeg: xfbeg,
          //                   fend: xfend,
          //                 )))
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Purchase Bill'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PurchaseBillList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Sales Challan'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoomSalesChallanList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Grey Job Issue'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoomGreyJobIssueList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
           ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Yarn Job Issue'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoomYarnJobIssueList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Beam Job Issue'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoomBeamJobIssueList(
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
            title: Text('Cash Book'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CashBookList(
                            companyid: xcompanyid,
                            companyname: xcompanyname,
                            fbeg: xfbeg,
                            fend: xfend,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Party Statement (Ledger)'),
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
            title: Text('Sale Bill Conc'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SaleBillMenu(
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MyApp()))
            },
          ),
        ],
      ),
    );
  }
}
