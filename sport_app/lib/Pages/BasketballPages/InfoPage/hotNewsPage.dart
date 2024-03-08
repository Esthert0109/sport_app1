import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Component/News/hotNewsComponent.dart';
import '../../../Component/News/topHotNewsComponent.dart';
import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';
import 'infoPageDetail.dart';

class HotNewsPage extends StatefulWidget {
  const HotNewsPage({super.key});

  @override
  State<HotNewsPage> createState() => _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kMainHotNewsColor,
    ));

    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      child: Column(
                        children: [
                          for (int i = 1; i < 4; i++)
                            InkWell(
                              onTap: () {
                                print("navi to news");
                                Get.to(() => const InfoPageDetail(),
                                    transition: Transition.fadeIn);
                              },
                              child: TopHotNewsComponent(
                                hotLogo: "images/info/hotTop$i.png",
                                title: "🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀",
                                read: 15522,
                              ),
                            ),
                          for (int i = 4; i < 27; i++)
                            InkWell(
                              onTap: () {
                                print("navi to news");
                              },
                              child: HotNewsComponent(
                                  index: i,
                                  title: "💥加莱诺读秒世界波绝杀，阿森纳全场零射正客场0-1波尔图。",
                                  read: 12613),
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
