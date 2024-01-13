import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../common/global.dart' as globals;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:myfirstapp/globals.dart' as globals;
import 'package:share_extend/share_extend.dart';

class PdfViewerPagePrint extends StatefulWidget {
  PdfViewerPagePrint(
      {Key? mykey,
      companyid,
      companyname,
      fbeg,
      fend,
      id,
      cPW,
      formatid,
      printid})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xid = id;
    xcPW = cPW;
    xformatid = formatid;
    xprintid = printid;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xcPW;
  var xformatid;
  var xprintid;
  var orderno;
  var orderchr;
  double printid1 = 0;
  double formatid2 = 0;

  @override
  _PdfViewerPagePrintState createState() => _PdfViewerPagePrintState();
}

class _PdfViewerPagePrintState extends State<PdfViewerPagePrint> {
  late File Pfile;
  bool isLoading = false;

  Future<void> loadNetwork() async {
    setState(() {
      //setprintformet();
      isLoading = true;
    });
    var companyid = globals.companyid;
    var id = widget.xid;
    var formatid = widget.xformatid;
    var printid = widget.xprintid;

    // var url =
    //     'https://vansh.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=10&printid=1&call=1&mobile=&email=&noofcopy=1&cWAApi=&cEmail=&sendwhatsapp=PARTY&nemailtemplate=0&cno=$companyid';
    var url =
        'https://looms.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=$formatid&printid=$printid&call=1&mobile=&email=&noofcopy=1&cWAApi=&sendwhatsapp=&cno=$companyid';
    //print(url);
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });
    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  //   Future<bool> setprintformet() async {
  //   var companyid = widget.xcompanyid;
  //   var db = globals.dbname;
  //   var msttable = widget.xmsttable;
  //   var printformet = widget.xformet;
  //   String uri = '';
  //   uri =
  //       "https://www.looms.equalsoftlink.com/api/api_comprintformat?dbname=$db&cno=$companyid&msttable=$msttable&printformet=$printformet";
  //   var response = await http.get(Uri.parse(uri));
  //   print(uri);
  //   var jsonData = jsonDecode(response.body);
  //   jsonData = jsonData['Data'];
  //   jsonData = jsonData[0];

  //   formatid = jsonData['formatid'].toString();
  //   printid = jsonData['printid'].toString();

  //   return true;
  // }

  Future<void> SendWhatAppnwork() async {
    setState(() {
      //setprintformet();
      isLoading = true;
    });
    // print("jatin"+formatid.toString());
    var companyid = globals.companyid;
    var id = widget.xid;
    var formatid = widget.xformatid;
    var printid = widget.xprintid;
    // var url =
    //     'https://vansh.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=10&printid=1&call=1&mobile=&email=&noofcopy=1&cWAApi=&cEmail=&sendwhatsapp=PARTY&nemailtemplate=0&cno=$companyid';
    var url =
        'https://looms.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=$formatid&printid=$printid&call=2&mobile=&email=&noofcopy=1&cWAApi=639b127a08175a3ef38f4367&sendwhatsapp=BOTH&cno=$companyid';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });
    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    var cPW = widget.xcPW;
    if (cPW == "PDF") {
      loadNetwork();
    } else {
      SendWhatAppnwork();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF Viewer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ShareExtend.share(Pfile.path, "file");
        },
        child: const Icon(Icons.picture_as_pdf_sharp),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child: PDFView(
                  filePath: Pfile.path,
                ),
              ),
            ),
    );
  }
}
