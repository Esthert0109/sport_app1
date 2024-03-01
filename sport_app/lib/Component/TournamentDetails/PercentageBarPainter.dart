import 'package:flutter/material.dart';

class PercentageBarPainter extends CustomPainter {
  final double percentage;

  PercentageBarPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromRGBO(51, 186, 83, 1)
      ..style = PaintingStyle.fill;

    double roundedPartWidth = size.width * percentage;

    // Create a rounded rectangle for the left side with the specified border radius
    RRect roundedPartRect = RRect.fromLTRBAndCorners(
      0,
      0,
      roundedPartWidth,
      size.height,
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10),
    );

    // Create a rounded rectangle for the right side with the specified border radius
    RRect straightPartRect = RRect.fromLTRBAndCorners(
      roundedPartWidth,
      0,
      size.width,
      size.height,
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10),
    );

    // Create a rounded rectangle for the full straight part with no border radius
    RRect fullstraightPartRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10),
    );

    // Draw the full straight part first
    paint.color = Color.fromRGBO(215, 221, 215, 1);
    canvas.drawRRect(fullstraightPartRect, paint);

    // Draw the rounded part
    paint.color = Color.fromRGBO(51, 186, 83, 1);
    canvas.drawRRect(roundedPartRect, paint);

    // Draw the straight part
    paint.color = Color.fromRGBO(215, 221, 215, 1);
    canvas.drawRRect(straightPartRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PercentageBarPainter2 extends CustomPainter {
  final double percentage2;

  PercentageBarPainter2(this.percentage2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromRGBO(51, 186, 83, 1)
      ..style = PaintingStyle.fill;

    double roundedPartWidth = size.width * percentage2;

    // Create a rounded rectangle for the left side with the specified border radius
    RRect roundedPartRect = RRect.fromLTRBAndCorners(
      0,
      0,
      roundedPartWidth,
      size.height,
      bottomLeft: Radius.circular(10),
      topLeft: Radius.circular(10),
    );

    // Create a rounded rectangle for the right side with the specified border radius
    RRect straightPartRect = RRect.fromLTRBAndCorners(
      roundedPartWidth,
      0,
      size.width,
      size.height,
      bottomLeft: Radius.circular(10),
      topLeft: Radius.circular(10),
    );

    // Create a rounded rectangle for the full straight part with no border radius
    RRect fullstraightPartRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      bottomLeft: Radius.circular(10),
      topLeft: Radius.circular(10),
    );

    // // Draw the full straight part first
    paint.color = Color.fromRGBO(215, 221, 215, 1);
    canvas.drawRRect(fullstraightPartRect, paint);

    // Draw the rounded part
    paint.color = Color.fromRGBO(215, 221, 215, 1);
    canvas.drawRRect(roundedPartRect, paint);

    // Draw the straight part
    paint.color = Color.fromRGBO(253, 162, 76, 1.0);
    canvas.drawRRect(straightPartRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PercentageBarOnTargetPainter extends CustomPainter {
  final double percentage1;
  final double percentage2;

  PercentageBarOnTargetPainter(this.percentage1, this.percentage2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = Color.fromRGBO(51, 186, 83, 1)
      ..style = PaintingStyle.fill;

    Paint paint2 = Paint()
      ..color = Color.fromRGBO(69, 206, 101, 1)
      ..style = PaintingStyle.fill;

    Paint paint3 = Paint()
      ..color = Color.fromRGBO(215, 221, 215, 1)
      ..style = PaintingStyle.fill;

    double part1Width = size.width * percentage1;
    double part2Width = size.width * percentage2;

    RRect part1RRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(0, 0, part1Width, size.height),
      topLeft: Radius.circular(0),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(10),
    );

    RRect part2RRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(0, 0, part2Width, size.height),
      topLeft: Radius.circular(0),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(10),
    );

    RRect part3RRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(size.width, 0, size.width, size.height),
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    );

    RRect fullstraightPartRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10),
    );

    // Draw the gray part
    canvas.drawRRect(fullstraightPartRect, paint3);

    // Draw the light green part
    canvas.drawRRect(part2RRect, paint2);
    // Draw the green part
    canvas.drawRRect(part1RRect, paint1);
    // Draw the gray part
    canvas.drawRRect(part3RRect, paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PercentageBarOnTargetPainter2 extends CustomPainter {
  final double percentage1;
  final double percentage2;

  PercentageBarOnTargetPainter2(this.percentage1, this.percentage2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = Color.fromRGBO(253, 162, 76, 1)
      ..style = PaintingStyle.fill;

    Paint paint2 = Paint()
      ..color = Color.fromRGBO(255, 189, 127, 1)
      ..style = PaintingStyle.fill;

    Paint paint3 = Paint()
      ..color = Color.fromRGBO(215, 221, 215, 1)
      ..style = PaintingStyle.fill;

    double part1Width = size.width * percentage1;
    double part2Width = size.width * percentage2;

    RRect part1RRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(size.width - part1Width, 0, size.width, size.height),
      topLeft: Radius.circular(10),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(0),
    );

    RRect part2RRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(size.width - part2Width, 0, size.width, size.height),
      topLeft: Radius.circular(10),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(0),
    );

    RRect part3RRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(size.width, 0, 0, size.height),
      topLeft: Radius.circular(10),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(0),
    );

    RRect fullstraightPartRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      bottomLeft: Radius.circular(10),
      topLeft: Radius.circular(10),
    );

    // Draw the gray part
    canvas.drawRRect(fullstraightPartRect, paint3);

    // Draw the gray part
    canvas.drawRRect(part3RRect, paint3);

    // Draw the light orange part
    canvas.drawRRect(part2RRect, paint2);

    // Draw the orange part
    canvas.drawRRect(part1RRect, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
