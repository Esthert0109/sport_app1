import 'dart:async';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Component/LivePage/followingBlockComponent.dart';
import 'package:sport_app/Provider/liveStreamProvider.dart';
import 'package:sport_app/Services/Utils/sharedPreferencesUtils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../Component/Common/liveSquareBlock.dart';
import '../../../Component/Common/loginDialog.dart';
import '../../../Component/Common/selectionButtonText.dart';
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
import '../../MyPages/savedLive.dart';
import '../../SearchPage/searchingPage.dart';
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

  //variables
  bool _showAppBar = true;
  bool _isScrollingDown = false;
  bool isLiveLoading = false;
  bool isCollectionLoading = false;
  bool isLogin = true;
  int statusId = 0;
  int followStatusId = 0;

  //Provider bookmark and live stream
  BookmarkProvider savedBookmarkProvider = BookmarkProvider();

  //live stream provider
  LiveStreamProvider liveProvider = LiveStreamProvider();

  //common variables
  List<LiveStreamData> basketballLiveStreamList = [];
  int liveStreamLength = 0;

  List<CollectMatchesData> threeCollections = [];
  int collectionLength = 0;

  // variables
  int page = 1;
  int size = 10;

  Future<void> checkLogin() async {
    //get shared preferences
    String? token = await SharedPreferencesUtils.getSavedToken();

    print("check token: ${token.toString()}");

    if (token.isEmptyOrNull) {
      isLogin = false;
    }
  }

  Future<void> getAllLiveList() async {
    LiveStreamModel? liveList =
        await liveProvider.getAllLiveStreamList(page, size);

    if (!isLiveLoading) {
      setState(() {
        isLiveLoading = true;
      });
      basketballLiveStreamList.addAll(liveList?.data ?? []);
      liveStreamLength = basketballLiveStreamList.length;
      setState(() {
        isLiveLoading = false;
        page++;
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

      basketballLiveStreamList.clear();
      liveStreamLength = basketballLiveStreamList.length;

      print("check: $liveStreamLength");
      print("check basket: ${basketballLiveStreamList.toString()}");
      page = 1;

      getCollections();
      getAllLiveList();
    });
  }

  //initState
  @override
  void initState() {
    super.initState();
    getCollections();
    getAllLiveList();
    checkLogin();

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

    List<String> statusList = [
      AppLocalizations.of(context)!.streaming,
      AppLocalizations.of(context)!.following
    ];

    List<String> followStatusList = [
      AppLocalizations.of(context)!.defaultSort,
      AppLocalizations.of(context)!.descendingSort,
      AppLocalizations.of(context)!.ascendingSort
    ];

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
                    LazyLoadScrollView(
              isLoading: isLiveLoading,
              onEndOfPage: () {
                setState(() {
                  (statusId == 0) ? getAllLiveList() : null;
                });
              },
              child: RefreshIndicator(
                color: kMainGreenColor,
                onRefresh: () async {
                  (statusId == 0) ? toggleRefresh() : null;
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                statusList.length,
                                (index) => Container(
                                      height: 28 * fem,
                                      padding: EdgeInsets.only(right: 25 * fem),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            statusId = index;
                                          });
                                        },
                                        child: Text(
                                          statusList[index],
                                          textAlign: TextAlign.center,
                                          style: (statusId == index)
                                              ? tSelectedTitleText
                                              : tUnselectedTitleText,
                                        ),
                                      ),
                                    ))),
                        (statusId == 0)
                            ? (isLiveLoading)
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15 * fem),
                                    child: Column(
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
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15 * fem),
                                    child: Column(
                                      children: List.generate(
                                          (liveStreamLength / 2).ceil(),
                                          (index) {
                                        int startIndex = index * 2;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            for (int j = startIndex;
                                                j < startIndex + 2 &&
                                                    j < liveStreamLength;
                                                j++)
                                              InkWell(
                                                onTap: () {
                                                  if (!isLogin) {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20))),
                                                        builder: (context) {
                                                          return LoginAlertDialog();
                                                        });
                                                  } else {
                                                    LiveStreamChatRoom page = LiveStreamChatRoom(
                                                        userLoginId: userModel
                                                            .id.value,
                                                        avChatRoomId:
                                                            "panda${basketballLiveStreamList[j].userId}",
                                                        anchor:
                                                            basketballLiveStreamList[
                                                                        j]
                                                                    .nickName ??
                                                                "",
                                                        streamTitle:
                                                            basketballLiveStreamList[
                                                                        j]
                                                                    .title ??
                                                                "",
                                                        anchorPic:
                                                            basketballLiveStreamList![j]
                                                                    .avatar ??
                                                                "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                                        playMode: V2TXLivePlayMode
                                                            .v2TXLivePlayModeLeb,
                                                        liveURL: "rtmp://play.mindark.cloud/live/" +
                                                            getStreamURL(
                                                                basketballLiveStreamList![j]
                                                                    .pushCode));

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    page));
                                                  }
                                                },
                                                child: LiveSquareBlock(
                                                  title:
                                                      basketballLiveStreamList[
                                                                  j]
                                                              .title ??
                                                          "",
                                                  anchor:
                                                      basketballLiveStreamList[
                                                                  j]
                                                              .nickName ??
                                                          "",
                                                  anchorPhoto:
                                                      basketballLiveStreamList![
                                                                  j]
                                                              .avatar ??
                                                          "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                                  livePhoto:
                                                      basketballLiveStreamList![
                                                                  j]
                                                              .cover ??
                                                          "https://images.chinatimes.com/newsphoto/2022-05-05/656/20220505001628.jpg",
                                                ),
                                              )
                                          ],
                                        );
                                      }),
                                    ),
                                  )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        // horizontal: 15 * fem,
                                        vertical: 10 * fem),
                                    child: SelectionButtonTextComponent(
                                        index: followStatusId,
                                        selectionList: followStatusList,
                                        isMainPage: false,
                                        onTap: (index) {
                                          setState(() {
                                            followStatusId = index;
                                          });
                                        }),
                                  ),
                                  Column(
                                    children: List.generate(
                                        30,
                                        (index) => FollowingBlockComponent(
                                            isStreaming: false,
                                            streamTitle: "",
                                            anchorName:
                                                "KIkoooooooooooooooooooooooooooooo",
                                            anchorPic:
                                                "https://i.ytimg.com/vi/xvQk-qV1070/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLCHK8qn2BR3DrfXETOUGrmen3kNlw")),
                                  )
                                ],
                              )
                      ],
                    ),
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
