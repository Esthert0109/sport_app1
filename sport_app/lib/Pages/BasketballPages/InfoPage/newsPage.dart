import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Component/Common/selectionButtonText.dart';

import '../../../Component/News/pinNewsComponent.dart';
import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/userDataModel.dart';
import '../../SearchPage/searchingPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'hotNewsPage.dart';
import 'infoPageDetail.dart';

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

  List<MockClass> topNewsList = [
    MockClass(
        title: '🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀', timeAgo: '1小时前', read: 1324),
    MockClass(
        title: '💥加莱诺读秒世界波绝杀，阿森纳全场零射正客场0-1波尔图。', timeAgo: '1小时前', read: 1654),
    MockClass(
        title: '🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀 💥加莱诺读秒世界波绝杀，阿森纳全场零射正客场0-1波尔图。',
        timeAgo: '1小时前',
        read: 64521)
  ];
  int topNewsLength = 0;

  List<String> img = [
    "https://apicms.thestar.com.my/uploads/images/2022/10/27/1793451.jpeg",
    "https://d3544la1u8djza.cloudfront.net/APHI/Blog/2016/10_October/persians/Persian+Cat+Facts+History+Personality+and+Care+_+ASPCA+Pet+Health+Insurance+_+white+Persian+cat+resting+on+a+brown+sofa-min.jpg",
    "https://www.dutch.com/cdn/shop/articles/shutterstock_538333303.jpg?v=1683242960",
    "https://i.ytimg.com/vi/xvQk-qV1070/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLCHK8qn2BR3DrfXETOUGrmen3kNlw",
    "https://us-tuna-sounds-images.voicemod.net/54a00490-7037-4e33-b837-061e21a639a1-1674436281444.png",
    "https://i.pinimg.com/280x280_RS/f7/64/9c/f7649c2a35ba2ad5d85a7474c4afa482.jpg"
  ];

  //variables
  bool _showAppBar = true;
  bool isScrollingDown = false;
  bool isLoading = false;
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

  void bottomScrollController() {
    if (_scrollController.position.userScrollDirection.toString() ==
        'ScrollDirection.reverse') {
      if (!isScrollingDown) {
        setState(() {
          isScrollingDown = true;
          _showAppBar = false;
        });
      }
    }

    if (_scrollController.position.userScrollDirection.toString() ==
        'ScrollDirection.forward') {
      if (isScrollingDown) {
        setState(() {
          isScrollingDown = false;
          _showAppBar = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(bottomScrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    tagLength = tagList.length;
    topNewsLength = topNewsList.length;

    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: kMainGreenColor));

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
                    child: InkWell(
                        onTap: () {
                          Get.to(() => HotNewsPage());
                        },
                        child: Image(image: AssetImage("images/info/hot.png"))),
                  )
                ],
              ),
            ),
            Expanded(
                child: LazyLoadScrollView(
              isLoading: isLoading,
              onEndOfPage: () {
                print("load more");
              },
              child: RefreshIndicator(
                color: kMainGreenColor,
                onRefresh: () async {
                  print("refresh");
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20 * fem, vertical: 10 * fem),
                        child: SelectionButtonTextComponent(
                            index: tagId,
                            selectionList: tagList,
                            isMainPage: false,
                            onTap: (index) {
                              setState(() {
                                tagId = index;
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            20 * fem, 0 * fem, 20 * fem, 10 * fem),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int index = 0;
                                  index < topNewsLength;
                                  index++)
                                InkWell(
                                  onTap: () {
                                    print("navi to news detail");
                                  },
                                  child: PinNewsComponent(
                                    title: topNewsList[index].title,
                                    timeAgo: topNewsList[index].timeAgo,
                                    read: topNewsList[index].read,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                        height: 183 * fem,
                        width: 343 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            print("navi to news info");
                          },
                          child: Swiper(
                            pagination: SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                color: kUnactivePaginationColor,
                                activeColor: kActivePaginationColor,
                                activeSize: 6,
                                size: 6,
                                space: 2,
                              ),
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15 * fem, vertical: 5 * fem),
                            ),
                            autoplay: true,
                            autoplayDelay: 3000,
                            viewportFraction: 0.95,
                            scale: 0.9,
                            itemCount: img.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 343 * fem,
                                  height: 183 * fem,
                                  child: Image(
                                    image: NetworkImage(img[index]),
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                          color: kMainGreenColor,
                                          size: 50 * fem,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10 * fem),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                print("navi into news info");
                                Get.to(() => InfoPageDetail(),
                                    transition: Transition.fadeIn);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10 * fem, horizontal: 10 * fem),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0 * fem, horizontal: 10 * fem),
                                height: 80 * fem,
                                // color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 100 * fem,
                                        height: 80 * fem,
                                        child: Image(
                                          image: NetworkImage(
                                            "https://i.redd.it/o6dt2yg2i90b1.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 80 * fem,
                                      width: 230 * fem,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10 * fem),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                              flex: 7,
                                              child: Text(
                                                "阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: tInfoTitle,
                                              )),
                                          Expanded(
                                              flex: 3,
                                              child: Text(
                                                "3002 " +
                                                    AppLocalizations.of(
                                                            context)!
                                                        .read,
                                                textAlign: TextAlign.right,
                                                style: tRead,
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

//mock class
class MockClass {
  final String title;
  final String timeAgo;
  final int read;

  MockClass({required this.title, required this.timeAgo, required this.read});
}
