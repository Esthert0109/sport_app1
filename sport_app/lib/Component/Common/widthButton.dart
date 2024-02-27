import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colorConstant.dart';

class WidthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? btnColor;
  final Color? fontColor;

  const WidthButton({
    required this.text,
    required this.onPressed,
    this.btnColor,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    Color buttonColor = btnColor ?? kMainGreenColor;
    Color btnFontColor = fontColor ?? kMainBackgroundColor;
    return Center(
      child: Container(
        width: 340 * fem,
        height: 60 * fem,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Add border radius here
                ),
              ),
              backgroundColor: MaterialStateProperty.all(buttonColor)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Text(text,
                style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16 * fem,
                    fontWeight: FontWeight.w600,
                    color: btnFontColor,
                    height: 1)),
          ),
        ),
      ),
    );
  }
}
