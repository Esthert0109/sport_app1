import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Lottie.asset(
          'images/common/pandahappy.json', // Replace 'loading.json' with the path to your Lottie animation
          width: 250, // Adjust the width as needed
          height: 250, // Adjust the height as needed
        ),
      );
    },
  );
}
