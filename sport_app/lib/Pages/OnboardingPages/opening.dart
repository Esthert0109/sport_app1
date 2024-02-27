import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

import '../../Constants/colorConstant.dart';
import '../../Provider/userProvider.dart';
import '../../Services/Utils/sharedPreferencesUtils.dart';
import '../../Services/Utils/tencent/tencentLicenseConfig.dart';
import '../../Services/Utils/tencent/tencentLiveUtils.dart';

class Opening extends StatefulWidget {
  const Opening({super.key});

  @override
  State<Opening> createState() => _OpeningState();
}

class _OpeningState extends State<Opening> {
  @override
  void initState() {
    super.initState();
    initAndLoginIm();
    getDataAndNavigate();
    setupLicense();
    getUserTencentLoginState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Loading into main page
  void getDataAndNavigate() async {
    // 缓冲 + 从本地设备加载用户数据
    Timer(const Duration(seconds: 2), () async {
      checklogin().then((loggedIn) {
        if (loggedIn) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/auth');
        }
      });
    });
  }

  // Login Tencent Chat Room
  Future<V2TimValueCallback<int>> getUserTencentLoginState() async {
    V2TimValueCallback<int> getLoginStateRes =
        await TencentImSDKPlugin.v2TIMManager.getLoginStatus();

    return getLoginStateRes;
  }

  @override
  Widget build(BuildContext context) {
    //standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 36 * fem),
              child: SvgPicture.asset('images/opening/opening_pic.svg'),
            ),
            SizedBox(
              height: 60 * fem,
            ),
            Image.asset(
              'images/opening/pandalogo.png',
              width: 60 * fem,
              height: 60 * fem,
            ),
            Image.asset(
              'images/opening/logo_font.png',
              width: 60 * fem,
              height: 25 * fem,
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> checklogin() async {
  String? getUsername = await SharedPreferencesUtils.getUsername();
  String? returnedtoken = await SharedPreferencesUtils.getSavedToken();

  if (getUsername != null) {
    bool isPasswordValid = await UserProvider()
        .loginUser(getUsername.toString(), returnedtoken.toString());
    if (isPasswordValid) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
