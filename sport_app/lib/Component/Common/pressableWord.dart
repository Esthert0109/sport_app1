import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colorConstant.dart';

class PressableWord extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  PressableWord({
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    Color fontBlue = color ?? kMainGreenColor;
    return GestureDetector(
      onTap: onPressed,
      child: Text(text,
          style: GoogleFonts.notoSansSc(
            fontSize: fontSize ?? 15 * fem,
            fontWeight: fontWeight ?? FontWeight.w700,
            letterSpacing: 0.14 * fem,
            color: fontBlue,
          )),
    );
  }
}
