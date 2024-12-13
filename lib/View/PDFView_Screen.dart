// import 'dart:convert';
// import 'dart:io';

// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_viewer/View/PDF_View.dart';
// import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart';
// import 'package:pdf_viewer/resources/Components/componets.dart';
// import 'package:pdf_viewer/resources/Constants/Constants.dart';
// import 'package:http/http.dart' as http;

// class PDFViewScreen extends StatefulWidget {
//   const PDFViewScreen({super.key});

//   @override
//   State<PDFViewScreen> createState() => _PDFViewScreenState();
// }

// class _PDFViewScreenState extends State<PDFViewScreen> {
//   PDFviewfunc() async {
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

//   WordView() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path;
//       final file = File(filePath!);
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
//                   scrollDirection: Axis.vertical,
//                   child: Text(docText ?? 'Error loading document')),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   //Docx To PDF
//   Future<void> convertDocxToPdf(File docxFile) async {
//     final progress = ProgressHUD.of(context);
//     progress?.show();

//     try {
//       final request =
//           http.MultipartRequest('POST', Uri.parse(AppUrls.DocXToPDF_URL));
//       final docxBytes = await docxFile.readAsBytes();
//       final base64Docx = base64Encode(docxBytes);

//       request.fields['StoreFile'] = 'true';
//       request.files.add(http.MultipartFile.fromString('File', base64Docx,
//           filename: docxFile.path.split('/').last));

//       final response = await request.send();
//       final responseBody = await http.Response.fromStream(response);

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(responseBody.body);
//         final pdfUrl = jsonResponse['Files'][0]['Url'];

//         progress?.dismiss();
//         _showResultDialog(pdfUrl);
//       } else {
//         progress?.dismiss();
//         _showErrorDialog('Conversion failed: ${responseBody.body}');
//       }
//     } catch (e) {
//       progress?.dismiss();
//       _showErrorDialog('Exception: $e');
//     }
//   }

//   Future<void> _pickAndConvert() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['docx'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       await convertDocxToPdf(file);
//     }
//   }

//   void _showResultDialog(String pdfUrl) {
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
//                 _downloadPdf(pdfUrl);
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('View'),
//               onPressed: () {
//                 _viewPdf(pdfUrl);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showErrorDialog(String message) {
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

//   Future<void> _downloadPdf(String pdfUrl) async {
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
//         _showErrorDialog('Failed to download the PDF.');
//       }
//     } catch (e) {
//       _showErrorDialog('Exception while downloading PDF: $e');
//     }
//   }

//   Future<void> _viewPdf(String pdfUrl) async {
//     try {
//       final response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/converted_file.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         await OpenFile.open(filePath);
//       } else {
//         _showErrorDialog('Failed to load the PDF for viewing.');
//       }
//     } catch (e) {
//       _showErrorDialog('Exception while viewing PDF: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height * 1;
//     final width = MediaQuery.of(context).size.width * 1;
//     return SafeArea(
//       child: Scaffold(
//           body: ProgressHUD(
//               child: Builder(
//         builder: (context) => Container(
//           child: Stack(
//             children: [
//               Container(
//                 height: height * 0.25,
//                 width: width,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: NetworkImage(
//                             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOTZ3JnnnqPJJU1Lg7t96peKfGV3BOlNxmG8US5fSbMPKNz0Wc1bC9VRsQuy16B6-L58A&usqp=CAU'),
//                         fit: BoxFit.cover),
//                     color: Colors.redAccent.shade200,
//                     borderRadius: BorderRadius.vertical(
//                         bottom: Radius.elliptical(width, 105))),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 80, left: 10),
//                 child: Column(
//                   children: [
//                     Text(
//                       "EASY PDF",
//                       style: TextStyle(
//                           fontSize: 25,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 300, left: 140),
//                 child: Column(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         PDFviewfunc();
//                       },
//                       child: ReUsable_Container(
//                         height: height * 0.06,
//                         width: width * 0.38,
//                         LinearGradient_Color1: Colors.red,
//                         LinearGradient_Color2: Colors.redAccent,
//                         borderColor: Colors.black,
//                         borderWidth: 2,
//                         borderRadius: 20,
//                         child: const Center(
//                           child: Text(
//                             'PDF View',
//                             style: Constants.ButtonStyle,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         WordView();
//                       },
//                       child: ReUsable_Container(
//                         height: height * 0.06,
//                         width: width * 0.38,
//                         LinearGradient_Color1: Colors.red,
//                         LinearGradient_Color2: Colors.blueAccent,
//                         borderColor: Colors.black,
//                         borderWidth: 2,
//                         borderRadius: 20,
//                         child: const Center(
//                           child: Text(
//                             'DOC View',
//                             style: Constants.ButtonStyle,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         _pickAndConvert();
//                       },
//                       child: ReUsable_Container(
//                         height: height * 0.06,
//                         width: width * 0.38,
//                         LinearGradient_Color1: Colors.red,
//                         LinearGradient_Color2: Colors.blueAccent,
//                         borderColor: Colors.black,
//                         borderWidth: 2,
//                         borderRadius: 20,
//                         child: Center(
//                           child: Text(
//                             'DOCx to PDF',
//                             style: Constants.ButtonStyle,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ))),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
//import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf_viewer/Services/DOCx_Services.dart';
import 'package:pdf_viewer/Services/PDF_Services.dart';
import 'package:pdf_viewer/View/CamScanner.dart';
import 'package:pdf_viewer/View/PDF_View.dart';
import 'package:pdf_viewer/View_Model/PDF_Services_Model.dart';
import 'package:pdf_viewer/resources/App_Urls/EndPoints_Urls.dart';
import 'package:pdf_viewer/resources/Components/componets.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pdf_viewer/resources/Constants/Constants.dart'; // For MediaType

