import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/main.dart';

import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SystemSetting extends StatefulWidget {
  const SystemSetting({Key? key}) : super(key: key);

  @override
  State<SystemSetting> createState() => _systemSettingState();

  static void launch(BuildContext context) {}
}

class _systemSettingState extends State<SystemSetting> {
  UserDataModel userModel = Get.find<UserDataModel>();

  Widget sectionBox(String text, Function()? onTap) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343 * fem,
        height: 60 * fem,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * fem),
          color: kMainComponentColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(20 * fem),
          child: Row(children: [
            Text(text),
            Spacer(),
            SvgPicture.asset('images/common/right-arrow.svg'),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kMainGreenColor,
      statusBarIconBrightness: Brightness.light,
    ));

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
        backgroundColor: kMainBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 56 * fem,
                color: kMainGreenColor,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(17 * fem, 16 * fem, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            'images/common/arrow-white.svg',
                            width: 24 * fem,
                            height: 24 * fem,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child:
                          //  Obx(
                          //   () =>
                          Text(
                        AppLocalizations.of(context)!.systemSetting,
                        style: TextStyle(
                          fontFamily: 'NotoSansSC',
                          fontSize: 18 * fem,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3 * fem,
                          color: kMainComponentColor,
                        ),
                      ),
                      // ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20 * fem),
              Stack(
                children: [
                  Container(
                    width: 114 * fem,
                    height: 114 * fem,
                  ),
                  // Obx(() =>
                  Center(
                      child: ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.changeLanguage,
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide.none,
                      fixedSize: Size(343 * fem, 60 * fem),
                      alignment: Alignment.centerLeft,
                      elevation: 0.2,
                    ),
                    onPressed: () => showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        context: context,
                        builder: ((context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10 * fem, vertical: 20 * fem),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ListTile(
                                  title: new Text('中文'),
                                  onTap: () {
                                    setState(() {
                                      userModel.isCN.value = true;
                                      MyApp.setLocale(context, Locale('zh'));
                                    });
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/home', ModalRoute.withName('/home'));
                                  },
                                ),
                                ListTile(
                                  title: new Text('English'),
                                  onTap: () {
                                    setState(() {
                                      userModel.isCN.value = false;
                                      MyApp.setLocale(context, Locale('en'));
                                    });
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/home', ModalRoute.withName('/home'));
                                  },
                                )
                              ],
                            ),
                          );
                        })),
                    // ),
                  )),
                ],
              )
            ],
          ),
        ));
  }
}
