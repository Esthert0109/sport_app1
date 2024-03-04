import 'package:flutter/material.dart';

class InfoDisplay extends StatelessWidget {
  final Color textColor;
  final String text;

  InfoDisplay({
    required this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(
              120, 200, 120, 120), // Adjust the padding as needed
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('images/search_empty.png'),
              Text(text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 1,
                    letterSpacing: 0.46,
                  )),
            ],
          )),
    );
  }
}
