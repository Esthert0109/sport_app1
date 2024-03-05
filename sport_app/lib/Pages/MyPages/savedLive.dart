import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Model/userDataModel.dart';

import '../../Component/MainPage/gameDisplayComponent.dart';
import '../../Constants/colorConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Constants/textConstant.dart';
import '../../Model/collectionModel.dart';
import '../../Provider/collectionProvider.dart';
import '../BasketballPages/basketballTournamentDetails.dart';

class SavedCollection extends StatefulWidget {
  const SavedCollection({super.key});

  @override
  State<SavedCollection> createState() => _SavedCollectionState();
}

class _SavedCollectionState extends State<SavedCollection> {
  // loading
  bool isLoading = false;

  // services and provider
  UserDataModel userDataModel = UserDataModel();
  BookmarkProvider provider = BookmarkProvider();

  // controller
  ScrollController _scrollController = ScrollController();

  // variables
  int page = 1;
  int size = 10;

  List<CollectMatchesData> allCollectionList = []; //get list in each date
  int collectionMatchesDataLength = 0;

  // fetch data
  List<AllCollectMatchesData> collectionList = []; // get number of date listed
  int collectionLength = 0;

  Future<void> getAllSavedCollections() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      print("check status: ${userDataModel.isFootball.value}");

      if (userDataModel.isFootball.value) {
        AllCollectMatchesModel? allCollectionModel =
            await provider.getAllFootballCollection(page, size);
        collectionList.addAll(allCollectionModel?.data ?? []);
        collectionLength = collectionList.length;
        print("check collection length: ${collectionLength}");
        print("check collection length: ${collectionList[0].data.length}");
      } else {
        AllCollectMatchesModel? allCollectionModel =
            await provider.getAllBasketballCollection(page, size);
        collectionList.addAll(allCollectionModel?.data ?? []);
        collectionLength = collectionList.length;

        print("check collection length: ${collectionLength}");
        print("check collection length: ${collectionList[0].data.length}");
      }

      setState(() {
        isLoading = false;
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSavedCollections();
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return SafeArea(
        child: Scaffold(
      backgroundColor: kMainBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainGreenColor,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kMainComponentColor),
        title: Text(AppLocalizations.of(context)!.myCollection,
            style: tInfoDetailTitle),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20 * fem,
            )),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20 * fem),
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: collectionLength,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return isLoading
                  ? Column(children: [
                      for (int i = 0; i < collectionLength; i++)
                        CardLoading(
                          height: 100 * fem,
                          borderRadius: BorderRadius.circular(8 * fem),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10 * fem, vertical: 10 * fem),
                        ),
                    ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              20 * fem, 15 * fem, 20 * fem, 10 * fem),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat('yyyy/MM/dd  EEEE', 'zh_CN').format(
                                DateTime.parse(collectionList[index].date)),
                            style: tCollectionDateTitle,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: collectionList[index].data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                print("navi into tournament");
                                BasketballTournamentDetails(
                                        id:
                                            '${collectionList[index].data[i].id}',
                                        matchDate:
                                            '${collectionList[index].data[i].matchDate}',
                                        matchStatus:
                                            '${collectionList[index].data[i].statusStr}',
                                        matchName:
                                            '${collectionList[index].data[i].competitionName}')
                                    .launch(context);
                              },
                              child: GameDisplayComponent(
                                id: collectionList[index].data[i].id ?? 0,
                                competitionType: collectionList[index]
                                        .data[i]
                                        .competitionName ??
                                    "",
                                duration: collectionList[index]
                                        .data[i]
                                        .matchTimeStr ??
                                    "00:00",
                                teamAName: collectionList[index]
                                        .data[i]
                                        .homeTeamName ??
                                    "",
                                teamALogo: collectionList[index]
                                        .data[i]
                                        .homeTeamLogo ??
                                    'images/mainpage/sampleLogo.png',
                                teamAScore: collectionList[index]
                                    .data[i]
                                    .homeTeamScore
                                    .toString(),
                                teamBName: collectionList[index]
                                        .data[i]
                                        .awayTeamName ??
                                    "",
                                teamBLogo: collectionList[index]
                                        .data[i]
                                        .awayTeamLogo ??
                                    'images/mainpage/sampleLogo.png',
                                teamBScore: collectionList[index]
                                    .data[i]
                                    .awayTeamScore
                                    .toString(),
                                isSaved: collectionList[index]
                                        .data[i]
                                        .hasCollected ??
                                    true,
                              ),
                            );
                          },
                        )
                      ],
                    );
            },
          )),
    ));
  }
}
