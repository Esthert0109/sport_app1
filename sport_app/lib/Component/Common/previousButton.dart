import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PrevBtn extends StatelessWidget {
  final Function? onTap;
  const PrevBtn({this.onTap});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return GestureDetector(
      onTap: () {
        onTap ?? Get.back(); //回到前页面
      },
      child: SvgPicture.asset(
        'images/common/Arrow.svg',
        width: 24 * fem,
        height: 24 * fem,
      ),
    );
  }
}
