import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  var xcompanyname;
  var xfbeg;
  var xfend;

  //final Function() notifyParent;

  BottomBar({Key? mykey, companyname, fbeg, fend}) : super(key: mykey) {
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
  }

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Text(
          widget.xcompanyname + ' ' + widget.xfbeg + ' To ' + widget.xfend,
          //style: TextStyle(color: Colors.white, fontSize: 15)
          style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.normal)),
      color: Colors.red,
    );
  }
}
