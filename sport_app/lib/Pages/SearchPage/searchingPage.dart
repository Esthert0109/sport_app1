import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Constants/Controller/layoutController.dart';
import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/matchesModel.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/collectionProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Provider/searchProvider.dart';

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
  String searchCriteria = '';

  // variables to fetch data
  List<PopularKeyWordsData> popularKeywordList = [];
  int keywordLength = 0;

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
                                    print("check search controller: $value");
                                    isSearched = true;
                                  }
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
                        "取消",
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
                // height: 500 * fem,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "历史记录",
                            style: tMain,
                          ),
                          InkWell(
                            onTap: () {
                              print("clear history");
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 5 * fem),
                              child: Text(
                                "清空",
                                style: tClearSearchHistory,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          )
                        ],
                      ),
                      Wrap(
                        spacing: 5 * fem, // Horizontal spacing between items
                        runSpacing: 0 * fem, // Vertical spacing between lines
                        children: List.generate(
                          10, // Replace itemCount with the actual number of items in your list
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
                                  horizontal: 15 * fem, vertical: 5 * fem),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    searchController = TextEditingController(
                                        text: "世界杯$index");
                                  });
                                },
                                child: Text(
                                  "世界杯$index",
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
                          "热门搜索",
                          style: tMain,
                        ),
                      ),
                      Wrap(
                        spacing: 5 * fem, // Horizontal spacing between items
                        runSpacing: 0 * fem, // Vertical spacing between lines
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
                                  horizontal: 15 * fem, vertical: 5 * fem),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    searchController = TextEditingController(
                                        text: popularKeywordList[index]
                                            .popularKeywords);
                                  });
                                },
                                child: Text(
                                  popularKeywordList[index].popularKeywords,
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
            )
          ],
        ),
      ),
    );
  }
}
