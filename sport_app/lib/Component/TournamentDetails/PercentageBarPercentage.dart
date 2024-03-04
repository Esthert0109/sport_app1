import 'package:flutter/material.dart';
import 'percentageBarPainter.dart';

class PercentageBarPercentage extends StatelessWidget {
  final double percent;
  final double percent_text;
  final double width;
  final double height;

  PercentageBarPercentage({
    required this.percent,
    required this.percent_text,
    this.width = 200.0,
    this.height = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomPaint(
          size: Size(width, height),
          painter: PercentageBarPainter(percent / 100), // 百分比倒转
        ),
        SizedBox(
          width: 10, // 在CustomPaint和Text小部件之间添加一些间距
        ),
        Container(
          width: 40,
          child: Text(
            '${((percent_text)).toInt()}',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ],
    );
  }
}

class PercentageBarPercentage2 extends StatelessWidget {
  final double percent2;
  final double percent2_text;
  final double width2;
  final double height2;

  PercentageBarPercentage2({
    required this.percent2,
    required this.percent2_text,
    this.width2 = 200.0,
    this.height2 = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          child: Text(
            '${((percent2_text)).toInt()}',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 0.0,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        SizedBox(
          width: 10, // 在CustomPaint和Text小部件之间添加一些间距
        ),
        CustomPaint(
          size: Size(width2, height2),
          painter: PercentageBarPainter2(1 - percent2 / 100), // 百分比倒转
        ),
      ],
    );
  }
}

class PercentageBarOnTarget extends StatelessWidget {
  final double percent_1;
  final double percent_2;
  final double percent_1_text;
  final double percent_2_text;
  final double width;
  final double height;

  PercentageBarOnTarget({
    required this.percent_1,
    required this.percent_2,
    required this.percent_1_text,
    required this.percent_2_text,
    this.width = 200.0,
    this.height = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomPaint(
          size: Size(width, height),
          painter: PercentageBarOnTargetPainter(
            percent_1 / 100,
            percent_2 / 100,
          ),
        ),
        SizedBox(
          width: 1, // 在CustomPaint和Text小部件之间添加一些间距
        ),
        Container(
          width: 40,
          child: Text(
            '${(percent_1_text).toInt()} (${(percent_2_text).toInt()})',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class PercentageBarOnTarget2 extends StatelessWidget {
  final double percent1;
  final double percent2;
  final double percent1_text;
  final double percent2_text;
  final double width2;
  final double height2;

  PercentageBarOnTarget2({
    required this.percent1,
    required this.percent2,
    required this.percent1_text,
    required this.percent2_text,
    this.width2 = 200.0,
    this.height2 = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          child: Text(
            '${(percent1_text).toInt()} (${(percent2_text).toInt()})',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 1, // 在CustomPaint和Text小部件之间添加一些间距
        ),
        CustomPaint(
          size: Size(width2, height2),
          painter: PercentageBarOnTargetPainter2(
            percent1 / 100,
            percent2 / 100,
          ),
        ),
      ],
    );
  }
}
