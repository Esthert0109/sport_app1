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

  List<InfoListData> topList = [];
  int topLength = 0;
  List<InfoListData> topList1 = [];
  int topLength1 = 0;
  List<InfoListData> topList2 = [];
  int topLength2 = 0;
  List<InfoListData> topList3 = [];
  int topLength3 = 0;

  List<InfoListData> infoList = [];
  int infoLength = 0;
  List<InfoListData> infoList1 = [];
  int infoLength1 = 0;
  List<InfoListData> infoList2 = [];
  int infoLength2 = 0;
  List<InfoListData> infoList3 = [];
  int infoLength3 = 0;

  List<InfoListData> imgList = [];
  int imgLength = 0;
  List<InfoListData> imgList1 = [];
  int imgLength1 = 0;
  List<InfoListData> imgList2 = [];
  int imgLength2 = 0;
  List<InfoListData> imgList3 = [];
  int imgLength3 = 0;

  // List<String> img = [
  //   "https://apicms.thestar.com.my/uploads/images/2022/10/27/1793451.jpeg",
  //   "https://d3544la1u8djza.cloudfront.net/APHI/Blog/2016/10_October/persians/Persian+Cat+Facts+History+Personality+and+Care+_+ASPCA+Pet+Health+Insurance+_+white+Persian+cat+resting+on+a+brown+sofa-min.jpg",
  //   "https://www.dutch.com/cdn/shop/articles/shutterstock_538333303.jpg?v=1683242960",
  //   "https://i.ytimg.com/vi/xvQk-qV1070/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLCHK8qn2BR3DrfXETOUGrmen3kNlw",
  //   "https://us-tuna-sounds-images.voicemod.net/54a00490-7037-4e33-b837-061e21a639a1-1674436281444.png",
  //   "https://i.pinimg.com/280x280_RS/f7/64/9c/f7649c2a35ba2ad5d85a7474c4afa482.jpg"
  // ];

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

  Future<void> getTopInfoList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      if (tagId == 0) {
        InfoListModel? infoModel = await infoProvider.getTopInfoList(tagId + 1);
        topList.addAll(infoModel?.data ?? []);
        topLength = topList.length;
        print("check list: ${topList}");
      } else if (tagId == 1) {
        InfoListModel? infoModel = await infoProvider.getTopInfoList(tagId + 1);
        topList1.addAll(infoModel?.data ?? []);
        topLength1 = topList1.length;
        print("check list: ${topList1}");
      } else if (tagId == 2) {
        InfoListModel? infoModel = await infoProvider.getTopInfoList(tagId + 1);
        topList2.addAll(infoModel?.data ?? []);
        topLength2 = topList2.length;
        print("check list: ${topList2}");
      } else {
        InfoListModel? infoModel = await infoProvider.getTopInfoList(tagId + 1);
        topList3.addAll(infoModel?.data ?? []);
        topLength3 = topList3.length;
        print("check list: ${topList3}");
      }

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

      if (tagId == 0) {
        InfoListModel? infoModel =
            await infoProvider.getImageInfoUrl(tagId + 1);
        imgList.addAll(infoModel?.data ?? []);
        imgLength = imgList.length;
        print("check list: ${imgList}");
      } else if (tagId == 1) {
        InfoListModel? infoModel =
            await infoProvider.getImageInfoUrl(tagId + 1);
        imgList1.addAll(infoModel?.data ?? []);
        imgLength1 = imgList1.length;
        print("check list: ${imgList1}");
      } else if (tagId == 2) {
        InfoListModel? infoModel =
            await infoProvider.getImageInfoUrl(tagId + 1);
        imgList2.addAll(infoModel?.data ?? []);
        imgLength2 = imgList2.length;
        print("check list: ${imgList2}");
      } else {
        InfoListModel? infoModel =
            await infoProvider.getImageInfoUrl(tagId + 1);
        imgList3.addAll(infoModel?.data ?? []);
        imgLength3 = imgList3.length;
        print("check list: ${imgList3}");
      }

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

      topList.clear();
      topList1.clear();
      topList2.clear();
      topList3.clear();
      topLength = topList.length;
      topLength1 = topList1.length;
      topLength2 = topList2.length;
      topLength3 = topList3.length;

      imgList.clear();
      imgList1.clear();
      imgList2.clear();
      imgList3.clear();
      imgLength = imgList.length;
      imgLength1 = imgList1.length;
      imgLength2 = imgList2.length;
      imgLength3 = imgList3.length;

      getInfoList();
      getTopInfoList();
      getImgInfoList();
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoryList();
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
                                      if (tagId == 0) {
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
                                      } else if (tagId == 1) {
                                        infoList1.clear();
                                        infoLength1 = infoList1.length;
                                        topList1.clear();
                                        topLength1 = topList1.length;
                                        imgList1.clear();
                                        imgLength1 = imgList1.length;

                                        page1 = 1;

                                        getInfoList();
                                        isLoading = false;
                                        getTopInfoList();

                                        isLoading = false;
                                        getImgInfoList();
                                      } else if (tagId == 2) {
                                        infoList2.clear();
                                        infoLength2 = infoList2.length;
                                        topList2.clear();
                                        topLength2 = topList2.length;
                                        imgList2.clear();
                                        imgLength2 = imgList2.length;
                                        page2 = 1;

                                        getInfoList();
                                        isLoading = false;
                                        getTopInfoList();
                                        isLoading = false;
                                        getImgInfoList();
                                      } else {
                                        infoList3.clear();
                                        infoLength3 = infoList3.length;
                                        topList3.clear();
                                        topLength3 = topList3.length;
                                        imgList3.clear();
                                        imgLength3 = imgList3.length;
                                        page3 = 1;

                                        getInfoList();
                                        isLoading = false;
                                        getTopInfoList();
                                        isLoading = false;
                                        getImgInfoList();
                                      }
                                    });
                                  }),
                            ),
                            (tagId == 0)
                                ? (infoLength == 0 &&
                                        topLength == 0 &&
                                        imgList.length == 0)
                                    ? searchEmptyWidget()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10 * fem,
                                                0 * fem,
                                                10 * fem,
                                                10 * fem),
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
                                                            () =>
                                                                InfoPageDetail(
                                                                  id: topList[
                                                                          index]
                                                                      .id,
                                                                ),
                                                            transition:
                                                                Transition
                                                                    .fadeIn);
                                                      },
                                                      child: PinNewsComponent(
                                                        title: topList[index]
                                                            .title,
                                                        timeAgo: topList[index]
                                                            .dateStr,
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
                                                    color:
                                                        kUnactivePaginationColor,
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
                                                          transition: Transition
                                                              .fadeIn);
                                                    },
                                                    child: Stack(children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Container(
                                                          width: 343 * fem,
                                                          height: 183 * fem,
                                                          child: Image(
                                                            image: NetworkImage(
                                                                imgList[index]
                                                                    .imgUrl),
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
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
                                                                  size:
                                                                      50 * fem,
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8 * fem),
                                                          child: Text(
                                                            imgList[index]
                                                                .title,
                                                            style: tSwiperTitle,
                                                            overflow:
                                                                TextOverflow
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
                                                            id: infoList[index]
                                                                .id,
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
                                                                infoList[index]
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
                                                                  infoList[
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
                                : (tagId == 1)
                                    ? (infoLength1 == 0 &&
                                            topLength1 == 0 &&
                                            imgList1.length == 0)
                                        ? searchEmptyWidget()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10 * fem,
                                                    0 * fem,
                                                    10 * fem,
                                                    10 * fem),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      for (int index = 0;
                                                          index < topLength1;
                                                          index++)
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                "navi to news detail");
                                                            Get.to(
                                                                () =>
                                                                    InfoPageDetail(
                                                                      id: topList1[
                                                                              index]
                                                                          .id,
                                                                    ),
                                                                transition:
                                                                    Transition
                                                                        .fadeIn);
                                                          },
                                                          child:
                                                              PinNewsComponent(
                                                            title:
                                                                topList1[index]
                                                                    .title,
                                                            timeAgo:
                                                                topList1[index]
                                                                    .dateStr,
                                                            read:
                                                                topList1[index]
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
                                                    Get.to(
                                                        () => InfoPageDetail(
                                                              id: infoList[2]
                                                                  .id,
                                                            ),
                                                        transition:
                                                            Transition.fadeIn);
                                                  },
                                                  child: Swiper(
                                                    pagination:
                                                        SwiperPagination(
                                                      builder:
                                                          DotSwiperPaginationBuilder(
                                                        color:
                                                            kUnactivePaginationColor,
                                                        activeColor:
                                                            kActivePaginationColor,
                                                        activeSize: 6,
                                                        size: 6,
                                                        space: 2,
                                                      ),
                                                      alignment:
                                                          Alignment.topRight,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  15 * fem,
                                                              vertical:
                                                                  5 * fem),
                                                    ),
                                                    autoplay: true,
                                                    autoplayDelay: 3000,
                                                    viewportFraction: 0.95,
                                                    scale: 0.9,
                                                    itemCount: imgList1.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                              () => InfoPageDetail(
                                                                  id: imgList1[
                                                                          index]
                                                                      .id),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn);
                                                        },
                                                        child: Stack(children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Container(
                                                              width: 343 * fem,
                                                              height: 183 * fem,
                                                              child: Image(
                                                                image: NetworkImage(
                                                                    imgList1[
                                                                            index]
                                                                        .imgUrl),
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
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
                                                                      size: 50 *
                                                                          fem,
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
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8 * fem),
                                                              child: Text(
                                                                imgList1[index]
                                                                    .title,
                                                                style:
                                                                    tSwiperTitle,
                                                                overflow:
                                                                    TextOverflow
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
                                                itemCount: infoLength1,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                          () => InfoPageDetail(
                                                              id: infoList1[
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
                                                                    infoList1[
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
                                                                      infoList1[
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
                                                                      "${infoList1[index].readCount}" +
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
                                              ),
                                            ],
                                          )
                                    : (tagId == 2)
                                        ? (infoLength2 == 0 &&
                                                topLength2 == 0 &&
                                                imgList2.length == 0)
                                            ? searchEmptyWidget()
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10 * fem,
                                                        0 * fem,
                                                        10 * fem,
                                                        10 * fem),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          for (int index = 0;
                                                              index <
                                                                  topLength2;
                                                              index++)
                                                            InkWell(
                                                              onTap: () {
                                                                print(
                                                                    "navi to news detail");
                                                                Get.to(
                                                                    () =>
                                                                        InfoPageDetail(
                                                                          id: topList2[index]
                                                                              .id,
                                                                        ),
                                                                    transition:
                                                                        Transition
                                                                            .fadeIn);
                                                              },
                                                              child:
                                                                  PinNewsComponent(
                                                                title: topList2[
                                                                        index]
                                                                    .title,
                                                                timeAgo: topList2[
                                                                        index]
                                                                    .dateStr,
                                                                read: topList2[
                                                                        index]
                                                                    .readCount,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10 * fem),
                                                    height: 183 * fem,
                                                    width: 343 * fem,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "navi to news info");
                                                        Get.to(
                                                            () =>
                                                                InfoPageDetail(
                                                                  id: infoList[
                                                                          3]
                                                                      .id,
                                                                ),
                                                            transition:
                                                                Transition
                                                                    .fadeIn);
                                                      },
                                                      child: Swiper(
                                                        pagination:
                                                            SwiperPagination(
                                                          builder:
                                                              DotSwiperPaginationBuilder(
                                                            color:
                                                                kUnactivePaginationColor,
                                                            activeColor:
                                                                kActivePaginationColor,
                                                            activeSize: 6,
                                                            size: 6,
                                                            space: 2,
                                                          ),
                                                          alignment: Alignment
                                                              .topRight,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15 * fem,
                                                                  vertical:
                                                                      5 * fem),
                                                        ),
                                                        autoplay: true,
                                                        autoplayDelay: 3000,
                                                        viewportFraction: 0.95,
                                                        scale: 0.9,
                                                        itemCount:
                                                            imgList2.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Get.to(
                                                                  () => InfoPageDetail(
                                                                      id: imgList2[
                                                                              index]
                                                                          .id),
                                                                  transition:
                                                                      Transition
                                                                          .fadeIn);
                                                            },
                                                            child: Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Container(
                                                                      width: 343 *
                                                                          fem,
                                                                      height:
                                                                          183 *
                                                                              fem,
                                                                      child:
                                                                          Image(
                                                                        image: NetworkImage(
                                                                            imgList2[index].imgUrl),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        loadingBuilder: (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                          if (loadingProgress ==
                                                                              null) {
                                                                            return child;
                                                                          }
                                                                          return Center(
                                                                            child:
                                                                                LoadingAnimationWidget.staggeredDotsWave(
                                                                              color: kMainGreenColor,
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
                                                                    bottom:
                                                                        5 * fem,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8 * fem),
                                                                      child:
                                                                          Text(
                                                                        imgList2[index]
                                                                            .title,
                                                                        style:
                                                                            tSwiperTitle,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                    itemCount: infoLength2,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                              () => InfoPageDetail(
                                                                  id: infoList2[
                                                                          index]
                                                                      .id),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10 * fem,
                                                                  vertical:
                                                                      10 * fem),
                                                          padding: EdgeInsets
                                                              .symmetric(
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
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      100 * fem,
                                                                  height:
                                                                      80 * fem,
                                                                  child: Image(
                                                                    image: NetworkImage(
                                                                        infoList2[index]
                                                                            .imgUrl),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                    80 * fem,
                                                                width:
                                                                    230 * fem,
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
                                                                        child:
                                                                            Text(
                                                                          infoList2[index]
                                                                              .title,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              tInfoTitle,
                                                                        )),
                                                                    Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            Text(
                                                                          "${infoList2[index].readCount}" +
                                                                              AppLocalizations.of(context)!.read,
                                                                          textAlign:
                                                                              TextAlign.right,
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
                                                  ),
                                                ],
                                              )
                                        : (infoLength3 == 0 &&
                                                topLength3 == 0 &&
                                                imgList3.length == 0)
                                            ? searchEmptyWidget()
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10 * fem,
                                                        0 * fem,
                                                        10 * fem,
                                                        10 * fem),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          for (int index = 0;
                                                              index <
                                                                  topLength3;
                                                              index++)
                                                            InkWell(
                                                              onTap: () {
                                                                print(
                                                                    "navi to news detail");
                                                                Get.to(
                                                                    () =>
                                                                        InfoPageDetail(
                                                                          id: topList3[index]
                                                                              .id,
                                                                        ),
                                                                    transition:
                                                                        Transition
                                                                            .fadeIn);
                                                              },
                                                              child:
                                                                  PinNewsComponent(
                                                                title: topList3[
                                                                        index]
                                                                    .title,
                                                                timeAgo: topList3[
                                                                        index]
                                                                    .dateStr,
                                                                read: topList3[
                                                                        index]
                                                                    .readCount,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10 * fem),
                                                    height: 183 * fem,
                                                    width: 343 * fem,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "navi to news info");
                                                        Get.to(
                                                            () =>
                                                                InfoPageDetail(
                                                                  id: infoList[
                                                                          4]
                                                                      .id,
                                                                ),
                                                            transition:
                                                                Transition
                                                                    .fadeIn);
                                                      },
                                                      child: Swiper(
                                                        pagination:
                                                            SwiperPagination(
                                                          builder:
                                                              DotSwiperPaginationBuilder(
                                                            color:
                                                                kUnactivePaginationColor,
                                                            activeColor:
                                                                kActivePaginationColor,
                                                            activeSize: 6,
                                                            size: 6,
                                                            space: 2,
                                                          ),
                                                          alignment: Alignment
                                                              .topRight,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15 * fem,
                                                                  vertical:
                                                                      5 * fem),
                                                        ),
                                                        autoplay: true,
                                                        autoplayDelay: 3000,
                                                        viewportFraction: 0.95,
                                                        scale: 0.9,
                                                        itemCount:
                                                            imgList3.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Get.to(
                                                                  () => InfoPageDetail(
                                                                      id: imgList3[
                                                                              index]
                                                                          .id),
                                                                  transition:
                                                                      Transition
                                                                          .fadeIn);
                                                            },
                                                            child: Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Container(
                                                                      width: 343 *
                                                                          fem,
                                                                      height:
                                                                          183 *
                                                                              fem,
                                                                      child:
                                                                          Image(
                                                                        image: NetworkImage(
                                                                            imgList3[index].imgUrl),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        loadingBuilder: (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                          if (loadingProgress ==
                                                                              null) {
                                                                            return child;
                                                                          }
                                                                          return Center(
                                                                            child:
                                                                                LoadingAnimationWidget.staggeredDotsWave(
                                                                              color: kMainGreenColor,
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
                                                                    bottom:
                                                                        5 * fem,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8 * fem),
                                                                      child:
                                                                          Text(
                                                                        imgList3[index]
                                                                            .title,
                                                                        style:
                                                                            tSwiperTitle,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                    itemCount: infoLength3,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                              () => InfoPageDetail(
                                                                  id: infoList3[
                                                                          index]
                                                                      .id),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10 * fem,
                                                                  vertical:
                                                                      10 * fem),
                                                          padding: EdgeInsets
                                                              .symmetric(
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
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      100 * fem,
                                                                  height:
                                                                      80 * fem,
                                                                  child: Image(
                                                                    image: NetworkImage(
                                                                        infoList3[index]
                                                                            .imgUrl),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                    80 * fem,
                                                                width:
                                                                    230 * fem,
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
                                                                        child:
                                                                            Text(
                                                                          infoList3[index]
                                                                              .title,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              tInfoTitle,
                                                                        )),
                                                                    Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            Text(
                                                                          "${infoList3[index].readCount}" +
                                                                              AppLocalizations.of(context)!.read,
                                                                          textAlign:
                                                                              TextAlign.right,
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

//mock class
class MockClass {
  final String title;
  final String timeAgo;
  final int read;

  MockClass({required this.title, required this.timeAgo, required this.read});
}
