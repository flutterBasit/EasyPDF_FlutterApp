// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:custom_image_crop/custom_image_crop.dart';

// class CroppingImage extends StatefulWidget {
//   const CroppingImage({super.key});

//   @override
//   State<CroppingImage> createState() => _CroppingImageState();
// }

// class _CroppingImageState extends State<CroppingImage> {
//   late CustomImageCropController controller;
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;

//   @override
//   void initState() {
//     super.initState();
//     controller = CustomImageCropController();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = pickedFile;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking image: $e")),
//       );
//     }
//   }

//   Future<Uint8List?> _convertMemoryImageToUint8List(
//       MemoryImage memoryImage) async {
//     final Completer<ui.Image> completer = Completer();
//     final ImageStream stream = memoryImage.resolve(ImageConfiguration());
//     stream.addListener(
//         ImageStreamListener((ImageInfo info, bool synchronousCall) {
//       completer.complete(info.image);
//     }));

//     final ui.Image image = await completer.future;
//     final ByteData? byteData =
//         await image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData?.buffer.asUint8List();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Crop'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.photo_library),
//             onPressed: () => _pickImage(ImageSource.gallery),
//           ),
//           IconButton(
//             icon: Icon(Icons.camera_alt),
//             onPressed: () => _pickImage(ImageSource.camera),
//           ),
//         ],
//       ),
//       body: _imageFile == null
//           ? Center(child: Text('No Image Selected'))
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: CustomImageCrop(
//                     cropController: controller,
//                     image: FileImage(File(_imageFile!.path)),
//                     overlayColor: Colors.black.withOpacity(0.5),
//                     backgroundColor: Colors.white,
//                     shape: CustomCropShape.Ratio, // Custom shape
//                     imageFit: CustomImageFit.fitCropSpace,
//                     cropPercentage: 0.8,
//                     drawPath: DottedCropPathPainter.drawPath,
//                     canRotate: true,
//                     canScale: true,
//                     canMove: true,
//                     clipShapeOnCrop: true,
//                     ratio: Ratio(width: 4, height: 3), // Aspect ratio
//                     borderRadius: 10,
//                     imagePaintDuringCrop: Paint()
//                       ..color = Colors.grey.withOpacity(0.5)
//                       ..style = PaintingStyle.fill,
//                     forceInsideCropArea: true,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                         icon: const Icon(Icons.refresh),
//                         onPressed: controller.reset),
//                     IconButton(
//                         icon: const Icon(Icons.zoom_in),
//                         onPressed: () => controller
//                             .addTransition(CropImageData(scale: 1.33))),
//                     IconButton(
//                         icon: const Icon(Icons.zoom_out),
//                         onPressed: () => controller
//                             .addTransition(CropImageData(scale: 0.75))),
//                     IconButton(
//                         icon: const Icon(Icons.rotate_left),
//                         onPressed: () => controller
//                             .addTransition(CropImageData(angle: -pi / 4))),
//                     IconButton(
//                         icon: const Icon(Icons.rotate_right),
//                         onPressed: () => controller
//                             .addTransition(CropImageData(angle: pi / 4))),
//                     IconButton(
//                       icon: const Icon(Icons.crop),
//                       onPressed: () async {
//                         final croppedImage = await controller.onCropImage();
//                         if (croppedImage != null) {
//                           final imageBytes =
//                               await _convertMemoryImageToUint8List(
//                                   croppedImage);
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (BuildContext context) =>
//                                   ResultScreen(imageBytes: imageBytes)));
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class ResultScreen extends StatelessWidget {
//   final Uint8List? imageBytes;

//   const ResultScreen({super.key, required this.imageBytes});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cropped Image")),
//       body: Center(
//         child: imageBytes != null
//             ? Image.memory(imageBytes!)
//             : Text("No Image Data"),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

class ScanDocument extends StatefulWidget {
  const ScanDocument({super.key});

  @override
  State<ScanDocument> createState() => _ScanDocumentState();
}

class _ScanDocumentState extends State<ScanDocument> {
  dynamic _scanDocument;

  Future<void> ScanFunction() async {
    dynamic scanDocument;
    try {
      scanDocument =
          await FlutterDocScanner().getScanDocuments() ?? 'Unknown Platform';
    } on PlatformException {
      scanDocument = 'Failed to load the Document';
    }

    // Update the state only if the widget is still mounted
    if (mounted) {
      setState(() {
        _scanDocument = scanDocument;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is Scan'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _scanDocument != null
              ? Center(
                  child: Text(_scanDocument.toString()),
                )
              : Center(
                  child: Text('No Pic taken'),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ScanFunction,
        label: Text('Scan'),
      ),
    );
  }
}
