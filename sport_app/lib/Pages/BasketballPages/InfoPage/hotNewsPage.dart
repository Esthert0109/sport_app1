import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Constants/colorConstant.dart';
import '../../../Constants/textConstant.dart';

class HotNewsPage extends StatefulWidget {
  const HotNewsPage({super.key});

  @override
  State<HotNewsPage> createState() => _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: kMainHotNewsColor));

    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      backgroundColor: kSecondaryHotNewsColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 121 * fem,
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
            Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      child: Container(
                        // height: 500 * fem,
                        padding: EdgeInsets.symmetric(
                            vertical: 30 * fem, horizontal: 20 * fem),
                        decoration: BoxDecoration(color: kMainComponentColor),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50 * fem,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Image(
                                            image: AssetImage(
                                                'images/info/hotTop1.png')),
                                      )),
                                  Expanded(
                                      flex: 9,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  left: 10 * fem,
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀',
                                                  style: tHotNewsTitle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10 * fem,
                                                    5 * fem,
                                                    0 * fem,
                                                    0 * fem),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 12 * fem,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'images/info/fire.png')),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  8 * fem),
                                                      child: Text(
                                                        "12613",
                                                        style: tTimeRead,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 12 * fem,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'images/info/boom.png')),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Divider(
                              color: kDividerColor,
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 50 * fem,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Image(
                                            image: AssetImage(
                                                'images/info/hotTop2.png')),
                                      )),
                                  Expanded(
                                      flex: 9,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  left: 10 * fem,
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀',
                                                  style: tHotNewsTitle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10 * fem,
                                                    5 * fem,
                                                    0 * fem,
                                                    0 * fem),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 12 * fem,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'images/info/fire.png')),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  8 * fem),
                                                      child: Text(
                                                        "12613",
                                                        style: tTimeRead,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 12 * fem,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'images/info/boom.png')),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Divider(
                              color: kDividerColor,
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 50 * fem,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Image(
                                            image: AssetImage(
                                                'images/info/hotTop2.png')),
                                      )),
                                  Expanded(
                                      flex: 9,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  left: 10 * fem,
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '🤣阿森纳全场零射正客场0-1波尔图，加莱诺读秒世界波绝杀',
                                                  style: tHotNewsTitle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10 * fem,
                                                    5 * fem,
                                                    0 * fem,
                                                    0 * fem),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 12 * fem,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'images/info/fire.png')),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  8 * fem),
                                                      child: Text(
                                                        "12613",
                                                        style: tTimeRead,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 12 * fem,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'images/info/boom.png')),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Divider(
                              color: kDividerColor,
                              thickness: 1,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
