import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sport_app/Constants/colorConstant.dart';
import 'package:sport_app/Model/userDataModel.dart';
import 'package:sport_app/Pages/MyPages/contactUs.dart';
import 'package:sport_app/Pages/MyPages/editProfile.dart';
import 'package:sport_app/Provider/popularGamesProvider.dart';

import '../../Component/Common/loginDialog.dart';
import '../../Constants/textConstant.dart';
import '../../Model/popularGameModel.dart';
import '../../Provider/userProvider.dart';
import '../../Services/Utils/sharedPreferencesUtils.dart';
import 'systemMessage.dart';
import 'systemSetting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PopularGameProvider gameProvider = PopularGameProvider();

  //controller
  // final RoundedLoadingButtonController btnController =
  //     RoundedLoadingButtonController();

  // common variables
  bool isLogin = true;
  bool isLoading = false;
  List<PopularGameData> gameList = [];
  int gameLength = 0;

  Future<void> checkLogin() async {
    //get shared preferences
    String? token = await SharedPreferencesUtils.getSavedToken();

    print("check token: ${token.toString()}");

    if (token.isEmptyOrNull) {
      isLogin = false;
      print("check login: ${isLogin}");
    } else {
      isLogin = true;
    }
  }

  Future<void> getPopularGameList() async {
    PopularGameModel? model = await gameProvider.getPopularGameList();

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      gameList.addAll(model?.data ?? []);
      gameLength = gameList.length;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPopularGameList();
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

    checkLogin();

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
                    Obx(
                      () => ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: userModel.isLogin.value
                              ? CircleAvatar(
                                  backgroundColor: kLightGreyColor,
                                  radius: 30 * fem,
                                  backgroundImage: NetworkImage(
                                      userModel.profilePicture.value),
                                  // fit: BoxFit.cover,
                                  // height: 60 * fem,
                                  // width: 60 * fem,
                                )
                              : Image(
                                  image: const NetworkImage(
                                      "https://cc.tvbs.com.tw/img/upload/2022/05/20/20220520170357-1298d211.jpg"
                                      // "images/myPage/profilePic.png"
                                      ),
                                  fit: BoxFit.cover,
                                  height: 60 * fem,
                                  width: 60 * fem,
                                )),
                    ),
                    Obx(() => Container(
                        width: 250 * fem,
                        margin: EdgeInsets.symmetric(horizontal: 10 * fem),
                        padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                        child: userModel.isLogin.value
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
                                          child: Text(
                                            userModel.userName.value,
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
                                  Text(
                                    userModel.id.value,
                                    style: tPhoneNo,
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  child: Text(
                                      AppLocalizations.of(context)!.login +
                                          "/" +
                                          AppLocalizations.of(context)!.reg,
                                      style: tUsername),
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
                              )))
                  ],
                ),
              ),
              (gameLength == 0)
                  ? SizedBox()
                  : Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30 * fem,
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10 * fem),
                              margin:
                                  EdgeInsets.symmetric(horizontal: 15 * fem),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(10), // Adjust as needed
                                  ),
                                  color: kMainComponentColor),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.popularGames,
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
                                  topRight:
                                      Radius.circular(8), // Adjust as needed
                                  bottomLeft: Radius.circular(8),
                                  bottomRight:
                                      Radius.circular(8), // Adjust as needed
                                ),
                                color: kMainComponentColor),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: isLoading
                                      ? List.generate(
                                          10,
                                          (index) => Container(
                                                margin: EdgeInsets.only(
                                                    right: 25 * fem),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 50 * fem,
                                                      width: 50 * fem,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: grey),
                                                    ),
                                                    Container(
                                                      width: 50 * fem,
                                                      margin: EdgeInsets.only(
                                                          top: 3 * fem),
                                                      child: const Text(
                                                        "游戏名字",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: tHotsGameName,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                      : List.generate(
                                          gameLength,
                                          (index) => Container(
                                                margin: EdgeInsets.only(
                                                    right: 25 * fem),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        launchUrl(Uri.parse(
                                                            gameList[index]
                                                                .gameAndroidUrl));
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Container(
                                                          height: 50 * fem,
                                                          width: 50 * fem,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: redColor),
                                                          child: Image(
                                                            image: NetworkImage(
                                                                gameList[index]
                                                                    .gameLogo),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 50 * fem,
                                                      margin: EdgeInsets.only(
                                                          top: 3 * fem),
                                                      child: Text(
                                                        userModel.isCN.value
                                                            ? gameList[index]
                                                                .gameNameCn
                                                            : gameList[index]
                                                                .gameNameEn,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: tHotsGameName,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))),
                            )),
                      ],
                    ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 15 * fem, vertical: 20 * fem),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10 * fem),
                      padding: EdgeInsets.only(left: 10 * fem),
                      height: 50 * fem,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kMainComponentColor),
                      child: InkWell(
                        onTap: () {
                          print("navi to system message");
                          userModel.isLogin.value
                              ? Get.to(() => SystemMessagePage(),
                                  transition: Transition.fadeIn)
                              : showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (context) {
                                    return LoginAlertDialog();
                                  });
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
                                  child: Text(
                                    AppLocalizations.of(context)!.noti,
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
                      padding: EdgeInsets.only(left: 10 * fem),
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
                                    AppLocalizations.of(context)!.contactUs,
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
                      padding: EdgeInsets.only(left: 10 * fem),
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
                                    AppLocalizations.of(context)!.systemSetting,
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
              Obx(() => userModel.isLogin.value
                  ? GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: white,
                                              surfaceTintColor: white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              content: Text(
                                                userModel.isCN.value
                                                    ? "确认登出？"
                                                    : "Log out now?",
                                                style: tMain,
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      // margin:
                                                      //     EdgeInsets.symmetric(horizontal: 5 * fem),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  10 * fem),
                                                      width: 120 * fem,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            236,
                                                                            191))),
                                                        child: Text(
                                                          userModel.isCN.value
                                                              ? "取消"
                                                              : "Cancel",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'NotoSansSC',
                                                            fontSize: 12 * fem,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: greenColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // margin:
                                                      //     EdgeInsets.symmetric(horizontal: 5 * fem),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  10 * fem),
                                                      width: 120 * fem,
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          SharedPreferencesUtils
                                                              .clearSharedPreferences();
                                                          userModel.isLogin
                                                              .value = false;
                                                          Navigator.pop(
                                                              context);
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1),
                                                              () async {
                                                            Get.offAllNamed(
                                                                '/auth');
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                                        kMainGreenColor)),
                                                        child: Text(
                                                          userModel.isCN.value
                                                              ? "确认"
                                                              : "Yes",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'NotoSansSC',
                                                            fontSize: 12 * fem,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(white),
                                      surfaceTintColor:
                                          MaterialStatePropertyAll(white)),
                                  child: Text(
                                      AppLocalizations.of(context)!.logout,
                                      style: TextStyle(color: kMainGreyColor)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
