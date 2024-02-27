import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorText extends StatelessWidget {
  final String Msg;
  const ErrorText({required this.Msg});

  @override
  Widget build(BuildContext context) {
    Color fontRed = Color(0xfff14336);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Text(Msg,
        style: GoogleFonts.notoSansSc(
          color: fontRed,
          fontSize: 14 * fem,
          fontWeight: FontWeight.w600,
        ));
  }
}
