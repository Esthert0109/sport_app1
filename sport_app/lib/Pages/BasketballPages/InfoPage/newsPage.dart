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
  List<int> categoryId = [];

  List<InfoListData> topList = [];
  int topLength = 0;

  List<InfoListData> infoList = [];
  int infoLength = 0;

  List<InfoListData> imgList = [];
  int imgLength = 0;

  //variables
  bool _showAppBar = true;
  bool isScrollingDown = false;
  bool isLoading = false;
  int tagId = 1;
  int page = 1;
  int size = 15;

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
        categoryId.add(list[i].categoryId);
      }

      setState(() {
        isLoading = false;
        getInfoList();
        getTopInfoList();
        getImgInfoList();
      });
    }
  }

  Future<void> getTopInfoList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      InfoListModel? infoModel =
          await infoProvider.getTopInfoList(categoryId[tagId]);
      topList.addAll(infoModel?.data ?? []);
      topLength = topList.length;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getImgInfoList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      InfoListModel? infoModel =
          await infoProvider.getImageInfoUrl(categoryId[tagId]);
      imgList.addAll(infoModel?.data ?? []);
      imgLength = imgList.length;

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

      InfoListModel? infoModel =
          await infoProvider.getInfoList(page, size, categoryId[tagId]);
      infoList.addAll(infoModel?.data ?? []);
      infoLength = infoList.length;

      setState(() {
        isLoading = false;
        page++;
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

      infoList.clear();

      infoLength = infoList.length;

      topList.clear();
      topLength = topList.length;

      imgList.clear();
      imgLength = imgList.length;

      getInfoList();
      getTopInfoList();
      getImgInfoList();
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoryList();
    isLoading = false;
    getInfoList();
    isLoading = false;
    getTopInfoList();
    isLoading = false;
    getImgInfoList();
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

                                      infoList.clear();
                                      infoLength = infoList.length;
                                      topList.clear();
                                      topLength = topList.length;
                                      imgList.clear();
                                      imgLength = imgList.length;
                                      page = 1;

                                      getInfoList();
                                      isLoading = false;
                                      getTopInfoList();
                                      isLoading = false;
                                      getImgInfoList();
                                    });
                                  }),
                            ),
                            (infoLength == 0 &&
                                    topLength == 0 &&
                                    imgList.length == 0)
                                ? searchEmptyWidget()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10 * fem,
                                            0 * fem, 10 * fem, 10 * fem),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              for (int index = 0;
                                                  index < topLength;
                                                  index++)
                                                InkWell(
                                                  onTap: () {
                                                    print(
                                                        "navi to news detail");
                                                    Get.to(
                                                        () => InfoPageDetail(
                                                              id: topList[index]
                                                                  .id,
                                                            ),
                                                        transition:
                                                            Transition.fadeIn);
                                                  },
                                                  child: PinNewsComponent(
                                                    title: topList[index].title,
                                                    timeAgo:
                                                        topList[index].dateStr,
                                                    read: topList[index]
                                                        .readCount,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10 * fem),
                                        height: 183 * fem,
                                        width: 343 * fem,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            print("navi to news info");
                                          },
                                          child: Swiper(
                                            pagination: SwiperPagination(
                                              builder:
                                                  DotSwiperPaginationBuilder(
                                                color: kUnactivePaginationColor,
                                                activeColor:
                                                    kActivePaginationColor,
                                                activeSize: 6,
                                                size: 6,
                                                space: 2,
                                              ),
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 15 * fem,
                                                  vertical: 5 * fem),
                                            ),
                                            autoplay: true,
                                            autoplayDelay: 3000,
                                            viewportFraction: 0.95,
                                            scale: 0.9,
                                            itemCount: imgList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                      () => InfoPageDetail(
                                                          id: imgList[index]
                                                              .id),
                                                      transition:
                                                          Transition.fadeIn);
                                                },
                                                child: Stack(children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Container(
                                                      width: 343 * fem,
                                                      height: 183 * fem,
                                                      child: Image(
                                                        image: NetworkImage(
                                                            imgList[index]
                                                                .imgUrl),
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                            child: LoadingAnimationWidget
                                                                .staggeredDotsWave(
                                                              color:
                                                                  kMainGreenColor,
                                                              size: 50 * fem,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 5 * fem,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  8 * fem),
                                                      child: Text(
                                                        imgList[index].title,
                                                        style: tSwiperTitle,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
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
                                                              "${infoList[index].readCount}" +
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
                                      ),
                                    ],
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
