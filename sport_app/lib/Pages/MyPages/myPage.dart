import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sport_app/Provider/userProvider.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/live_room.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Services/Utils/sharedPreferencesUtils.dart';
import 'contactUs.dart';
import 'editProfile.dart';
import 'savedLive.dart';
import 'systemSetting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //  get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  // provider
  UserProvider provider = UserProvider();

  //controller
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  Widget whiteBox(String text, Function()? onTap) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * fem),
          color: kMainComponentColor,
        ),
        width: 105 * fem,
        height: 60 * fem,
        child: Center(
            child: Text(
          text,
          style: tMyPageBtn,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: kMainGreenColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return SafeArea(
        child: Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * fem),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 46,
            ),
            Stack(
              children: [
                Container(
                  width: 114 * fem,
                  height: 114 * fem,
                ),
                Obx(() => Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kMainGreenColor,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              Image.network(userModel.profilePicture.value)
                                  .image,
                          radius: 56 * fem,
                          backgroundColor: Colors
                              .transparent, // Set background color to transparent
                        ),
                      ],
                    )),
                Positioned(
                  left: 80 * fem,
                  top: 80 * fem,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => EditProfile());
                    },
                    child: SvgPicture.asset(
                      'images/myPage/chg-pic-icon.svg',
                      width: 28 * fem,
                      height: 28 * fem,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 24 * fem,
            ),
            Obx(
              () => Text(userModel.userName.value, style: tUsername),
            ),
            SizedBox(
              height: 4 * fem,
            ),
            Text(userModel.id.value, style: tPhoneNo),
            SizedBox(
              height: 30 * fem,
            ),
            GestureDetector(
              onTap: () => {Get.to(() => SavedLivePage())},
              child: Container(
                  width: 340 * fem,
                  height: 60 * fem,
                  decoration: BoxDecoration(
                      color: kMainGreenColor,
                      borderRadius: BorderRadius.circular(8 * fem)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8 * fem),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'images/myPage/Circle.svg',
                          color: Colors.transparent,
                        ),
                        // Obx(
                        //   () =>
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.myCollection,
                              style: tCollectionBtn,
                            )),
                        // ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset('images/myPage/Circle.svg'),
                              SvgPicture.asset('images/myPage/Bookmark.svg'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: 14 * fem,
            ),
            // Obx(
            //   () =>
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                whiteBox(AppLocalizations.of(context)!.noti, () async {
                  // LiveRoom(loginUserID: userModel.id.value, avChatRoomID: 'wtf', streamerName: '', streamTitle: '', avatar: '',).launch(context);
                }),
                SizedBox(
                  width: 14 * fem,
                ),
                whiteBox(AppLocalizations.of(context)!.contactUs, () {
                  Get.to(() => ContactUs());
                }),
                SizedBox(
                  width: 14 * fem,
                ),
                whiteBox(AppLocalizations.of(context)!.systemSetting, () {
                  Get.to(() => SystemSetting());
                }),
              ],
            ),
            // ),
            SizedBox(
              height: 180 * fem,
            ),
            // Obx(
            //   () =>
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(0),
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
                              style: TextStyle(color: Colors.black)),
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
            // )
          ],
        ),
      ),
    ));
  }
}
