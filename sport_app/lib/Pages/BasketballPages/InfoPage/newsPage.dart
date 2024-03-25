import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Component/Common/selectionButtonText.dart';
import 'package:sport_app/Component/Loading/emptyResultComponent.dart';
import 'package:sport_app/Provider/infoProvider.dart';

import '../../../Component/News/pinNewsComponent.dart';
import '../../../Constants/Controller/layoutController.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/infoModel.dart';
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
  List<String> categoryList = [];
  int categoryLength = 0;
  List<InfoListData> infoList = [];
  int infoLength = 0;
  List<InfoListData> infoList1 = [];
  int infoLength1 = 0;
  List<InfoListData> infoList2 = [];
  int infoLength2 = 0;
  List<InfoListData> infoList3 = [];
  int infoLength3 = 0;

  //variables
  bool _showAppBar = true;
  bool isScrollingDown = false;
  bool isLoading = false;
  int tagId = 0;
  int page = 1;
  int page1 = 1;
  int page2 = 1;
  int page3 = 1;
  int size = 15;
  // int search = 0;

  //controller
  ScrollController _scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();

  // provider
  InfoProvider infoProvider = InfoProvider();

  //get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  Future<void> getCategoryList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      InfoCategoryModel? categoryModel = await infoProvider.getInfoCategories();
      List<InfoCategoryData> list = [];
      list.addAll(categoryModel?.data ?? []);
      categoryLength = list.length;

      for (int i = 0; i < categoryLength; i++) {
        categoryList.add(list[i].category);
      }

      print("check cat: ${categoryList}");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getInfoList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      if (tagId == 0) {
        InfoListModel? infoModel =
            await infoProvider.getInfoList(page, size, tagId + 1);
        infoList.addAll(infoModel?.data ?? []);
        infoLength = infoList.length;
        print("check list: ${infoList}");
        page++;
      } else if (tagId == 1) {
        InfoListModel? infoModel =
            await infoProvider.getInfoList(page1, size, tagId + 1);
        infoList1.addAll(infoModel?.data ?? []);
        infoLength1 = infoList1.length;
        print("check list: ${infoList1}");
        page1++;
      } else if (tagId == 2) {
        InfoListModel? infoModel =
            await infoProvider.getInfoList(page2, size, tagId + 1);
        infoList2.addAll(infoModel?.data ?? []);
        infoLength2 = infoList2.length;
        print("check list: ${infoList2}");
        page2++;
      } else {
        InfoListModel? infoModel =
            await infoProvider.getInfoList(page3, size, tagId + 1);
        infoList3.addAll(infoModel?.data ?? []);
        infoLength3 = infoList3.length;
        print("check list: ${infoList3}");
        page3++;
      }

      setState(() {
        isLoading = false;
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

  void refresh() {
    setState(() {
      tagId = 0;
      page = 1;
      page1 = 1;
      page2 = 1;
      page3 = 1;
      infoList.clear();
      infoList1.clear();
      infoList2.clear();
      infoList3.clear();
      infoLength = infoList.length;
      infoLength1 = infoList1.length;
      infoLength2 = infoList2.length;
      infoLength3 = infoList3.length;
      getInfoList();
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoryList();
    getInfoList();
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
                          Get.to(() => HotNewsPage(),
                              transition: Transition.rightToLeft);
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
                getInfoList();
              },
              child: RefreshIndicator(
                color: kMainGreenColor,
                onRefresh: () async {
                  print("refresh");
                  refresh();
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
                            horizontal: 5 * fem, vertical: 5 * fem),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15 * fem, vertical: 10 * fem),
                              child: SelectionButtonTextComponent(
                                  index: tagId,
                                  selectionList: categoryList,
                                  isMainPage: false,
                                  onTap: (index) {
                                    setState(() {
                                      tagId = index;
                                      getInfoList();
                                    });
                                  }),
                            ),
                            (tagId == 0)
                                ? (infoLength == 0)
                                    ? searchEmptyWidget()
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: infoLength,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                  () => InfoPageDetail(
                                                        id: infoList[index].id,
                                                      ),
                                                  transition:
                                                      Transition.fadeIn);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10 * fem,
                                                  vertical: 10 * fem),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5 * fem,
                                                  vertical: 10 * fem),
                                              height: 80 * fem,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Container(
                                                      width: 100 * fem,
                                                      height: 80 * fem,
                                                      child: Image(
                                                        image: NetworkImage(
                                                            infoList[index]
                                                                .imgUrl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 80 * fem,
                                                    width: 230 * fem,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10 * fem),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                              infoList[index]
                                                                  .title,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: tInfoTitle,
                                                            )),
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              "3002 " +
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .read,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
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
                                      )
                                : (tagId == 1)
                                    ? (infoLength1 == 0)
                                        ? searchEmptyWidget()
                                        : ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: infoLength1,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                      () => InfoPageDetail(
                                                          id: infoList1[index]
                                                              .id),
                                                      transition:
                                                          Transition.fadeIn);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10 * fem,
                                                      vertical: 10 * fem),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5 * fem,
                                                      vertical: 10 * fem),
                                                  height: 80 * fem,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Container(
                                                          width: 100 * fem,
                                                          height: 80 * fem,
                                                          child: Image(
                                                            image: NetworkImage(
                                                                infoList1[index]
                                                                    .imgUrl),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 80 * fem,
                                                        width: 230 * fem,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10 * fem),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Expanded(
                                                                flex: 7,
                                                                child: Text(
                                                                  infoList1[
                                                                          index]
                                                                      .title,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      tInfoTitle,
                                                                )),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  "3002 " +
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .read,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
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
                                          )
                                    : (tagId == 2)
                                        ? (infoLength2 == 0)
                                            ? searchEmptyWidget()
                                            : ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: infoLength2,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                          () => InfoPageDetail(
                                                              id: infoList2[
                                                                      index]
                                                                  .id),
                                                          transition: Transition
                                                              .fadeIn);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  10 * fem,
                                                              vertical:
                                                                  10 * fem),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  5 * fem,
                                                              vertical:
                                                                  10 * fem),
                                                      height: 80 * fem,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Container(
                                                              width: 100 * fem,
                                                              height: 80 * fem,
                                                              child: Image(
                                                                image: NetworkImage(
                                                                    infoList2[
                                                                            index]
                                                                        .imgUrl),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 80 * fem,
                                                            width: 230 * fem,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10 *
                                                                            fem),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Expanded(
                                                                    flex: 7,
                                                                    child: Text(
                                                                      infoList2[
                                                                              index]
                                                                          .title,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          tInfoTitle,
                                                                    )),
                                                                Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                      "3002 " +
                                                                          AppLocalizations.of(context)!
                                                                              .read,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style:
                                                                          tRead,
                                                                    ))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                        : (infoLength3 == 0)
                                            ? searchEmptyWidget()
                                            : ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: infoLength3,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                          () => InfoPageDetail(
                                                              id: infoList3[
                                                                      index]
                                                                  .id),
                                                          transition: Transition
                                                              .fadeIn);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  10 * fem,
                                                              vertical:
                                                                  10 * fem),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  5 * fem,
                                                              vertical:
                                                                  10 * fem),
                                                      height: 80 * fem,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Container(
                                                              width: 100 * fem,
                                                              height: 80 * fem,
                                                              child: Image(
                                                                image: NetworkImage(
                                                                    infoList3[
                                                                            index]
                                                                        .imgUrl),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 80 * fem,
                                                            width: 230 * fem,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10 *
                                                                            fem),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Expanded(
                                                                    flex: 7,
                                                                    child: Text(
                                                                      infoList3[
                                                                              index]
                                                                          .title,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          tInfoTitle,
                                                                    )),
                                                                Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                      "3002 " +
                                                                          AppLocalizations.of(context)!
                                                                              .read,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style:
                                                                          tRead,
                                                                    ))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
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
