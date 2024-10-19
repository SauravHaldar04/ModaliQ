import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

Future<void> viewPdf(File file, BuildContext context) async {
  String path = file.path;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: PDFView(
          filePath: path,
          pdfData: file.readAsBytesSync(),
        ),
      ),
    ),
  );
}
