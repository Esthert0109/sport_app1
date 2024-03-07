import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/userDataModel.dart';
import '../../SearchPage/searchingPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<String> tagList = [
    '最新',
    "热门",
    "足球",
    "NBA",
    "CBA",
    "英超",
    "中超",
    "意甲",
    "德甲",
    "日韩",
    "焦点",
    "澳超"
  ];
  int tagLength = 0;

  //variables
  bool _showAppBar = true;
  int tagId = 0;

  //controller
  ScrollController _scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();

  //get user info
  UserDataModel userModel = Get.find<UserDataModel>();

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
    tagLength = tagList.length;

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
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SearchingPage(),
                          transition: Transition.noTransition);
                    },
                    child: Container(
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
                  ),
                  const Spacer(),
                  Container(
                    height: 24 * fem,
                    alignment: Alignment.centerLeft,
                    child: Image(image: AssetImage("images/info/hot.png")),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 20 * fem, vertical: 10 * fem),
              // color: greenColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      tagLength,
                      (index) => Container(
                            height: 25 * fem,
                            padding: EdgeInsets.only(right: 20 * fem),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  tagId = index;
                                });
                              },
                              child: Center(
                                child: Text(
                                  tagList[index],
                                  textAlign: TextAlign.center,
                                  style: (tagId == index)
                                      ? tSelectedTagTitle
                                      : tUnselectedTagTitle,
                                ),
                              ),
                            ),
                          )),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.fromLTRB(20 * fem, 0 * fem, 20 * fem, 20 * fem),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 5 * fem, vertical: 10 * fem),
                      child: Column(
                        children: [
                          Text(
                            "🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀 🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀",
                            style: tNewsTopTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
