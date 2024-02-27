import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingLongButton extends StatelessWidget {
  const LoadingLongButton({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Container(
        width: 340 * fem,
        height: 50 * fem,
        decoration: BoxDecoration(
            color: Color(0xff0075FE), borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: LoadingAnimationWidget.waveDots(
              color: Colors.white, size: 30 * fem),
        ));
  }
}

class LoadingShortButton extends StatelessWidget {
  const LoadingShortButton({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Container(
        width: 105 * fem,
        height: 55 * fem,
        decoration: BoxDecoration(
            color: Color(0xff1C2840), borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: LoadingAnimationWidget.inkDrop(
              color: Colors.white, size: 30 * fem),
        ));
  }
}
