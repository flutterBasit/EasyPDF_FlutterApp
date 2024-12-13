// import 'dart:convert';
// import 'dart:io';

// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_viewer/View/PDF_View.dart';
// import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// class PDF_Services {
//   //function for PDF View
//   static Future<void> PDFviewfunc(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//       );
//     }
//   }

//   // Word View Function
//   static Future<void> WordView(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       final file = File(filePath);
//       final bytes = await file.readAsBytes();
//       String docText = await docxToText(bytes);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(title: Text('Word Document')),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Text(
//                     docText.isNotEmpty ? docText : 'Error loading document'),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> convertDocxToPdf(File docxFile, BuildContext context) async {
//     try {
//       final request =
//           http.MultipartRequest('POST', Uri.parse(AppUrls.DocXToPDF_URL));
//       final docxBytes = await docxFile.readAsBytes();

//       // Add the file to the request
//       request.files.add(http.MultipartFile.fromBytes(
//         'File',
//         docxBytes,
//         filename: docxFile.path.split('/').last,
//         contentType: MediaType('application',
//             'vnd.openxmlformats-officedocument.wordprocessingml.document'),
//       ));

//       // Add any additional fields if needed
//       request.fields['StoreFile'] = 'true';

//       // Send the request
//       final response = await request.send();

//       // Check the response status
//       if (response.statusCode == 200) {
//         final responseBody = await http.Response.fromStream(response);
//         final jsonResponse = json.decode(responseBody.body);

//         // Extract the PDF URL from the JSON response
//         final pdfUrl = jsonResponse['Files'][0]['Url'];
//         _showResultDialog(pdfUrl, context);
//       } else {
//         final responseBody = await http.Response.fromStream(response);
//         _showErrorDialog('Conversion failed: ${responseBody.body}', context);
//       }
//     } catch (e) {
//       _showErrorDialog('Exception: $e', context);
//     }
//   }

//    Future<void> _pickAndConvert(BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['docx'],
//       );

//       if (result != null && result.files.single.path != null) {
//         File file = File(result.files.single.path!);
//         await convertDocxToPdf(file, context);
//       } else {
//         print('No file selected');
//       }
//     } catch (e) {
//       print('Error in _pickAndConvert: $e');
//       _showErrorDialog('Error in _pickAndConvert: $e', context);
//     }
//   }

//   // Show Result Dialog
//   void _showResultDialog(String pdfUrl, BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Conversion Successful'),
//           content: Text(
//               'The DOCX file was successfully converted to PDF. What would you like to do next?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Download'),
//               onPressed: () {
//                 _downloadPdf(pdfUrl, context);
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('View'),
//               onPressed: () {
//                 _viewPdf(pdfUrl, context);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Show Error Dialog
//   void _showErrorDialog(String message, BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Download PDF
//   Future<void> _downloadPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getExternalStorageDirectory();
//         final filePath = '${directory!.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('PDF downloaded to $filePath')),
//         );
//       } else {
//         _showErrorDialog('Failed to download the PDF.', context);
//       }
//     } catch (e) {
//       _showErrorDialog('Exception while downloading PDF: $e', context);
//       print(e.toString());
//     }
//   }

//   // View PDF
//   Future<void> _viewPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         await OpenFile.open(filePath);
//       } else {
//         _showErrorDialog('Failed to load the PDF for viewing.', context);
//       }
//     } catch (e) {
//       _showErrorDialog('Exception while viewing PDF: $e', context);
//       print(e.toString());
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:io';

// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:pdf_viewer/Utility/Utilities.dart';
// import 'package:pdf_viewer/View/PDF_View.dart';
// import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart'; // For MediaType

// class PDF_Services {
//   static Future<void> PDFviewfunc(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//       );
//     }
//   }

//   // Word View Function
//   static Future<void> WordView(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       final file = File(filePath);
//       final bytes = await file.readAsBytes();
//       String docText = await docxToText(bytes);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(title: Text('Word Document')),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Text(
//                     docText.isNotEmpty ? docText : 'Error loading document'),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   // Static pick and convert function
//   static Future<void> pickAndConvert(BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['docx'],
//       );

