import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';

import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';

class LiveDisplayBlock extends StatefulWidget {
  String? id;
  int index;
  String? competitionType;
  String? duration;
  String? savedAmount;
  bool isSaved;
  String? teamAName;
  String? teamALogo;
  String? teamAScore;
  String? teamBName;
  String? teamBLogo;
  String? teamBScore;
  String? status;
  // Function? onTapCallback;
  List<dynamic> getBookmarkBlockList = [];

  LiveDisplayBlock({
    super.key,
    required this.id,
    required this.index,
    required this.competitionType,
    required this.duration,
    required this.savedAmount,
    required this.isSaved,
    required this.teamAName,
    required this.teamALogo,
    required this.teamAScore,
    required this.teamBName,
    required this.teamBLogo,
    required this.teamBScore,
    required this.status,
    // required this.onTapCallback,
    required this.getBookmarkBlockList,
  });

  @override
  State<LiveDisplayBlock> createState() => _LiveDisplayBlockState();
}

class _LiveDisplayBlockState extends State<LiveDisplayBlock> {
  // SearchLiveStreamProvider searchProvider = SearchLiveStreamProvider();
  Map<String, dynamic> saveBookmarkResult = {};
  List<dynamic> getBookmarkList = [];
  bool checkBookmarkSaved = true;
  bool checkDeleteBookmark = false;
  bool shouldRefresh = false;

  UserDataModel userModel = Get.find<UserDataModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? id = widget.id;
    int index = widget.index;
    String? competitionType = widget.competitionType;
    String? duration = widget.duration;
    String? savedAmount = widget.savedAmount;
    bool isSaved = widget.isSaved;
    String? teamAName = widget.teamAName;
    String? teamALogo = widget.teamALogo;
    String? teamAScore = widget.teamAScore;
    String? teamBName = widget.teamBName;
    String? teamBLogo = widget.teamBLogo;
    String? teamBScore = widget.teamBScore;
    String? status = widget.status;
    List<dynamic> getBookmarkBlockList = widget.getBookmarkBlockList;

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7 * fem),
      width: 343 * fem,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * fem),
        color: kMainComponentColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0 * fem),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 150 * fem),
                  padding: EdgeInsets.symmetric(
                      vertical: 4 * fem, horizontal: 8 * fem),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(49 * fem),
                    color: kLightGreyColor,
                  ),
                  child: Text(
                    competitionType ?? "No Data",
                    style: TextStyle(
                      fontFamily: 'NotoSansSC',
                      fontSize: 12 * fem,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3 * fem,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 20 * fem,
                ),
                Text(
                  duration ?? "No Data",
                  style: TextStyle(
                      color: kComponentHintTextColor,
                      fontFamily: 'NotoSansSC',
                      fontSize: 12 * fem,
                      letterSpacing: 0.3 * fem,
                      fontWeight: FontWeight.w400),
                ),
                Spacer(),
                userModel.isCN == true
                    ? Text('')
                    : Container(
                        width: 80,
                        child: Center(
                          child: Text(
                            status ?? "No Data",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: kMainGreyColor,
                                fontFamily: 'NotoSansSC',
                                fontSize: 12 * fem,
                                letterSpacing: 0.3 * fem,
                                fontWeight: FontWeight.w400),
                          ),
                        )),
                SizedBox(
                  width: 10 * fem,
                ),
                GestureDetector(
                  onTap: () async {
                   
                  },
                  child: SvgPicture.asset(isSaved
                      ? 'images/Bookmark-1.svg'
                      : 'images/Bookmark-0.svg'),
                )
              ],
            ),
            SizedBox(
              height: 16 * fem,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 143 * fem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          constraints: BoxConstraints(maxWidth: 65 * fem),
                          child: Center(
                            child: Text(
                              teamAName ?? "No Data",
                              style: TextStyle(
                                  color: kMainTitleColor,
                                  fontFamily: 'NotoSansSC',
                                  fontSize: 13 * fem,
                                  letterSpacing: 0.3 * fem,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      SizedBox(
                        width: 4 * fem,
                      ),
                      Container(
                          width: 24 * fem,
                          height: 24 * fem,
                          child: Center(
                            child: Image.network(
                              teamALogo ?? "No Data",
                            ),
                          )),
                      SizedBox(
                        width: 5 * fem,
                      ),
                      Container(
                          width: 45 * fem,
                          child: Center(
                            child: Text(
                              teamAScore ?? "No Data",
                              style: TextStyle(
                                  color: kMainTitleColor,
                                  fontFamily: 'NotoSansSC',
                                  fontSize: 16 * fem,
                                  letterSpacing: 0.3 * fem,
                                  fontWeight: FontWeight.w600),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  width: 4 * fem,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SvgPicture.asset(
                      'images/Circle.svg',
                      color: userModel.isCN.value == true
                          ? status == '开'
                              ? Color.fromARGB(255, 166, 241, 166)
                              : Color.fromARGB(255, 182, 182, 182)
                          : Color.fromARGB(255, 255, 255, 255),
                      width: 28 * fem,
                      height: 28 * fem,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5 * fem),
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 20 * fem),
                          child: userModel.isCN.value == true
                              ? Text(
                                  status ?? "No Data",
                                  style: TextStyle(
                                      color: status == '开'
                                          ? Color(0xFF16B13B)
                                          : kMainGreyColor,
                                      fontFamily: 'NotoSansSC',
                                      fontSize: 12 * fem,
                                      letterSpacing: 0.3 * fem,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  "VS",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'NotoSansSC',
                                    fontSize: 12 * fem,
                                    letterSpacing: 0.3 * fem,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                    ),
                  ],
                ),
                SizedBox(
                  width: 4 * fem,
                ),
                Container(
                  width: 143 * fem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                          child: Container(
                              width: 45 * fem,
                              child: Center(
                                child: Text(
                                  teamBScore ?? "No Data",
                                  style: TextStyle(
                                      color: kMainGreyColor,
                                      fontFamily: 'NotoSansSC',
                                      fontSize: 16 * fem,
                                      letterSpacing: 0.3 * fem,
                                      fontWeight: FontWeight.w700),
                                ),
                              ))),
                      SizedBox(
                        width: 5 * fem,
                      ),
                      Container(
                        width: 24 * fem,
                        height: 24 * fem,
                        child: Image.network(
                          teamBLogo ?? "No Data",
                        ),
                      ),
                      SizedBox(
                        width: 4 * fem,
                      ),
                      Container(
                          constraints: BoxConstraints(maxWidth: 60 * fem),
                          child: Center(
                            child: Text(
                              teamBName ?? "No Data",
                              style: TextStyle(
                                  color: kMainTitleColor,
                                  fontFamily: 'NotoSansSC',
                                  fontSize: 13 * fem,
                                  letterSpacing: 0.3 * fem,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
