import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Component/Common/statusButton.dart';
import '../../../Component/Common/statusDateButton.dart';
import '../../../Component/MainPage/gameDisplayComponent.dart';
import '../../../Component/MainPage/liveStreamCarouselComponent.dart';
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
  ScrollController _scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();

  // default button id
  int statusId = 0;
  int futureDateId = 0;
  int pastDateId = 6;

  //variables
  bool _showAppBar = true;
  bool isScrollingDown = false;
  bool isLoading = true;
  int item = 0;

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

  List<DateTime> generateFutureDates(int numberOfDays) {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < numberOfDays; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      dates.add(nextDay);
    }

    return dates;
  }

  List<DateTime> generatePastDates(int numberOfDays) {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < numberOfDays; i++) {
      DateTime pastDay = today.subtract(Duration(days: i));
      dates.add(pastDay);
    }

    return dates.reversed.toList();
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

    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent) {
    //   if (_scrollController.position.atEdge) {
    //     setState(() {
    //       print("add item");
    //       item += 10;
    //       print("item: $item");
    //     });
    //   }
    // }
  }

  Future<void> refresh() async {
    setState(() {
      print("refresh");
      statusId = 0;
      futureDateId = 0;
      pastDateId = 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    // status and date
    List<String> statusList = [
      AppLocalizations.of(context)!.started,
      AppLocalizations.of(context)!.yet,
      AppLocalizations.of(context)!.end
    ];

    List<DateTime> futureDateList = generateFutureDates(7);
    List<DateTime> pastDateList = generatePastDates(7);

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
            Expanded(
                child: LazyLoadScrollView(
              isLoading: isLoading,
              onEndOfPage: () {
                setState(() {
                  if (statusId == 0) {
                    print("started");
                  } else if (statusId == 1 && futureDateId == 0) {
                    print("future 1");
                  } else if (statusId == 1 && futureDateId == 1) {
                    print("future 2");
                  } else if (statusId == 1 && futureDateId == 2) {
                    print("future 3");
                  } else if (statusId == 1 && futureDateId == 3) {
                    print("future 4");
                  } else if (statusId == 1 && futureDateId == 4) {
                    print("future 5");
                  } else if (statusId == 1 && futureDateId == 5) {
                    print("future 6");
                  } else if (statusId == 1 && futureDateId == 6) {
                    print("future 7");
                  } else if (statusId == 2 && pastDateId == 0) {
                    print("past 1");
                  } else if (statusId == 2 && pastDateId == 1) {
                    print("past 2");
                  } else if (statusId == 2 && pastDateId == 2) {
                    print("past 3");
                  } else if (statusId == 2 && pastDateId == 3) {
                    print("past 4");
                  } else if (statusId == 2 && pastDateId == 4) {
                    print("past 5");
                  } else if (statusId == 2 && pastDateId == 5) {
                    print("past 6");
                  } else if (statusId == 2 && pastDateId == 6) {
                    print("past 7");
                  }
                });
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  refresh();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CarouselSlider.builder(
                        itemCount: 5,
                        options: CarouselOptions(
                            viewportFraction: 0.9,
                            autoPlay: true,
                            autoPlayAnimationDuration: Durations.long2),
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () async {},
                            child: LiveStreamCarousel(
                                title:
                                    "testinga aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaa",
                                anchor:
                                    "Testingaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                                anchorPhoto:
                                    "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                liveStreamPhoto:
                                    "https://images.chinatimes.com/newsphoto/2022-05-05/656/20220505001628.jpg"),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10 * fem, vertical: 10 * fem),
                        // padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 12 * fem),
                              child: Text(
                                AppLocalizations.of(context)!.competition,
                                style: tMain,
                              ),
                            ),

                            StatusButtonComponent(
                              statusId: statusId,
                              statusList: statusList,
                              onTap: (index) {
                                setState(() {
                                  statusId = index;
                                });
                              },
                            ),
                            (statusId == 1)
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10 * fem),
                                    child: StatusDateButtonComponent(
                                      dateId: futureDateId,
                                      dateList: futureDateList,
                                      isFuture: true,
                                      onTap: (index) {
                                        setState(() {
                                          futureDateId = index;
                                        });
                                      },
                                    ),
                                  )
                                : (statusId == 2)
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10 * fem),
                                        child: StatusDateButtonComponent(
                                          dateId: pastDateId,
                                          dateList: pastDateList,
                                          isFuture: false,
                                          onTap: (index) {
                                            setState(() {
                                              pastDateId = index;
                                            });
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                            // Expanded(child: child)

                            (statusId == 0)
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 10,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          print("navi into tournament");
                                        },
                                        child: GameDisplayComponent(
                                          id: 0,
                                          competitionType:
                                              "Iraqi League - Regular",
                                          duration: "12:59",
                                          teamAName: "Real Club Deportivo",
                                          teamALogo:
                                              'images/mainpage/sampleLogo.png',
                                          teamAScore: "12",
                                          teamBName:
                                              "Real Club Deportivo de La Coruña",
                                          teamBLogo:
                                              'images/mainpage/sampleLogo.png',
                                          teamBScore: "562",
                                          isSaved: true,
                                        ),
                                      );
                                    },
                                  )
                                : (statusId == 1 && futureDateId == 0)
                                    ? ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 10,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              print("navi into tournament");
                                            },
                                            child: GameDisplayComponent(
                                              id: 0,
                                              competitionType: "欧冠",
                                              duration: "12:59",
                                              teamAName: "马德里竞技足球俱乐部",
                                              teamALogo:
                                                  'images/mainpage/sampleLogo.png',
                                              teamAScore: "0",
                                              teamBName: "阿尔希拉尔体育俱乐部",
                                              teamBLogo:
                                                  'images/mainpage/sampleLogo.png',
                                              teamBScore: "562",
                                              isSaved: true,
                                            ),
                                          );
                                        },
                                      )
                                    : (statusId == 1 && futureDateId == 1)
                                        ? ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: 10,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  print("navi into tournament");
                                                },
                                                child: GameDisplayComponent(
                                                  id: 0,
                                                  competitionType:
                                                      "Iraqi League - Regular",
                                                  duration: "12:59",
                                                  teamAName:
                                                      "Real Club Deportivo",
                                                  teamALogo:
                                                      'images/mainpage/sampleLogo.png',
                                                  teamAScore: "12",
                                                  teamBName:
                                                      "Real Club Deportivo de La Coruña",
                                                  teamBLogo:
                                                      'images/mainpage/sampleLogo.png',
                                                  teamBScore: "562",
                                                  isSaved: true,
                                                ),
                                              );
                                            },
                                          )
                                        : (statusId == 1 && futureDateId == 2)
                                            ? ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: 10,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "navi into tournament");
                                                    },
                                                    child: GameDisplayComponent(
                                                      id: 0,
                                                      competitionType: "欧冠",
                                                      duration: "12:59",
                                                      teamAName: "马德里竞技足球俱乐部",
                                                      teamALogo:
                                                          'images/mainpage/sampleLogo.png',
                                                      teamAScore: "0",
                                                      teamBName: "阿尔希拉尔体育俱乐部",
                                                      teamBLogo:
                                                          'images/mainpage/sampleLogo.png',
                                                      teamBScore: "562",
                                                      isSaved: true,
                                                    ),
                                                  );
                                                },
                                              )
                                            : (statusId == 1 &&
                                                    futureDateId == 3)
                                                ? ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: 10,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "navi into tournament");
                                                        },
                                                        child:
                                                            GameDisplayComponent(
                                                          id: 0,
                                                          competitionType:
                                                              "Iraqi League - Regular",
                                                          duration: "12:59",
                                                          teamAName:
                                                              "Real Club Deportivo",
                                                          teamALogo:
                                                              'images/mainpage/sampleLogo.png',
                                                          teamAScore: "12",
                                                          teamBName:
                                                              "Real Club Deportivo de La Coruña",
                                                          teamBLogo:
                                                              'images/mainpage/sampleLogo.png',
                                                          teamBScore: "562",
                                                          isSaved: true,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : (statusId == 1 &&
                                                        futureDateId == 4)
                                                    ? ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: 10,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              print(
                                                                  "navi into tournament");
                                                            },
                                                            child:
                                                                GameDisplayComponent(
                                                              id: 0,
                                                              competitionType:
                                                                  "欧冠",
                                                              duration: "12:59",
                                                              teamAName:
                                                                  "马德里竞技足球俱乐部",
                                                              teamALogo:
                                                                  'images/mainpage/sampleLogo.png',
                                                              teamAScore: "0",
                                                              teamBName:
                                                                  "阿尔希拉尔体育俱乐部",
                                                              teamBLogo:
                                                                  'images/mainpage/sampleLogo.png',
                                                              teamBScore: "562",
                                                              isSaved: true,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : (statusId == 1 &&
                                                            futureDateId == 5)
                                                        ? ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: 10,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  print(
                                                                      "navi into tournament");
                                                                },
                                                                child:
                                                                    GameDisplayComponent(
                                                                  id: 0,
                                                                  competitionType:
                                                                      "Iraqi League - Regular",
                                                                  duration:
                                                                      "12:59",
                                                                  teamAName:
                                                                      "Real Club Deportivo",
                                                                  teamALogo:
                                                                      'images/mainpage/sampleLogo.png',
                                                                  teamAScore:
                                                                      "12",
                                                                  teamBName:
                                                                      "Real Club Deportivo de La Coruña",
                                                                  teamBLogo:
                                                                      'images/mainpage/sampleLogo.png',
                                                                  teamBScore:
                                                                      "562",
                                                                  isSaved: true,
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : (statusId == 1 &&
                                                                futureDateId ==
                                                                    6)
                                                            ? ListView.builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                itemCount: 10,
                                                                shrinkWrap:
                                                                    true,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "navi into tournament");
                                                                    },
                                                                    child:
                                                                        GameDisplayComponent(
                                                                      id: 0,
                                                                      competitionType:
                                                                          "欧冠",
                                                                      duration:
                                                                          "12:59",
                                                                      teamAName:
                                                                          "马德里竞技足球俱乐部",
                                                                      teamALogo:
                                                                          'images/mainpage/sampleLogo.png',
                                                                      teamAScore:
                                                                          "0",
                                                                      teamBName:
                                                                          "阿尔希拉尔体育俱乐部",
                                                                      teamBLogo:
                                                                          'images/mainpage/sampleLogo.png',
                                                                      teamBScore:
                                                                          "562",
                                                                      isSaved:
                                                                          true,
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : (statusId == 2 &&
                                                                    pastDateId ==
                                                                        0)
                                                                ? ListView
                                                                    .builder(
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount:
                                                                        10,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              "navi into tournament");
                                                                        },
                                                                        child:
                                                                            GameDisplayComponent(
                                                                          id: 0,
                                                                          competitionType:
                                                                              "欧冠",
                                                                          duration:
                                                                              "12:59",
                                                                          teamAName:
                                                                              "马德里竞技足球俱乐部",
                                                                          teamALogo:
                                                                              'images/mainpage/sampleLogo.png',
                                                                          teamAScore:
                                                                              "0",
                                                                          teamBName:
                                                                              "阿尔希拉尔体育俱乐部",
                                                                          teamBLogo:
                                                                              'images/mainpage/sampleLogo.png',
                                                                          teamBScore:
                                                                              "562",
                                                                          isSaved:
                                                                              true,
                                                                        ),
                                                                      );
                                                                    },
                                                                  )
                                                                : (statusId ==
                                                                            2 &&
                                                                        pastDateId ==
                                                                            1)
                                                                    ? ListView
                                                                        .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        itemCount:
                                                                            10,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              print("navi into tournament");
                                                                            },
                                                                            child:
                                                                                GameDisplayComponent(
                                                                              id: 0,
                                                                              competitionType: "Iraqi League - Regular",
                                                                              duration: "12:59",
                                                                              teamAName: "Real Club Deportivo",
                                                                              teamALogo: 'images/mainpage/sampleLogo.png',
                                                                              teamAScore: "12",
                                                                              teamBName: "Real Club Deportivo de La Coruña",
                                                                              teamBLogo: 'images/mainpage/sampleLogo.png',
                                                                              teamBScore: "562",
                                                                              isSaved: true,
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                    : (statusId ==
                                                                                2 &&
                                                                            pastDateId ==
                                                                                2)
                                                                        ? ListView
                                                                            .builder(
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            itemCount:
                                                                                10,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return GestureDetector(
                                                                                onTap: () {
                                                                                  print("navi into tournament");
                                                                                },
                                                                                child: GameDisplayComponent(
                                                                                  id: 0,
                                                                                  competitionType: "欧冠",
                                                                                  duration: "12:59",
                                                                                  teamAName: "马德里竞技足球俱乐部",
                                                                                  teamALogo: 'images/mainpage/sampleLogo.png',
                                                                                  teamAScore: "0",
                                                                                  teamBName: "阿尔希拉尔体育俱乐部",
                                                                                  teamBLogo: 'images/mainpage/sampleLogo.png',
                                                                                  teamBScore: "562",
                                                                                  isSaved: true,
                                                                                ),
                                                                              );
                                                                            },
                                                                          )
                                                                        : (statusId == 2 &&
                                                                                pastDateId == 3)
                                                                            ? ListView.builder(
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                itemCount: 10,
                                                                                shrinkWrap: true,
                                                                                itemBuilder: (context, index) {
                                                                                  return GestureDetector(
                                                                                    onTap: () {
                                                                                      print("navi into tournament");
                                                                                    },
                                                                                    child: GameDisplayComponent(
                                                                                      id: 0,
                                                                                      competitionType: "Iraqi League - Regular",
                                                                                      duration: "12:59",
                                                                                      teamAName: "Real Club Deportivo",
                                                                                      teamALogo: 'images/mainpage/sampleLogo.png',
                                                                                      teamAScore: "12",
                                                                                      teamBName: "Real Club Deportivo de La Coruña",
                                                                                      teamBLogo: 'images/mainpage/sampleLogo.png',
                                                                                      teamBScore: "562",
                                                                                      isSaved: true,
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              )
                                                                            : (statusId == 2 && pastDateId == 4)
                                                                                ? ListView.builder(
                                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                                    itemCount: 10,
                                                                                    shrinkWrap: true,
                                                                                    itemBuilder: (context, index) {
                                                                                      return GestureDetector(
                                                                                        onTap: () {
                                                                                          print("navi into tournament");
                                                                                        },
                                                                                        child: GameDisplayComponent(
                                                                                          id: 0,
                                                                                          competitionType: "欧冠",
                                                                                          duration: "12:59",
                                                                                          teamAName: "马德里竞技足球俱乐部",
                                                                                          teamALogo: 'images/mainpage/sampleLogo.png',
                                                                                          teamAScore: "0",
                                                                                          teamBName: "阿尔希拉尔体育俱乐部",
                                                                                          teamBLogo: 'images/mainpage/sampleLogo.png',
                                                                                          teamBScore: "562",
                                                                                          isSaved: true,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  )
                                                                                : (statusId == 2 && pastDateId == 5)
                                                                                    ? ListView.builder(
                                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                                        itemCount: 10,
                                                                                        shrinkWrap: true,
                                                                                        itemBuilder: (context, index) {
                                                                                          return GestureDetector(
                                                                                            onTap: () {
                                                                                              print("navi into tournament");
                                                                                            },
                                                                                            child: GameDisplayComponent(
                                                                                              id: 0,
                                                                                              competitionType: "Iraqi League - Regular",
                                                                                              duration: "12:59",
                                                                                              teamAName: "Real Club Deportivo",
                                                                                              teamALogo: 'images/mainpage/sampleLogo.png',
                                                                                              teamAScore: "12",
                                                                                              teamBName: "Real Club Deportivo de La Coruña",
                                                                                              teamBLogo: 'images/mainpage/sampleLogo.png',
                                                                                              teamBScore: "562",
                                                                                              isSaved: true,
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      )
                                                                                    : (statusId == 2 && pastDateId == 6)
                                                                                        ? ListView.builder(
                                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                                            itemCount: 10,
                                                                                            shrinkWrap: true,
                                                                                            itemBuilder: (context, index) {
                                                                                              return GestureDetector(
                                                                                                onTap: () {
                                                                                                  print("navi into tournament");
                                                                                                },
                                                                                                child: GameDisplayComponent(
                                                                                                  id: 0,
                                                                                                  competitionType: "欧冠",
                                                                                                  duration: "12:59",
                                                                                                  teamAName: "马德里竞技足球俱乐部",
                                                                                                  teamALogo: 'images/mainpage/sampleLogo.png',
                                                                                                  teamAScore: "0",
                                                                                                  teamBName: "阿尔希拉尔体育俱乐部",
                                                                                                  teamBLogo: 'images/mainpage/sampleLogo.png',
                                                                                                  teamBScore: "562",
                                                                                                  isSaved: false,
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          )
                                                                                        : Container(),
                            isLoading
                                ? Center(
                                    child: Lottie.asset(
                                      'images/common/pandahappy.json', // Replace 'loading.json' with the path to your Lottie animation
                                      width: 250, // Adjust the width as needed
                                      height:
                                          250, // Adjust the height as needed
                                    ),
                                  )
                                : Center(),
                          ],
                        ),
                      ),
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