//       if (result != null && result.files.single.path != null) {
//         File file = File(result.files.single.path!);
//         await convertDocxToPdf(
//             file, context); // Make sure this is static or adjust accordingly
//       } else {
//         print('No file selected');
//       }
//     } catch (e) {
//       print('Error in pickAndConvert: $e');
//       showErrorDialog('Error in pickAndConvert: $e',
//           context); // Make sure this is static or adjust accordingly
//     }
//   }

//   // Static convertDocxToPdf function
//   static Future<void> convertDocxToPdf(
//       File docxFile, BuildContext context) async {
//     try {
//       final request =
//           http.MultipartRequest('POST', Uri.parse(AppUrls.DocXToPDF_URL));
//       final docxBytes = await docxFile.readAsBytes();

//       // Add the file to the request
//       request.files.add(http.MultipartFile.fromBytes(
//         'File',
//         docxBytes,
//         filename: docxFile.path.split('/').last,
//         contentType: MediaType('application',
//             'vnd.openxmlformats-officedocument.wordprocessingml.document'),
//       ));

//       // Add any additional fields if needed
//       request.fields['StoreFile'] = 'true';

//       // Send the request
//       final response = await request.send();

//       // Check the response status
//       if (response.statusCode == 200) {
//         final responseBody = await http.Response.fromStream(response);
//         final jsonResponse = json.decode(responseBody.body);

//         // Extract the PDF URL from the JSON response
//         final pdfUrl = jsonResponse['Files'][0]['Url'];
//         showResultDialog(pdfUrl, context);
//       } else {
//         final responseBody = await http.Response.fromStream(response);
//         if (context.mounted) {
//           showErrorDialog('Conversion failed: ${responseBody.body}', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception: $e', context);
//       }
//     }
//   }

