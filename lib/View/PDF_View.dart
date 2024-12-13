import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_viewer/Utility/Utilities.dart';

class PDFView2 extends StatefulWidget {
  String path;
  PDFView2({super.key, required this.path});

  @override
  State<PDFView2> createState() => _PDFView2State();
}

class _PDFView2State extends State<PDFView2> {
  late PDFViewController _pdfViewController;
  int _totalPages = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easy PDF'),
      ),
      body: PDFView(
        filePath: widget.path,
        // enableSwipe: true, // Enable swipe gestures
        // swipeHorizontal: true,
        // Allow horizontal swiping
        onPageError: (page, e) {
          // Handle errors here
          Utilities.FlutterSnackBar(context, e.toString());
        },
        onPageChanged: (page, total) {
          // Handle page changes here
          //  Utitlities.FlutterSnackBar(context, total.toString());
        },
        onRender: (_pages) {
          // Called when the PDF is rendered
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // Save the controller for future use, if needed
          _pdfViewController = pdfViewController;
          _pdfViewController.getPageCount().then((count) {
            setState(() {
              _totalPages = count!;
            });
          });
        },
      ),
    );
  }
}
