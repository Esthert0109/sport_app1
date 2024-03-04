import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Component/MainPage/gameDisplayComponent.dart';
import '../../Constants/colorConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Constants/textConstant.dart';
import '../../Model/collectionModel.dart';
import '../../Provider/collectionProvider.dart';

class SavedCollection extends StatefulWidget {
  const SavedCollection({super.key});

  @override
  State<SavedCollection> createState() => _SavedCollectionState();
}

class _SavedCollectionState extends State<SavedCollection> {
  // loading
  bool isLoading = false;

  // services and provider
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

      AllCollectMatchesModel? allCollectionModel =
          await provider.getAllBasketballCollection(page, size);
      collectionList.addAll(allCollectionModel?.data ?? []);
      collectionLength = collectionList.length;

      print("check collection: ${collectionList.toString()}");

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
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("navi into tournament");
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
              );
            },
          )
          ),
    ));
  }
}
