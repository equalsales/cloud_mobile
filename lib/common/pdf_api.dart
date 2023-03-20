import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    //savePdf(pdf);

    //final file2 = File('test.pdf');
    //await file2.writeAsBytesSync(pdf.save());
    //return file2;

    final bytes = await pdf.save();
    String path = '';
    if (kIsWeb) {
      //path = "/assets";
    } else {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }

    final file = File('${path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  Future savePdf(pdf) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/example.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  // savePDF() async {
  //   Uint8List pdfInBytes = await pdf.save();
  //   final blob = html.Blob([pdfInBytes], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   anchor = html.document.createElement('a') as html.AnchorElement
  //     ..href = url
  //     ..style.display = 'none'
  //     ..download = 'pdf.pdf';
  //   html.document.body.children.add(anchor);
  // }
}
