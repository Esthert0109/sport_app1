import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Component/News/hotNewsComponent.dart';
import '../../../Component/News/topHotNewsComponent.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import '../../../Model/infoModel.dart';
import '../../../Provider/infoProvider.dart';
import 'infoPageDetail.dart';

class HotNewsPage extends StatefulWidget {
  const HotNewsPage({super.key});

  @override
  State<HotNewsPage> createState() => _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  // provider
  InfoProvider infoProvider = InfoProvider();

  List<InfoListData> popularInfoList = [];
  int infoLength = 0;
  Random random = Random();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kMainHotNewsColor,
    ));
    getPopularInfoList();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kMainGreenColor,
    ));
    super.dispose();
  }

  Future<void> getPopularInfoList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      InfoListModel? infoModel = await infoProvider.getPopularInfoList(4);

      popularInfoList.addAll(infoModel?.data ?? []);
      infoLength = popularInfoList.length;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.maxFinite,
              color: kSecondaryHotNewsColor,
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: kSecondaryHotNewsColor,
                scrolledUnderElevation: 0.0,
                elevation: 0.0,
                flexibleSpace: ClipRRect(
                  child: Container(
                    height: 121 * fem,
                    // width: 375 * fem,
                    color: kSecondaryHotNewsColor,
                    alignment: Alignment.topCenter,
                    child: Image(
                      image: AssetImage('images/info/hotNewsBanner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                actions: [],
              ),
            ),
            Positioned(
              top: 121 * fem,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        20 * fem, 30 * fem, 20 * fem, 10 * fem),
                    decoration: BoxDecoration(color: kMainComponentColor),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: isLoading
                          ? Center(
                              child: Lottie.asset(
                                'images/common/pandahappy.json', // Replace 'loading.json' with the path to your Lottie animation
                                width: 250, // Adjust the width as needed
                                height: 250, // Adjust the height as needed
                              ),
                            )
                          : Column(
                              children: [
                                for (int i = 0; i < 3; i++)
                                  InkWell(
                                    onTap: () {
                                      print("navi to news");
                                      Get.to(
                                          () => InfoPageDetail(
                                              id: popularInfoList[i].id),
                                          transition: Transition.fadeIn);
                                    },
                                    child: TopHotNewsComponent(
                                      hotLogo: "images/info/hotTop${i + 1}.png",
                                      title: popularInfoList[i].title,
                                      read: popularInfoList[i].readCount,
                                    ),
                                  ),
                                for (int i = 3; i < infoLength; i++)
                                  InkWell(
                                    onTap: () {
                                      print("navi to news");
                                      Get.to(
                                          () => InfoPageDetail(
                                              id: popularInfoList[i].id),
                                          transition: Transition.fadeIn);
                                    },
                                    child: HotNewsComponent(
                                        index: i,
                                        title: popularInfoList[i].title,
                                        read: popularInfoList[i].readCount),
                                  )
                              ],
                            ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
