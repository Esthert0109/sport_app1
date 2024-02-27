import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Provider/liveStreamProvider.dart';

import '../../../Component/Common/liveSquareBlock.dart';
import '../../../Component/Loading/loadingLiveDisplayBlock.dart';
import '../../../Component/Tencent/liveStreamPlayer.dart';
import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/userDataModel.dart';
import '../../../Provider/bookmarkProvider.dart';
import '../../TencentLiveStreamRoom/liveStreamChatRoom.dart';

class BasketballLivePage extends StatefulWidget {
  const BasketballLivePage({super.key});

  @override
  State<BasketballLivePage> createState() => _BasketballLivePageState();
}

class _BasketballLivePageState extends State<BasketballLivePage>
    with SingleTickerProviderStateMixin {
  //get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  //controller
  final ScrollController _scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();

  //Bookmark and livestream list
  List<dynamic> savedBookmarkList = [];
  List<dynamic> getBookmarkList = [];

  //variables
  bool _showAppBar = true;
  bool _isScrollingDown = false;
  bool _isLiveLoading = true;
  bool _isSavedLiveLoading = true;
  bool shouldRefresh = false;

  //Provider bookmark and live stream
  BookmarkProvider savedBookmarkProvider = BookmarkProvider();
  //live stream provider
  LiveStreamProvider liveProvider = LiveStreamProvider();

  //common variables
  List<dynamic>? getAllLiveStreamList = [];
  List<dynamic>? AllLiveStreamList = [];
  List<dynamic>? basketballLiveStreamList = [];
  List<Map<String, dynamic>> savedMatch = [{}];
  int allStreamCount = 0;

  // get data

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
                          '搜索赛事/球队',
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
                child: Obx(() => RefreshIndicator(
                      onRefresh: () async {
                        // refreshBookmarkList();
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 * fem, vertical: 10 * fem),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '我收藏的直播',
                                    style: tMain,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("goto saved Live");
                                    },
                                    child: Text(
                                      '展示所有',
                                      style: tShowAll,
                                    ),
                                  )
                                ],
                              ),
                              if (savedBookmarkList.isNotEmpty) ...[
                                Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (savedBookmarkList.length >= 3)
                                        ? 3
                                        : savedBookmarkList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Column(
                                          children: [
                                            // InkWell(
                                            //   onTap: () {
                                            //     BasketballTournamentDetails(
                                            //             id:
                                            //                 '${savedBookmarkList?[index]['id']}',
                                            //             matchDate:
                                            //                 '${savedBookmarkList?[index]['matchDate']}',
                                            //             matchStatus:
                                            //                 '${savedBookmarkList?[index]['statusStr']}',
                                            //             matchName:
                                            //                 '${savedBookmarkList?[index]['competitionName']}')
                                            //         .launch(context);
                                            //   },
                                            //   child: LiveDisplayBlock(
                                            //       id: savedBookmarkList?[index]['id']
                                            //           .toString(),
                                            //       index: index,
                                            //       competitionType: savedBookmarkList?[index]
                                            //               ['competitionName']
                                            //           .toString(),
                                            //       duration:
                                            //           savedBookmarkList?[index]
                                            //                   ['matchTimeStr']
                                            //               .toString(),
                                            //       savedAmount: '0',
                                            //       isSaved: getBookmarkList.contains(
                                            //           savedBookmarkList[index]
                                            //               ['id']),
                                            //       teamAName:
                                            //           savedBookmarkList?[index]
                                            //                   ['homeTeamName']
                                            //               .toString(),
                                            //       teamALogo:
                                            //           savedBookmarkList?[index]
                                            //                   ['homeTeamLogo']
                                            //               .toString(),
                                            //       teamAScore: savedBookmarkList?[index]['homeTeamScore'].toString(),
                                            //       teamBName: savedBookmarkList?[index]['awayTeamName'].toString(),
                                            //       teamBLogo: savedBookmarkList?[index]['awayTeamLogo'].toString(),
                                            //       teamBScore: savedBookmarkList?[index]['awayTeamScore'].toString(),
                                            //       status: savedBookmarkList?[index]['statusStr'].toString(),
                                            //       // onTapCallback: toggleRefresh,
                                            //       getBookmarkBlockList: getBookmarkList),
                                            // )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ] else
                                Padding(
                                  padding: EdgeInsets.all(20 * fem),
                                  child: Text('快去收藏些直播吧！', style: tShowAll),
                                ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '正在直播',
                                  style: tMain,
                                ),
                              ),
                              SizedBox(
                                height: 10 * fem,
                              ),
                              if (_isLiveLoading) ...{
                                Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        LoadingLiveSquareDisplayBlock(),
                                        LoadingLiveSquareDisplayBlock(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 14 * fem,
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        LoadingLiveSquareDisplayBlock(),
                                        LoadingLiveSquareDisplayBlock()
                                      ],
                                    )
                                  ],
                                )
                              } else
                                for (int i = 0; i < allStreamCount; i += 2)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (int j = i;
                                          j < i + 2 && j < allStreamCount;
                                          j++)
                                        InkWell(
                                          onTap: () {
                                            LiveStreamChatRoom page = LiveStreamChatRoom(
                                                userLoginId: userModel.id.value,
                                                avChatRoomId:
                                                    "panda${basketballLiveStreamList![j]['userId']}",
                                                anchor:
                                                    basketballLiveStreamList![j]
                                                        ['nickName'],
                                                streamTitle:
                                                    basketballLiveStreamList![j]
                                                        ['title'],
                                                anchorPic:
                                                    basketballLiveStreamList![j]
                                                        ['avatar'],
                                                playMode: V2TXLivePlayMode
                                                    .v2TXLivePlayModeLeb,
                                                liveURL:
                                                    "rtmp://play.mindark.cloud/live/"
                                                // +
                                                //     getStreamURL(
                                                //         basketballLiveStreamList![
                                                //                 j]
                                                //             ['pushCode'])

                                                );

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        page));
                                          },
                                          child: LiveSquareBlock(
                                            title: basketballLiveStreamList![j]
                                                ['title'],
                                            anchor: basketballLiveStreamList![j]
                                                ['nickName'],
                                            anchorPhoto:
                                                basketballLiveStreamList![j]
                                                    ['avatar'],
                                            livePhoto:
                                                basketballLiveStreamList![j]
                                                    ['cover'],
                                          ),
                                        )
                                    ],
                                  )
                            ],
                          ),
                        ),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
