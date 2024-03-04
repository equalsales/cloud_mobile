import 'package:flutter/material.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import '../../../common/global.dart' as globals;
//import 'package:easy_search_bar/easy_search_bar.dart';

class EqAppBar extends AppBar {
  EqAppBar(
      {Key? mykey,
      this.AppBarTitle = '',
      this.leading,
      this.iconTheme,
      this.elevation = 0,
      this.backgroundColor = Colors.green,
      this.centerTitle = true})
      : super(key: mykey) {}

  final String? AppBarTitle;
  final Widget? leading;
  final IconThemeData? iconTheme;
  final double? elevation;
  final Color? backgroundColor;
  final bool? centerTitle;

  @override
  _EqAppBarState createState() => _EqAppBarState();
}

class _EqAppBarState extends State<EqAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.AppBarTitle.toString(),
        style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'verdana'),
      ),
      leading: widget.leading,
      iconTheme: widget.iconTheme,
      elevation: widget.elevation,
      backgroundColor: widget.backgroundColor,
      centerTitle: widget.centerTitle,
    );
  }
}
