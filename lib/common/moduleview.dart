import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import '../../../common/global.dart' as globals;
//import 'package:easy_search_bar/easy_search_bar.dart';

class ModuleVIew extends StatefulWidget {
  final VoidCallback onAdd;
  final VoidCallback onBack;
  final void Function(int) onPDF;
  final void Function(int) onDel;
  final void Function(int) onEdit;
  //final VoidCallback onPDF;
  //final VoidCallback onDel;
  //const ModuleVIew(
  //{super.key, companyid, companyname, fbeg, fend, required this.onAdd});

  ModuleVIew(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      Data,
      DataFormat,
      Title,
      required this.onAdd,
      required this.onBack,
      required this.onPDF,
      required this.onDel,
      required this.onEdit
      //required this.onDel
      })
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    _Title = Title;
    _Data = Data;
    _orgData = Data;
    _DataFormat = DataFormat;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  String _Title = '';
  Widget appBarTitle = new Text(
    "Search Sample",
    style: new TextStyle(color: Colors.white),
  );
  //final TextEditingController _searchQuery = new TextEditingController();

  String _DataFormat = '';
  List _Data = [];
  List _orgData = [];

  @override
  _ModuleViewPageState createState() => _ModuleViewPageState();
}

class _ModuleViewPageState extends State<ModuleVIew> {
  bool _searchBoolean = false;
  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        if (s != '') {
          setState(() {
            List xData = [];
            List xIndex = [];

            for (int i = 0; i < widget._orgData.length; i++) {
              for (var xkey in widget._orgData[0].keys) {
                print(widget._orgData[i][xkey].toString());
                if (widget._orgData[i][xkey].toString().contains(s)) {
                  xIndex.add(i);
                }
              }
            }

            print(xIndex);
            for (int i = 0; i < xIndex.length; i++) {
              xData.add(widget._orgData[xIndex[i]]);
            }
            setState(() {
              widget._Data = xData;
            });
          });
        } else {
          setState(() {
            widget._Data = widget._orgData;
          });
        }
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'verdana'),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  // print(Title);

  String searchValue = '';
  Icon cusIcon = Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.green,
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: widget.onBack,
          ),
          title: !_searchBoolean
              ? Text(
                  widget._Title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'verdana'),
                )
              : _searchTextField(),
          actions: !_searchBoolean
              ? [
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                          //_searchIndexList = [];
                        });
                      })
                ]
              : [
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                          setState(() {
                            widget._Data = widget._orgData;
                          });
                        });
                      })
                ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: widget.onAdd,
        //onPressed: () => {print('clicked'), onAdd},
      ),
      body: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Center(
            child: ListView.builder(
          itemCount: widget._Data.length,
          itemBuilder: (context, index) {
            //String unit = widget._Data[index]['unit'].toString();

            //print(widget._Data[0]);
            //this._Data.keys.forEach((k) => print("Key : $k"));
            //Map myMap = this._Data[0].asMap();

            //print(this._Data[0].keys);
            String _DataFormat2 = widget._DataFormat;
            for (var xkey in widget._Data[0].keys) {
              _DataFormat2 = _DataFormat2.replaceAll(
                  '#' + xkey + '#', widget._Data[index][xkey].toString());
              //print(xkey);
            }
            //print(_DataFormat2);
            //print(myMap);
            // myMap.forEach((key, value) {
            //   print(key);
            // });

            String id = widget._Data[index]['id'].toString();

            //int newid = int.parse(id);

            return Slidable(
              key: ValueKey(index),
              startActionPane:
                  ActionPane(motion: const BehindMotion(), children: [
                SlidableAction(
                    //onPressed: onPDF,
                    onPressed: (context) => {widget.onPDF(int.parse(id))},
                    icon: Icons.picture_as_pdf,
                    label: 'PDF',
                    backgroundColor: Color(0xFFFE4A49)),
                SlidableAction(
                    onPressed: (context) => {widget.onDel(int.parse(id))},
                    icon: Icons.delete_forever,
                    label: 'Delete',
                    backgroundColor: Colors.blue)
              ]),
              child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      //isThreeLine: true,
                      title: Text(
                        //unit,
                        _DataFormat2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'verdana'),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        widget.onEdit(int.parse(id));
                      },
                    ),
                  )),
            );
          },
        )),
      ),
    );
  }
}
