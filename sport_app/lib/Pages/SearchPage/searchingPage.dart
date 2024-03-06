import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Component/Loading/emptyResultComponent.dart';
import 'package:sport_app/Services/Utils/sharedPreferencesUtils.dart';

import '../../Component/MainPage/gameDisplayComponent.dart';
import '../../Constants/Controller/layoutController.dart';
import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/matchesModel.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/collectionProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Provider/searchProvider.dart';
import '../BasketballPages/basketballTournamentDetails.dart';
import '../FootballPages/footballTournamentDetails.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  // controller
  TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final LayoutController lc = Get.find<LayoutController>();
  late FocusNode focusNode;

  // services and provider
  SearchProvider searchProvider = SearchProvider();
  BookmarkProvider saveBookmarkProvider = BookmarkProvider();

  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  // common variables
  bool _showAppBar = true;
  bool isSearched = false;
  bool isLoading = false;
  bool isSearchLoading = false;
  String searchCriteria = '';
  int page = 1;
  int size = 10;

  // variables to fetch data
  List<PopularKeyWordsData> popularKeywordList = [];
  int keywordLength = 0;
  List<SearchMatchesData> searchResult = [];
  int searchResultLength = 0;
  List<String>? searchHistory = [];
  int searchHistoryLength = 0;

  //choices of main page
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

  Future<void> getSearchResultList(String search) async {
    SearchMatchesModel? searchMatchesModel =
        await searchProvider.searchMatches(page, size, search);

    setState(() {
      isSearchLoading = true;
    });
    searchResult.addAll(searchMatchesModel?.data ?? []);
    searchResultLength = searchResult.length;

    setState(() {
      isSearchLoading = false;
      page++;
    });
  }

  Future<void> getAllPopularKeyWords() async {
    PopularKeyWordsModel? popularKeywordListModel =
        await searchProvider.getAllPopularKeyWords();

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      popularKeywordList.addAll(popularKeywordListModel?.data ?? []);
      keywordLength = popularKeywordList.length;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPopularKeyWords();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> getSearchHistory() async {
    searchHistory = await SharedPreferencesUtils.getSearchHistory();
    searchHistoryLength = searchHistory?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    getSearchHistory();

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
                    padding: EdgeInsets.fromLTRB(
                        15 * fem, 8 * fem, 0 * fem, 8 * fem),
                    width: 280 * fem,
                    height: 40 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * fem),
                      color: kMainComponentColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/appBar/searching.svg',
                          width: 12 * fem,
                          height: 12 * fem,
                        ),
                        SizedBox(
                          width: 2 * fem,
                        ),
                        Expanded(
                          child: Container(
                            width: 260 * fem,
                            margin: EdgeInsets.only(left: 10 * fem),
                            child: TextField(
                              controller: searchController,
                              style: tSearchingText,
                              focusNode: focusNode,
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    searchCriteria = value;
                                  }
                                });
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  isSearched = true;
                                  searchResult.clear();
                                  searchResultLength = searchResult.length;
                                  getSearchResultList(value);
                                  SharedPreferencesUtils.saveSearchHistory(
                                      value);
                                });
                              },
                              cursorColor: kMainGreenColor,
                              cursorHeight: 20 * fem,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)!.search,
                                  hintStyle: tSearchBarText,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8 * fem),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0 * fem, horizontal: 0 * fem),
                                    onPressed: () {
                                      setState(() {
                                        searchController.clear();
                                        isSearched = false;
                                      });
                                    },
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 60 * fem,
                      height: 40 * fem,
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: tCancelSearch,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 10 * fem, vertical: 15 * fem),
                padding: EdgeInsets.symmetric(horizontal: 5 * fem),
                child: LazyLoadScrollView(
                  onEndOfPage: () {
                    setState(() {
                      if (isSearched) {
                        getSearchResultList(searchController.text);
                      }
                    });
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: isSearched
                        ? isSearchLoading
                            ? Column(children: [
                                for (int i = 0; i < 4; i++)
                                  CardLoading(
                                    height: 100 * fem,
                                    borderRadius:
                                        BorderRadius.circular(8 * fem),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10 * fem,
                                        vertical: 10 * fem),
                                  ),
                              ])
                            : (searchResultLength == 0)
                                ? searchEmptyWidget()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        itemCount: searchResultLength,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              print("navi into tournament");
                                              if (userModel.isFootball.value) {
                                                TournamentDetails(
                                                  id: '${searchResult[index].id}',
                                                  matchDate:
                                                      '${searchResult[index].matchDate}',
                                                  matchStatus:
                                                      '${searchResult[index].statusStr}',
                                                  matchName:
                                                      '${searchResult[index].competitionName}',
                                                  homeTeamFormation:
                                                      '${searchResult[index].homeFormation}',
                                                  awayTeamFormation:
                                                      '${searchResult[index].awayFormation}',
                                                  lineUp: searchResult[index]
                                                          .lineUp ??
                                                      0,
                                                ).launch(context);
                                              } else {
                                                BasketballTournamentDetails(
                                                        id:
                                                            '${searchResult[index].id}',
                                                        matchDate:
                                                            '${searchResult[index].matchDate}',
                                                        matchStatus:
                                                            '${searchResult[index].statusStr}',
                                                        matchName:
                                                            '${searchResult[index].competitionName}')
                                                    .launch(context);
                                              }
                                            },
                                            child: GameDisplayComponent(
                                              id: searchResult[index].id ?? 0,
                                              competitionType:
                                                  searchResult[index]
                                                          .competitionName ??
                                                      "",
                                              duration: searchResult[index]
                                                      .matchTimeStr ??
                                                  "00:00",
                                              teamAName: searchResult[index]
                                                      .homeTeamName ??
                                                  "",
                                              teamALogo: searchResult[index]
                                                      .homeTeamLogo ??
                                                  'images/mainpage/sampleLogo.png',
                                              teamAScore: searchResult[index]
                                                  .homeTeamScore
                                                  .toString(),
                                              teamBName: searchResult[index]
                                                      .awayTeamName ??
                                                  "",
                                              teamBLogo: searchResult[index]
                                                      .awayTeamLogo ??
                                                  'images/mainpage/sampleLogo.png',
                                              teamBScore: searchResult[index]
                                                  .awayTeamScore
                                                  .toString(),
                                              isSaved: searchResult[index]
                                                      .hasCollected ??
                                                  false,
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.history,
                                    style: tMain,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print("clear history");
                                      SharedPreferencesUtils
                                          .clearSearchHistory();
                                      setState(() {
                                        searchHistory!.clear();
                                        searchHistoryLength =
                                            searchHistory!.length;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5 * fem),
                                      child: Text(
                                        AppLocalizations.of(context)!.clear,
                                        style: tClearSearchHistory,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              (searchHistoryLength == 0)
                                  ? SizedBox(
                                      height: 30 * fem,
                                    )
                                  : Wrap(
                                      spacing: 5 *
                                          fem, // Horizontal spacing between items
                                      runSpacing: 0 *
                                          fem, // Vertical spacing between lines
                                      children: List.generate(
                                        searchHistoryLength, // Replace itemCount with the actual number of items in your list
                                        (index) {
                                          return Container(
                                            height: 34 * fem,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                              color: kMainComponentColor,
                                            ),
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                15 * fem, 10 * fem, 0 * fem),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15 * fem,
                                                vertical: 5 * fem),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  searchController =
                                                      TextEditingController(
                                                          text: searchHistory?[
                                                                  index] ??
                                                              "");
                                                });
                                              },
                                              child: Text(
                                                searchHistory?[index] ?? "",
                                                style: tSearchTag,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(top: 20 * fem),
                                child: Text(
                                  AppLocalizations.of(context)!.trending,
                                  style: tMain,
                                ),
                              ),
                              Wrap(
                                spacing:
                                    5 * fem, // Horizontal spacing between items
                                runSpacing:
                                    0 * fem, // Vertical spacing between lines
                                children: List.generate(
                                  keywordLength, // Replace itemCount with the actual number of items in your list
                                  (index) {
                                    return Container(
                                      height: 34 * fem,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: kMainComponentColor,
                                      ),
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 15 * fem, 10 * fem, 0 * fem),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15 * fem,
                                          vertical: 5 * fem),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            searchController =
                                                TextEditingController(
                                                    text: popularKeywordList[
                                                            index]
                                                        .popularKeywords);
                                          });
                                        },
                                        child: Text(
                                          popularKeywordList[index]
                                              .popularKeywords,
                                          style: tSearchTag,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
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
