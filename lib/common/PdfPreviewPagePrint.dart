import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:myfirstapp/globals.dart' as globals;
import 'package:share_extend/share_extend.dart';
class PdfViewerPagePrint extends StatefulWidget {
  PdfViewerPagePrint({Key? mykey, companyid, companyname, fbeg, fend, id,cPW})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xid = id;
    xcPW=cPW;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xid;
  var xcPW;
  var orderno;
  var orderchr;
  double tottaka = 0;
  double totmtrs = 0;

  @override
  _PdfViewerPagePrintState createState() => _PdfViewerPagePrintState();
}

class _PdfViewerPagePrintState extends State<PdfViewerPagePrint> {
  late File Pfile;
  bool isLoading = false;

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    //var companyid = globals.companyid;
    var id = widget.xid;
    // var url = 
    //     'https://vansh.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=10&printid=1&call=1&mobile=&email=&noofcopy=1&cWAApi=&cEmail=&sendwhatsapp=PARTY&nemailtemplate=0&cno=$companyid';
    var url = 'https://looms.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=55&printid=49&call=1&mobile=&email=&noofcopy=1&cWAApi=&sendwhatsapp=&cno=2';
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



Future<void> SendWhatAppnwork() async {
    setState(() {
      isLoading = true;
    });
    //var companyid = globals.companyid;
    var id = widget.xid;
    // var url = 
    //     'https://vansh.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=10&printid=1&call=1&mobile=&email=&noofcopy=1&cWAApi=&cEmail=&sendwhatsapp=PARTY&nemailtemplate=0&cno=$companyid';
    var url ='https://looms.equalsoftlink.com/printsaleorderdf/$id?fromserial=0&toserial=0&srchr=&formatid=55&printid=49&call=2&mobile=&email=&noofcopy=1&cWAApi=639b127a08175a3ef38f4367&sendwhatsapp=BOTH&cno=2';
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
    if (cPW == "PDF")
    {
      loadNetwork();
    }
    else
    {
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