class PDFViewScreen extends StatefulWidget {
  const PDFViewScreen({super.key});

  @override
  State<PDFViewScreen> createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff190207),
        body: Stack(
          children: [
            Container(
              height: height * 0.25,
              width: width,
              decoration: BoxDecoration(
                // image: const DecorationImage(
                //   image: NetworkImage(
                //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOTZ3JnnnqPJJU1Lg7t96peKfGV3BOlNxmG8US5fSbMPKNz0Wc1bC9VRsQuy16B6-L58A&usqp=CAU'),
                //   fit: BoxFit.cover,
                // ),
                color: const Color(0xff3D0000),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(width * 0.5, 110)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50, left: 120),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.s,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "EASY PDF",
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 60,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 250, left: 18),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            PDF_Services.PDFviewfunc(context);
                          },
                          child: ReUsable_Container(
                            height: height * 0.16,
                            width: width * 0.38,
                            borderColor: Colors.white,
                            borderWidth: 1,
                            borderRadius: 20,
                            LinearGradient_Color1: const Color(0xff9D0B28),
                            LinearGradient_Color2: const Color(0xff9D0B28),
                            child: const Center(
                              child: Text(
                                'PDF View',
                                style: Constants.ButtonStyle2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          width: width * 0.15, // Adjust height as needed
                          child: const VerticalDivider(
                            thickness: 2,
                            color: Colors.white54,
                          ),
                        ),
                        //SizedBox(width: width * 0.15),
                        InkWell(
                          onTap: () {
                            PDF_Services.WordView(context);
                          },
                          child: ReUsable_Container(
                            height: height * 0.16,
                            width: width * 0.38,
                            borderColor: Colors.white38,
                            borderWidth: 2,
                            borderRadius: 20,
                            LinearGradient_Color1: const Color(0xff9D0B28),
                            LinearGradient_Color2: const Color(0xff9D0B28),
                            child: const Center(
                              child: Text(
                                'DOCx View',
                                style: Constants.ButtonStyle2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: height * 0.001),
                  const SizedBox(
                    width: 350,
                    height: 50,
                    child: Divider(
                      thickness: 2,
                      color: Colors.white54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 18),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            DOCxServices.pickAndConvert(context);
                          },
                          child: ReUsable_Container(
                            height: height * 0.16,
                            width: width * 0.38,
                            borderColor: Colors.white38,
                            borderWidth: 2,
                            borderRadius: 20,
                            LinearGradient_Color1: const Color(0xff9D0B28),
                            LinearGradient_Color2: const Color(0xff9D0B28),
                            child: const Center(
                              child: Text(
                                'Convert \n   PDF \n     to \n   DOCx',
                                style: Constants.ButtonStyle2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          width: width * 0.15, // Adjust height as needed
                          child: const VerticalDivider(
                            thickness: 2,
                            color: Colors.white54,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            PDF_Services.pickAndConvert(context);
                          },
                          child: ReUsable_Container(
                            height: height * 0.16,
                            width: width * 0.38,
                            borderColor: Colors.white38,
                            borderWidth: 2,
                            borderRadius: 20,
                            LinearGradient_Color1: const Color(0xff9D0B28),
                            LinearGradient_Color2: const Color(0xff9D0B28),
                            child: const Center(
                              child: Text(
                                'Convert \n  DOCx \n     to \n   PDF',
                                style: Constants.ButtonStyle2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 350,
                    height: 50,
                    child: Divider(
                      thickness: 2,
                      color: Colors.white54,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      //PDF_Services.pickAndConvert(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanDocument()));
                    },
                    child: ReUsable_Container(
                      height: height * 0.16,
                      width: width * 0.38,
                      borderColor: Colors.white38,
                      borderWidth: 2,
                      borderRadius: 20,
                      LinearGradient_Color1: const Color(0xff9D0B28),
                      LinearGradient_Color2: const Color(0xff9D0B28),
                      child: const Center(
                        child: Text(
                          'Page Scanner',
                          style: Constants.ButtonStyle2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
