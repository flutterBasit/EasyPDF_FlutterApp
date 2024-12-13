import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_dart/opencv_dart.dart';
import 'dart:io';

class ImageEnhancerApp extends StatefulWidget {
  @override
  _ImageEnhancerAppState createState() => _ImageEnhancerAppState();
}

class _ImageEnhancerAppState extends State<ImageEnhancerApp> {
  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> enhanceImage(File image) async {
    try {
      // Read the image as bytes
      final bytes = await image.readAsBytes();

      // Apply Gaussian Blur using OpenCV
      final Uint8List enhancedBytes =
          (await gaussianBlur(bytes as Mat, [15, 15] as (int, int), 0))
              as Uint8List;

      // Save the enhanced image to a new file
      final String newPath = image.path.replaceFirst('.jpg', '_enhanced.jpg');
      final enhancedImage = await File(newPath).writeAsBytes(enhancedBytes);

      return enhancedImage;
    } catch (e) {
      print('Error enhancing image: $e');
      return null;
    }
  }

  Future<void> _pickAndEnhanceImage() async {
    final image = await pickImage();
    if (image != null) {
      final enhancedImage = await enhanceImage(image);
      setState(() {
        _image = enhancedImage;
      });
    }
  }

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Enhancer'),
      ),
      body: Center(
        child:
            _image == null ? Text('No image selected.') : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndEnhanceImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
