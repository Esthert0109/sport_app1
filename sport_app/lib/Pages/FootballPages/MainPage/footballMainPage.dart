import 'package:card_loading/card_loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Provider/footballMatchProvider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../Component/Common/loadingScreen.dart';
import '../../../Component/Common/snackBar.dart';
import '../../../Component/Common/statusButton.dart';
import '../../../Component/Common/statusDateButton.dart';
import '../../../Component/MainPage/gameDisplayComponent.dart';
import '../../../Component/MainPage/liveStreamCarouselComponent.dart';
import '../../../Component/Tencent/liveStreamPlayer.dart';
import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/liveStreamModel.dart';
import '../../../Model/matchesModel.dart';
import '../../../Model/userDataModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../Provider/liveStreamProvider.dart';
import '../../../Services/Utils/tencent/tencentLiveUtils.dart';
import '../../BasketballPages/basketballTournamentDetails.dart';
import '../../TencentLiveStreamRoom/liveStreamChatRoom.dart';
import '../footballTournamentDetails.dart';

class FootballMainPage extends StatefulWidget {
  const FootballMainPage({super.key});

  @override
  State<FootballMainPage> createState() => _FootballMainPageState();
}

class _FootballMainPageState extends State<FootballMainPage>
    with SingleTickerProviderStateMixin {
  //get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  //controller
  ScrollController _scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();
  TextEditingController _searchController = TextEditingController();

  // services and provider
  LiveStreamProvider liveStreamProvider = LiveStreamProvider();
  FootballMatchProvider matchesProvider = FootballMatchProvider();

  // fetch data from provider
  DateTime now = DateTime.now();
  int size = 10;
  List<FootballMatchesData> startedList = [];
  int startedLength = 0;
  int pageStarted = 1;
  List<FootballMatchesData> futureList1 = [];
  int future1Length = 0;
  int pageFuture1 = 1;
  List<FootballMatchesData> futureList2 = [];
  int future2Length = 0;
  int pageFuture2 = 1;
  List<FootballMatchesData> futureList3 = [];
  int future3Length = 0;
  int pageFuture3 = 1;
  List<FootballMatchesData> futureList4 = [];
  int future4Length = 0;
  int pageFuture4 = 1;
  List<FootballMatchesData> futureList5 = [];
  int future5Length = 0;
  int pageFuture5 = 1;
  List<FootballMatchesData> futureList6 = [];
  int future6Length = 0;
  int pageFuture6 = 1;
  List<FootballMatchesData> futureList7 = [];
  int future7Length = 0;
  int pageFuture7 = 1;
  List<FootballMatchesData> pastList1 = [];
  int past1Length = 0;
  int pagePast1 = 1;
  List<FootballMatchesData> pastList2 = [];
  int past2Length = 0;
  int pagePast2 = 1;
  List<FootballMatchesData> pastList3 = [];
  int past3Length = 0;
  int pagePast3 = 1;
  List<FootballMatchesData> pastList4 = [];
  int past4Length = 0;
  int pagePast4 = 1;
  List<FootballMatchesData> pastList5 = [];
  int past5Length = 0;
  int pagePast5 = 1;
  List<FootballMatchesData> pastList6 = [];
  int past6Length = 0;
  int pagePast6 = 1;
  List<FootballMatchesData> pastList7 = [];
  int past7Length = 0;
  int pagePast7 = 1;

  List<LiveStreamData> liveStreamList = [];
  int liveStreamLength = 0;

  // default button id
  int statusId = 0;
  int futureDateId = 0;
  int pastDateId = 6;

  //variables
  bool _showAppBar = true;
  bool isScrollingDown = false;
  bool isCarouselLoading = false;
  bool isEventLoading = false;
  bool isLoading = false;
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

  // fetch live stream room data
  Future<void> getPopularLiveStreamRoomList() async {
    LiveStreamModel? liveStreamModel =
        await liveStreamProvider.getPopularLiveStreamList();

    if (!isCarouselLoading) {
      setState(() {
        isCarouselLoading = true;
      });
      liveStreamList.addAll(liveStreamModel?.data ?? []);
      liveStreamLength = liveStreamList.length;
      setState(() {
        isCarouselLoading = false;
      });
    }
  }

  String getStreamURL(streamUrl) {
    int index = streamUrl.indexOf('?');
    if (index != -1) {
      String result = streamUrl.substring(0, index);
      return result;
    } else {
      print('No match found');
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(bottomScrollController);
    getStartedEventList();
    getPopularLiveStreamRoomList();
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
  }

  // get event
  Future<void> getStartedEventList() async {
    FootballStartedMatchesModel? startedMatchesModel =
        await matchesProvider.getStartedEventList(pageStarted, size);

    if (!isEventLoading) {
      setState(() {
        isEventLoading = true;
      });
      startedList.addAll(startedMatchesModel?.data.start ?? []);
      startedLength = startedList.length;

      setState(() {
        isEventLoading = false;
        pageStarted++;
      });
    }
  }

  Future<void> getEventListByDate() async {
    if (!isEventLoading) {
      setState(() {
        isEventLoading = true;
      });

      if (statusId == 1) {
        List<DateTime> futureDate = generateFutureDates(7);
        DateTime date = futureDate[futureDateId];
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        if (futureDateId == 0) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture1, size, true);

          futureList1.addAll(matchesModel?.data ?? []);
          future1Length = futureList1.length;

          setState(() {
            isEventLoading = false;
            pageFuture1++;
          });
        } else if (futureDateId == 1) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture2, size, true);

          futureList2.addAll(matchesModel?.data ?? []);
          future2Length = futureList2.length;

          setState(() {
            isEventLoading = false;
            pageFuture2++;
          });
        } else if (futureDateId == 2) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture3, size, true);

          futureList3.addAll(matchesModel?.data ?? []);
          future3Length = futureList3.length;

          setState(() {
            isEventLoading = false;
            pageFuture3++;
          });
        } else if (futureDateId == 3) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture4, size, true);

          futureList4.addAll(matchesModel?.data ?? []);
          future4Length = futureList4.length;

          setState(() {
            isEventLoading = false;
            pageFuture4++;
          });
        } else if (futureDateId == 4) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture5, size, true);

          futureList5.addAll(matchesModel?.data ?? []);
          future5Length = futureList5.length;

          setState(() {
            isEventLoading = false;
            pageFuture5++;
          });
        } else if (futureDateId == 5) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture6, size, true);

          futureList6.addAll(matchesModel?.data ?? []);
          future6Length = futureList6.length;

          setState(() {
            isEventLoading = false;
            pageFuture6++;
          });
        } else if (futureDateId == 6) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pageFuture7, size, true);

          futureList7.addAll(matchesModel?.data ?? []);
          future7Length = futureList7.length;

          setState(() {
            isEventLoading = false;
            pageFuture7++;
          });
        }
      } else {
        List<DateTime> pastDate = generatePastDates(7);
        DateTime date = pastDate[futureDateId];
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        if (futureDateId == 0) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast1, size, false);

          pastList1.addAll(matchesModel?.data ?? []);
          past1Length = pastList1.length;

          setState(() {
            isEventLoading = false;
            pagePast1++;
          });
        } else if (pastDateId == 1) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast2, size, false);

          pastList2.addAll(matchesModel?.data ?? []);
          past2Length = pastList2.length;

          setState(() {
            isEventLoading = false;
            pagePast2++;
          });
        } else if (pastDateId == 2) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast3, size, false);

          pastList3.addAll(matchesModel?.data ?? []);
          past3Length = pastList3.length;

          setState(() {
            isEventLoading = false;
            pagePast3++;
          });
        } else if (pastDateId == 3) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast4, size, false);

          pastList4.addAll(matchesModel?.data ?? []);
          past4Length = pastList4.length;

          setState(() {
            isEventLoading = false;
            pagePast4++;
          });
        } else if (pastDateId == 4) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast5, size, false);

          pastList5.addAll(matchesModel?.data ?? []);
          past5Length = pastList5.length;

          setState(() {
            isEventLoading = false;
            pagePast5++;
          });
        } else if (pastDateId == 5) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast6, size, false);

          pastList6.addAll(matchesModel?.data ?? []);
          past6Length = pastList6.length;

          setState(() {
            isEventLoading = false;
            pagePast6++;
          });
        } else if (pastDateId == 6) {
          FootballMatchesModel? matchesModel = await matchesProvider
              .getEventByDate(formattedDate, pagePast7, size, false);

          pastList7.addAll(matchesModel?.data ?? []);
          past7Length = pastList7.length;

          setState(() {
            isEventLoading = false;
            pagePast7++;
          });
        }
      }
      setState(() {
        isEventLoading = false;
      });
    }
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
                      // getStartedEventList();
                    } else {
                      // getEventListByDate();
                    }
                  });
                },
                child: RefreshIndicator(
                  color: kMainGreenColor,
                  onRefresh: () async {
                    // refresh
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        isCarouselLoading
                            ? CardLoading(
                                height: 185 * fem,
                                borderRadius: BorderRadius.circular(8 * fem),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10 * fem, vertical: 10 * fem),
                              )
                            : (liveStreamLength == 0)
                                ? Container(
                                    width: 328 * fem,
                                    height: 183 * fem,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10 * fem),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8 * fem),
                                          child: Image.asset(
                                            userModel.isCN.value
                                                ? "images/myPage/NoStreamCN.png"
                                                : "images/myPage/NoStreamEN.png",
                                            fit: BoxFit.cover,
                                            width: 328 * fem,
                                            height: 183 * fem,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : CarouselSlider.builder(
                                    itemCount: liveStreamLength,
                                    options: CarouselOptions(
                                        viewportFraction: 0.9,
                                        autoPlay: true,
                                        autoPlayAnimationDuration:
                                            Durations.long2),
                                    itemBuilder: (context, index, realIndex) {
                                      return GestureDetector(
                                        onTap: () async {
                                          showLoadingDialog(context);
                                          V2TimValueCallback<int>
                                              userLoginStatusRes =
                                              await TencentImSDKPlugin
                                                  .v2TIMManager
                                                  .getLoginStatus();
                                          if (userLoginStatusRes.code == 0) {
                                            int? status =
                                                userLoginStatusRes.data;

                                            if (status == 1) {
                                              LiveStreamChatRoom page = LiveStreamChatRoom(
                                                  userLoginId: userModel
                                                      .id.value,
                                                  avChatRoomId:
                                                      "panda${liveStreamList![index].userId}",
                                                  anchor: liveStreamList![index]
                                                          .nickName ??
                                                      "",
                                                  streamTitle: liveStreamList![
                                                              index]
                                                          .title ??
                                                      "",
                                                  anchorPic: liveStreamList![
                                                              index]
                                                          .avatar ??
                                                      "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                                  playMode: V2TXLivePlayMode
                                                      .v2TXLivePlayModeLeb,
                                                  liveURL:
                                                      "rtmp://play.mindark.cloud/live/" +
                                                          getStreamURL(
                                                              liveStreamList![
                                                                      index]
                                                                  .pushCode));

                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          page));
                                            } else if (status == 2) {
                                              //logined
                                            } else if (status == 3) {
                                              bool isChangeNickname =
                                                  await userLogin(
                                                userModel.id.value,
                                              );
                                              if (isChangeNickname) {
                                                LiveStreamChatRoom page = LiveStreamChatRoom(
                                                    userLoginId:
                                                        userModel.id.value,
                                                    avChatRoomId:
                                                        "panda${liveStreamList![index].userId}",
                                                    anchor: liveStreamList![
                                                                index]
                                                            .nickName ??
                                                        "",
                                                    streamTitle:
                                                        liveStreamList![index]
                                                                .title ??
                                                            "",
                                                    anchorPic: liveStreamList![
                                                                index]
                                                            .avatar ??
                                                        "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                                    playMode: V2TXLivePlayMode
                                                        .v2TXLivePlayModeLeb,
                                                    liveURL:
                                                        "rtmp://play.mindark.cloud/live/" +
                                                            getStreamURL(
                                                                liveStreamList![
                                                                        index]
                                                                    .pushCode));

                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            page));
                                              }
                                            } else {
                                              Navigator.of(context).pop();
                                              openSnackbar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .noInternet,
                                                  kComponentErrorTextColor);
                                            }
                                          }
                                        },
                                        child: LiveStreamCarousel(
                                            title:
                                                liveStreamList[index].title ??
                                                    "",
                                            anchor: liveStreamList[index]
                                                    .nickName ??
                                                "",
                                            anchorPhoto: liveStreamList[index]
                                                    .avatar ??
                                                "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                            liveStreamPhoto: liveStreamList[
                                                        index]
                                                    .cover ??
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
                              Container(
                                height: 58 * fem,
                                margin: EdgeInsets.fromLTRB(
                                    10 * fem, 0, 10 * fem, 10 * fem),
                                child: Image(
                                    image: AssetImage(
                                        "images/mainpage/advertisement.png")),
                              ),
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
                                    if (statusId == 0) {
                                      startedList.clear();
                                      startedLength = startedList.length;
                                      pageStarted = 1;
                                      getStartedEventList();
                                    } else {
                                      futureDateId = 0;
                                      futureList1.clear();
                                      futureList2.clear();
                                      futureList3.clear();
                                      futureList4.clear();
                                      futureList5.clear();
                                      futureList6.clear();
                                      futureList7.clear();
                                      pastList1.clear();
                                      pastList2.clear();
                                      pastList3.clear();
                                      pastList4.clear();
                                      pastList5.clear();
                                      pastList6.clear();
                                      pastList7.clear();
                                      future1Length = futureList1.length;
                                      future2Length = futureList2.length;
                                      future3Length = futureList3.length;
                                      future4Length = futureList4.length;
                                      future5Length = futureList5.length;
                                      future6Length = futureList6.length;
                                      future7Length = futureList7.length;
                                      past1Length = pastList1.length;
                                      past2Length = pastList2.length;
                                      past3Length = pastList3.length;
                                      past4Length = pastList4.length;
                                      past5Length = pastList5.length;
                                      past6Length = pastList6.length;
                                      past7Length = pastList7.length;
                                      pageFuture1 = 1;
                                      pageFuture2 = 1;
                                      pageFuture3 = 1;
                                      pageFuture4 = 1;
                                      pageFuture5 = 1;
                                      pageFuture6 = 1;
                                      pageFuture7 = 1;
                                      pagePast1 = 1;
                                      pagePast2 = 1;
                                      pagePast3 = 1;
                                      pagePast4 = 1;
                                      pagePast5 = 1;
                                      pagePast6 = 1;
                                      pagePast7 = 1;
                                      // getEventListByDate();
                                    }
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
                                            // getEventListByDate();
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
                                                // getEventListByDate();
                                              });
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                              (statusId == 0)
                                  ? isEventLoading
                                      ? Column(children: [
                                          for (int i = 0; i < 4; i++)
                                            CardLoading(
                                              height: 100 * fem,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8 * fem),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10 * fem,
                                                  vertical: 10 * fem),
                                            ),
                                        ])
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: startedLength,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                print("navi into tournament");
                                                TournamentDetails(
                                                  id: '${startedList?[index].id}',
                                                  matchDate:
                                                      '${startedList?[index].matchDate}',
                                                  matchStatus: '未开赛',
                                                  matchName:
                                                      '${startedList?[index].competitionName}',
                                                  homeTeamFormation:
                                                      '${startedList?[index].homeFormation}',
                                                  awayTeamFormation:
                                                      '${startedList?[index].awayFormation}',
                                                  lineUp: startedList?[index]
                                                          .lineUp ??
                                                      0,
                                                ).launch(context);
                                              },
                                              child: GameDisplayComponent(
                                                id: startedList[index].id ?? 0,
                                                competitionType:
                                                    startedList[index]
                                                            .competitionName ??
                                                        "",
                                                duration: startedList[index]
                                                        .matchTimeStr ??
                                                    "00:00",
                                                teamAName: startedList[index]
                                                        .homeTeamName ??
                                                    "",
                                                teamALogo: startedList[index]
                                                        .homeTeamLogo ??
                                                    'images/mainpage/sampleLogo.png',
                                                teamAScore: startedList[index]
                                                    .homeTeamScore
                                                    .toString(),
                                                teamBName: startedList[index]
                                                        .awayTeamName ??
                                                    "",
                                                teamBLogo: startedList[index]
                                                        .awayTeamLogo ??
                                                    'images/mainpage/sampleLogo.png',
                                                teamBScore: startedList[index]
                                                    .awayTeamScore
                                                    .toString(),
                                                isSaved: startedList[index]
                                                        .hasCollected ??
                                                    false,
                                              ),
                                            );
                                          },
                                        )
                                  : (statusId == 1 && futureDateId == 0)
                                      ? isEventLoading
                                          ? Column(children: [
                                              if (future1Length < 4)
                                                for (int i = 0; i < 4; i++)
                                                  CardLoading(
                                                    height: 100 * fem,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8 * fem),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10 * fem,
                                                            vertical: 10 * fem),
                                                  ),
                                              for (int i = 0;
                                                  i < future1Length;
                                                  i++)
                                                CardLoading(
                                                  height: 100 * fem,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8 * fem),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10 * fem,
                                                      vertical: 10 * fem),
                                                ),
                                            ])
                                          : ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: future1Length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        "navi into tournament");
                                                    TournamentDetails(
                                                      id: '${futureList1[index].id}',
                                                      matchDate:
                                                          '${futureList1[index].matchDate}',
                                                      matchStatus: '未开赛',
                                                      matchName:
                                                          '${futureList1[index].competitionName}',
                                                      homeTeamFormation:
                                                          '${futureList1[index].homeFormation}',
                                                      awayTeamFormation:
                                                          '${futureList1[index].awayFormation}',
                                                      lineUp: futureList1[index]
                                                              .lineUp ??
                                                          0,
                                                    ).launch(context);
                                                  },
                                                  child: GameDisplayComponent(
                                                    id: futureList1[index].id ??
                                                        0,
                                                    competitionType: futureList1[
                                                                index]
                                                            .competitionName ??
                                                        "",
                                                    duration: futureList1[index]
                                                            .matchTimeStr ??
                                                        "00:00",
                                                    teamAName:
                                                        futureList1[index]
                                                                .homeTeamName ??
                                                            "",
                                                    teamALogo: futureList1[
                                                                index]
                                                            .homeTeamLogo ??
                                                        'images/mainpage/sampleLogo.png',
                                                    teamAScore:
                                                        futureList1[index]
                                                            .homeTeamScore
                                                            .toString(),
                                                    teamBName:
                                                        futureList1[index]
                                                                .awayTeamName ??
                                                            "",
                                                    teamBLogo: futureList1[
                                                                index]
                                                            .awayTeamLogo ??
                                                        'images/mainpage/sampleLogo.png',
                                                    teamBScore:
                                                        futureList1[index]
                                                            .awayTeamScore
                                                            .toString(),
                                                    isSaved: futureList1[index]
                                                            .hasCollected ??
                                                        false,
                                                  ),
                                                );
                                              },
                                            )
                                      : (statusId == 1 && futureDateId == 1)
                                          ? isEventLoading
                                              ? Column(children: [
                                                  Column(children: [
                                                    if (future2Length < 4)
                                                      for (int i = 0;
                                                          i < 4;
                                                          i++)
                                                        CardLoading(
                                                          height: 100 * fem,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8 * fem),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10 * fem,
                                                                  vertical:
                                                                      10 * fem),
                                                        ),
                                                    for (int i = 0;
                                                        i < future2Length;
                                                        i++)
                                                      CardLoading(
                                                        height: 100 * fem,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8 * fem),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10 * fem,
                                                                vertical:
                                                                    10 * fem),
                                                      ),
                                                  ])
                                                ])
                                              : ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: future2Length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            "navi into tournament");
                                                        TournamentDetails(
                                                          id: '${futureList2[index].id}',
                                                          matchDate:
                                                              '${futureList2[index].matchDate}',
                                                          matchStatus: '未开赛',
                                                          matchName:
                                                              '${futureList2[index].competitionName}',
                                                          homeTeamFormation:
                                                              '${futureList2[index].homeFormation}',
                                                          awayTeamFormation:
                                                              '${futureList2[index].awayFormation}',
                                                          lineUp:
                                                              futureList2[index]
                                                                      .lineUp ??
                                                                  0,
                                                        ).launch(context);
                                                      },
                                                      child:
                                                          GameDisplayComponent(
                                                        id: futureList2[index]
                                                                .id ??
                                                            0,
                                                        competitionType:
                                                            futureList2[index]
                                                                    .competitionName ??
                                                                "",
                                                        duration: futureList2[
                                                                    index]
                                                                .matchTimeStr ??
                                                            "00:00",
                                                        teamAName: futureList2[
                                                                    index]
                                                                .homeTeamName ??
                                                            "",
                                                        teamALogo: futureList2[
                                                                    index]
                                                                .homeTeamLogo ??
                                                            'images/mainpage/sampleLogo.png',
                                                        teamAScore:
                                                            futureList2[index]
                                                                .homeTeamScore
                                                                .toString(),
                                                        teamBName: futureList2[
                                                                    index]
                                                                .awayTeamName ??
                                                            "",
                                                        teamBLogo: futureList2[
                                                                    index]
                                                                .awayTeamLogo ??
                                                            'images/mainpage/sampleLogo.png',
                                                        teamBScore:
                                                            futureList2[index]
                                                                .awayTeamScore
                                                                .toString(),
                                                        isSaved: futureList2[
                                                                    index]
                                                                .hasCollected ??
                                                            false,
                                                      ),
                                                    );
                                                  },
                                                )
                                          : (statusId == 1 && futureDateId == 2)
                                              ? isEventLoading
                                                  ? Column(children: [
                                                      Column(children: [
                                                        if (future3Length < 4)
                                                          for (int i = 0;
                                                              i < 4;
                                                              i++)
                                                            CardLoading(
                                                              height: 100 * fem,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8 * fem),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10 *
                                                                              fem,
                                                                      vertical:
                                                                          10 *
                                                                              fem),
                                                            ),
                                                        for (int i = 0;
                                                            i < future3Length;
                                                            i++)
                                                          CardLoading(
                                                            height: 100 * fem,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8 * fem),
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10 *
                                                                            fem,
                                                                    vertical:
                                                                        10 *
                                                                            fem),
                                                          ),
                                                      ])
                                                    ])
                                                  : ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: future3Length,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                "navi into tournament");
                                                            TournamentDetails(
                                                              id: '${futureList3[index].id}',
                                                              matchDate:
                                                                  '${futureList3[index].matchDate}',
                                                              matchStatus:
                                                                  '未开赛',
                                                              matchName:
                                                                  '${futureList3[index].competitionName}',
                                                              homeTeamFormation:
                                                                  '${futureList3[index].homeFormation}',
                                                              awayTeamFormation:
                                                                  '${futureList3[index].awayFormation}',
                                                              lineUp: futureList3[
                                                                          index]
                                                                      .lineUp ??
                                                                  0,
                                                            ).launch(context);
                                                          },
                                                          child:
                                                              GameDisplayComponent(
                                                            id: futureList3[
                                                                        index]
                                                                    .id ??
                                                                0,
                                                            competitionType:
                                                                futureList3[index]
                                                                        .competitionName ??
                                                                    "",
                                                            duration: futureList3[
                                                                        index]
                                                                    .matchTimeStr ??
                                                                "00:00",
                                                            teamAName: futureList3[
                                                                        index]
                                                                    .homeTeamName ??
                                                                "",
                                                            teamALogo: futureList3[
                                                                        index]
                                                                    .homeTeamLogo ??
                                                                'images/mainpage/sampleLogo.png',
                                                            teamAScore:
                                                                futureList3[
                                                                        index]
                                                                    .homeTeamScore
                                                                    .toString(),
                                                            teamBName: futureList3[
                                                                        index]
                                                                    .awayTeamName ??
                                                                "",
                                                            teamBLogo: futureList3[
                                                                        index]
                                                                    .awayTeamLogo ??
                                                                'images/mainpage/sampleLogo.png',
                                                            teamBScore:
                                                                futureList3[
                                                                        index]
                                                                    .awayTeamScore
                                                                    .toString(),
                                                            isSaved: futureList3[
                                                                        index]
                                                                    .hasCollected ??
                                                                false,
                                                          ),
                                                        );
                                                      },
                                                    )
                                              : (statusId == 1 &&
                                                      futureDateId == 3)
                                                  ? isEventLoading
                                                      ? Column(children: [
                                                          Column(children: [
                                                            if (future4Length <
                                                                4)
                                                              for (int i = 0;
                                                                  i < 4;
                                                                  i++)
                                                                CardLoading(
                                                                  height:
                                                                      100 * fem,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(8 *
                                                                              fem),
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10 *
                                                                              fem,
                                                                      vertical:
                                                                          10 *
                                                                              fem),
                                                                ),
                                                            for (int i = 0;
                                                                i < future4Length;
                                                                i++)
                                                              CardLoading(
                                                                height:
                                                                    100 * fem,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8 *
                                                                            fem),
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10 *
                                                                            fem,
                                                                    vertical:
                                                                        10 *
                                                                            fem),
                                                              ),
                                                          ])
                                                        ])
                                                      : ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              future4Length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "navi into tournament");
                                                                TournamentDetails(
                                                                  id: '${futureList4[index].id}',
                                                                  matchDate:
                                                                      '${futureList4[index].matchDate}',
                                                                  matchStatus:
                                                                      '未开赛',
                                                                  matchName:
                                                                      '${futureList4[index].competitionName}',
                                                                  homeTeamFormation:
                                                                      '${futureList4[index].homeFormation}',
                                                                  awayTeamFormation:
                                                                      '${futureList4[index].awayFormation}',
                                                                  lineUp: futureList4[
                                                                              index]
                                                                          .lineUp ??
                                                                      0,
                                                                ).launch(
                                                                    context);
                                                              },
                                                              child:
                                                                  GameDisplayComponent(
                                                                id: futureList4[
                                                                            index]
                                                                        .id ??
                                                                    0,
                                                                competitionType:
                                                                    futureList4[index]
                                                                            .competitionName ??
                                                                        "",
                                                                duration: futureList4[
                                                                            index]
                                                                        .matchTimeStr ??
                                                                    "00:00",
                                                                teamAName: futureList4[
                                                                            index]
                                                                        .homeTeamName ??
                                                                    "",
                                                                teamALogo: futureList4[
                                                                            index]
                                                                        .homeTeamLogo ??
                                                                    'images/mainpage/sampleLogo.png',
                                                                teamAScore: futureList4[
                                                                        index]
                                                                    .homeTeamScore
                                                                    .toString(),
                                                                teamBName: futureList4[
                                                                            index]
                                                                        .awayTeamName ??
                                                                    "",
                                                                teamBLogo: futureList4[
                                                                            index]
                                                                        .awayTeamLogo ??
                                                                    'images/mainpage/sampleLogo.png',
                                                                teamBScore: futureList4[
                                                                        index]
                                                                    .awayTeamScore
                                                                    .toString(),
                                                                isSaved: futureList4[
                                                                            index]
                                                                        .hasCollected ??
                                                                    false,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                  : (statusId == 1 &&
                                                          futureDateId == 4)
                                                      ? isEventLoading
                                                          ? Column(children: [
                                                              Column(children: [
                                                                if (future5Length <
                                                                    4)
                                                                  for (int i =
                                                                          0;
                                                                      i < 4;
                                                                      i++)
                                                                    CardLoading(
                                                                      height:
                                                                          100 *
                                                                              fem,
                                                                      borderRadius:
                                                                          BorderRadius.circular(8 *
                                                                              fem),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: 10 *
                                                                              fem,
                                                                          vertical:
                                                                              10 * fem),
                                                                    ),
                                                                for (int i = 0;
                                                                    i < future5Length;
                                                                    i++)
                                                                  CardLoading(
                                                                    height:
                                                                        100 *
                                                                            fem,
                                                                    borderRadius:
                                                                        BorderRadius.circular(8 *
                                                                            fem),
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10 *
                                                                                fem,
                                                                        vertical:
                                                                            10 *
                                                                                fem),
                                                                  ),
                                                              ])
                                                            ])
                                                          : ListView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  future5Length,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        "navi into tournament");
                                                                    TournamentDetails(
                                                                      id: '${futureList5[index].id}',
                                                                      matchDate:
                                                                          '${futureList5[index].matchDate}',
                                                                      matchStatus:
                                                                          '未开赛',
                                                                      matchName:
                                                                          '${futureList5[index].competitionName}',
                                                                      homeTeamFormation:
                                                                          '${futureList5[index].homeFormation}',
                                                                      awayTeamFormation:
                                                                          '${futureList5[index].awayFormation}',
                                                                      lineUp:
                                                                          futureList5[index].lineUp ??
                                                                              0,
                                                                    ).launch(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      GameDisplayComponent(
                                                                    id: futureList5[index]
                                                                            .id ??
                                                                        0,
                                                                    competitionType:
                                                                        futureList5[index].competitionName ??
                                                                            "",
                                                                    duration: futureList5[index]
                                                                            .matchTimeStr ??
                                                                        "00:00",
                                                                    teamAName:
                                                                        futureList5[index].homeTeamName ??
                                                                            "",
                                                                    teamALogo: futureList5[index]
                                                                            .homeTeamLogo ??
                                                                        'images/mainpage/sampleLogo.png',
                                                                    teamAScore: futureList5[
                                                                            index]
                                                                        .homeTeamScore
                                                                        .toString(),
                                                                    teamBName:
                                                                        futureList5[index].awayTeamName ??
                                                                            "",
                                                                    teamBLogo: futureList5[index]
                                                                            .awayTeamLogo ??
                                                                        'images/mainpage/sampleLogo.png',
                                                                    teamBScore: futureList5[
                                                                            index]
                                                                        .awayTeamScore
                                                                        .toString(),
                                                                    isSaved: futureList5[index]
                                                                            .hasCollected ??
                                                                        false,
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                      : (statusId == 1 &&
                                                              futureDateId == 5)
                                                          ? isEventLoading
                                                              ? Column(
                                                                  children: [
                                                                      Column(
                                                                          children: [
                                                                            if (future6Length <
                                                                                4)
                                                                              for (int i = 0; i < 4; i++)
                                                                                CardLoading(
                                                                                  height: 100 * fem,
                                                                                  borderRadius: BorderRadius.circular(8 * fem),
                                                                                  margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                ),
                                                                            for (int i = 0;
                                                                                i < future6Length;
                                                                                i++)
                                                                              CardLoading(
                                                                                height: 100 * fem,
                                                                                borderRadius: BorderRadius.circular(8 * fem),
                                                                                margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                              ),
                                                                          ])
                                                                    ])
                                                              : ListView
                                                                  .builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  itemCount:
                                                                      future6Length,
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
                                                                        TournamentDetails(
                                                                          id: '${futureList6[index].id}',
                                                                          matchDate:
                                                                              '${futureList6[index].matchDate}',
                                                                          matchStatus:
                                                                              '未开赛',
                                                                          matchName:
                                                                              '${futureList6[index].competitionName}',
                                                                          homeTeamFormation:
                                                                              '${futureList6[index].homeFormation}',
                                                                          awayTeamFormation:
                                                                              '${futureList6[index].awayFormation}',
                                                                          lineUp:
                                                                              futureList6[index].lineUp ?? 0,
                                                                        ).launch(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          GameDisplayComponent(
                                                                        id: futureList6[index].id ??
                                                                            0,
                                                                        competitionType:
                                                                            futureList6[index].competitionName ??
                                                                                "",
                                                                        duration:
                                                                            futureList6[index].matchTimeStr ??
                                                                                "00:00",
                                                                        teamAName:
                                                                            futureList6[index].homeTeamName ??
                                                                                "",
                                                                        teamALogo:
                                                                            futureList6[index].homeTeamLogo ??
                                                                                'images/mainpage/sampleLogo.png',
                                                                        teamAScore: futureList6[index]
                                                                            .homeTeamScore
                                                                            .toString(),
                                                                        teamBName:
                                                                            futureList6[index].awayTeamName ??
                                                                                "",
                                                                        teamBLogo:
                                                                            futureList6[index].awayTeamLogo ??
                                                                                'images/mainpage/sampleLogo.png',
                                                                        teamBScore: futureList6[index]
                                                                            .awayTeamScore
                                                                            .toString(),
                                                                        isSaved:
                                                                            futureList6[index].hasCollected ??
                                                                                false,
                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                          : (statusId == 1 &&
                                                                  futureDateId ==
                                                                      6)
                                                              ? isEventLoading
                                                                  ? Column(
                                                                      children: [
                                                                          Column(
                                                                              children: [
                                                                                if (future7Length < 4)
                                                                                  for (int i = 0; i < 4; i++)
                                                                                    CardLoading(
                                                                                      height: 100 * fem,
                                                                                      borderRadius: BorderRadius.circular(8 * fem),
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                    ),
                                                                                for (int i = 0; i < future7Length; i++)
                                                                                  CardLoading(
                                                                                    height: 100 * fem,
                                                                                    borderRadius: BorderRadius.circular(8 * fem),
                                                                                    margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                  ),
                                                                              ])
                                                                        ])
                                                                  : ListView
                                                                      .builder(
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemCount:
                                                                          future7Length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            print("navi into tournament");

                                                                            TournamentDetails(
                                                                              id: '${futureList7[index].id}',
                                                                              matchDate: '${futureList7[index].matchDate}',
                                                                              matchStatus: '未开赛',
                                                                              matchName: '${futureList7[index].competitionName}',
                                                                              homeTeamFormation: '${futureList7[index].homeFormation}',
                                                                              awayTeamFormation: '${futureList7[index].awayFormation}',
                                                                              lineUp: futureList7[index].lineUp ?? 0,
                                                                            ).launch(context);
                                                                          },
                                                                          child:
                                                                              GameDisplayComponent(
                                                                            id: futureList7[index].id ??
                                                                                0,
                                                                            competitionType:
                                                                                futureList7[index].competitionName ?? "",
                                                                            duration:
                                                                                futureList7[index].matchTimeStr ?? "00:00",
                                                                            teamAName:
                                                                                futureList7[index].homeTeamName ?? "",
                                                                            teamALogo:
                                                                                futureList7[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                            teamAScore:
                                                                                futureList7[index].homeTeamScore.toString(),
                                                                            teamBName:
                                                                                futureList7[index].awayTeamName ?? "",
                                                                            teamBLogo:
                                                                                futureList7[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                            teamBScore:
                                                                                futureList7[index].awayTeamScore.toString(),
                                                                            isSaved:
                                                                                futureList7[index].hasCollected ?? false,
                                                                          ),
                                                                        );
                                                                      },
                                                                    )
                                                              : (statusId ==
                                                                          2 &&
                                                                      pastDateId ==
                                                                          0)
                                                                  ? isEventLoading
                                                                      ? Column(
                                                                          children: [
                                                                              Column(children: [
                                                                                if (past1Length < 4)
                                                                                  for (int i = 0; i < 4; i++)
                                                                                    CardLoading(
                                                                                      height: 100 * fem,
                                                                                      borderRadius: BorderRadius.circular(8 * fem),
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                    ),
                                                                                for (int i = 0; i < past1Length; i++)
                                                                                  CardLoading(
                                                                                    height: 100 * fem,
                                                                                    borderRadius: BorderRadius.circular(8 * fem),
                                                                                    margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                  ),
                                                                              ])
                                                                            ])
                                                                      : ListView
                                                                          .builder(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              past1Length,
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                print("navi into tournament");
                                                                                TournamentDetails(
                                                                                  id: '${pastList1[index].id}',
                                                                                  matchDate: '${pastList1[index].matchDate}',
                                                                                  matchStatus: '未开赛',
                                                                                  matchName: '${pastList1[index].competitionName}',
                                                                                  homeTeamFormation: '${pastList1[index].homeFormation}',
                                                                                  awayTeamFormation: '${pastList1[index].awayFormation}',
                                                                                  lineUp: pastList1[index].lineUp ?? 0,
                                                                                ).launch(context);
                                                                              },
                                                                              child: GameDisplayComponent(
                                                                                id: pastList1[index].id ?? 0,
                                                                                competitionType: pastList1[index].competitionName ?? "",
                                                                                duration: pastList1[index].matchTimeStr ?? "00:00",
                                                                                teamAName: pastList1[index].homeTeamName ?? "",
                                                                                teamALogo: pastList1[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                teamAScore: pastList1[index].homeTeamScore.toString(),
                                                                                teamBName: pastList1[index].awayTeamName ?? "",
                                                                                teamBLogo: pastList1[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                teamBScore: pastList1[index].awayTeamScore.toString(),
                                                                                isSaved: pastList1[index].hasCollected ?? false,
                                                                              ),
                                                                            );
                                                                          },
                                                                        )
                                                                  : (statusId ==
                                                                              2 &&
                                                                          pastDateId ==
                                                                              1)
                                                                      ? isEventLoading
                                                                          ? Column(
                                                                              children: [
                                                                                  if (past2Length < 4)
                                                                                    for (int i = 0; i < 4; i++)
                                                                                      CardLoading(
                                                                                        height: 100 * fem,
                                                                                        borderRadius: BorderRadius.circular(8 * fem),
                                                                                        margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                      ),
                                                                                  for (int i = 0; i < past2Length; i++)
                                                                                    CardLoading(
                                                                                      height: 100 * fem,
                                                                                      borderRadius: BorderRadius.circular(8 * fem),
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                    ),
                                                                                ])
                                                                          : ListView
                                                                              .builder(
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              itemCount: past2Length,
                                                                              shrinkWrap: true,
                                                                              itemBuilder: (context, index) {
                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    print("navi into tournament");
                                                                                    TournamentDetails(
                                                                                      id: '${pastList2[index].id}',
                                                                                      matchDate: '${pastList2[index].matchDate}',
                                                                                      matchStatus: '未开赛',
                                                                                      matchName: '${pastList2[index].competitionName}',
                                                                                      homeTeamFormation: '${pastList2[index].homeFormation}',
                                                                                      awayTeamFormation: '${pastList2[index].awayFormation}',
                                                                                      lineUp: pastList2[index].lineUp ?? 0,
                                                                                    ).launch(context);
                                                                                  },
                                                                                  child: GameDisplayComponent(
                                                                                    id: pastList2[index].id ?? 0,
                                                                                    competitionType: pastList2[index].competitionName ?? "",
                                                                                    duration: pastList2[index].matchTimeStr ?? "00:00",
                                                                                    teamAName: pastList2[index].homeTeamName ?? "",
                                                                                    teamALogo: pastList2[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                    teamAScore: pastList2[index].homeTeamScore.toString(),
                                                                                    teamBName: pastList2[index].awayTeamName ?? "",
                                                                                    teamBLogo: pastList2[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                    teamBScore: pastList2[index].awayTeamScore.toString(),
                                                                                    isSaved: pastList2[index].hasCollected ?? false,
                                                                                  ),
                                                                                );
                                                                              },
                                                                            )
                                                                      : (statusId == 2 &&
                                                                              pastDateId == 2)
                                                                          ? isEventLoading
                                                                              ? Column(children: [
                                                                                  if (past3Length < 4)
                                                                                    for (int i = 0; i < 4; i++)
                                                                                      CardLoading(
                                                                                        height: 100 * fem,
                                                                                        borderRadius: BorderRadius.circular(8 * fem),
                                                                                        margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                      ),
                                                                                  for (int i = 0; i < past3Length; i++)
                                                                                    CardLoading(
                                                                                      height: 100 * fem,
                                                                                      borderRadius: BorderRadius.circular(8 * fem),
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                    ),
                                                                                ])
                                                                              : ListView.builder(
                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                  itemCount: past3Length,
                                                                                  shrinkWrap: true,
                                                                                  itemBuilder: (context, index) {
                                                                                    return GestureDetector(
                                                                                      onTap: () {
                                                                                        print("navi into tournament");
                                                                                        TournamentDetails(
                                                                                          id: '${pastList3[index].id}',
                                                                                          matchDate: '${pastList3[index].matchDate}',
                                                                                          matchStatus: '未开赛',
                                                                                          matchName: '${pastList3[index].competitionName}',
                                                                                          homeTeamFormation: '${pastList3[index].homeFormation}',
                                                                                          awayTeamFormation: '${pastList3[index].awayFormation}',
                                                                                          lineUp: pastList3[index].lineUp ?? 0,
                                                                                        ).launch(context);
                                                                                      },
                                                                                      child: GameDisplayComponent(
                                                                                        id: pastList3[index].id ?? 0,
                                                                                        competitionType: pastList3[index].competitionName ?? "",
                                                                                        duration: pastList3[index].matchTimeStr ?? "00:00",
                                                                                        teamAName: pastList3[index].homeTeamName ?? "",
                                                                                        teamALogo: pastList3[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                        teamAScore: pastList3[index].homeTeamScore.toString(),
                                                                                        teamBName: pastList3[index].awayTeamName ?? "",
                                                                                        teamBLogo: pastList3[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                        teamBScore: pastList3[index].awayTeamScore.toString(),
                                                                                        isSaved: pastList3[index].hasCollected ?? false,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                )
                                                                          : (statusId == 2 && pastDateId == 3)
                                                                              ? isEventLoading
                                                                                  ? Column(children: [
                                                                                      if (past4Length < 4)
                                                                                        for (int i = 0; i < 4; i++)
                                                                                          CardLoading(
                                                                                            height: 100 * fem,
                                                                                            borderRadius: BorderRadius.circular(8 * fem),
                                                                                            margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                          ),
                                                                                      for (int i = 0; i < past4Length; i++)
                                                                                        CardLoading(
                                                                                          height: 100 * fem,
                                                                                          borderRadius: BorderRadius.circular(8 * fem),
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                        ),
                                                                                    ])
                                                                                  : ListView.builder(
                                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                                      itemCount: past4Length,
                                                                                      shrinkWrap: true,
                                                                                      itemBuilder: (context, index) {
                                                                                        return GestureDetector(
                                                                                          onTap: () {
                                                                                            print("navi into tournament");
                                                                                            TournamentDetails(
                                                                                              id: '${pastList4[index].id}',
                                                                                              matchDate: '${pastList4[index].matchDate}',
                                                                                              matchStatus: '未开赛',
                                                                                              matchName: '${pastList4[index].competitionName}',
                                                                                              homeTeamFormation: '${pastList4[index].homeFormation}',
                                                                                              awayTeamFormation: '${pastList4[index].awayFormation}',
                                                                                              lineUp: pastList4[index].lineUp ?? 0,
                                                                                            ).launch(context);
                                                                                          },
                                                                                          child: GameDisplayComponent(
                                                                                            id: pastList4[index].id ?? 0,
                                                                                            competitionType: pastList4[index].competitionName ?? "",
                                                                                            duration: pastList4[index].matchTimeStr ?? "00:00",
                                                                                            teamAName: pastList4[index].homeTeamName ?? "",
                                                                                            teamALogo: pastList4[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                            teamAScore: pastList4[index].homeTeamScore.toString(),
                                                                                            teamBName: pastList4[index].awayTeamName ?? "",
                                                                                            teamBLogo: pastList4[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                            teamBScore: pastList4[index].awayTeamScore.toString(),
                                                                                            isSaved: pastList4[index].hasCollected ?? false,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    )
                                                                              : (statusId == 2 && pastDateId == 4)
                                                                                  ? isEventLoading
                                                                                      ? Column(children: [
                                                                                          if (past5Length < 4)
                                                                                            for (int i = 0; i < 4; i++)
                                                                                              CardLoading(
                                                                                                height: 100 * fem,
                                                                                                borderRadius: BorderRadius.circular(8 * fem),
                                                                                                margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                              ),
                                                                                          for (int i = 0; i < past5Length; i++)
                                                                                            CardLoading(
                                                                                              height: 100 * fem,
                                                                                              borderRadius: BorderRadius.circular(8 * fem),
                                                                                              margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                            ),
                                                                                        ])
                                                                                      : ListView.builder(
                                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                                          itemCount: past5Length,
                                                                                          shrinkWrap: true,
                                                                                          itemBuilder: (context, index) {
                                                                                            return GestureDetector(
                                                                                              onTap: () {
                                                                                                print("navi into tournament");
                                                                                                TournamentDetails(
                                                                                                  id: '${pastList5[index].id}',
                                                                                                  matchDate: '${pastList5[index].matchDate}',
                                                                                                  matchStatus: '未开赛',
                                                                                                  matchName: '${pastList5[index].competitionName}',
                                                                                                  homeTeamFormation: '${pastList5[index].homeFormation}',
                                                                                                  awayTeamFormation: '${pastList5[index].awayFormation}',
                                                                                                  lineUp: pastList5[index].lineUp ?? 0,
                                                                                                ).launch(context);
                                                                                              },
                                                                                              child: GameDisplayComponent(
                                                                                                id: pastList5[index].id ?? 0,
                                                                                                competitionType: pastList5[index].competitionName ?? "",
                                                                                                duration: pastList5[index].matchTimeStr ?? "00:00",
                                                                                                teamAName: pastList5[index].homeTeamName ?? "",
                                                                                                teamALogo: pastList5[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                                teamAScore: pastList5[index].homeTeamScore.toString(),
                                                                                                teamBName: pastList5[index].awayTeamName ?? "",
                                                                                                teamBLogo: pastList5[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                                teamBScore: pastList5[index].awayTeamScore.toString(),
                                                                                                isSaved: pastList5[index].hasCollected ?? false,
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        )
                                                                                  : (statusId == 2 && pastDateId == 5)
                                                                                      ? isEventLoading
                                                                                          ? Column(children: [
                                                                                              if (past6Length < 4)
                                                                                                for (int i = 0; i < 4; i++)
                                                                                                  CardLoading(
                                                                                                    height: 100 * fem,
                                                                                                    borderRadius: BorderRadius.circular(8 * fem),
                                                                                                    margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                                  ),
                                                                                              for (int i = 0; i < past6Length; i++)
                                                                                                CardLoading(
                                                                                                  height: 100 * fem,
                                                                                                  borderRadius: BorderRadius.circular(8 * fem),
                                                                                                  margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                                ),
                                                                                            ])
                                                                                          : ListView.builder(
                                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                                              itemCount: past6Length,
                                                                                              shrinkWrap: true,
                                                                                              itemBuilder: (context, index) {
                                                                                                return GestureDetector(
                                                                                                  onTap: () {
                                                                                                    print("navi into tournament");
                                                                                                    TournamentDetails(
                                                                                                      id: '${pastList6[index].id}',
                                                                                                      matchDate: '${pastList6[index].matchDate}',
                                                                                                      matchStatus: '未开赛',
                                                                                                      matchName: '${pastList6[index].competitionName}',
                                                                                                      homeTeamFormation: '${pastList6[index].homeFormation}',
                                                                                                      awayTeamFormation: '${pastList6[index].awayFormation}',
                                                                                                      lineUp: pastList6[index].lineUp ?? 0,
                                                                                                    ).launch(context);
                                                                                                  },
                                                                                                  child: GameDisplayComponent(
                                                                                                    id: pastList6[index].id ?? 0,
                                                                                                    competitionType: pastList6[index].competitionName ?? "",
                                                                                                    duration: pastList6[index].matchTimeStr ?? "00:00",
                                                                                                    teamAName: pastList6[index].homeTeamName ?? "",
                                                                                                    teamALogo: pastList6[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                                    teamAScore: pastList6[index].homeTeamScore.toString(),
                                                                                                    teamBName: pastList6[index].awayTeamName ?? "",
                                                                                                    teamBLogo: pastList6[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                                    teamBScore: pastList6[index].awayTeamScore.toString(),
                                                                                                    isSaved: pastList6[index].hasCollected ?? false,
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            )
                                                                                      : (statusId == 2 && pastDateId == 6)
                                                                                          ? isEventLoading
                                                                                              ? Column(children: [
                                                                                                  if (past7Length < 4)
                                                                                                    for (int i = 0; i < 4; i++)
                                                                                                      CardLoading(
                                                                                                        height: 100 * fem,
                                                                                                        borderRadius: BorderRadius.circular(8 * fem),
                                                                                                        margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                                      ),
                                                                                                  for (int i = 0; i < past7Length; i++)
                                                                                                    CardLoading(
                                                                                                      height: 100 * fem,
                                                                                                      borderRadius: BorderRadius.circular(8 * fem),
                                                                                                      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
                                                                                                    ),
                                                                                                ])
                                                                                              : ListView.builder(
                                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                                  itemCount: past7Length,
                                                                                                  shrinkWrap: true,
                                                                                                  itemBuilder: (context, index) {
                                                                                                    return GestureDetector(
                                                                                                      onTap: () {
                                                                                                        print("navi into tournament");
                                                                                                        TournamentDetails(
                                                                                                          id: '${pastList7[index].id}',
                                                                                                          matchDate: '${pastList7[index].matchDate}',
                                                                                                          matchStatus: '未开赛',
                                                                                                          matchName: '${pastList7[index].competitionName}',
                                                                                                          homeTeamFormation: '${pastList7[index].homeFormation}',
                                                                                                          awayTeamFormation: '${pastList7[index].awayFormation}',
                                                                                                          lineUp: pastList7[index].lineUp ?? 0,
                                                                                                        ).launch(context);
                                                                                                      },
                                                                                                      child: GameDisplayComponent(
                                                                                                        id: pastList7[index].id ?? 0,
                                                                                                        competitionType: pastList7[index].competitionName ?? "",
                                                                                                        duration: pastList7[index].matchTimeStr ?? "00:00",
                                                                                                        teamAName: pastList7[index].homeTeamName ?? "",
                                                                                                        teamALogo: pastList7[index].homeTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                                        teamAScore: pastList7[index].homeTeamScore.toString(),
                                                                                                        teamBName: pastList7[index].awayTeamName ?? "",
                                                                                                        teamBLogo: pastList7[index].awayTeamLogo ?? 'images/mainpage/sampleLogo.png',
                                                                                                        teamBScore: pastList7[index].awayTeamScore.toString(),
                                                                                                        isSaved: pastList7[index].hasCollected ?? false,
                                                                                                      ),
                                                                                                    );
                                                                                                  },
                                                                                                )
                                                                                          : Container(),
                              isLoading
                                  ? Center(
                                      child: Lottie.asset(
                                        'images/common/pandahappy.json', // Replace 'loading.json' with the path to your Lottie animation
                                        width:
                                            250, // Adjust the width as needed
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
