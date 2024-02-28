import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'Constants/colorConstant.dart';
import 'Constants/textConstant.dart';
import 'Model/userDataModel.dart';
import 'Pages/BasketballPages/InfoPage/BasketballInfoPage.dart';
import 'Pages/BasketballPages/LivePage/BasketballLivePage.dart';
import 'Pages/BasketballPages/MainPage/BasketballMainPage.dart';
import 'Pages/FootballPages/InfoPage/footballInfoPage.dart';
import 'Pages/FootballPages/LivePage/footballLivePage.dart';
import 'Pages/FootballPages/MainPage/footballMainPage.dart';
import 'Pages/myPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNaviBar extends StatefulWidget {
  const BottomNaviBar({super.key});

  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  //get user current info
  UserDataModel userDataModel = Get.find<UserDataModel>();

  //set to main page
  int pageIndex = 0;

  //football pages
  List<Widget> footballPagesLayout = <Widget>[
    const FootballMainPage(),
    const FootballLivePage(),
    const FootballInfoPage(),
    const MyPage(),
  ];

  //basketball pages
  List<Widget> basketballPagesLayout = <Widget>[
    const BasketballMainPage(),
    const BasketballLivePage(),
    const BasketballInfoPage(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    //standard size of the app
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: kMainGreenColor));

    //obx setting
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: pageIndex,
            children: userDataModel.isFootball.value == true
                ? footballPagesLayout
                : basketballPagesLayout,
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(top: 0 * fem),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: 1.0 * fem, color: Colors.transparent)),
            ),
            child: BottomNavigationBar(
              backgroundColor: kMainComponentColor,
              currentIndex: pageIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: kMainGreenColor,
              unselectedItemColor: kMainBottomNaviBtnColor,
              selectedLabelStyle: tSelectedBottomNaviBtn,
              unselectedLabelStyle: tUnselectedBottomNaviBtn,
              onTap: (int index) {
                setState(() {
                  pageIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.mainPage,
                    icon: pageIndex == 0
                        ? SvgPicture.asset('images/bottomNaviBtn/home-1.svg')
                        : SvgPicture.asset('images/bottomNaviBtn/home-0.svg'),
                    backgroundColor: kMainBackgroundColor),
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.live,
                    icon: pageIndex == 1
                        ? SvgPicture.asset('images/bottomNaviBtn/live-1.svg')
                        : SvgPicture.asset('images/bottomNaviBtn/live-0.svg'),
                    backgroundColor: kMainBackgroundColor),
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.info,
                    icon: pageIndex == 2
                        ? SvgPicture.asset('images/bottomNaviBtn/info-0.svg')
                        : SvgPicture.asset('images/bottomNaviBtn/info-1.svg'),
                    backgroundColor: kMainBackgroundColor),
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.my,
                    icon: pageIndex == 3
                        ? SvgPicture.asset('images/bottomNaviBtn/profile-1.svg')
                        : SvgPicture.asset(
                            'images/bottomNaviBtn/profile-0.svg'),
                    backgroundColor: kMainBackgroundColor),
              ],
            ),
          ),
        ));
  }
}
