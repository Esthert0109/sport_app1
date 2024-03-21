import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Model/liveStreamModel.dart';
import 'package:sport_app/Provider/liveStreamProvider.dart';

import '../../Component/Loading/emptyResultComponent.dart';
import '../../Component/TournamentDetails/fixedColumnTable2.dart';
import '../../Component/TournamentDetails/percentageBarPercentage.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/basketballMatchProvider.dart';

class BasketballTournamentDetails extends StatefulWidget {
  const BasketballTournamentDetails({
    Key? key,
    required this.id,
    required this.matchDate,
    required this.matchStatus,
    required this.matchName,
  }) : super(key: key);

  final String id;
  final String matchDate;
  final String matchStatus;
  final String matchName;

  @override
  State<BasketballTournamentDetails> createState() =>
      _BasketballTournamentDetailsState();
}

class _BasketballTournamentDetailsState
    extends State<BasketballTournamentDetails> {
  //Provider
  BasketballMatchProvider provider = BasketballMatchProvider();
  LiveStreamProvider liveProvider = LiveStreamProvider();
  Map<String, dynamic> basketballMatchById = new Map<String, dynamic>();
  Map<String, dynamic>? basketballMatchLineUpById;
  List<dynamic>? homeTeamLineUp;
  List<dynamic>? awayTeamLineUp;
  String animationUrl = "";
  String liveUrl = "";

  //Variables
  int selectedButton = 1;
  int selectedTextButton = 1;
  bool isLoading = true;
  bool isDetailNull = false;
  String matchStatusStr = '';

  //User Model
  UserDataModel userModel = Get.find<UserDataModel>();

  ButtonStyle buttonStyle(int buttonNumber) {
    return ElevatedButton.styleFrom(
        // primary: selectedButton == buttonNumber ? Colors.green : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(53)));
  }

  //provider body
  Future<Map<String, dynamic>?> getTournamentDetails() async {
    if (await provider.getBasketballLiveData(widget.id) == null ||
        await provider.getBasketballLiveData(widget.id) == {}) {
      isDetailNull == true;
    } else {
      basketballMatchById = (await provider.getBasketballLiveData(widget.id))!;

      print("check data: ${basketballMatchById}");
    }

    return basketballMatchById;
  }

  Future<void> getAnimationUrl() async {
    AnimationStreamModel? animationModel =
        await liveProvider.getAnimationUrl("basketball", widget.id);
    animationUrl = animationModel?.data ?? "";
  }

  Future<void> getLiveUrl() async {
    AnimationStreamModel? animationModel =
        await liveProvider.getLiveUrl("football", widget.id);
    liveUrl = animationModel?.data ?? "";
  }

  Future<Map<String, dynamic>> getBasketballMatchLineUpById() async {
    return basketballMatchLineUpById =
        await provider.getBasketballLineUp(widget.id);
  }

  //initState
  @override
  void initState() {
    super.initState();
    getAnimationUrl();
    getLiveUrl();

    if (widget.matchStatus == '未') {
      matchStatusStr = userModel.isCN == true ? '未开赛' : 'Not Started Yet';
    } else if (widget.matchStatus == '已') {
      matchStatusStr = userModel.isCN == true ? '已开赛' : 'Started';
    } else {
      matchStatusStr = userModel.isCN == true ? '正在进行' : 'On Going';
    }

    getTournamentDetails().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    getBasketballMatchLineUpById().then((v) {
      setState(() {
        homeTeamLineUp = basketballMatchLineUpById!['home'];
        awayTeamLineUp = basketballMatchLineUpById!['away'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //size of widget
    double screenWidth = MediaQuery.of(context).size.width;
    double viewportFraction = 328 / screenWidth;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kMainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.matchName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'NotoSansSC',
              fontWeight: FontWeight.w600,
              height: 1.56,
              letterSpacing: 0.3),
        ),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'images/tournament/basketball_tournament.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        )
                      ],
                    )
                  : (basketballMatchById?.isEmpty ?? false)
                      ? userModel.isCN.value
                          ? Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    'images/tournament/basketball_tournament.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text("无信息数据",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      letterSpacing: 0.46,
                                    )),
                              ],
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    'images/tournament/basketball_tournament.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text("No Match Data",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      letterSpacing: 0.46,
                                    )),
                              ],
                            )
                      : Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'images/tournament/basketball_tournament.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 54,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.matchDate,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFF8FEE4),
                                    fontSize: 12,
                                    fontFamily: 'NotoSansSC',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: 0.46,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 72,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  matchStatusStr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFF8FEE4),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: 0.46,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 76,
                              left: 48,
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        basketballMatchById!['homeTeamLogo']
                                            .toString()),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 77.92,
                              right: 49.92,
                              child: Container(
                                width: 42.17,
                                height: 42.17,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        basketballMatchById!['awayTeamLogo']
                                            .toString()),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 135, 0, 0),
                                    child: Text(
                                      "${basketballMatchById?['homeTeamName'].toString()}",
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'NotoSansSC',
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                        letterSpacing: 0.30,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 135, 0, 0),
                                    child: Text(
                                      "${basketballMatchById?['awayTeamName'].toString()}",
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'NotoSansSC',
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                        letterSpacing: 0.30,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              top: 122,
                              left: 120,
                              child: Text(
                                '${basketballMatchById?['homeScore'].toString()}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'NotoSansSC',
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                  letterSpacing: 0.42,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 122,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '-',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'NotoSansSC',
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 122,
                              right: 123,
                              child: Text(
                                '${basketballMatchById?['awayScore'].toString()}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'NotoSansSC',
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                  letterSpacing: 0.42,
                                ),
                              ),
                            ),
                            Positioned(
                                top: 160,
                                left: 85,
                                child: GestureDetector(
                                  onTap: () {
                                    print("navi to live stream");
                                    if (liveUrl == "" || liveUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("没有直播"),
                                        backgroundColor: redColor,
                                      ));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "视频直播",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.3,
                                            color: white),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Image(
                                            width: 24,
                                            height: 24,
                                            image: AssetImage(
                                                "images/tournament/videoLiveStream.png")),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                                top: 160,
                                right: 85,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        "navi to animation stream: ${animationUrl}");
                                    if (animationUrl == "" ||
                                        animationUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("没有动画直播"),
                                        backgroundColor: redColor,
                                      ));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Image(
                                            width: 24,
                                            height: 24,
                                            image: AssetImage(
                                                "images/tournament/animationStream.png")),
                                      ),
                                      Text(
                                        "动画直播",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.3,
                                            color: white),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton = 1;
                        });
                      },
                      child: Text(
                        userModel.isCN == true ? "赛况" : "Match Status",
                        style: TextStyle(
                            color: selectedButton == 1
                                ? Colors.white
                                : kComponentHintTextColor,
                            fontSize: 14,
                            fontFamily: 'NotoSansSC'),
                      ),
                      style: buttonStyle(1).copyWith(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStatePropertyAll(
                              selectedButton == 1 ? kMainGreenColor : white)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       selectedButton = 2;
                    //     });
                    //   },
                    //   child: Text(
                    //     userModel.isCN == true ? "直播" : "Live",
                    //     style: TextStyle(
                    //         color: selectedButton == 2
                    //             ? Colors.white
                    //             : kHintTextColor,
                    //         fontSize: 14,
                    //         fontFamily: 'NotoSansSC'),
                    //   ),
                    //   style: buttonStyle(2)
                    //       .copyWith(elevation: MaterialStateProperty.all(0)),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton = 3;
                        });
                      },
                      child: Text(
                        userModel.isCN == true ? "阵容" : "Line-up",
                        style: TextStyle(
                            color: selectedButton == 3
                                ? Colors.white
                                : kComponentHintTextColor,
                            fontSize: 14,
                            fontFamily: 'NotoSansSC'),
                      ),
                      style: buttonStyle(3).copyWith(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStatePropertyAll(
                              selectedButton == 3 ? kMainGreenColor : white)),
                    )
                  ],
                ),
              ),
              Container(
                child: isDetailNull
                    ? searchEmptyWidget()
                    : getContentForSelectedButton(),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget getContentForSelectedButton() {
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = (screenWidth - 0) * 0.2;

    //parsing function
    double parseDouble(String key, Map<String, dynamic> data) {
      print("check: ${data[key]}");
      if (data[key] != null && data[key] != '') {
        return double.parse(data[key].toString());
      } else {
        return 0;
      }
    }

    //case 1 graph variables

    //CN
    double noHomeThreePointer =
        parseDouble('hthreePointGoals', basketballMatchById);
    double noAwayThreePointer =
        parseDouble('athreePointGoals', basketballMatchById);
    double noHomeTwoPointer = parseDouble('htwoGoal', basketballMatchById);
    double noAwayTwoPointer = parseDouble('atwoGoal', basketballMatchById);
    double noHomeFoul = parseDouble('hpersonalFouls', basketballMatchById);
    double noAwayFoul = parseDouble('apersonalFouls', basketballMatchById);
    // double noHomeFreeThrow = parseDouble('key', data)
    double noHomeFreeThrowPercentage =
        parseDouble('hfreeThrows', basketballMatchById);
    double noAwayFreeThrowPercentage =
        parseDouble('afreeThrows', basketballMatchById);
    double noHomePauseRemain =
        parseDouble('hnumPauseRemain', basketballMatchById);
    double noAwayPauseRemain =
        parseDouble('anumPauseRemain', basketballMatchById);
    double noHomeTotalPause = parseDouble('htotalPause', basketballMatchById);
    double noAwayTotalPause = parseDouble('atotalPause', basketballMatchById);
    double noHomeFreeThrow = parseDouble('hfreeThrows', basketballMatchById);
    double noAwayFreeThrow = parseDouble('afreeThrows', basketballMatchById);

    //EN
    double noHomeThreePointerEN =
        parseDouble('hthreePointGoals', basketballMatchById);
    double noAwayThreePointerEN =
        parseDouble('athreePointGoals', basketballMatchById);
    double noHomeBlockEN = parseDouble('hblocks', basketballMatchById);
    double noAwayBlockEN = parseDouble('ablocks', basketballMatchById);
    double noHomeFieldGoalEN = parseDouble('hfieldGoals', basketballMatchById);
    double noAwayFieldGoalEN = parseDouble('afieldGoals', basketballMatchById);
    double noHomeFreeThrowEN = parseDouble('hfreeThrows', basketballMatchById);
    double noAwayFreeThrowEN = parseDouble('afreeThrows', basketballMatchById);
    double noHomePersonalFoulEN =
        parseDouble('hpersonalFouls', basketballMatchById);
    double noAwayPersonalFoulEN =
        parseDouble('apersonalFouls', basketballMatchById);
    double noHomeReboundEN = parseDouble('hrebounds', basketballMatchById);
    double noAwayReboundEN = parseDouble('arebounds', basketballMatchById);
    double noHomeStealEN = parseDouble('hsteals', basketballMatchById);
    double noAwayStealEN = parseDouble('asteals', basketballMatchById);
    double noHomeTurnOverEN = parseDouble('hturnOvers', basketballMatchById);
    double noAwayTurnOverEN = parseDouble('aturnOvers', basketballMatchById);

    //calculation of percentage in graph
    //CN
    double percentOfThreePointerHome =
        ((noAwayThreePointer + noHomeThreePointer) == 0)
            ? 0
            : (noHomeThreePointer / (noAwayThreePointer + noHomeThreePointer)) *
                100;
    double percentOfThreePointerAway =
        ((noAwayThreePointer + noHomeThreePointer) == 0)
            ? 0
            : (noAwayThreePointer / (noAwayThreePointer + noHomeThreePointer)) *
                100;

    double percentOfTwoPointerHome =
        ((noAwayTwoPointer + noHomeTwoPointer) == 0)
            ? 0
            : (noHomeTwoPointer / (noAwayTwoPointer + noHomeTwoPointer)) * 100;
    double percentOfTwoPointerAway =
        ((noAwayTwoPointer + noHomeTwoPointer) == 0)
            ? 0
            : (noAwayTwoPointer / (noAwayTwoPointer + noHomeTwoPointer)) * 100;

    double percentOfFoulHome = ((noAwayFoul + noHomeFoul) == 0)
        ? 0
        : (noHomeFoul / (noAwayFoul + noHomeFoul)) * 100;
    double percentOfFoulAway = ((noAwayFoul + noHomeFoul) == 0)
        ? 0
        : (noAwayFoul / (noAwayFoul + noHomeFoul)) * 100;

    double percentageOfPauseRemainHome =
        ((noAwayPauseRemain + noHomePauseRemain) == 0)
            ? 0
            : (noHomePauseRemain / (noAwayPauseRemain + noHomePauseRemain)) *
                100;
    double percentageOfPauseRemainAway =
        ((noAwayPauseRemain + noHomePauseRemain) == 0)
            ? 0
            : (noAwayPauseRemain / (noAwayPauseRemain + noHomePauseRemain)) *
                100;

    double percentageOfTotalPauseHome =
        ((noAwayTotalPause + noHomeTotalPause) == 0)
            ? 0
            : (noHomeTotalPause / (noAwayTotalPause + noHomeTotalPause)) * 100;
    double percentageOfTotalPauseAway =
        ((noAwayTotalPause + noHomeTotalPause) == 0)
            ? 0
            : (noAwayTotalPause / (noAwayTotalPause + noHomeTotalPause)) * 100;

    double percentageOfFreeThrowHome =
        ((noHomeFreeThrow + noAwayFreeThrow) == 0)
            ? 0
            : (noHomeFreeThrow / (noHomeFreeThrow + noAwayFreeThrow)) * 100;
    double percentageOfFreeThrowAway =
        ((noHomeFreeThrow + noAwayFreeThrow) == 0)
            ? 0
            : (noAwayFreeThrow / (noHomeFreeThrow + noAwayFreeThrow)) * 100;

    //EN
    double percentageOfBlocksHomeEN = ((noAwayBlockEN + noHomeBlockEN) == 0)
        ? 0
        : (noHomeBlockEN / (noAwayBlockEN + noHomeBlockEN)) * 100;
    double percentageOfBlocksAwayEN = ((noAwayBlockEN + noHomeBlockEN) == 0)
        ? 0
        : (noAwayBlockEN / (noAwayBlockEN + noHomeBlockEN)) * 100;

    double percentageOfFieldGoalsHomeEN =
        ((noAwayFieldGoalEN + noHomeFieldGoalEN) == 0)
            ? 0
            : (noHomeFieldGoalEN / (noAwayFieldGoalEN + noHomeFieldGoalEN)) *
                100;
    double percentageOfFieldGoalsAwayEN =
        ((noAwayFieldGoalEN + noHomeFieldGoalEN) == 0)
            ? 0
            : (noAwayFieldGoalEN / (noAwayFieldGoalEN + noHomeFieldGoalEN)) *
                100;

    double percentageOfFreeThrowHomeEN =
        ((noAwayFreeThrowEN + noHomeFreeThrowEN) == 0)
            ? 0
            : (noHomeFreeThrowEN / (noAwayFreeThrowEN + noHomeFreeThrowEN)) *
                100;
    double percentageOfFreeThrowAwayEN =
        ((noAwayFreeThrowEN + noHomeFreeThrowEN) == 0)
            ? 0
            : (noAwayFreeThrowEN / (noAwayFreeThrowEN + noHomeFreeThrowEN)) *
                100;

    double percentageOfPersonalFoulHomeEN =
        ((noAwayPersonalFoulEN + noHomePersonalFoulEN) == 0)
            ? 0
            : (noHomePersonalFoulEN /
                    (noAwayPersonalFoulEN + noHomePersonalFoulEN)) *
                100;
    double percentageOfPersonalFoulAwayEN =
        ((noAwayPersonalFoulEN + noHomePersonalFoulEN) == 0)
            ? 0
            : (noAwayPersonalFoulEN /
                    (noAwayPersonalFoulEN + noHomePersonalFoulEN)) *
                100;

    double percentageOfReboundHomeEN =
        ((noAwayReboundEN + noHomeReboundEN) == 0)
            ? 0
            : (noHomeReboundEN / (noAwayReboundEN + noHomeReboundEN)) * 100;
    double percentageOfReboundAwayEN =
        ((noAwayReboundEN + noHomeReboundEN) == 0)
            ? 0
            : (noAwayReboundEN / (noAwayReboundEN + noHomeReboundEN)) * 100;

    double percentageOfStealHomeEN = ((noAwayStealEN + noHomeStealEN) == 0)
        ? 0
        : (noHomeStealEN / (noAwayStealEN + noHomeStealEN)) * 100;
    double percentageOfStealAwayEN = ((noAwayStealEN + noHomeStealEN) == 0)
        ? 0
        : (noAwayStealEN / (noAwayStealEN + noHomeStealEN)) * 100;

    double percentageOfThreePointGoalHomeEN =
        ((noAwayThreePointerEN + noHomeThreePointerEN) == 0)
            ? 0
            : (noHomeThreePointerEN /
                    (noAwayThreePointerEN + noHomeThreePointerEN)) *
                100;
    double percentageOfThreePointGoalAwayEN =
        ((noAwayThreePointerEN + noHomeThreePointerEN) == 0)
            ? 0
            : (noAwayThreePointerEN /
                    (noAwayThreePointerEN + noHomeThreePointerEN)) *
                100;

    double percentageOfTurnOverHomeEN =
        ((noAwayTurnOverEN + noHomeTurnOverEN) == 0)
            ? 0
            : (noHomeTurnOverEN / (noAwayTurnOverEN + noHomeTurnOverEN)) * 100;
    double percentageOfTurnOverAwayEN =
        ((noAwayTurnOverEN + noHomeTurnOverEN) == 0)
            ? 0
            : (noAwayTurnOverEN / (noAwayTurnOverEN + noHomeTurnOverEN)) * 100;

    //function to check null
    bool isDataNullFunction() {
      if (userModel.isCN.value) {
        if (noHomeThreePointer == 0 &&
            noAwayThreePointer == 0 &&
            noHomeTwoPointer == 0 &&
            noAwayTwoPointer == 0 &&
            noHomeFoul == 0 &&
            noAwayFoul == 0 &&
            noHomeFreeThrowPercentage == 0 &&
            noAwayFreeThrowPercentage == 0 &&
            noHomePauseRemain == 0 &&
            noAwayPauseRemain == 0 &&
            noHomeTotalPause == 0 &&
            noAwayTotalPause == 0 &&
            noHomeFreeThrow == 0 &&
            noAwayFreeThrow == 0) {
          return true;
        }
      } else {
        if (noHomeThreePointerEN == 0 &&
            noAwayThreePointerEN == 0 &&
            noHomeBlockEN == 0 &&
            noAwayBlockEN == 0 &&
            noHomeFieldGoalEN == 0 &&
            noAwayFieldGoalEN == 0 &&
            noHomeFreeThrowEN == 0 &&
            noAwayFreeThrowEN == 0 &&
            noHomePersonalFoulEN == 0 &&
            noAwayPersonalFoulEN == 0 &&
            noHomeReboundEN == 0 &&
            noAwayReboundEN == 0 &&
            noHomeStealEN == 0 &&
            noAwayStealEN == 0 &&
            noHomeTurnOverEN == 0 &&
            noAwayTurnOverEN == 0) {
          return true;
        }
      }
      return false;
    }

    bool isFixedTableNullFunction() {
      if (homeTeamLineUp!.isEmpty && awayTeamLineUp!.isEmpty) {
        return true;
      }
      return false;
    }

    switch (selectedButton) {
      case 1:
        return isLoading
            ? Center(
                child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ))
            : (basketballMatchById?.isEmpty ?? false)
                ? searchEmptyWidget()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
                    child: Center(
                      child: Container(
                          width: screenWidth * 1,
                          height: 480,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadiusDirectional.circular(20),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                    width: screenWidth * 1,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: screenWidth * 1,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: tableMainColor),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 0.03 * screenWidth,
                                              ),
                                              SizedBox(
                                                  width: 0.25 * screenWidth,
                                                  child: Container(
                                                    child: Text(
                                                      userModel.isCN.value
                                                          ? "球队"
                                                          : "Team",
                                                      style: TextStyle(
                                                          color: kMainGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      userModel.isCN.value
                                                          ? "1节"
                                                          : "Q1",
                                                      style: TextStyle(
                                                          color: kMainGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      userModel.isCN.value
                                                          ? "2节"
                                                          : "Q2",
                                                      style: TextStyle(
                                                          color: kMainGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      userModel.isCN.value
                                                          ? "3节"
                                                          : "Q3",
                                                      style: TextStyle(
                                                          color: kMainGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      userModel.isCN.value
                                                          ? "4节"
                                                          : "Q4",
                                                      style: TextStyle(
                                                          color: kMainGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.15 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      userModel.isCN.value
                                                          ? "总分"
                                                          : "Total",
                                                      style: TextStyle(
                                                          color: kMainGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * 1,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 0.03 * screenWidth,
                                              ),
                                              SizedBox(
                                                  width: 0.25 * screenWidth,
                                                  child: Container(
                                                    child: Text(
                                                      "${basketballMatchById!['homeTeamName']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['hfquarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['hsquarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['htquarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['h4Quarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.15 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['homeScore']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * 1,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: tableMainColor),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 0.03 * screenWidth,
                                              ),
                                              SizedBox(
                                                  width: 0.25 * screenWidth,
                                                  child: Container(
                                                    child: Text(
                                                      "${basketballMatchById!['awayTeamName']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['afquarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['asquarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['atquarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.12 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['a4Quarter']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.15 * screenWidth,
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${basketballMatchById!['awayScore']}",
                                                      style: TextStyle(
                                                          color:
                                                              kMainGreyColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  isDataNullFunction() == true
                                      ? Container(
                                          width: screenWidth * 1,
                                          height: 300,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 8, 5, 5),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Image.asset(
                                              'images/common/search_empty.png'),
                                        )
                                      : Container(
                                          width: screenWidth * 1,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 8, 5, 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 0),
                                            child: Container(
                                              height: 300,
                                              width: screenWidth * 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child:
                                                            PercentageBarPercentage2(
                                                          percent2: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentOfThreePointerHome ==
                                                                      0
                                                                  ? 0
                                                                  : percentOfThreePointerHome)
                                                              : (percentageOfThreePointGoalHomeEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfThreePointGoalHomeEN), //need percentage home team
                                                          percent2_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noHomeThreePointer ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeThreePointer)
                                                              : (noHomeThreePointerEN ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeThreePointerEN), // need number
                                                          width2: barWidth,
                                                          height2: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                        userModel.isCN == true
                                                            ? '3分球'
                                                            : '3 Pointer',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child:
                                                            PercentageBarPercentage(
                                                          percent: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentOfThreePointerAway ==
                                                                      0
                                                                  ? 0
                                                                  : percentOfThreePointerAway)
                                                              : (percentageOfThreePointGoalAwayEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfThreePointGoalAwayEN),
                                                          percent_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noAwayThreePointer ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayThreePointer)
                                                              : (noAwayThreePointerEN ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayThreePointerEN),
                                                          width: barWidth,
                                                          height: 10.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: userModel.isCN.value
                                                        ? 10
                                                        : 20,
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 0),
                                                  //       child:
                                                  //           PercentageBarPercentage2(
                                                  //         percent2: userModel
                                                  //                     .isCN ==
                                                  //                 true
                                                  //             ? (percentOfTwoPointerHome ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : percentOfTwoPointerHome)
                                                  //             : (percentageOfBlocksHomeEN ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : percentageOfBlocksHomeEN), //need percentage home team
                                                  //         percent2_text: userModel
                                                  //                     .isCN ==
                                                  //                 true
                                                  //             ? (noHomeTwoPointer ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : noHomeTwoPointer)
                                                  //             : (noHomeBlockEN ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : noHomeBlockEN), // need number
                                                  //         width2: barWidth,
                                                  //         height2: 10,
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: 1,
                                                  //     ),
                                                  //     Text(
                                                  //       userModel.isCN == true
                                                  //           ? '2分球'
                                                  //           : 'Blocks',
                                                  //       style: TextStyle(
                                                  //           fontSize: 14),
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: 1,
                                                  //     ),
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(right: 0),
                                                  //       child:
                                                  //           PercentageBarPercentage(
                                                  //         percent: userModel
                                                  //                     .isCN ==
                                                  //                 true
                                                  //             ? (percentOfTwoPointerAway ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : percentOfTwoPointerAway)
                                                  //             : (percentageOfBlocksAwayEN ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : percentageOfBlocksAwayEN),
                                                  //         percent_text: userModel
                                                  //                     .isCN ==
                                                  //                 true
                                                  //             ? (noAwayTwoPointer ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : noAwayTwoPointer)
                                                  //             : (noAwayBlockEN ==
                                                  //                     0
                                                  //                 ? 0
                                                  //                 : noAwayBlockEN),
                                                  //         width: barWidth,
                                                  //         height: 10.0,
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // SizedBox(
                                                  //   height: userModel.isCN.value
                                                  //       ? 10
                                                  //       : 20,
                                                  // ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child:
                                                            PercentageBarPercentage2(
                                                          percent2: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentOfFoulHome ==
                                                                      0
                                                                  ? 0
                                                                  : percentOfFoulHome)
                                                              : (percentageOfPersonalFoulHomeEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfPersonalFoulHomeEN), //need percentage home team
                                                          percent2_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noHomeFoul == 0
                                                                  ? 0
                                                                  : noHomeFoul)
                                                              : (noHomePersonalFoulEN ==
                                                                      0
                                                                  ? 0
                                                                  : noHomePersonalFoulEN), // need number
                                                          width2: barWidth,
                                                          height2: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                        userModel.isCN == true
                                                            ? '犯规'
                                                            : 'Foul',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child:
                                                            PercentageBarPercentage(
                                                          percent: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentOfFoulAway ==
                                                                      0
                                                                  ? 0
                                                                  : percentOfFoulAway)
                                                              : (percentageOfPersonalFoulAwayEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfPersonalFoulAwayEN),
                                                          percent_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noAwayFoul == 0
                                                                  ? 0
                                                                  : noAwayFoul)
                                                              : (noAwayPersonalFoulEN ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayPersonalFoulEN),
                                                          width: barWidth,
                                                          height: 10.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: userModel.isCN.value
                                                        ? 10
                                                        : 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child:
                                                            PercentageBarPercentage2(
                                                          percent2: userModel
                                                                  .isCN.value
                                                              ? (percentageOfFreeThrowHome ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfFreeThrowHome)
                                                              : (percentageOfFreeThrowHomeEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfFreeThrowHomeEN),
                                                          percent2_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noHomeFreeThrow ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeFreeThrow)
                                                              : (noHomeFreeThrowEN ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeFreeThrowEN),
                                                          width2: barWidth,
                                                          height2: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      SizedBox(
                                                          width: 50,
                                                          child: Center(
                                                            child: Text(
                                                              userModel.isCN ==
                                                                      true
                                                                  ? '罚球进球数'
                                                                  : 'Free Throw',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child:
                                                            PercentageBarPercentage(
                                                          percent: userModel
                                                                  .isCN.value
                                                              ? (percentageOfFreeThrowAway ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfFreeThrowAway)
                                                              : (percentageOfFreeThrowAwayEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfFreeThrowAwayEN),
                                                          percent_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noAwayFreeThrow ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayFreeThrow)
                                                              : (noAwayFreeThrowEN ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayFreeThrowEN),
                                                          width: barWidth,
                                                          height: 10.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: userModel.isCN.value
                                                        ? 10
                                                        : 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child:
                                                            PercentageBarPercentage2(
                                                          percent2: userModel
                                                                  .isCN.value
                                                              ? ((noHomeFreeThrowPercentage ==
                                                                      0)
                                                                  ? 0
                                                                  : noHomeFreeThrowPercentage)
                                                              : (percentageOfStealHomeEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfStealHomeEN), //need percentage home team
                                                          percent2_text: userModel
                                                                  .isCN.value
                                                              ? (noHomeFreeThrowPercentage ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeFreeThrowPercentage)
                                                              : (noHomeStealEN ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeStealEN), // need number
                                                          width2: barWidth,
                                                          height2: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        child: Center(
                                                          child: Text(
                                                            userModel.isCN ==
                                                                    true
                                                                ? '罚球命中率'
                                                                : 'Steal',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child:
                                                            PercentageBarPercentage(
                                                          percent: userModel
                                                                  .isCN.value
                                                              ? (noAwayFreeThrowPercentage ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayFreeThrowPercentage)
                                                              : (percentageOfStealAwayEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfStealAwayEN),
                                                          percent_text: userModel
                                                                  .isCN.value
                                                              ? (noAwayFreeThrowPercentage ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayFreeThrowPercentage)
                                                              : (noAwayStealEN ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayStealEN),
                                                          width: barWidth,
                                                          height: 10.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: userModel.isCN.value
                                                        ? 10
                                                        : 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child:
                                                            PercentageBarPercentage2(
                                                          percent2: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentageOfPauseRemainHome ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfPauseRemainHome)
                                                              : (percentageOfTurnOverHomeEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfTurnOverHomeEN), //need percentage home team
                                                          percent2_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noHomePauseRemain ==
                                                                      0
                                                                  ? 0
                                                                  : noHomePauseRemain)
                                                              : (noHomeTurnOverEN ==
                                                                      0
                                                                  ? 0
                                                                  : noHomeTurnOverEN), // need number
                                                          width2: barWidth,
                                                          height2: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        child: Center(
                                                          child: Text(
                                                            userModel.isCN ==
                                                                    true
                                                                ? '剩余暂停数'
                                                                : 'Turn Over',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child:
                                                            PercentageBarPercentage(
                                                          percent: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentageOfPauseRemainAway ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfPauseRemainAway)
                                                              : (percentageOfTurnOverAwayEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfTurnOverAwayEN),
                                                          percent_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? noAwayPauseRemain
                                                              : noAwayTurnOverEN,
                                                          width: barWidth,
                                                          height: 10.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: userModel.isCN.value
                                                        ? 10
                                                        : 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child:
                                                            PercentageBarPercentage2(
                                                          percent2: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentageOfTotalPauseHome ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfTotalPauseHome)
                                                              : (percentageOfFieldGoalsHomeEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfFieldGoalsHomeEN), //need percentage home team
                                                          percent2_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? noHomeTotalPause
                                                              : noHomeFieldGoalEN, // need number
                                                          width2: barWidth,
                                                          height2: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        child: Center(
                                                          child: Text(
                                                            userModel.isCN ==
                                                                    true
                                                                ? '总暂停数'
                                                                : 'Field Goal',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child:
                                                            PercentageBarPercentage(
                                                          percent: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (percentageOfTotalPauseAway ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfTotalPauseAway)
                                                              : (percentageOfFieldGoalsAwayEN ==
                                                                      0
                                                                  ? 0
                                                                  : percentageOfFieldGoalsAwayEN),
                                                          percent_text: userModel
                                                                      .isCN ==
                                                                  true
                                                              ? (noAwayTotalPause ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayTotalPause)
                                                              : (noAwayFieldGoalEN ==
                                                                      0
                                                                  ? 0
                                                                  : noAwayFieldGoalEN),
                                                          width: barWidth,
                                                          height: 10.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: userModel.isCN.value
                                                        ? 10
                                                        : 15,
                                                  ),
                                                  userModel.isCN == true
                                                      ? Row()
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 0),
                                                              child:
                                                                  PercentageBarPercentage2(
                                                                percent2:
                                                                    percentageOfReboundHomeEN ==
                                                                            0
                                                                        ? 0
                                                                        : percentageOfReboundHomeEN, //need percentage home team
                                                                percent2_text:
                                                                    noHomeReboundEN ==
                                                                            0
                                                                        ? 0
                                                                        : noHomeReboundEN, // need number
                                                                width2:
                                                                    barWidth,
                                                                height2: 10,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 1,
                                                            ),
                                                            Text(
                                                              'Rebound',
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            SizedBox(
                                                              width: 1,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 0),
                                                              child:
                                                                  PercentageBarPercentage(
                                                                percent:
                                                                    percentageOfReboundAwayEN ==
                                                                            0
                                                                        ? 0
                                                                        : percentageOfReboundAwayEN,
                                                                percent_text:
                                                                    noAwayReboundEN ==
                                                                            0
                                                                        ? 0
                                                                        : noAwayReboundEN,
                                                                width: barWidth,
                                                                height: 10.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ))),
                    ),
                  );
      // case 2:
      //   return Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
      //         child: Container(
      //           width: 89,
      //           height: 24,
      //           child: Stack(
      //             children: [
      //               Positioned(
      //                 left: 0,
      //                 top: 0,
      //                 child: Container(
      //                   width: 24,
      //                   height: 24,
      //                   clipBehavior: Clip.antiAlias,
      //                   decoration: BoxDecoration(),
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [SvgPicture.asset('images/live-0.svg')],
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 32,
      //                 top: 0,
      //                 child: Text(
      //                   userModel.isCN.value ? '本场主播' : "Anchor",
      //                   style: TextStyle(
      //                       color: kBlackColor,
      //                       fontSize: 14,
      //                       fontFamily: 'NotoSansSC',
      //                       fontWeight: FontWeight.w400,
      //                       height: 1.71,
      //                       letterSpacing: 0.3),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             GestureDetector(
      //               onTap: () {
      //                 LiveStreamChatRoom page = LiveStreamChatRoom(
      //                     userLoginId: userModel.id.value,
      //                     avChatRoomId: "@TGS#aCXDLWE5CR",
      //                     anchor: "i['anchor']",
      //                     streamTitle: "i['title']",
      //                     anchorPic: userModel.profilePicture.value,
      //                     playMode: V2TXLivePlayMode.v2TXLivePlayModeLeb,
      //                     liveURL:
      //                         "rtmp://play.mindark.cloud/live/sd-1-4037281");
      //               },
      //               child: LiveSquareBlock(
      //                 anchor: '主播昵称',
      //                 title: '测试直播',
      //                 anchorPhoto: 'images/pandalogo.png',
      //                 livePhoto: 'images/image 107.png',
      //               ),
      //             ),
      //             LiveSquareBlock(
      //               anchor: '主播昵称',
      //               title: '测试直播',
      //               anchorPhoto: 'images/pandalogo.png',
      //               livePhoto: 'images/image 107.png',
      //             ),
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 14, 0, 10),
      //         child: Container(
      //           width: 300,
      //           height: 24,
      //           child: Stack(
      //             children: [
      //               Positioned(
      //                 left: 0,
      //                 top: 0,
      //                 child: Container(
      //                   width: 24,
      //                   height: 24,
      //                   clipBehavior: Clip.antiAlias,
      //                   decoration: BoxDecoration(),
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     mainAxisSize: MainAxisSize.min,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [SvgPicture.asset('images/live-0.svg')],
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                   left: 32,
      //                   top: 0,
      //                   child: Container(
      //                     height: 24,
      //                     width: 300,
      //                     child: Text(
      //                       userModel.isCN.value ? '比赛直播' : "Live Stream",
      //                       style: TextStyle(
      //                           color: kBlackColor,
      //                           fontSize: 14,
      //                           fontFamily: 'NotoSansSC',
      //                           fontWeight: FontWeight.w400,
      //                           height: 1.71,
      //                           letterSpacing: 0.30),
      //                     ),
      //                   ))
      //             ],
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
      //         child: Container(
      //           width: 100,
      //           height: 28,
      //           padding: const EdgeInsets.symmetric(horizontal: 12),
      //           decoration: ShapeDecoration(
      //               color: Colors.white,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(53),
      //               )),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             mainAxisSize: MainAxisSize.min,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Text(
      //                 userModel.isCN.value ? "直播地址" : "Address 01",
      //                 textAlign: TextAlign.right,
      //                 style: TextStyle(
      //                     color: kGreyColor,
      //                     fontSize: 14,
      //                     fontFamily: 'NotoSansSC',
      //                     fontWeight: FontWeight.w500,
      //                     height: 2,
      //                     letterSpacing: 0.3),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
      //         child: Container(
      //           width: 100,
      //           height: 28,
      //           padding: const EdgeInsets.symmetric(horizontal: 12),
      //           decoration: ShapeDecoration(
      //               color: Colors.white,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(53),
      //               )),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             mainAxisSize: MainAxisSize.min,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Text(
      //                 userModel.isCN.value ? "直播地址" : "Address 02",
      //                 textAlign: TextAlign.right,
      //                 style: TextStyle(
      //                     color: kGreyColor,
      //                     fontSize: 14,
      //                     fontFamily: 'NotoSansSC',
      //                     fontWeight: FontWeight.w500,
      //                     height: 2,
      //                     letterSpacing: 0.3),
      //               )
      //             ],
      //           ),
      //         ),
      //       )
      //     ],
      //   );
      case 3:
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
                  child: (basketballMatchById?.isEmpty ?? false)
                      ? searchEmptyWidget()
                      : isFixedTableNullFunction() == true
                          ? searchEmptyWidget()
                          : Column(
                              children: [
                                FixedTable(
                                    id: widget.id,
                                    homeTeamLineUp: homeTeamLineUp,
                                    awayTeamLineUp: awayTeamLineUp,
                                    isHome: true,
                                    homeTeamLogo:
                                        "${basketballMatchById?['homeTeamLogo'].toString()}",
                                    awayTeamLogo:
                                        "${basketballMatchById?['awayTeamLogo'].toString()}",
                                    homeTeamName:
                                        "${basketballMatchById?['homeTeamName'].toString()}",
                                    awayTeamName:
                                        "${basketballMatchById?['awayTeamName'].toString()}"),
                                SizedBox(
                                  height: 20,
                                ),
                                FixedTable(
                                    id: widget.id,
                                    homeTeamLineUp: homeTeamLineUp,
                                    awayTeamLineUp: awayTeamLineUp,
                                    isHome: false,
                                    homeTeamLogo:
                                        "${basketballMatchById?['homeTeamLogo'].toString()}",
                                    awayTeamLogo:
                                        "${basketballMatchById?['awayTeamLogo'].toString()}",
                                    homeTeamName:
                                        "${basketballMatchById?['homeTeamName'].toString()}",
                                    awayTeamName:
                                        "${basketballMatchById?['awayTeamName'].toString()}"),
                              ],
                            )),
            ],
          ),
        );

      default:
        return const Center(
          child: Text(""),
        );
    }
  }
}
