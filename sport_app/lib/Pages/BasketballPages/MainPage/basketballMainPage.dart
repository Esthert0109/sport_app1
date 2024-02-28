import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/userDataModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BasketballMainPage extends StatefulWidget {
  const BasketballMainPage({super.key});

  @override
  State<BasketballMainPage> createState() => _BasketballMainPageState();
}

class _BasketballMainPageState extends State<BasketballMainPage>
    with SingleTickerProviderStateMixin {
//get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  //controller
  final ScrollController _scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();

  //variables
  bool _showAppBar = true;

  //choice of main page
  void dropdownCallback(String? selectedValue) {
    setState(() {
      lc.sportType.value = selectedValue!;

      print("check sport selection: $selectedValue");
      if (lc.sportType.value == 'basketball') {
        userModel.isFootball.value = false;
        print("check sport selection 2: ${userModel.isFootball.value}");
      } else {
        userModel.isFootball.value = true;
        print("check sport selection 2: ${userModel.isFootball.value}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                  horizontal: 16 * fem, vertical: 10 * fem),
              height: _showAppBar ? 56 * fem : 0,
              color: kMainGreenColor,
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                scrolledUnderElevation: 0.0,
                surfaceTintColor: Colors.transparent,
                actions: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 8 * fem, horizontal: 10 * fem),
                    width: 280 * fem,
                    height: 40 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * fem),
                      color: kMainComponentColor.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'images/appBar/search.svg',
                          width: 24 * fem,
                          height: 24 * fem,
                        ),
                        SizedBox(
                          width: 2 * fem,
                        ),
                        Text(
                          AppLocalizations.of(context)!.search,
                          style: tSearch,
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  DropdownButton(
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    dropdownColor: Color.fromARGB(255, 211, 255, 212),
                    icon: Padding(
                      padding: EdgeInsets.only(left: 5 * fem),
                      child: SvgPicture.asset('images/appBar/down-arrow.svg'),
                    ),
                    borderRadius: BorderRadius.circular(8 * fem),
                    items: [
                      DropdownMenuItem(
                        value: 'basketball',
                        child: Center(
                          child: Image.asset(
                            'images/appBar/basketball.png',
                            width: 24 * fem,
                            height: 24 * fem,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'football',
                        child: Center(
                          child: Image.asset(
                            'images/appBar/football.png',
                            width: 24 * fem,
                            height: 24 * fem,
                          ),
                        ),
                      ),
                    ],
                    value: lc.sportType.value,
                    onChanged: dropdownCallback,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 10 * fem, vertical: 10 * fem),
              padding: EdgeInsets.symmetric(
                  horizontal: 10 * fem, vertical: 10 * fem),
              height: 100 * fem,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kMainComponentColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 340 * fem,
                      // color: redColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: Cro,
                        children: [
                          Expanded(
                              flex: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20 * fem,
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8 * fem),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLightGreyColor),
                                    child: Text(
                                      "Iraqi League - Regular",
                                      style: tTagButton,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    height: 20 * fem,
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20 * fem),
                                    child: Text(
                                      "00:00",
                                      style: tDate,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    width: 24 * fem,
                                    height: 24 * fem,
                                    alignment: Alignment.topRight,
                                    // color: Colors.amber,
                                    child: SvgPicture.asset(
                                        'images/common/Bookmark-0.svg')),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(right: 8 * fem),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Real Club Deportivo de La Coruña",
                                style: tGroupName,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Image(
                                  image: AssetImage(
                                      'images/mainpage/sampleLogo.png')),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1 * fem),
                              alignment: Alignment.center,
                              child: Text(
                                "123 - 123",
                                style: tScore,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Image(
                                  image: AssetImage(
                                      'images/mainpage/sampleLogo.png')),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(left: 8 * fem),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Association",
                                style: tGroupName,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
