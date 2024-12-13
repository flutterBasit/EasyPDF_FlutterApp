import 'package:flutter/material.dart';

class ReUsable_Container extends StatelessWidget {
  double? height;
  double? width;
  Widget? child;
  Color LinearGradient_Color1;
  Color LinearGradient_Color2;
  double? borderRadius;
  Color borderColor;
  double? borderWidth;

  ReUsable_Container(
      {super.key,
      this.height,
      this.width,
      this.child,
      required this.LinearGradient_Color1,
      required this.LinearGradient_Color2,
      this.borderRadius,
      required this.borderColor,
      this.borderWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [LinearGradient_Color1, LinearGradient_Color2],
          ),
          border:
              Border.all(color: borderColor, width: borderWidth!.toDouble()),
          borderRadius: BorderRadius.circular(borderRadius!.toDouble()),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Colors.white, spreadRadius: 0.5, blurRadius: 20)
          ]),
      child: Center(child: child),
    );
  }
}
