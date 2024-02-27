import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Component/Common/widthButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import '../AuthenticationPages/login.dart';
import '../AuthenticationPages/registration.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    UserDataModel userModel = Get.find<UserDataModel>();

    return Scaffold(
      backgroundColor: kMainComponentColor,
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 50 * fem,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(15.0 * fem),
                height: MediaQuery.of(context).size.width * 1.3,
                width: 800 * fem,
                child: Transform.scale(
                    scale: 1.1,
                    child: SvgPicture.asset('images/opening/opening_pic.svg')),
              ),
            ),
            SizedBox(
              height: 18 * fem,
            ),
            WidthButton(
              text: '登录',
              onPressed: () {
                Get.to(() => const Login());
              },
            ),
            SizedBox(
              height: 15 * fem,
            ),
            WidthButton(
                text: '注册',
                btnColor: kSecondaryBtnColor,
                fontColor: kMainGreenColor,
                onPressed: () {
                  Get.to(() => const Register());
                })
          ],
        ),
      ),
    );
  }
}
