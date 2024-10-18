// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_mobile/list/driver_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_mobile/function.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;
import 'package:just_audio/just_audio.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:intl/intl.dart';

class SaleChallanDelivery extends StatefulWidget {
  SaleChallanDelivery({Key? mykey, companyid, companyname, fbeg, fend, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var serial;
  var srchr;

  @override
  _SaleChallanDeliveryState createState() => _SaleChallanDeliveryState();
}

class _SaleChallanDeliveryState extends State<SaleChallanDelivery> {

  TextEditingController _tempono = new TextEditingController();
  TextEditingController _deliveryman = new TextEditingController();
  TextEditingController _deliverydate = new TextEditingController();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  var challanno = '';
  List _deliverylist = [];
  
  String barcode = '';
  var success = false;
  var message = '';

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fromDate = retconvdate(widget.xfbeg);
    toDate = retconvdate(widget.xfend);

    var curDate = getsystemdate();
    _deliverydate.text = DateFormat("dd-MM-yyyy").format(curDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: getsystemdate(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
        _deliverydate.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  void gotoDriverScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DriverList(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

      var retResult = result;

      print(retResult);
      _deliverylist = result[1];
      result = result[1];
      // branchid = _branchlist[0];
      // print(branchid);

      var selBranch = '';
      for (var ictr = 0; ictr < retResult[0].length; ictr++) {
        if (ictr > 0) {
          selBranch = selBranch + ',';
        }
        selBranch = selBranch + retResult[0][ictr];
      }
      // _branchid.text = branchid.toString();
      _deliveryman.text = selBranch;
  }

  Future<void> _playAudio() async {
    print("dd");
      await _audioPlayer.setAsset('assets/bit/ring.mp3');
      _audioPlayer.play();
   }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  
  Future<bool> scanloadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var id = widget.xid;
    var username = globals.username;
    var tempono = _tempono.text;
    var deliveryman = _deliveryman.text;
    var deliverydate = _deliverydate.text;
    // var fromdate = retconvdate(widget.xfbeg);
    // var todate = retconvdate(widget.xfend);

    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(deliverydate);
    String date = DateFormat("yyyy-MM-dd").format(parsedDate);

    uri = '${globals.cdomain}/api/api_salechallanqrcodescanner?dbname=$db'+
        '&tablename=salechlnmst&id=$barcode&user=$username&cno=$cno' +
        '&drivername=$deliveryman&tempano=$tempono&deldate=$date';

    print(" scanloadData :" + uri);
    var response = await http.get(Uri.parse(uri));

    var jsonData = jsonDecode(response.body);
    jsonData = jsonData['QrcodeScannerdata'];
    var data = jsonData[0]['challanno'].toString();
    print(data);
    challanno = data;

    return true;
  }
  
  Future<bool> scanAlereadyloadData() async {
    String uri = '';
    var cno = globals.companyid;
    var db = globals.dbname;
    var username = globals.username;

    uri = '${globals.cdomain}/api/api_salechallanqrcodescanner?dbname=$db'+
        '&tablename=salechlnmst&id=$barcode&user=$username&cno=$cno&mark=Y';

    print(" scanAlereadyloadData :" + uri);
    var response = await http.get(Uri.parse(uri));
    
    var jsonData = jsonDecode(response.body);
    success = jsonData['Success'];
    message = jsonData['Message'];
    print(success);
    print(message);

    return true;
  }
  
  Future<bool> successBox() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Challan No: $challanno',
      desc: 'Qrcode scan successfully',
      btnOkOnPress: () {
        debugPrint('Dialog confirmed');
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog dismissed from callback $type');
      },
    ).show();
    return true;
  }

  @override
  Widget build(BuildContext context) {      
    return AiBarcodeScanner(
      borderWidth: 7,
      errorColor: Colors.red,
      successColor: Colors.green,
      // borderColor: barcode == '' ? Colors.grey : Colors.green,
      borderColor: Colors.grey,
      onDispose: () {
        debugPrint("Barcode scanner disposed!");
      },
      hideGalleryButton: false,
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      ),
      onDetect: (BarcodeCapture capture) {
        final String? scannedValue = capture.barcodes.first.rawValue;
        debugPrint("Barcode scanned: $scannedValue");
        setState(() async {
          barcode = scannedValue ?? "Unknown";
          if(barcode != ''){
            await scanAlereadyloadData();
            if(success == true){
              _playAudio();
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: Text("Qr Code Scan Successfully"),
                    content: Text('$message'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child: Text("Ok", style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            }else{
              _playAudio();
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: Text(" Delivery Datails!!!"),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _deliverydate,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_month),
                              hintText: 'Delivery Date',
                              labelText: 'Delivery Date',
                            ),
                            onTap: () {
                              _selectDate(context);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a delivery date";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _deliveryman,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Driver name',
                              labelText: 'Driver Name',
                            ),
                            onTap: () {
                              gotoDriverScreen();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter driver name";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _tempono,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.car_crash_outlined),
                              hintText: 'Vehicle no',
                              labelText: 'Vehicle No',
                            ),
                            onTap: () {},
                            onChanged: (value) {
                              _tempono.value = TextEditingValue(
                                text: value.toUpperCase(),
                                selection: _tempono.selection,
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter vehicle no";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                              ),
                              onPressed: () async{
                                if (_formKey.currentState!.validate()) {
                                  await scanloadData();
                                  Navigator.pop(context);
                                  await successBox();
                                }
                              }, 
                              child: Text("Ok", style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            }
          }
        });
      },
      validator: (value) {
        if (value.barcodes.isEmpty) {
          return false;
        }
        return true;
      },
    );
  }
}
