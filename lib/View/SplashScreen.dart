import 'package:flutter/material.dart';
import 'package:pdf_viewer/Utility/RoutesNames.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _SplashscreenService();
  }

  _SplashscreenService() async {
    await Future.delayed(Duration(seconds: 5), () {});

    Navigator.pushReplacementNamed(context, RoutesNames.PDFView_Screen);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xff190207),
            body: Stack(children: [
              Container(
                height: height * 0.25,
                width: width,
                decoration: BoxDecoration(
                    color: const Color(0xff3D0000),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(width * 0.5, 110))),
              ),

              Positioned(
                top: height * 0.35,
                left: width * 0.3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.s,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "EASY PDF",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * 0.1,
                      child: Icon(
                        Icons.picture_as_pdf,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    SizedBox(
                        // height: height * 0.05,
                        child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 60,
                    ))
                  ],
                ),
              ),
              //     Stack(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(top: 300, left: 124),
              //           child: Text(
              //             "EASY PDF",
              //             style: TextStyle(
              //                 fontSize: 35,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(top: 340, left: 180),
              //           child: SizedBox(
              //             height: height * 0.1,
              //             child: Icon(
              //               Icons.picture_as_pdf,
              //               size: 60,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(top: 280, left: 130),
              //           child: SizedBox(
              //             height: height * 0.2,
              //             width: width * 0.6,
              //             child: CircularProgressIndicator(
              //               color: Colors.white,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              Padding(
                padding: const EdgeInsets.only(top: 650),
                child: Container(
                  height: height * 0.25,
                  width: width,
                  decoration: BoxDecoration(
                      color: const Color(0xff3D0000),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(width * 0.5, 110))),
                ),
              )
            ])));
  }
}
