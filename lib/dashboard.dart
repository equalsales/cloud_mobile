import 'dart:convert';
import 'package:flutter/material.dart';
import 'common/global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:cloud_mobile/function.dart';
import 'package:cloud_mobile/common/eqappbar.dart';
import 'package:cloud_mobile/dashboard/sidebar.dart';
import 'package:cloud_mobile/common/bottombar.dart';

class Dashboard extends StatefulWidget {
  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  Dashboard({Key? mykey, companyid, companyname, fbeg, fend})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //List _companydetailsX = [];
  //List _companydetailsY = [];
  final List<BarChartModel> data = [];

  @override
  void initState() {
    super.initState();
    companydetails();
  }

  @override
  Widget build(BuildContext context) {
    // print('dhaval');
    // print(data);

    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: 'Sales',
        data: data,
        domainFn: (BarChartModel series, _) => series.xValues,
        measureFn: (BarChartModel series, _) => series.yValues,
        colorFn: (BarChartModel series, _) => series.color,
      )
    ];

    return Scaffold(
      drawer: SideDrawer(
          companyid: widget.xcompanyid,
          companyname: widget.xcompanyname,
          fbeg: widget.xfbeg,
          fend: widget.xfend),
      appBar: EqAppBar(
        AppBarTitle: 'Dashboard [' + widget.xcompanyid + ']',
      ),
      body: Center(
        child: Container(
            width: 700,
            padding: const EdgeInsets.all(10),
            child: charts.BarChart(series, animate: true)),
        //child: JobsListView()
      ),
      bottomNavigationBar: BottomBar(
          companyname: widget.xcompanyname,
          fbeg: widget.xfbeg,
          fend: widget.xfend),
    );
  }

  Future<bool> companydetails() async {
    var cfromdate = retconvdate(globals.startdate).toString();
    var ctodate = retconvdate(globals.enddate).toString();

    var cno = globals.companyid;
    var db = globals.dbname;
    //print('----');
    //print(cno);
    var api =
        "${globals.cdomain2}/api/api_getchartsales?dbname=$db&companyid=$cno&type=ms&fromdate=$cfromdate&todate=$ctodate";
    print(api);

    var response = await http.get(Uri.parse(api));

    var jsonData = jsonDecode(response.body);

    var jsonX = jsonData['xValues'];
    var jsonY = jsonData['yValues'];

    print(jsonX);
    print(jsonY);

    // for (var ictr = 0; ictr < jsonX.length; ictr++) {
    //   data.add(BarChartModel(
    //       xValues: jsonX[ictr].toString(),
    //       yValues: double.parse(jsonY[ictr]),
    //       color: charts.ColorUtil.fromDartColor(Colors.blue)));
    // }

    // setState(() {
      //_companydetailsX = jsonX;
      //_companydetailsY = jsonY;
    // });

    return true;
  }

  void gotoSettings(BuildContext context) async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => SettingPreView(
    //               companyid: widget.xcompanyid,
    //               companyname: widget.xcompanyname,
    //               fbeg: widget.xfbeg,
    //               fend: widget.xfend,
    //             )));
  }

  final List<BarChartModel> data2 = [
    BarChartModel(
        xValues: "April",
        yValues: 201410872.00,
        color: charts.ColorUtil.fromDartColor(Colors.blue)),
    BarChartModel(
        xValues: "May",
        yValues: 201510872.00,
        color: charts.ColorUtil.fromDartColor(Colors.blue)),
  ];
}

class BarChartModel {
  String xValues;
  double yValues;
  final charts.Color color;

  BarChartModel(
      {required this.xValues, required this.yValues, required this.color});
}
