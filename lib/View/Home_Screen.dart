//import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pdf_viewer/Utility/RoutesNames.dart';
import 'package:pdf_viewer/resources/Components/componets.dart';
import 'package:pdf_viewer/resources/Constants/Constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Easy PDF ",
              body:
                  "Experience the power of PDF simplicity with Easy PDF. Our app empowers you to create professional-looking documents, read PDFs effortlessly, and convert files between formats with ease.",
              image: ReUsable_Container(
                height: height * 0.3,
                width: width * 0.6,
                LinearGradient_Color1: Colors.red,
                LinearGradient_Color2: Colors.redAccent.shade100,
                borderColor: Colors.black,
                borderRadius: 40,
                borderWidth: 2,
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 100,
                ),
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                bodyTextStyle:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                imagePadding: EdgeInsets.all(24),
                contentMargin: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            PageViewModel(
              title: "Easy PDF And Word",
              body:
                  "Simplify your document workflow with Easy PDF and Word. Our app offers seamless conversion, viewing, and basic editing tools for both PDF and Word files",
              image: ReUsable_Container(
                height: height * 0.3,
                width: width * 0.6,
                LinearGradient_Color1: Colors.red,
                LinearGradient_Color2: Colors.blueAccent.shade100,
                borderColor: Colors.black,
                borderRadius: 40,
                borderWidth: 2.5,
                child: const Icon(
                  Icons.document_scanner_rounded,
                  size: 100,
                ),
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                bodyTextStyle:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                imagePadding: EdgeInsets.all(24),
                contentMargin: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            // Add more PageViewModel instances here for additional pages
          ],
          onDone: () {
            // Navigate to another screen
            //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NextScreen()));
            Navigator.pushReplacementNamed(context, RoutesNames.SplashScreen);
          },
          onSkip: () {
            // Navigate to another screen
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NextScreen()));
            Navigator.pushReplacementNamed(context, RoutesNames.SplashScreen);
          },
          showSkipButton: true,
          skip: ReUsable_Container(
            height: height * 0.05,
            width: width * 0.15,
            LinearGradient_Color1: Colors.black,
            LinearGradient_Color2: Colors.black,
            borderColor: Colors.white,
            borderWidth: 2.5,
            borderRadius: 15,
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
          next: const Icon(Icons.arrow_forward),
          done: ReUsable_Container(
            height: height * 0.05,
            width: width * 0.15,
            LinearGradient_Color1: Colors.black,
            LinearGradient_Color2: Colors.black,
            borderColor: Colors.white,
            borderWidth: 2.5,
            borderRadius: 15,
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          )),
    );
  }
}
