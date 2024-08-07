// ignore_for_file: must_be_immutable

import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/machine_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import '../../../common/global.dart' as globals;
import 'package:cloud_mobile/common/bottombar.dart';

class LoomMachinecardDetAdd extends StatefulWidget {
  LoomMachinecardDetAdd(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      itemDet,
      id,})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xItemDetails = itemDet;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _LoomMachinecardDetAddState createState() => _LoomMachinecardDetAddState();
}

class _LoomMachinecardDetAddState extends State<LoomMachinecardDetAdd> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _machine	 = new TextEditingController();
  TextEditingController _rpm = new TextEditingController();
  TextEditingController _dsmeters = new TextEditingController();
  TextEditingController _dsefficiency = new TextEditingController();
  TextEditingController _dsname = new TextEditingController();
  TextEditingController _nsmeters = new TextEditingController();
  TextEditingController _nefficiency = new TextEditingController();
  TextEditingController _nsname = new TextEditingController();
  TextEditingController _totmeters = new TextEditingController();
  TextEditingController _warplength = new TextEditingController();
  TextEditingController _outmeters= new TextEditingController();
  TextEditingController _remainmeters = new TextEditingController();
  TextEditingController _ends = new TextEditingController();
  TextEditingController _reed = new TextEditingController();
  TextEditingController _pick = new TextEditingController();
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  
  double ordMeters = 0;

  final _formKey = GlobalKey<FormState>();

  
  @override
  void initState() {
    super.initState();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();

    List ItemDetails = widget.xItemDetails;
    int length = ItemDetails.length;
    print('Length :' + length.toString());
    // if (length > 0) {
    //   setState(() {
    //     _orderno.text = ItemDetails[length - 1]['orderno'].toString();
    //     _itemname.text = ItemDetails[length - 1]['itemname'].toString();
    //     _design.text = ItemDetails[length - 1]['design'].toString();
    //     _unit.text = ItemDetails[length - 1]['unit'].toString();
    //     _rate.text = ItemDetails[length - 1]['rate'].toString();
      // });
    // }

    //_date.text = curDate.toString().split(' ')[0];

    // if (int.parse(widget.xid) > 0) {
    //   //loadData();
    // }
  }

  void gotoItemnameScreen(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => item_list(
                  companyid: widget.xcompanyid,
                  companyname: widget.xcompanyname,
                  fbeg: widget.xfbeg,
                  fend: widget.xfend,
                )));
    setState(() {
      var retResult = result;
      var newResult = result[1];
      var selItemname = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selItemname = selItemname + ',';
        }
        selItemname = selItemname + retResult[0][ictr];
      }
      setState(() {
        _itemname.text = newResult[0]['itemname'].toString();
      });
    });
  }
  
  void gotoMachineScreen(BuildContext contex) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => machine_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

    setState(() {
      var retResult = result;
      
      var selMachine = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selMachine = selMachine + ',';
        }
        selMachine = selMachine + retResult[0][ictr];
      }
      _machine.text = selMachine;
    });
  }


  @override
  Widget build(BuildContext context) {
    Future<bool> saveData() async {
      String uri = '';
      var cno = globals.companyid;
      var db = globals.dbname;
      var username = globals.username;

      var machine = _machine.text;
      var rpm = _rpm.text;
      var dsmeters = _dsmeters.text;
      var dsefficiency = _dsefficiency.text;
      var dsname = _dsname.text;
      var nsmeters = _nsmeters.text;
      var nefficiency = _nefficiency.text;
      var nsname = _nsname.text;
      var totmeters = _totmeters.text;
      var warplength = _warplength.text;
      var netoutmeterswt = _outmeters.text;
      var remainmeters = _remainmeters.text;
      var ends = _ends.text;
      var reed = _reed.text;
      var pick = _pick.text;
      var itemname = _itemname.text;
      var remarks = _remarks.text;

      widget.xitemDet.add({
        'machine': machine,
        'rpm': rpm,
        'dsmeters': dsmeters,
        'dsefficiency': dsefficiency,
        'dsname': dsname,
        'nsmeters': nsmeters,
        'nsefficiency': nefficiency,
        'nsname': nsname,
        'totmeters': totmeters,
        'warplength': warplength,
        'outmeters': netoutmeterswt,
        'remainmeters': remainmeters,
        'ends': ends,
        'reed': reed,        
        'pick': pick,
        'itemname': itemname,
        'remarks': remarks,
      });
      Navigator.pop(context, widget.xitemDet);
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Machine Card [ ] ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: Colors.green,
          onPressed: () => {
            if(_formKey.currentState!.validate()){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Form submitted successfully')),
              ),
              saveData()
            }
          }),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _machine,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Select Machine',
                      labelText: 'Machine',
                    ),
                    onTap: () {
                      gotoMachineScreen(context);
                    },
                    validator: (value) {
                      if (value == '') {
                        return "Please enter Machine";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                  controller: _rpm,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Rpm',
                    labelText: 'Rpm',
                  ),
                  validator: (value) {
                    return null;
                  },
                )),
                Expanded(
                  child: TextFormField(
                    controller: _dsmeters,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Dsmeters',
                      labelText: 'Dsmeters',
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dsefficiency,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Dsefficiency',
                      labelText: 'Dsefficiency',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(              
                    controller: _dsname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Dsname',
                      labelText: 'Dsname',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nsmeters,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Nsmeters',
                      labelText: 'Nsmeters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _nefficiency,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Nsefficiency',
                      labelText: 'Nsefficiency',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nsname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Nsname',
                      labelText: 'Nsname',
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _totmeters,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Totmeters',
                      labelText: 'Totmeters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _warplength,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Warplength',
                      labelText: 'Warplength',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _outmeters,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Outmeters',
                      labelText: 'Outmeters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _remainmeters,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Remainmeters',
                      labelText: 'Remainmeters',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _ends,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Ends',
                      labelText: 'Ends',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _reed,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Reed',
                      labelText: 'Reed',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _pick,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Pick',
                      labelText: 'Pick',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _itemname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Itemname',
                      labelText: 'Itemname',
                    ),
                    onTap: () {
                      gotoItemnameScreen(context);
                    },
                    validator: (value) {
                      if (value == '') {
                        return "Please enter itemname";
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _remarks,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Remarks',
                      labelText: 'Remarks',
                    ),
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      )),
      bottomNavigationBar: BottomBar(
        companyname: widget.xcompanyname,
        fbeg: widget.xfbeg,
        fend: widget.xfend,
      ),
    );
  }
}