//   // Static showResultDialog function
//   static void showResultDialog(String pdfUrl, BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF3D0000), // Set background color of dialog
//           title: Text(
//             'Conversion Successful',
//             style: TextStyle(color: Colors.white), // Set title text color
//           ),
//           content: Text(
//             'The DOCX file was successfully converted to PDF. What would you like to do next?',
//             style: TextStyle(color: Colors.white), // Set content text color
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Download'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white, // Text color
//                 backgroundColor: Color(0xFFFF0000), // Button color
//               ),
//               onPressed: () {
//                 downloadPdf(pdfUrl, context);
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('View'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white, // Text color
//                 backgroundColor: Color(0xFFFF0000), // Button color
//               ),
//               onPressed: () {
//                 viewPdf(pdfUrl, context);
//                 // Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   static void showErrorDialog(String message, BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF3D0000), // Set background color of dialog
//           title: Text(
//             'Error',
//             style: TextStyle(color: Colors.white), // Set title text color
//           ),
//           content: Text(
//             message,
//             style: TextStyle(color: Colors.white), // Set content text color
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white, // Text color
//                 backgroundColor: Color(0xFFFF0000), // Button color
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Static downloadPdf function
//   static Future<void> downloadPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getExternalStorageDirectory();
//         final filePath = '${directory!.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('PDF downloaded to $filePath')),
//         // );
//         Utitlities.FlutterSnackBar(context, "File Downloaded at $filePath");
//       } else {
//         if (context.mounted) {
//           showErrorDialog('Failed to download the PDF.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception while downloading PDF: $e', context);
//       }
//     }
//   }

//   // Static viewPdf function
//   static Future<void> viewPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         if (context.mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//           );
//         }
//       } else {
//         if (context.mounted) {
//           showErrorDialog('Failed to load the PDF for viewing.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception while viewing PDF: $e', context);
//       }
//     }
//   }
// }
// import 'dart:convert';
// import 'dart:io';

// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:pdf_viewer/Utility/Utilities.dart';
// import 'package:pdf_viewer/View/PDF_View.dart';
// import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart'; // For MediaType
// import 'package:flutter/services.dart';

// class PDF_Services {
//   static Future<void> PDFviewfunc(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//       );
//     }
//   }

//   // Word View Function
//   static Future<void> WordView(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       final file = File(filePath);
//       final bytes = await file.readAsBytes();
//       String docText = await docxToText(bytes);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(title: const Text('Word Document')),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Text(
//                     docText.isNotEmpty ? docText : 'Error loading document'),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   static const platform = MethodChannel('com.example.pdf_viewer/open_folder');

//   static Future<void> openFolder(String path) async {
//     try {
//       await platform.invokeMethod('openFolder', {'path': path});
//     } on PlatformException catch (e) {
//       print("Failed to open folder: '${e.message}'.");
//     }
//   }

//   // Static pick and convert function
//   static Future<void> pickAndConvert(BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['docx'],
//       );

//       if (result != null && result.files.single.path != null) {
//         File file = File(result.files.single.path!);
//         await convertDocxToPdf(
//             file, context); // Make sure this is static or adjust accordingly
//       } else {
//         print('No file selected');
//       }
//     } catch (e) {
//       print('Error in pickAndConvert: $e');
//       showErrorDialog('Error in pickAndConvert: $e',
//           context); // Make sure this is static or adjust accordingly
//     }
//   }

//   // Static convertDocxToPdf function
//   static Future<void> convertDocxToPdf(
//       File docxFile, BuildContext context) async {
//     try {
//       final request =
//           http.MultipartRequest('POST', Uri.parse(AppUrls.DocXToPDF_URL));
//       final docxBytes = await docxFile.readAsBytes();

//       // Add the file to the request
//       request.files.add(http.MultipartFile.fromBytes(
//         'File',
//         docxBytes,
//         filename: docxFile.path.split('/').last,
//         contentType: MediaType('application',
//             'vnd.openxmlformats-officedocument.wordprocessingml.document'),
//       ));

//       // Add any additional fields if needed
//       request.fields['StoreFile'] = 'true';

//       // Send the request
//       final response = await request.send();

//       // Check the response status
//       if (response.statusCode == 200) {
//         final responseBody = await http.Response.fromStream(response);
//         final jsonResponse = json.decode(responseBody.body);

//         // Extract the PDF URL from the JSON response
//         final pdfUrl = jsonResponse['Files'][0]['Url'];
//         showResultBottomSheet(pdfUrl, context);
//       } else {
//         final responseBody = await http.Response.fromStream(response);
//         if (context.mounted) {
//           showErrorDialog('Conversion failed: ${responseBody.body}', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception: $e', context);
//       }
//     }
//   }

//   // Static showResultBottomSheet function
//   static void showResultBottomSheet(String pdfUrl, BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor:
//           const Color(0xFF3D0000), // Set background color of BottomSheet
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const Text(
//                 'Conversion Successful',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'The DOCX file was successfully converted to PDF. What would you like to do next?',
//                 style: TextStyle(color: Colors.white),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF0000),
//                     ),
//                     onPressed: () {
//                       downloadPdf(pdfUrl, context);
//                       Navigator.of(context).pop();
//                       openFolder(pdfUrl);
//                     },
//                     child: const Text('Download',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF0000),
//                     ),
//                     onPressed: () {
//                       viewPdf(pdfUrl, context);
//                     },
//                     child: const Text('View',
//                         style: const TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   static void showErrorDialog(String message, BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor:
//               const Color(0xFF3D0000), // Set background color of dialog
//           title: const Text(
//             'Error',
//             style: TextStyle(color: Colors.white), // Set title text color
//           ),
//           content: Text(
//             message,
//             style:
//                 const TextStyle(color: Colors.white), // Set content text color
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white, // Text color
//                 backgroundColor: const Color(0xFFFF0000), // Button color
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Static downloadPdf function
//   static Future<void> downloadPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getExternalStorageDirectory();
//         final filePath = '${directory!.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         Utilities.FlutterSnackBar(context, "File Downloaded at $filePath");
//       } else {
//         if (context.mounted) {
//           showErrorDialog('Failed to download the PDF.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception while downloading PDF: $e', context);
//       }
//     }
//   }

//   // Static viewPdf function
//   static Future<void> viewPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         if (context.mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//           );
//         }
//       } else {
//         if (context.mounted) {
//           showErrorDialog('Failed to load the PDF for viewing.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception while viewing PDF: $e', context);
//       }
//     }
//   }
// }
// import 'dart:convert';
// import 'dart:io';

// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:pdf_viewer/Utility/Utilities.dart';
// import 'package:pdf_viewer/View/PDF_View.dart';
// import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart'; // For MediaType
// import 'package:flutter/services.dart';

// class PDF_Services {
//   static Future<void> PDFviewfunc(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//       );
//     }
//   }

//   // Word View Function
//   static Future<void> WordView(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       final file = File(filePath);
//       final bytes = await file.readAsBytes();
//       String docText = await docxToText(bytes);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(title: const Text('Word Document')),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Text(
//                     docText.isNotEmpty ? docText : 'Error loading document'),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   static const platform = MethodChannel('com.example.pdf_viewer/open_folder');

//   static Future<void> openFolder(String path) async {
//     try {
//       await platform.invokeMethod('openFolder', {'path': path});
//     } on PlatformException catch (e) {
//       print("Failed to open folder: '${e.message}'.");
//     }
//   }

//   // Static pick and convert function
//   static Future<void> pickAndConvert(BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['docx'],
//       );

//       if (result != null && result.files.single.path != null) {
//         File file = File(result.files.single.path!);

//         await convertDocxToPdf(
//             file, context);
//              // Make sure this is static or adjust accordingly

//       } else {
//         print('No file selected');
//       }
//     } catch (e) {
//       print('Error in pickAndConvert: $e');
//       showErrorDialog('Error in pickAndConvert: $e',
//           context); // Make sure this is static or adjust accordingly
//     }
//   }

//   // Static convertDocxToPdf function
//   static Future<void> convertDocxToPdf(
//       File docxFile, BuildContext context) async {
//     try {
//       final request =
//           http.MultipartRequest('POST', Uri.parse(AppUrls.DocXToPDF_URL));
//       final docxBytes = await docxFile.readAsBytes();

//       // Add the file to the request
//       request.files.add(http.MultipartFile.fromBytes(
//         'File',
//         docxBytes,
//         filename: docxFile.path.split('/').last,
//         contentType: MediaType('application',
//             'vnd.openxmlformats-officedocument.wordprocessingml.document'),
//       ));

//       // Add any additional fields if needed
//       request.fields['StoreFile'] = 'true';

//       // Send the request
//       final response = await request.send();

//       // Check the response status
//       if (response.statusCode == 200) {
//         final responseBody = await http.Response.fromStream(response);
//         final jsonResponse = json.decode(responseBody.body);

//         // Extract the PDF URL from the JSON response
//         final pdfUrl = jsonResponse['Files'][0]['Url'];
//         showResultBottomSheet(pdfUrl, context);
//       } else {
//         final responseBody = await http.Response.fromStream(response);
//         if (context.mounted) {
//           showErrorDialog('Conversion failed: ${responseBody.body}', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception: $e', context);
//       }
//     }
//   }

//   // Static showResultBottomSheet function
//   static void showResultBottomSheet(String pdfUrl, BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor:
//           const Color(0xFF3D0000), // Set background color of BottomSheet
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const Text(
//                 'Conversion Successful',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'The DOCX file was successfully converted to PDF. What would you like to do next?',
//                 style: TextStyle(color: Colors.white),
//               ),
//               const SizedBox(height: 100),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF0000),
//                     ),
//                     onPressed: () async {
//                       final directory = await getExternalStorageDirectory();
//                       final filePath = '${directory!.path}/converted_file.pdf';
//                       await downloadPdf(pdfUrl, filePath, context);
//                       Navigator.of(context).pop();
//                       openFolder(filePath);
//                     },
//                     child: const Text('Download',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF0000),
//                     ),
//                     onPressed: () {
//                       viewPdf(pdfUrl, context);
//                     },
//                     child: const Text('View',
//                         style: const TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   static void showErrorDialog(String message, BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor:
//               const Color(0xFF3D0000), // Set background color of dialog
//           title: const Text(
//             'Error',
//             style: TextStyle(color: Colors.white), // Set title text color
//           ),
//           content: Text(
//             message,
//             style:
//                 const TextStyle(color: Colors.white), // Set content text color
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white, // Text color
//                 backgroundColor: const Color(0xFFFF0000), // Button color
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Static downloadPdf function
//   static Future<void> downloadPdf(
//       String pdfUrl, String filePath, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         Utilities.FlutterSnackBar(context, "File Downloaded at $filePath");
//       } else {
//         if (context.mounted) {
//           showErrorDialog('Failed to download the PDF.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception while downloading PDF: $e', context);
//       }
//     }
//   }

//   // Static viewPdf function
//   static Future<void> viewPdf(String pdfUrl, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         if (context.mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
//           );
//         }
//       } else {
//         if (context.mounted) {
//           showErrorDialog('Failed to fetch the PDF.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showErrorDialog('Exception while fetching PDF: $e', context);
//       }
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer/Utility/Utilities.dart';
import 'package:pdf_viewer/View/PDF_View.dart';
import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart';

class PDF_Services {
  static Future<void> PDFviewfunc(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
      );
    }
  }

  // Word View Function
  static Future<void> WordView(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      String docText = await docxToText(bytes);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Word Document')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                    docText.isNotEmpty ? docText : 'Error loading document'),
              ),
            ),
          ),
        ),
      );
    }
  }

  static Future<void> pickAndConvert(BuildContext context) async {
    try {
      // Pick the file using FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
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

        // Convert the DOCX file to PDF
        await convertDocxToPdf(file, context);
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error in pickAndConvert: $e');
      showErrorDialog('Error in pickAndConvert: $e', context);
    }
  }

  static Future<void> convertDocxToPdf(
      File docxFile, BuildContext context) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(AppUrls.DocXToPDF_URL));
      final docxBytes = await docxFile.readAsBytes();

      request.files.add(http.MultipartFile.fromBytes(
        'File',
        docxBytes,
        filename: docxFile.path.split('/').last,
        contentType: MediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document'),
      ));

      request.fields['StoreFile'] = 'true';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final jsonResponse = json.decode(responseBody.body);

        final pdfUrl = jsonResponse['Files'][0]['Url'];

        // Close the CircularProgressIndicator BottomSheet
        Navigator.of(context).pop();

        showResultBottomSheet(pdfUrl, context);
      } else {
        final responseBody = await http.Response.fromStream(response);
        if (context.mounted) {
          Navigator.of(context).pop(); // Close CircularProgressIndicator
          showErrorDialog('Conversion failed: ${responseBody.body}', context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close CircularProgressIndicator
        showErrorDialog('Exception: $e', context);
      }
    }
  }

  // static void showResultBottomSheet(String pdfUrl, BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 200,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Conversion Successful!',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 await downloadFile(pdfUrl, context);
  //               },
  //               child: const Text('Download PDF'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 await viewFile(pdfUrl, context);
  //               },
  //               child: const Text('View PDF'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  static void showResultBottomSheet(String pdfUrl, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF3D0000), // Set background color of BottomSheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height:
              300, // Set a fixed height or use MediaQuery for dynamic height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Conversion Successful!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'The PDF file was successfully converted. What would you like to do next?',
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
                    onPressed: () async {
                      await downloadFile(pdfUrl, context);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                    ),
                    onPressed: () async {
                      await viewFile(pdfUrl, context);
                    },
                    child: const Text(
                      'View',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> downloadFile(String url, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/converted.pdf';
      final file = File(filePath);

      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);

      Utilities.FlutterSnackBar(context, "File Downloaded at $filePath");
    } catch (e) {
      showErrorDialog('Failed to download file: $e', context);
    }
  }

  static Future<void> viewFile(String url, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/converted.pdf';
      final file = File(filePath);

      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
        );
      }

// await OpenFile.open(file.path);
    } catch (e) {
      showErrorDialog('Failed to open file: $e', context);
    }
  }

  static void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
