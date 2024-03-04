import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Component/Common/snackBar.dart';
import '../../Component/MainPage/gameDisplayComponent.dart';
import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/collectionProvider.dart';
import '../../Provider/searchEventProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchEventPage extends StatefulWidget {
  const SearchEventPage({Key? key}) : super(key: key);

  @override
  State<SearchEventPage> createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEventPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchEventProvider searchProvider = SearchEventProvider();
  BookmarkProvider saveBookmarkProvider = BookmarkProvider();
  UserDataModel userModel = Get.find<UserDataModel>();
  final ScrollController scrollController = ScrollController();

  String searchText = "";
  String setBookmarkList = "";
  String selectedText = "";
  int searchPages = 1;
  int getPopularSearchListCount = 0;
  Map<String, dynamic> saveBookmarkResult = {};

  List<dynamic> searchLiveStreamCompetitionResult = [];
  List<dynamic> searchLiveStreamTeamResult = [];
  List<dynamic> searchLiveOverallResult = [];
  List<dynamic> searchLiveStreamCompetitionScrollResult = [];
  List<dynamic> searchLiveStreamTeamScrollResult = [];
  List<dynamic> getBookmarkList = [];
  List<dynamic> trendingData = [];
  List<dynamic>? popularSearch = [];

  bool isLoading = false;
  bool shouldRefresh = false;
  bool checkData = true;
  bool checkSearchText = false;
  bool isScrollingDown = false, isRefreshing = false;
  bool checkBookmark = false;
  bool checkBookmarkDuplicate = false;
  bool isCN = true;

  List<dynamic> sampleSearchData = [
    {"name": "埃斯柏兰卡"},
    {"name": "墨西哥"},
    {"name": "联盟杯"},
  ];

  List<dynamic> sampleTrendingData = [
    {"name": "埃斯柏兰卡"},
    {"name": "墨西哥超级联赛"},
    {"name": "非洲足球联盟杯"},
    {"name": "Division"},
    {"name": "亚特兰特"},
    {"name": "摩洛哥"},
    {"name": "德国足球甲级联赛"},
    {"name": "法国全国联赛"},
    {"name": "比利时U21联赛"},
    {"name": "丹麦女子甲级联赛"},
    {"name": "北爱尔兰联赛杯"},
    {"name": "乌克兰杯"},
  ];

  final List<String> imgList = [
    'images/sample1.png',
    'images/sample2.png',
    // Add more image URLs
  ];

  @override
  void initState() {
    super.initState();

    getPopularSearchList()?.then((value) {
      setState(() {
        popularSearch = value;
      });
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (scrollController.position.atEdge) {
          bool isTop = scrollController.position.pixels == 0;
          if (isTop) {
          } else {
            if (mounted) {
              setState(() {
                isScrollingDown = true;
                Future.delayed(Duration(seconds: 2), () async {
                  isScrollingDown = false;
                  searchPages++;
                  searchProvider
                      .searchLiveCompetitionStream(
                          searchText, searchPages.toString())
                      .then((searchLiveStreamCompetitionScrollResult) {
                    if (mounted) {
                      setState(() {
                        for (var item
                            in searchLiveStreamCompetitionScrollResult) {
                          if (!searchLiveOverallResult
                              .any((element) => element["id"] == item["id"])) {
                            searchLiveOverallResult.add(item);
                          }
                        }
                        for (var item in searchLiveStreamTeamScrollResult) {
                          if (!searchLiveOverallResult
                              .any((element) => element["id"] == item["id"])) {
                            searchLiveOverallResult.add(item);
                          }
                        }
                      });
                    }
                  });
                  searchProvider
                      .searchLiveTeamStream(searchText, searchPages.toString())
                      .then((searchLiveStreamTeamScrollResult) {
                    if (mounted) {
                      setState(() {
                        for (var item
                            in searchLiveStreamCompetitionScrollResult) {
                          if (!searchLiveOverallResult
                              .any((element) => element["id"] == item["id"])) {
                            searchLiveOverallResult.add(item);
                          }
                        }
                        for (var item in searchLiveStreamTeamScrollResult) {
                          if (!searchLiveOverallResult
                              .any((element) => element["id"] == item["id"])) {
                            searchLiveOverallResult.add(item);
                          }
                        }
                      });
                    }
                  });
                  searchListWidget();
                });
              });
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> toggleRefresh() async {
    String removeBookmarkId = await getPreBookmarkId();
    String savedBookmarkId = await savedPreBookmarkId();
    setState(() {
      shouldRefresh = !shouldRefresh;
      if (mounted) {
        setState(() {
          checkData = false;
          checkSearchText = false;
          if (removeBookmarkId != "") {
            getBookmarkList.remove(int.parse(removeBookmarkId));
          } else {
            getBookmarkList.add(int.parse(savedBookmarkId));
          }
          removePreBookmarkId();
          Container(
            child: searchListWidget(),
          );
        });
      }
    });
  }

  Future<List<dynamic>> getLiveStreamBookmark() async {
    List<dynamic> getBookmarkList =
        await saveBookmarkProvider.getLiveStreamBookmark();
    return getBookmarkList;
  }

  Future<String> getPreBookmarkId() async {
    final prefs = await SharedPreferences.getInstance();
    final removeBookmarkId = prefs.getString('removeBookmarkId') ?? "";
    return removeBookmarkId;
  }

  Future<String> savedPreBookmarkId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedBookmarkId = prefs.getString('savedBookmarkId') ?? "";
    return savedBookmarkId;
  }

  Future<String?> removePreBookmarkId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedBookmarkId');
    await prefs.remove('removeBookmarkId');
    return null;
  }

  Future<List<dynamic>?> getPopularSearchList() async {
    final getPopularSearchList = await searchProvider.getPopularSearchList();
    getPopularSearchListCount = getPopularSearchList!.length;
    return getPopularSearchList;
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    // Set the status bar color

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(statusBarColor: kMainGreenColor),
    // );
    return SafeArea(
        child: Scaffold(
            backgroundColor: kMainBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: kMainGreenColor,
              title: Padding(
                padding: EdgeInsets.fromLTRB(0, 10 * fem, 0, 10 * fem),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 300,
                        height: 40,
                        padding: EdgeInsets.symmetric(
                            vertical: 3 * fem, horizontal: 5 * fem),
                        child: TextField(
                            controller: _searchController,
                            onChanged: (text) {
                              if (mounted) {
                                setState(() {
                                  if (text.isNotEmpty) {
                                    checkData = true;
                                  }
                                });
                              }
                            },
                            cursorColor: kMainGreenColor,
                            cursorHeight: 30,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.search,
                                hintStyle: tSearch,
                                contentPadding: EdgeInsets.all(10 * fem),
                                counterText: "",
                                filled: true,
                                fillColor: const Color(0x4DFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SvgPicture.asset(
                                  'images/appBar/search.svg',
                                  width: 24 * fem,
                                  height: 24 * fem,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.grey[600]),
                                        onPressed: () {
                                          if (mounted) {
                                            setState(() {
                                              checkData = true;
                                              _searchController.clear();
                                              searchLiveStreamCompetitionResult =
                                                  [];
                                            });
                                          }
                                        },
                                      )
                                    : null),
                            textInputAction: TextInputAction.done,
                            maxLength: 20,
                            autofocus: true,
                            enabled: true,
                            onSubmitted: (textSearch) async {
                              // process Search
                              searchLiveOverallResult = [];
                              searchText = textSearch;
                              searchPages = 1;
                              searchLiveStreamCompetitionResult =
                                  await searchProvider
                                      .searchLiveCompetitionStream(
                                          searchText, searchPages.toString());
                              searchLiveStreamTeamResult =
                                  await searchProvider.searchLiveTeamStream(
                                      searchText, searchPages.toString());
                              print(searchLiveStreamCompetitionResult);
                              print(searchLiveStreamTeamResult);

                              searchLiveStreamCompetitionResult.sort((a, b) {
                                final DateTime dateTimeA =
                                    a["matchTime"] ?? DateTime(0);
                                final DateTime dateTimeB =
                                    b["matchTime"] ?? DateTime(0);
                                return dateTimeB.compareTo(dateTimeA);
                              });

                              searchLiveStreamTeamResult.sort((a, b) {
                                final DateTime dateTimeA =
                                    a["matchTime"] ?? DateTime(0);
                                final DateTime dateTimeB =
                                    b["matchTime"] ?? DateTime(0);
                                return dateTimeB.compareTo(dateTimeA);
                              });

                              if (searchText.isEmpty) {
                                openSnackbar(
                                    context,
                                    AppLocalizations.of(context)!.noResult,
                                    kComponentErrorTextColor);
                              } else if (searchLiveStreamCompetitionResult
                                      .isEmpty &&
                                  searchLiveStreamTeamResult.isEmpty) {
                                if (mounted) {
                                  setState(() {
                                    checkData = false;
                                    checkSearchText = true;
                                  });
                                }
                                Container(child: searchEmptyWidget());
                                openSnackbar(
                                    context,
                                    AppLocalizations.of(context)!.noResult,
                                    kComponentErrorTextColor);
                              } else {
                                if (mounted) {
                                  setState(() {
                                    checkData = false;
                                    checkSearchText = false;
                                    getBookmarkList = [];
                                    getLiveStreamBookmark().then((value) {
                                      if (mounted) {
                                        setState(() {
                                          for (var i = 0;
                                              i < value.length;
                                              i++) {
                                            getBookmarkList.add(value[i]['id']);
                                          }
                                        });
                                      }
                                    });
                                    for (var item
                                        in searchLiveStreamTeamResult) {
                                      if (!searchLiveOverallResult.any(
                                          (element) =>
                                              element["id"] == item["id"])) {
                                        searchLiveOverallResult.add(item);
                                      }
                                    }
                                    for (var item
                                        in searchLiveStreamCompetitionResult) {
                                      if (!searchLiveOverallResult.any(
                                          (element) =>
                                              element["id"] == item["id"])) {
                                        searchLiveOverallResult.add(item);
                                      }
                                    }
                                    Container(
                                      child: searchListWidget(),
                                    );
                                  });
                                }
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    // Set the background color to green
                    primary: Colors.white, // Set the text color to white
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: checkData
                          ? searchHistoryWidget()
                          : checkSearchText
                              ? searchEmptyWidget()
                              : searchListWidget(),
                    ),
                    Center(
                      child: Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: isScrollingDown,
                          child: Container(
                              margin: EdgeInsets.only(top: 0, bottom: 0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kComponentSuccessTextColor),
                              ))),
                    )
                  ]),
            )));
  }

  Widget searchHistoryWidget() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              AppLocalizations.of(context)!.history,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSansSC',
                  height: 1,
                  letterSpacing: 0.30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Text(
              AppLocalizations.of(context)!.clear,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSansSC',
                  height: 1,
                  letterSpacing: 0.30,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ]),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: searchHistoryList(),
            ),
          ]),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              AppLocalizations.of(context)!.trending,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSansSC',
                  height: 1,
                  letterSpacing: 0.30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: trendingList(),
            ),
          ]),
        ),
      ],
    );
  }

  Widget trendingList() {
    // 展示热门搜索
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: List.generate(
        // sampleTrendingData.length,
        getPopularSearchListCount,
        (index) {
          return GestureDetector(
            onTap: () async {
              searchLiveOverallResult = [];
              _searchController.text = popularSearch?[index]['popularKeywords'];
              searchText = popularSearch?[index]['popularKeywords'];
              searchPages = 1;
              searchLiveStreamCompetitionResult =
                  await searchProvider.searchLiveCompetitionStream(
                      searchText, searchPages.toString());
              searchLiveStreamTeamResult = await searchProvider
                  .searchLiveTeamStream(searchText, searchPages.toString());

              searchLiveStreamCompetitionResult.sort((a, b) {
                final DateTime dateTimeA = a["matchTime"] ?? DateTime(0);
                final DateTime dateTimeB = b["matchTime"] ?? DateTime(0);
                return dateTimeB.compareTo(dateTimeA);
              });

              searchLiveStreamTeamResult.sort((a, b) {
                final DateTime dateTimeA = a["matchTime"] ?? DateTime(0);
                final DateTime dateTimeB = b["matchTime"] ?? DateTime(0);
                return dateTimeB.compareTo(dateTimeA);
              });

              if (searchLiveStreamCompetitionResult.isEmpty &&
                  searchLiveStreamTeamResult.isEmpty) {
                if (mounted) {
                  setState(() {
                    checkData = false;
                    checkSearchText = true;
                  });
                }
                Container(child: searchEmptyWidget());
                openSnackbar(context, AppLocalizations.of(context)!.noResult,
                    kComponentErrorTextColor);
              } else {
                if (mounted) {
                  setState(() {
                    checkData = false;
                    checkSearchText = false;
                    getBookmarkList = [];
                    getLiveStreamBookmark().then((value) {
                      if (mounted) {
                        setState(() {
                          for (var i = 0; i < value.length; i++) {
                            getBookmarkList.add(value[i]['id']);
                          }
                        });
                      }
                    });
                    for (var item in searchLiveStreamTeamResult) {
                      if (!searchLiveOverallResult
                          .any((element) => element["id"] == item["id"])) {
                        searchLiveOverallResult.add(item);
                      }
                    }
                    for (var item in searchLiveStreamCompetitionResult) {
                      if (!searchLiveOverallResult
                          .any((element) => element["id"] == item["id"])) {
                        searchLiveOverallResult.add(item);
                      }
                    }
                    Container(
                      child: searchListWidget(),
                    );
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(popularSearch?[index]['popularKeywords']),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchHistoryList() {
    // 展示用户搜索历史
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: List.generate(
        3,
        (index) {
          return GestureDetector(
            onTap: () async {
              searchLiveOverallResult = [];
              _searchController.text = sampleSearchData[index]['name'];
              searchText = sampleSearchData[index]['name'];
              searchPages = 1;
              searchLiveStreamCompetitionResult =
                  await searchProvider.searchLiveCompetitionStream(
                      searchText, searchPages.toString());
              searchLiveStreamTeamResult = await searchProvider
                  .searchLiveTeamStream(searchText, searchPages.toString());

              searchLiveStreamCompetitionResult.sort((a, b) {
                final DateTime dateTimeA = a["matchTime"] ?? DateTime(0);
                final DateTime dateTimeB = b["matchTime"] ?? DateTime(0);
                return dateTimeB.compareTo(dateTimeA);
              });

              searchLiveStreamTeamResult.sort((a, b) {
                final DateTime dateTimeA = a["matchTime"] ?? DateTime(0);
                final DateTime dateTimeB = b["matchTime"] ?? DateTime(0);
                return dateTimeB.compareTo(dateTimeA);
              });

              if (searchLiveStreamCompetitionResult.isEmpty &&
                  searchLiveStreamTeamResult.isEmpty) {
                if (mounted) {
                  setState(() {
                    checkData = false;
                    checkSearchText = true;
                  });
                }
                Container(child: searchEmptyWidget());
                openSnackbar(context, AppLocalizations.of(context)!.noResult,
                    kComponentErrorTextColor);
              } else {
                if (mounted) {
                  setState(() {
                    checkData = false;
                    checkSearchText = false;
                    getBookmarkList = [];
                    getLiveStreamBookmark().then((value) {
                      if (mounted) {
                        setState(() {
                          for (var i = 0; i < value.length; i++) {
                            getBookmarkList.add(value[i]['id']);
                          }
                        });
                      }
                    });
                    for (var item in searchLiveStreamTeamResult) {
                      if (!searchLiveOverallResult
                          .any((element) => element["id"] == item["id"])) {
                        searchLiveOverallResult.add(item);
                      }
                    }
                    for (var item in searchLiveStreamCompetitionResult) {
                      if (!searchLiveOverallResult
                          .any((element) => element["id"] == item["id"])) {
                        searchLiveOverallResult.add(item);
                      }
                    }
                    Container(
                      child: searchListWidget(),
                    );
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(sampleSearchData[index]['name']),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchEmptyWidget() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(120, 200, 120, 120),
        child: Image.asset('images/common/search_empty.png'));
  }

  Widget searchListWidget() {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * fem),
        child: Column(children: [
          for (int i = 0; i < searchLiveOverallResult.length; i++)
            InkWell(
              onTap: () {
                // if (searchLiveOverallResult?[i]['lineUp'] == null) {
                //   searchLiveOverallResult?[i]['lineUp'] = 0;
                // }
                // TournamentDetails(
                //   id: '${searchLiveOverallResult?[i]['id']}',
                //   matchDate: '${searchLiveOverallResult?[i]['matchDate']}',
                //   matchStatus: '${searchLiveOverallResult?[i]['statusStr']}',
                //   matchName:
                //       '${searchLiveOverallResult?[i]['competitionName']}',
                //   homeTeamFormation:
                //       '${searchLiveOverallResult?[i]['homeFormation']}',
                //   awayTeamFormation:
                //       '${searchLiveOverallResult?[i]['awayFormation']}',
                //   lineUp: searchLiveOverallResult?[i]['lineUp'],
                // ).launch(context);
                // print(getBookmarkList);
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

              // child: LiveDisplayBlock(
              //   getBookmarkBlockList: getBookmarkList,
              //   onTapCallback: toggleRefresh,
              //   index: i,
              //   id: searchLiveOverallResult?[i]['id'].toString(),
              //   competitionType:
              //       searchLiveOverallResult?[i]['competitionName'].toString(),
              //   duration:
              //       searchLiveOverallResult?[i]['matchTimeStr'].toString(),
              //   savedAmount: '0',
              //   isSaved:
              //       getBookmarkList.contains(searchLiveOverallResult[i]['id']),
              //   teamAName:
              //       searchLiveOverallResult?[i]['homeTeamName'].toString(),
              //   teamALogo:
              //       searchLiveOverallResult?[i]['homeTeamLogo'].toString(),
              //   teamAScore:
              //       searchLiveOverallResult?[i]['homeTeamScore'].toString(),
              //   teamBName:
              //       searchLiveOverallResult?[i]['awayTeamName'].toString(),
              //   teamBLogo:
              //       searchLiveOverallResult?[i]['awayTeamLogo'].toString(),
              //   teamBScore:
              //       searchLiveOverallResult?[i]['awayTeamScore'].toString(),
              //   status: searchLiveOverallResult?[i]['statusStr'].toString(),
              // ),
            ),
        ]));
  }
}
