import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colorConstant.dart';

class HeadingText extends StatelessWidget {
  final String text;

  HeadingText({required this.text});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    Color fontColor = kMainTitleColor;
    return Text(text,
        style: GoogleFonts.notoSansSc(
          fontSize: 30 * fem,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3 * fem,
          color: fontColor,
        ));
  }
}
