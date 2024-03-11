import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sport_app/Constants/colorConstant.dart';
import 'package:sport_app/Model/userDataModel.dart';
import 'package:sport_app/Pages/MyPages/contactUs.dart';
import 'package:sport_app/Pages/MyPages/editProfile.dart';

import '../../Component/Common/loginDialog.dart';
import '../../Constants/textConstant.dart';
import '../../Provider/userProvider.dart';
import '../../Services/Utils/sharedPreferencesUtils.dart';
import 'systemMessage.dart';
import 'systemSetting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  // provider
  UserProvider provider = UserProvider();

  //controller
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  // common variables
  bool isLogin = true;

  Future<void> checkLogin() async {
    //get shared preferences
    String? token = await SharedPreferencesUtils.getSavedToken();

    print("check token: ${token.toString()}");

    if (token.isEmptyOrNull) {
      isLogin = false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: kMainGreenColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // set standard
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100 * fem,
                margin: EdgeInsets.symmetric(
                    vertical: 20 * fem, horizontal: 20 * fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: isLogin
                            ? Image(
                                image: const NetworkImage(
                                    "https://cc.tvbs.com.tw/img/upload/2022/05/20/20220520170357-1298d211.jpg"),
                                fit: BoxFit.cover,
                                height: 60 * fem,
                                width: 60 * fem,
                              )
                            : Image(
                                image: const AssetImage(
                                    "images/myPage/profilePic.png"),
                                fit: BoxFit.cover,
                                height: 60 * fem,
                                width: 60 * fem,
                              )),
                    Container(
                        width: 250 * fem,
                        margin: EdgeInsets.symmetric(horizontal: 10 * fem),
                        padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                        child: isLogin
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 200 * fem,
                                          child: const Text(
                                            "你猜你猜你猜 你猜你猜你猜 你猜你猜你猜",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: tUsername,
                                          )),
                                      InkWell(
                                        onTap: () {
                                          print(
                                              "edit projecxxxxxxxxxxxxxxxxxxxxxxxxxxxxy");
                                          Get.to(() => EditProfile(),
                                              transition: Transition.fadeIn);
                                        },
                                        child: Image(
                                          image: const AssetImage(
                                              "images/myPage/editProfile.png"),
                                          width: 24 * fem,
                                          height: 24 * fem,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Text(
                                    "0123456789",
                                    style: tPhoneNo,
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  child: Text("登录/注册", style: tUsername),
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        builder: (context) {
                                          return LoginAlertDialog();
                                        });
                                  },
                                ),
                              ))
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 30 * fem,
                    width: 100 * fem,
                    margin: EdgeInsets.symmetric(horizontal: 15 * fem),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), // Adjust as needed
                        ),
                        color: kMainComponentColor),
                    child: Center(
                        child: Text(
                      "热门游戏",
                      style: tHotGames,
                    )),
                  ),
                ],
              ),
              Container(
                  height: 120 * fem,
                  margin: EdgeInsets.symmetric(horizontal: 15 * fem),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20 * fem, vertical: 20 * fem),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8), // Adjust as needed
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8), // Adjust as needed
                      ),
                      color: kMainComponentColor),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          10,
                          (index) => Container(
                                margin: EdgeInsets.only(right: 25 * fem),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50 * fem,
                                      width: 50 * fem,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: redColor),
                                    ),
                                    Container(
                                      width: 50 * fem,
                                      margin: EdgeInsets.only(top: 3 * fem),
                                      child: const Text(
                                        "游戏名字",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: tHotsGameName,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 15 * fem, vertical: 20 * fem),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10 * fem),
                      height: 50 * fem,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kMainComponentColor),
                      child: InkWell(
                        onTap: () {
                          print("navi to system message");
                          Get.to(() => SystemMessagePage(),
                              transition: Transition.fadeIn);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 8 * fem),
                                  height: 24 * fem,
                                  width: 24 * fem,
                                  child: Image(
                                    image: const AssetImage(
                                        "images/myPage/systemMessage.png"),
                                    height: 24 * fem,
                                    width: 24 * fem,
                                  ),
                                )),
                            Expanded(
                                flex: 7,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3 * fem),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "系统消息",
                                    style: tMyPageBtn,
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 8 * fem),
                                  alignment: Alignment.centerRight,
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: kUnselectedTextColor,
                                    size: 30,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10 * fem),
                      height: 50 * fem,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kMainComponentColor),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const ContactUs(),
                              transition: Transition.fadeIn);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 6 * fem),
                                  height: 24 * fem,
                                  width: 24 * fem,
                                  child: Image(
                                    image: AssetImage(
                                        "images/myPage/contactUs.png"),
                                    height: 24 * fem,
                                    width: 24 * fem,
                                  ),
                                )),
                            Expanded(
                                flex: 7,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3 * fem),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "联系我们",
                                    style: tMyPageBtn,
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 8 * fem),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: kUnselectedTextColor,
                                    size: 30,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10 * fem),
                      height: 50 * fem,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kMainComponentColor),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const SystemSetting(),
                              transition: Transition.fadeIn);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 6 * fem),
                                  height: 24 * fem,
                                  width: 24 * fem,
                                  child: Image(
                                    image: AssetImage(
                                        "images/myPage/systemSetting.png"),
                                    height: 24 * fem,
                                    width: 24 * fem,
                                  ),
                                )),
                            Expanded(
                                flex: 7,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3 * fem),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "系统消息",
                                    style: tMyPageBtn,
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 8 * fem),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: kUnselectedTextColor,
                                    size: 30,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 15 * fem, vertical: 0 * fem),
                  child: Image(
                    image: AssetImage("images/myPage/ads.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          RoundedLoadingButton(
                            color: Colors.white,
                            valueColor: kMainGreenColor,
                            width: 150,
                            height: 40,
                            elevation: 0,
                            child: Text(AppLocalizations.of(context)!.logout,
                                style: TextStyle(color: kMainGreyColor)),
                            controller: btnController,
                            onPressed: () {
                              SharedPreferencesUtils.clearSharedPreferences();

                              Future.delayed(Duration(seconds: 2), () async {
                                Get.offAllNamed('/auth');
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
