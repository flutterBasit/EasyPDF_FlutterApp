import 'package:flutter/material.dart';
import 'package:pdf_viewer/Services/PDF_Services.dart';
import 'package:pdf_viewer/Utility/Routes.dart';
import 'package:pdf_viewer/Utility/RoutesNames.dart';
import 'package:pdf_viewer/View/CamScanner.dart';
import 'package:pdf_viewer/View/imageEnhancer.dart';
import 'package:pdf_viewer/View_Model/PDF_Services_Model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: ImageEnhancerApp(),
      initialRoute: RoutesNames.Home_Screen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
