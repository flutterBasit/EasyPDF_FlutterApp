import 'dart:convert';
import 'dart:io';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer/Utility/Utilities.dart';
import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart';

class DOCxServices {
  // Pick and convert PDF to DOCX
  static Future<void> pickAndConvert(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

// Show CircularProgressIndicator in a BottomSheet
        showModalBottomSheet(
          backgroundColor: const Color(0xFF3D0000),
          context: context,
          isDismissible: false,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Converting, please wait...",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
            );
          },
        );

        await convertPdfToDocx(file, context);
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error in pickAndConvert: $e');
      if (context.mounted) {
        showErrorDialog('Error picking file: $e', context);
      }
    }
  }

  // Convert PDF to DOCX
  static Future<void> convertPdfToDocx(
      File pdfFile, BuildContext context) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(AppUrls.PDFToDocX_URL));
      final pdfBytes = await pdfFile.readAsBytes();

      request.files.add(http.MultipartFile.fromBytes(
        'File',
        pdfBytes,
        filename: pdfFile.path.split('/').last,
        contentType: MediaType('application', 'pdf'),
      ));

      request.fields['StoreFile'] = 'true';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final jsonResponse = json.decode(responseBody.body);
        final docxUrl = jsonResponse['Files'][0]['Url'];

        if (context.mounted) {
          // Close the CircularProgressIndicator BottomSheet
          Navigator.of(context).pop();
          showResultBottomSheet(docxUrl, context);
        }
      } else {
        final responseBody = await http.Response.fromStream(response);
        if (context.mounted) {
          // Close the CircularProgressIndicator BottomSheet
          Navigator.of(context).pop();
          showErrorDialog('Conversion failed: ${responseBody.body}', context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Close the CircularProgressIndicator BottomSheet
        Navigator.of(context).pop();
        showErrorDialog('Exception: $e', context);
      }
    }
  }

  // Show result bottom sheet
  // static void showResultBottomSheet(String docxUrl, BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Text(
  //               'Conversion Successful',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 10),
  //             Text(
  //                 'The PDF file was successfully converted to DOCX. What would you like to do next?'),
  //             SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 downloadDocx(docxUrl, context);
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Download'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 viewDocx(docxUrl, context);
  //               },
  //               child: Text('View'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  static void showResultBottomSheet(String docxUrl, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF3D0000), // Set background color of BottomSheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Conversion Successful',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'The DOCX file was successfully converted to PDF. What would you like to do next?',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                    ),
                    onPressed: () {
                      downloadDocx(docxUrl, context);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Download',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                    ),
                    onPressed: () {
                      viewDocx(docxUrl, context);
                    },
                    child: const Text('View',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Error dialog
  static void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Download DOCX file
  static Future<void> downloadDocx(String docxUrl, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(docxUrl));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/converted_file.docx';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // ignore: use_build_context_synchronously
        Utilities.FlutterSnackBar(context, "File Downloaded at $filePath");
      } else {
        if (context.mounted) {
          showErrorDialog('Failed to download the DOCX.', context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorDialog('Exception while downloading DOCX: $e', context);
      }
    }
  }

  // View DOCX file
  static Future<void> viewDocx(String docxUrl, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(docxUrl));
      if (response.statusCode == 200) {
        final docxBytes = response.bodyBytes;
        final docxText = await docxToText(docxBytes);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Word Document')),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      docxText.isNotEmpty ? docxText : 'Error loading document',
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      } else {
        showErrorDialog('Failed to load the DOCX for viewing.', context);
      }
    } catch (e) {
      showErrorDialog('Exception while viewing DOCX: $e', context);
    }
  }
}
