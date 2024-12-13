// import 'package:flutter/material.dart';

// class Utitlities {
//   static FlutterSnackBar(BuildContext context, String message) {
//     final snackBar = SnackBar(
//       content: AnimatedContainer(
//         duration: Duration(seconds: 5),
//         curve: Curves.easeInOut,
//         child: Text(message),
//       ),
//       backgroundColor: Colors.redAccent.shade200,
//       elevation: 100,
//       padding: EdgeInsets.all(15),
//       duration: Duration(seconds: 4),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
import 'package:flutter/material.dart';

class Utilities {
  static void FlutterSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top +
            kToolbarHeight, // Position it below the status bar and app bar
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            color: Colors.redAccent.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(const Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }

  static void FlutterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.teal, // Custom background color
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Converting ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'This will take few seconds!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator()
            ],
          ),
        );
      },
    );
  }
}
