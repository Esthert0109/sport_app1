import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorText extends StatelessWidget {
  final String Msg;
  const ErrorText({required this.Msg});

  @override
  Widget build(BuildContext context) {
    Color fontRed = Color.fromARGB(255, 168, 43, 31);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20 * fem),
      child: Text(Msg,
          style: GoogleFonts.notoSansSc(
            color: fontRed,
            fontSize: 13 * fem,
            fontWeight: FontWeight.w400,
          )),
    );
  }
}
