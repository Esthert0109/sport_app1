import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Component/LivePage/followingBlockComponent.dart';
import 'package:sport_app/Provider/anchorFollowProvider.dart';
import 'package:sport_app/Provider/liveStreamProvider.dart';
import 'package:sport_app/Services/Utils/sharedPreferencesUtils.dart';

import '../../../Component/Common/liveSquareBlock.dart';
import '../../../Component/Common/loginDialog.dart';
import '../../../Component/Common/selectionButtonText.dart';
import '../../../Component/Loading/emptyResultComponent.dart';
import '../../../Component/Loading/loadingLiveDisplayBlock.dart';
import '../../../Component/Tencent/liveStreamPlayer.dart';
import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/followingModel.dart';
import '../../../Model/liveStreamModel.dart';
import '../../../Model/userDataModel.dart';
import '../../../Provider/collectionProvider.dart';
import '../../SearchPage/searchingPage.dart';
import '../../TencentLiveStreamRoom/liveStreamChatRoom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  // bool isCollectionLoading = false;
  bool isFollowLoading = false;
  bool isLogin = true;
  int statusId = 0;
  int followStatusId = 0;

  //Provider bookmark and live stream
  BookmarkProvider savedBookmarkProvider = BookmarkProvider();

  //live stream provider
  LiveStreamProvider liveProvider = LiveStreamProvider();

  // following provider
  AnchorFollowProvider followProvider = AnchorFollowProvider();

  //common variables
  List<LiveStreamData> basketballLiveStreamList = [];
  int liveStreamLength = 0;

  // variables
  int page = 1;
  int size = 10;
  int followPage = 1;
  int followPageDesc = 1;
  int followPageAsc = 1;

  List<FollowData> followingList = [];
  int followingLength = 0;

  List<FollowData> followingListDesc = [];
  int followingDescLength = 0;

  List<FollowData> followingListAsc = [];
  int followingAscLength = 0;

  Future<void> checkLogin() async {
    //get shared preferences
    String? token = await SharedPreferencesUtils.getSavedToken();

    print("check token: ${token.toString()}");

    if (token.isEmptyOrNull) {
      isLogin = false;
    } else {
      isLogin = true;
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

  Future<void> getFollowingList() async {
    if (!isFollowLoading) {
      setState(() {
        isFollowLoading = true;
      });

      FollowModel? followModel =
          await followProvider.getFollowingList(followPage, size);
      followingList.addAll(followModel?.data ?? []);
      followingLength = followingList.length;

      setState(() {
        isFollowLoading = false;
        followPage++;
      });
    }
  }

  Future<void> getFollowingListDesc() async {
    FollowModel? followModel =
        await followProvider.getFollowingListDesc(followPageDesc, size);
    if (!isFollowLoading) {
      setState(() {
        isFollowLoading = true;
      });

      followingListDesc.addAll(followModel?.data ?? []);
      followingDescLength = followingList.length;

      setState(() {
        isFollowLoading = false;
        followPageDesc++;
      });
    }
  }

  Future<void> getFollowingListAsc() async {
    if (!isFollowLoading) {
      setState(() {
        isFollowLoading = true;
      });

      FollowModel? followModel =
          await followProvider.getFollowingListAsc(followPageAsc, size);
      followingListAsc.addAll(followModel?.data ?? []);
      followingAscLength = followingList.length;

      setState(() {
        isFollowLoading = false;
        followPageAsc++;
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
      statusId = 0;
      followStatusId = 0;

      followingList.clear();
      followingLength = followingList.length;
      followPage = 1;

      basketballLiveStreamList.clear();
      liveStreamLength = basketballLiveStreamList.length;
      page = 1;

      // getCollections();
      getFollowingList();
      getAllLiveList();
    });
  }

  //initState
  @override
  void initState() {
    super.initState();
    getAllLiveList();
    checkLogin();
    getFollowingList();

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

    checkLogin();

    List<String> statusList = [
      AppLocalizations.of(context)!.streaming,
      AppLocalizations.of(context)!.following
    ];

    List<String> statusListNoLogin = [AppLocalizations.of(context)!.streaming];

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
                        Get.to(() => const SearchingPage(),
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
                      dropdownColor: const Color.fromARGB(255, 211, 255, 212),
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
                child: LazyLoadScrollView(
              isLoading: isLiveLoading,
              onEndOfPage: () {
                setState(() {
                  (statusId == 0) ? getAllLiveList() : getFollowingList();
                });
              },
              child: RefreshIndicator(
                color: kMainGreenColor,
                onRefresh: () async {
                  (statusId == 0) ? toggleRefresh() : toggleRefresh();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16 * fem, vertical: 10 * fem),
                    child: Obx(
                      () => Column(
                        children: [
                          userModel.isLogin.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      statusList.length,
                                      (index) => Container(
                                            height: 28 * fem,
                                            padding: EdgeInsets.only(
                                                right: 25 * fem),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  statusId = index;
                                                  if (statusId == 0) {
                                                    basketballLiveStreamList
                                                        .clear();
                                                    liveStreamLength =
                                                        basketballLiveStreamList
                                                            .length;
                                                    page = 1;

                                                    getAllLiveList();
                                                  } else {
                                                    isFollowLoading = false;
                                                    followStatusId = 0;
                                                    followingList.clear();
                                                    followingLength =
                                                        followingList.length;
                                                    followPage = 1;
                                                    getFollowingList();
                                                  }
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
                                          )))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      statusListNoLogin.length,
                                      (index) => Container(
                                            height: 28 * fem,
                                            padding: EdgeInsets.only(
                                                right: 25 * fem),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  statusId = index;
                                                });
                                              },
                                              child: Text(
                                                statusListNoLogin[index],
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
                                          vertical: 25 * fem),
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
                                                    if (userModel
                                                            .isLogin.value ==
                                                        false) {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              20))),
                                                          builder: (context) {
                                                            return const LoginAlertDialog();
                                                          });
                                                    } else {
                                                      LiveStreamChatRoom page =
                                                          LiveStreamChatRoom(
                                                        userLoginId:
                                                            userModel.id.value,
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
                                                            basketballLiveStreamList![
                                                                        j]
                                                                    .avatar ??
                                                                "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                                        playMode: V2TXLivePlayMode
                                                            .v2TXLivePlayModeLeb,
                                                        liveURL:
                                                            "${getStreamURL(basketballLiveStreamList[j].pushCode)}",
                                                        anchorId:
                                                            '${basketballLiveStreamList[j].userId}',
                                                      );

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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10 * fem),
                                      child: SelectionButtonTextComponent(
                                          index: followStatusId,
                                          selectionList: followStatusList,
                                          isMainPage: false,
                                          onTap: (index) {
                                            setState(() {
                                              followStatusId = index;
                                              if (followStatusId == 0) {
                                                followingList.clear();
                                                followingLength =
                                                    followingList.length;
                                                followPage = 1;
                                                getFollowingList();
                                              } else if (followStatusId == 1) {
                                                followingListDesc.clear();
                                                followingDescLength =
                                                    followingListDesc.length;
                                                followPageDesc = 1;
                                                getFollowingListDesc();
                                              } else {
                                                followingListAsc.clear();
                                                followingAscLength =
                                                    followingListAsc.length;
                                                followPageAsc = 1;
                                                getFollowingListAsc();
                                              }
                                            });
                                          }),
                                    ),
                                    (followingLength == 0)
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                  height: 550 * fem,
                                                  alignment: Alignment.center,
                                                  child: searchEmptyWidget()),
                                              Container(
                                                height: 100 * fem,
                                                child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .noFollowing,
                                                    style: tFollowNull,
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          )
                                        : (followStatusId == 0)
                                            ? Column(
                                                children: List.generate(
                                                    followingLength,
                                                    (index) =>
                                                        FollowingBlockComponent(
                                                          isStreaming:
                                                              followingList[
                                                                      index]
                                                                  .streamingStatus,
                                                          streamTitle:
                                                              followingList[
                                                                          index]
                                                                      .liveStreamDetails
                                                                      ?.title ??
                                                                  "",
                                                          anchorName:
                                                              followingList[
                                                                      index]
                                                                  .anchorDetails
                                                                  .nickName,
                                                          anchorPic:
                                                              followingList[
                                                                      index]
                                                                  .anchorDetails
                                                                  .head,
                                                          anchorId:
                                                              followingList[
                                                                      index]
                                                                  .anchorId,
                                                          onTapCallback:
                                                              toggleRefresh,
                                                        )),
                                              )
                                            : (followStatusId == 1)
                                                ? Column(
                                                    children: List.generate(
                                                        followingDescLength,
                                                        (index) =>
                                                            FollowingBlockComponent(
                                                              isStreaming:
                                                                  followingListDesc[
                                                                          index]
                                                                      .streamingStatus,
                                                              streamTitle: followingListDesc[
                                                                          index]
                                                                      .liveStreamDetails
                                                                      ?.title ??
                                                                  "",
                                                              anchorName:
                                                                  followingListDesc[
                                                                          index]
                                                                      .anchorDetails
                                                                      .nickName,
                                                              anchorPic:
                                                                  followingListDesc[
                                                                          index]
                                                                      .anchorDetails
                                                                      .head,
                                                              anchorId:
                                                                  followingListDesc[
                                                                          index]
                                                                      .anchorId,
                                                              onTapCallback:
                                                                  toggleRefresh,
                                                            )),
                                                  )
                                                : Column(
                                                    children: List.generate(
                                                        followingAscLength,
                                                        (index) =>
                                                            FollowingBlockComponent(
                                                              isStreaming:
                                                                  followingListAsc[
                                                                          index]
                                                                      .streamingStatus,
                                                              streamTitle: followingListAsc[
                                                                          index]
                                                                      .liveStreamDetails
                                                                      ?.title ??
                                                                  "",
                                                              anchorName:
                                                                  followingListAsc[
                                                                          index]
                                                                      .anchorDetails
                                                                      .nickName,
                                                              anchorPic:
                                                                  followingListAsc[
                                                                          index]
                                                                      .anchorDetails
                                                                      .head,
                                                              anchorId:
                                                                  followingListAsc[
                                                                          index]
                                                                      .anchorId,
                                                              onTapCallback:
                                                                  toggleRefresh,
                                                            )),
                                                  )
                                  ],
                                )
                        ],
                      ),
                    ),
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
