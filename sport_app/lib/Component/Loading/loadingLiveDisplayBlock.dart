import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class LoadingLiveDisplayBlock extends StatelessWidget {
  const LoadingLiveDisplayBlock({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return CardLoading(
      height: 90 * fem,
      margin: EdgeInsets.symmetric(vertical: 7 * fem),
      width: 343 * fem,
      borderRadius: BorderRadius.circular(8 * fem),
    );
  }
}

class LoadingLiveSquareDisplayBlock extends StatelessWidget {
  const LoadingLiveSquareDisplayBlock({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return CardLoading(
      height: 142 * fem,
      width: 165 * fem,
      borderRadius: BorderRadius.circular(8 * fem),
    );
  }
}