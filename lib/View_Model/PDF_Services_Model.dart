// // import 'dart:io';

// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf_viewer/Services/PDF_Services.dart';
// // import 'package:pdf_viewer/View/PDF_View.dart';
// // import 'package:http/http.dart' as http;

// // class ConversionViewModel extends ChangeNotifier {
// //   final ConversionService _conversionService;

// //   ConversionViewModel(this._conversionService);

// //   Future<void> convertFile(BuildContext context, File file, String targetType,
// //       {Map<String, dynamic>? additionalParams}) async {
// //     try {
// //       final request = ConversionRequest(
// //           file: file,
// //           targetType: targetType,
// //           additionalParams: additionalParams);
// //       final response = await _conversionService.convertFile(request);
// //       _showResultDialog(response.downloadUrl, context);
// //     } catch (e) {
// //       _showErrorDialog('Conversion failed: $e', context);
// //     }
// //   }

// //   void _showResultDialog(String downloadUrl, BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Conversion Successful'),
// //           content: Text(
// //               'The file was successfully converted. What would you like to do next?'),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('Download'),
// //               onPressed: () {
// //                 _downloadFile(downloadUrl, context);
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('View'),
// //               onPressed: () {
// //                 _viewFile(downloadUrl, context);
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   void _showErrorDialog(String message, BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Error'),
// //           content: Text(message),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('OK'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _downloadFile(String url, BuildContext context) async {
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final directory = await getExternalStorageDirectory();
// //         final filePath =
// //             '${directory!.path}/converted_file.${url.split('.').last}';
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('File downloaded to $filePath')),
// //         );
// //       } else {
// //         _showErrorDialog('Failed to download the file.', context);
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Exception while downloading file: $e', context);
// //     }
// //   }

// //   Future<void> _viewFile(String url, BuildContext context) async {
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final directory = await getTemporaryDirectory();
// //         final filePath =
// //             '${directory.path}/converted_file.${url.split('.').last}';
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);

// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
// //         );
// //       } else {
// //         _showErrorDialog('Failed to load the file for viewing.', context);
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Exception while viewing file: $e', context);
// //     }
// //   }
// // }
// //   // _showResultDialog, _showErrorDialog, _downloadFile, _viewFile methods remain the same

// // class ConversionViewModel extends ChangeNotifier {
// //   final ConversionService _conversionService;

// //   ConversionViewModel(this._conversionService);

// //   Future<void> convertFile(BuildContext context, File file, String targetType,
// //       {Map<String, dynamic>? additionalParams}) async {
// //     try {
// //       final request = ConversionRequest(
// //           file: file,
// //           targetType: targetType,
// //           additionalParams: additionalParams);
// //       final response = await _conversionService.convertFile(request);
// //       _showResultDialog(response.downloadUrl, context);
// //     } catch (e) {
// //       _showErrorDialog('Conversion failed: $e', context);
// //     }
// //   }

// //   void _showResultDialog(String downloadUrl, BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Conversion Successful'),
// //           content: Text(
// //               'The file was successfully converted. What would you like to do next?'),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('Download'),
// //               onPressed: () {
// //                 _downloadFile(downloadUrl, context);
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('View'),
// //               onPressed: () {
// //                 _viewFile(downloadUrl, context);
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   void _showErrorDialog(String message, BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Error'),
// //           content: Text(message),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('OK'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _downloadFile(String url, BuildContext context) async {
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final directory = await getExternalStorageDirectory();
// //         final filePath =
// //             '${directory!.path}/converted_file.${url.split('.').last}';
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('File downloaded to $filePath')),
// //         );
// //       } else {
// //         _showErrorDialog('Failed to download the file.', context);
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Exception while downloading file: $e', context);
// //     }
// //   }

// //   Future<void> _viewFile(String url, BuildContext context) async {
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final directory = await getTemporaryDirectory();
// //         final filePath =
// //             '${directory.path}/converted_file.${url.split('.').last}';
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);

// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
// //         );
// //       } else {
// //         _showErrorDialog('Failed to load the file for viewing.', context);
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Exception while viewing file: $e', context);
// //     }
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_viewer/Services/PDF_Services.dart';
// import 'package:pdf_viewer/View/PDF_View.dart';

// // class ConversionViewModel extends ChangeNotifier {
// //   final ConversionService _conversionService;

// //   ConversionViewModel(this._conversionService);

// //   Future<void> convertFile(BuildContext context, File file, String targetType,
// //       {Map<String, dynamic>? additionalParams}) async {
// //     try {
// //       final request = ConversionRequest(
// //           file: file,
// //           targetType: targetType,
// //           additionalParams: additionalParams);
// //       final response = await _conversionService.convertFile(request);

// //       // Ensure that the dialog is shown after the current frame has been rendered
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _showResultDialog(response.downloadUrl, context);
// //       });
// //     } catch (e) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _showErrorDialog('Conversion failed: $e', context);
// //       });
// //     }
// //   }

// //   void _showResultDialog(String downloadUrl, BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Conversion Successful'),
// //           content: Text(
// //               'The file was successfully converted. What would you like to do next?'),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('Download'),
// //               onPressed: () {
// //                 _downloadFile(downloadUrl, context);
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('View'),
// //               onPressed: () {
// //                 _viewFile(downloadUrl, context);
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   void _showErrorDialog(String message, BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Error'),
// //           content: Text(message),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('OK'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _downloadFile(String url, BuildContext context) async {
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final directory = await getExternalStorageDirectory();
// //         final filePath =
// //             '${directory!.path}/converted_file.${url.split('.').last}';
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('File downloaded to $filePath')),
// //         );
// //       } else {
// //         _showErrorDialog('Failed to download the file.', context);
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Exception while downloading file: $e', context);
// //     }
// //   }

// //   Future<void> _viewFile(String url, BuildContext context) async {
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final directory = await getTemporaryDirectory();
// //         final filePath =
// //             '${directory.path}/converted_file.${url.split('.').last}';
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);

// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (context) => PDFView2(path: filePath)),
// //         );
// //       } else {
// //         _showErrorDialog('Failed to load the file for viewing.', context);
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Exception while viewing file: $e', context);
// //     }
// //   }
// // }
// class ConversionViewModel extends ChangeNotifier {
//   final ConversionService _conversionService;

//   ConversionViewModel(this._conversionService);

//   Future<void> convertFile(BuildContext context, File file, String targetType,
//       {Map<String, dynamic>? additionalParams}) async {
//     try {
//       final request = ConversionRequest(
//           file: file,
//           targetType: targetType,
//           additionalParams: additionalParams);
//       final response = await _conversionService.convertFile(request);
//       print(response);
//       if (context.mounted) {
//         print('Dilage box');
//         _showResultDialog(response.downloadUrl, context);
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showErrorDialog('Conversion failed: $e', context);
//       }
//     }
//   }

//   void _showResultDialog(String downloadUrl, BuildContext context) {
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Conversion Successful'),
//             content: Text(
//                 'The file was successfully converted. What would you like to do next?'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('Download'),
//                 onPressed: () {
//                   _downloadFile(downloadUrl, context);
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text('View'),
//                 onPressed: () {
//                   _viewFile(downloadUrl, context);
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _showErrorDialog(String message, BuildContext context) {
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text(message),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   Future<void> _downloadFile(String url, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final directory = await getExternalStorageDirectory();
//         final filePath =
//             '${directory!.path}/converted_file.${url.split('.').last}';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('File downloaded to $filePath')),
//           );
//         }
//       } else {
//         if (context.mounted) {
//           _showErrorDialog('Failed to download the file.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showErrorDialog('Exception while downloading file: $e', context);
//       }
//     }
//   }

//   Future<void> _viewFile(String url, BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final filePath =
//             '${directory.path}/converted_file.${url.split('.').last}';
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
//           _showErrorDialog('Failed to load the file for viewing.', context);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showErrorDialog('Exception while viewing file: $e', context);
//       }
//     }
//   }
// }
