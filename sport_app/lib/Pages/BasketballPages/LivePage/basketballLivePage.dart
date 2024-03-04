import 'dart:async';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Provider/liveStreamProvider.dart';

import '../../../Component/Common/liveSquareBlock.dart';
import '../../../Component/LivePage/liveDisplayBlockComponent.dart';
import '../../../Component/Loading/loadingLiveDisplayBlock.dart';
import '../../../Component/MainPage/gameDisplayComponent.dart';
import '../../../Component/Tencent/liveStreamPlayer.dart';
import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/collectionModel.dart';
import '../../../Model/liveStreamModel.dart';
import '../../../Model/userDataModel.dart';
import '../../../Provider/collectionProvider.dart';
import '../../TencentLiveStreamRoom/liveStreamChatRoom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../basketballTournamentDetails.dart';

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
  bool isLiveLoading = false;
  bool isCollectionLoading = false;
  bool shouldRefresh = false;

  //Provider bookmark and live stream
  BookmarkProvider savedBookmarkProvider = BookmarkProvider();
  //live stream provider
  LiveStreamProvider liveProvider = LiveStreamProvider();

  //common variables
  // List<dynamic>? getAllLiveStreamList = [];
  // List<dynamic>? AllLiveStreamList = [];
  List<LiveStreamData> basketballLiveStreamList = [];
  int liveStreamLength = 0;

  List<CollectMatchesData> threeCollections = [];
  int collectionLength = 0;

  Future<void> getAllLiveList() async {
    LiveStreamModel? liveList = await liveProvider.getAllLiveStreamList();

    if (!isLiveLoading) {
      setState(() {
        isLiveLoading = true;
      });
      basketballLiveStreamList.addAll(liveList?.data ?? []);
      liveStreamLength = basketballLiveStreamList.length;
      setState(() {
        isLiveLoading = false;
      });
    }
  }

  Future<void> getCollections() async {
    if (!isCollectionLoading) {
      setState(() {
        isCollectionLoading = true;
      });

      CollectMatchesModel? collection =
          await savedBookmarkProvider.getThreeBasketballCollection();
      threeCollections.addAll(collection?.data ?? []);
      collectionLength = threeCollections.length;

      setState(() {
        isCollectionLoading = false;
      });
    }
  }

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

  Future<void> toggleRefresh() async {
    setState(() {
      threeCollections.clear();
      collectionLength = threeCollections.length;

      getCollections();

      basketballLiveStreamList.clear();
      liveStreamLength = basketballLiveStreamList.length;
      getAllLiveList();
    });
  }

  //initState
  @override
  void initState() {
    super.initState();
    getCollections();
    getAllLiveList();
    print("savedBookmarkList: ${savedBookmarkList.toString()}");

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection.toString() ==
          'ScrollDirection.reverse') {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
            _showAppBar = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection.toString() ==
          'ScrollDirection.forward') {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
            _showAppBar = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(() {});
    super.dispose();
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
              child: Obx(
                () => AppBar(
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
            ),
            Expanded(
                child:
                    // Obx(() =>
                    RefreshIndicator(
              color: kMainGreenColor,
              onRefresh: () async {
                toggleRefresh();
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.myCollection,
                            style: tMain,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("goto saved Live");
                            },
                            child: Text(
                              AppLocalizations.of(context)!.showAll,
                              style: tShowAll,
                            ),
                          )
                        ],
                      ),
                      isCollectionLoading
                          ? Column(
                              children: [
                                for (int i = 0; i < 3; i++)
                                  CardLoading(
                                    height: 100 * fem,
                                    borderRadius:
                                        BorderRadius.circular(8 * fem),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10 * fem,
                                        vertical: 10 * fem),
                                  ),
                              ],
                            )
                          : (collectionLength == 0)
                              ? Padding(
                                  padding: EdgeInsets.all(20 * fem),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .savedCollection,
                                      style: tShowAll),
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10 * fem),
                                  itemCount: collectionLength,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print("navi into tournament");
                                        BasketballTournamentDetails(
                                                id:
                                                    '${threeCollections[index].id}',
                                                matchDate:
                                                    '${threeCollections[index].matchDate}',
                                                matchStatus:
                                                    '${threeCollections[index].statusStr}',
                                                matchName:
                                                    '${threeCollections[index].competitionName}')
                                            .launch(context);
                                      },
                                      child: GameDisplayComponent(
                                        id: threeCollections[index].id ?? 0,
                                        competitionType: threeCollections[index]
                                                .competitionName ??
                                            "",
                                        duration: threeCollections[index]
                                                .matchTimeStr ??
                                            "00:00",
                                        teamAName: threeCollections[index]
                                                .homeTeamName ??
                                            "",
                                        teamALogo: threeCollections[index]
                                                .homeTeamLogo ??
                                            'images/mainpage/sampleLogo.png',
                                        teamAScore: threeCollections[index]
                                            .homeTeamScore
                                            .toString(),
                                        teamBName: threeCollections[index]
                                                .awayTeamName ??
                                            "",
                                        teamBLogo: threeCollections[index]
                                                .awayTeamLogo ??
                                            'images/mainpage/sampleLogo.png',
                                        teamBScore: threeCollections[index]
                                            .awayTeamScore
                                            .toString(),
                                        isSaved: threeCollections[index]
                                                .hasCollected ??
                                            false,
                                      ),
                                    );
                                  },
                                ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppLocalizations.of(context)!.streaming,
                          style: tMain,
                        ),
                      ),
                      SizedBox(
                        height: 10 * fem,
                      ),
                      if (isLiveLoading) ...{
                        Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LoadingLiveSquareDisplayBlock(),
                                LoadingLiveSquareDisplayBlock(),
                              ],
                            ),
                            SizedBox(
                              height: 14 * fem,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LoadingLiveSquareDisplayBlock(),
                                LoadingLiveSquareDisplayBlock()
                              ],
                            )
                          ],
                        )
                      } else
                        for (int i = 0; i < liveStreamLength; i += 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int j = i;
                                  j < i + 2 && j < liveStreamLength;
                                  j++)
                                InkWell(
                                  onTap: () {
                                    LiveStreamChatRoom page = LiveStreamChatRoom(
                                        userLoginId: userModel.id.value,
                                        avChatRoomId:
                                            "panda${basketballLiveStreamList[j].userId}",
                                        anchor: basketballLiveStreamList[j]
                                                .nickName ??
                                            "",
                                        streamTitle:
                                            basketballLiveStreamList[j].title ??
                                                "",
                                        anchorPic: basketballLiveStreamList![j]
                                                .avatar ??
                                            "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                        playMode: V2TXLivePlayMode
                                            .v2TXLivePlayModeLeb,
                                        liveURL:
                                            "rtmp://play.mindark.cloud/live/" +
                                                getStreamURL(
                                                    basketballLiveStreamList![j]
                                                        .pushCode));

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => page));
                                  },
                                  child: LiveSquareBlock(
                                    title:
                                        basketballLiveStreamList[j].title ?? "",
                                    anchor:
                                        basketballLiveStreamList[j].nickName ??
                                            "",
                                    anchorPhoto: basketballLiveStreamList![j]
                                            .avatar ??
                                        "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                    livePhoto: basketballLiveStreamList![j]
                                            .cover ??
                                        "https://images.chinatimes.com/newsphoto/2022-05-05/656/20220505001628.jpg",
                                  ),
                                )
                            ],
                          )
                    ],
                  ),
                ),
              ),
            ))
            // )
          ],
        ),
      ),
    );
  }
}
