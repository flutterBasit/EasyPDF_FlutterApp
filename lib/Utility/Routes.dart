import 'package:flutter/material.dart';
import 'package:pdf_viewer/Utility/RoutesNames.dart';
import 'package:pdf_viewer/View/Home_Screen.dart';
import 'package:pdf_viewer/View/PDFView_Screen.dart';
import 'package:pdf_viewer/View/SplashScreen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.Home_Screen:
        return _fadeRoute(HomeScreen(), settings);
      case RoutesNames.PDFView_Screen:
        return _fadeRoute(PDFViewScreen(), settings);
      case RoutesNames.SplashScreen:
        return _fadeRoute(Splashscreen(), settings);
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("No Rotes Defined"),
            ),
          );
        });
    }
  }

  // Fade Transition
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      settings: settings,
    );
  }

  // Slide Transition
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      settings: settings,
    );
  }
}
