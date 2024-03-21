// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../Component/Loading/emptyResultComponent.dart';
import '../../Component/TournamentDetails/PercentageBarPercentage.dart';
import '../../Component/TournamentDetails/infoDisplay.dart';
import '../../Component/TournamentDetails/mapContent.dart';
import '../../Component/TournamentDetails/substituteList.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/footballMatchesModel.dart';
import '../../Model/liveStreamModel.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/footballMatchProvider.dart';
import '../../Provider/liveStreamProvider.dart';

class TournamentDetails extends StatefulWidget {
  const TournamentDetails(
      {Key? key,
      required this.id,
      required this.matchDate,
      required this.matchStatus,
      required this.matchName,
      required this.homeTeamFormation,
      required this.awayTeamFormation,
      required this.lineUp})
      : super(key: key);
  final String id;
  final String matchDate;
  final String matchStatus;
  final String matchName;
  final String homeTeamFormation;
  final String awayTeamFormation;
  final int lineUp;

  @override
  State<TournamentDetails> createState() => _TournamentDetailsState();
}

class _TournamentDetailsState extends State<TournamentDetails> {
  FootballMatchProvider provider = FootballMatchProvider();
  LiveStreamProvider liveProvider = LiveStreamProvider();
  Map<String, dynamic> footballMatchById = new Map<String, dynamic>();

  int selectedButton = 1;
  int selectedTextButton = 1;
  bool isLoading = false;
  bool isDetailNull = false;
  bool isCN = true;
  String matchStatusStr = '';
  // int lineUp = 1;
  String animationUrl = "";
  UserDataModel userModel = Get.find<UserDataModel>();

  // get football live data
  FootballLiveData liveData = FootballLiveData();
  FootballLineUpData lineUpData =
      FootballLineUpData(homeMatchLineUpList: [], awayMatchLineUpList: []);

  ButtonStyle buttonStyle(int buttonNumber) {
    return ElevatedButton.styleFrom(
      // primary: selectedButton == buttonNumber
      // ? Colors.green
      // : Colors.white, // Change the text color based on the button color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(53)),
    );
  }

  @override
  void initState() {
    super.initState();
    getFootballLiveData();
    getFootballLineUpData();
    getAnimationUrl();

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

    getTournamentLineup();
  }

  Future<void> getAnimationUrl() async {
    AnimationStreamModel? animationModel =
        await liveProvider.getAnimationUrl("football", widget.id);
    animationUrl = animationModel?.data ?? "";
  }

  Future<void> getFootballLiveData() async {
    FootballLiveDataModel? liveDataModel =
        await provider.getFootballLiveData(widget.id);

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      liveData = liveDataModel?.data ?? FootballLiveData();
      print("check new Api: $liveData");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getFootballLineUpData() async {
    FootballLineUpModel? lineUpModel =
        await provider.getFootballLineUp(widget.id);
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      lineUpData = lineUpModel?.data ??
          FootballLineUpData(homeMatchLineUpList: [], awayMatchLineUpList: []);
      print("check new Api: $lineUpData");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> getTournamentDetails() async {
    if (await provider.getFootballMatchbyId(widget.id, userModel.isCN.value) ==
        null) {
      isDetailNull = true;
    } else {
      footballMatchById = (await provider.getFootballMatchbyId(
          widget.id, userModel.isCN.value))!;
    }

    return footballMatchById;
  }

  Map<String, dynamic> footballLineupByMatchId = new Map<String, dynamic>();
  Future<Map<String, dynamic>> getTournamentLineup() async {
    footballLineupByMatchId =
        await provider.getFootballLineup(widget.id, userModel.isCN.value);

    return footballLineupByMatchId;
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black),
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double viewportFraction = 328.0 / screenWidth;

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
              letterSpacing: 0.30,
            ),
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
                              'images/tournament/tournament_detail.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ],
                      )
                    : (footballMatchById?.isEmpty ?? false)
                        ? userModel.isCN.value
                            ? Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.asset(
                                          'images/tournament/tournament_detail.png',
                                          fit: BoxFit.fill,
                                        )),
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
                                  ])
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(
                                      'images/tournament/tournament_detail.png',
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
                        : Stack(children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'images/tournament/tournament_detail.png',
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
                                  '${widget.matchDate}',
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
                                        footballMatchById['homeTeamLogo']
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
                                        footballMatchById['awayTeamLogo']
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
                                  width: 140,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 135, 0, 0),
                                    child: Text(
                                      footballMatchById['homeTeamName']
                                          .toString(),
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
                                  width: 140,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 135, 0, 0),
                                    child: Text(
                                      footballMatchById['awayTeamName']
                                          .toString(),
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
                              left: 144,
                              child: Text(
                                '${footballMatchById['homeScore'].toString()}',
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
                              right: 143,
                              child: Text(
                                '${footballMatchById['awayScore'].toString()}',
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
                                        "navi to animation stream:${animationUrl}");

                                    if (animationUrl == "" ||
                                        animationUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("没有直播"),
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
                          ]),
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
                      ),
                    ],
                  ),
                ),
                Container(
                  // set height to your preference// optional
                  child: isDetailNull
                      ? searchEmptyWidget()
                      // ? SizedBox()
                      : getContentForSelectedButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getContentForSelectedButton() {
    // FootballMatchProvider FootballMatchProvider
    final screenWidth = MediaQuery.of(context).size.width;

    final barWidth = (screenWidth - 0) * 0.2; // 调整为需要的宽度

    // Case 3
    List<dynamic> F_list;
    List<dynamic> M_list;
    List<dynamic> G_list;
    List<dynamic> D_list;
    List<dynamic> S_list;

    List<dynamic> AF_list;
    List<dynamic> AM_list;
    List<dynamic> AG_list;
    List<dynamic> AD_list;
    List<dynamic> AS_list;

    if (userModel.isCN.value) {
      F_list = ["F"];
      M_list = ["M"];
      G_list = ["G"];
      D_list = ["D"];
      S_list = ["S"];

      AF_list = ["F"];
      AM_list = ["M"];
      AG_list = ["G"];
      AD_list = ["D"];
      AS_list = ["S"];
    } else {
      // HOME
      List<String> parts = widget.homeTeamFormation.split("-");
      int F = 0, M = 0, D = 0, S = 0;

      if (parts.length >= 1) {
        F = int.tryParse(parts[0]) ?? 0;
      }
      if (parts.length >= 2) {
        M = int.tryParse(parts[1]) ?? 0;
      }
      if (parts.length >= 3) {
        D = int.tryParse(parts[2]) ?? 0;
      }
      if (parts.length >= 4) {
        S = int.tryParse(parts[3]) ?? 0;
      }

      print("part----------$parts");
      print("$F + $M + $D + $S");

      // AWAY
      List<String> Aparts = widget.awayTeamFormation.split("-");
      int AF = 0, AM = 0, AD = 0, AS = 0;

      if (Aparts.length >= 1) {
        AF = int.tryParse(Aparts[0]) ?? 0;
      }
      if (Aparts.length >= 2) {
        AM = int.tryParse(Aparts[1]) ?? 0;
      }
      if (Aparts.length >= 3) {
        AD = int.tryParse(Aparts[2]) ?? 0;
      }
      if (Aparts.length >= 4) {
        AS = int.tryParse(Aparts[3]) ?? 0;
      }

      print("part----------$Aparts");
      print("$AF + $AM + $AD + $AS");

      List<int> generateNumberList(int start, int end) {
        List<int> numbersList = [];
        for (int i = start; i <= end; i++) {
          numbersList.add(i);
        }
        return numbersList;
      }

      // HOME
      F_list = generateNumberList(F + M + 2, F + M + D + 1);
      print("first: $F_list");

      M_list = generateNumberList(F + 2, F + M + 1);
      print("second: $M_list");

      D_list = generateNumberList(2, F + 1);
      print("third: $D_list");

      S_list = generateNumberList(F + M + D + 2, F + M + D + S + 1);
      print("fourth: $S_list");

      G_list = [1];

      // AWAY
      AF_list = generateNumberList(AF + AM + 2, AF + AM + AD + 1);
      print("A_first: $AF_list");

      AM_list = generateNumberList(AF + 2, AF + AM + 1);
      print("A_second: $AM_list");

      AD_list = generateNumberList(2, AF + 1);
      print("A_third: $AD_list");

      AS_list = generateNumberList(AF + AM + AD + 2, AF + AM + AD + AS + 1);
      print("A_fourth: $AS_list");

      AG_list = [1];
    }

    //HOME TEAM
    var homeMatchLineUpList = footballLineupByMatchId['homeMatchLineUpList'];

    List<String> F_shirtNumber = [];
    List<String> F_playerName = [];
    List<int> F_captain = [];

    List<String> M_shirtNumber = [];
    List<String> M_playerName = [];
    List<int> M_captain = [];

    List<String> G_shirtNumber = [];
    List<String> G_playerName = [];
    List<int> G_captain = [];

    List<String> D_shirtNumber = [];
    List<String> D_playerName = [];
    List<int> D_captain = [];

    List<String> S_shirtNumber = [];
    List<String> S_playerName = [];
    List<int> S_captain = [];

    //AWAY TEAM
    var awayMatchLineUpList = footballLineupByMatchId['awayMatchLineList'];

    List<String> AF_shirtNumber = [];
    List<String> AF_playerName = [];
    List<int> AF_captain = [];

    List<String> AM_shirtNumber = [];
    List<String> AM_playerName = [];
    List<int> AM_captain = [];

    List<String> AG_shirtNumber = [];
    List<String> AG_playerName = [];
    List<int> AG_captain = [];

    List<String> AD_shirtNumber = [];
    List<String> AD_playerName = [];
    List<int> AD_captain = [];

    List<String> AS_shirtNumber = [];
    List<String> AS_playerName = [];
    List<int> AS_captain = [];

    void processPlayerPosition(
      List<Map<String, dynamic>> playerList,
      List<dynamic> positionList,
      List<int> captainList,
      List<String> shirtNumberList,
      List<String> playerNameList,
    ) {
      for (var player in playerList) {
        dynamic position = player['position'];
        int first = player['first'];
        int captain = player['captain'];

        if (positionList.contains(position) && first == 1) {
          int id = player['shirtNumber'];
          String fullName = player['playerName'];

          List<String> nameParts = fullName.split(RegExp(r'[ ·]'));
          String name = nameParts.isNotEmpty ? nameParts.last.trim() : fullName;

          captainList.add(captain);
          shirtNumberList.add(id.toString());
          playerNameList.add(name);
        }
      }
    }

    // HOME
    if (homeMatchLineUpList != null) {
      List<Map<String, dynamic>> lineupList =
          List<Map<String, dynamic>>.from(homeMatchLineUpList);

      processPlayerPosition(
          lineupList, F_list, F_captain, F_shirtNumber, F_playerName);
      processPlayerPosition(
          lineupList, M_list, M_captain, M_shirtNumber, M_playerName);
      processPlayerPosition(
          lineupList, G_list, G_captain, G_shirtNumber, G_playerName);
      processPlayerPosition(
          lineupList, D_list, D_captain, D_shirtNumber, D_playerName);
      processPlayerPosition(
          lineupList, S_list, S_captain, S_shirtNumber, S_playerName);
    }

    // AWAY
    if (awayMatchLineUpList != null) {
      List<Map<String, dynamic>> lineupList =
          List<Map<String, dynamic>>.from(awayMatchLineUpList);

      processPlayerPosition(
          lineupList, AF_list, AF_captain, AF_shirtNumber, AF_playerName);
      processPlayerPosition(
          lineupList, AM_list, AM_captain, AM_shirtNumber, AM_playerName);
      processPlayerPosition(
          lineupList, AG_list, AG_captain, AG_shirtNumber, AG_playerName);
      processPlayerPosition(
          lineupList, AD_list, AD_captain, AD_shirtNumber, AD_playerName);
      processPlayerPosition(
          lineupList, AS_list, AS_captain, AS_shirtNumber, AS_playerName);
    }

    // Case 1
    double parseDouble(String key, Map<String, dynamic> data) {
      if (data[key] != null) {
        print("check: ${data[key]}");

        String value = data[key].toString();
        if (value.contains('%')) {
          value = value.replaceAll("%", '');
          return double.parse(value);
        }

        return double.parse(data[key].toString());
        // return double.parse("55");
      }
      return 0.0;
    }

    print(
        "$F_shirtNumber + $M_shirtNumber + $G_shirtNumber + $D_shirtNumber + $S_shirtNumber");
    print(
        "$AF_shirtNumber + $AM_shirtNumber + $AG_shirtNumber + $AD_shirtNumber + $AS_shirtNumber");

    // Define percent - 脚球 - left
    String homecornerKickNum =
        parseDouble('homeCornerKickNum', footballMatchById).toInt().toString();

    // Define percent - 脚球 - right
    String awaycornerKickNum =
        parseDouble('awayCornerKickNum', footballMatchById).toInt().toString();

    // Define percent - 黄牌 - left
    String homeYellowCardNum =
        parseDouble('homeYellowCardNum', footballMatchById).toInt().toString();

    // Define percent - 黄牌 - right
    String awayYellowCardNum =
        parseDouble('awayYellowCardNum', footballMatchById).toInt().toString();

    // Define percent - 红牌 - left
    String homeRedCardNum =
        parseDouble('homeRedCardNum', footballMatchById).toInt().toString();

    // Define percent - 红牌 - right
    String awayRedCardNum =
        parseDouble('awayRedCardNum', footballMatchById).toInt().toString();

    // Define percent - 控球率 - orange
    double percent_homePossession =
        parseDouble('homePossessionRate', footballMatchById);

    // Define percent - 控球率 - green
    double percent_awayPossession =
        parseDouble('awayPossessionRate', footballMatchById);

    // Define percent - 危险进攻 - orange
    double percent_homeAttack =
        parseDouble('homeAttackDangerNum', footballMatchById);

    // Define percent - 危险进攻 - green
    double percent_awayAttack =
        parseDouble('awayAttackDangerNum', footballMatchById);

    // Define percent - 进攻 - orange
    double percent_homeAttackNum =
        parseDouble('homeAttackNum', footballMatchById);

    // Define percent - 进攻 - green
    double percent_awayAttackNum =
        parseDouble('awayAttackNum', footballMatchById);

    // Define percent_1 (left bar) - 射门（射正）- orange
    double percent1 = parseDouble('homeShootGoalNum', footballMatchById);

    // Define percent_2 (left bar)  - 射门（射正）- light orange - ()
    double percent2 = parseDouble('homeBiasNum', footballMatchById);

    // Define percent_2 (left bar) - 射门（射正）- green - ()
    double percent_1 = parseDouble('awayShootGoalNum', footballMatchById);

    // Define percent_2 (right bar)  - 射门（射正）- light green - ()
    double percent_2 = parseDouble('awayBiasNum', footballMatchById);

    // Define percent - 点球 - orange
    double percent_homeCountBall =
        parseDouble('homePenaltyNum', footballMatchById);

    // Define percent - 点球 - green
    double percent_awayCountBall =
        parseDouble('awayPenaltyNum', footballMatchById);

    switch (selectedButton) {
      case 1:
        // Return a ListView for Button 1
        //与屏幕向内Padding
        return isLoading
            ? Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20.0), // Adjust the value as needed
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              )
            : (footballMatchById?.isEmpty ?? false)
                ? userModel.isCN.value
                    ? InfoDisplay(
                        text: '无信息',
                        textColor: Colors.black,
                      )
                    : InfoDisplay(
                        text: 'No Information',
                        textColor: Colors.black,
                      )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                    child: Center(
                      //Container 来添加白背景
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                        child: Column(
                          //Container 里面的Column 来接受Multiple Container
                          children: [
                            //第一个Container 来显示 角球，黄牌，红牌
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  1, // 使用屏幕宽度的90%
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                                'images/tournament/jiaoQiu.png',
                                                width: 35,
                                                height: 30),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(homecornerKickNum),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                                'images/tournament/hongPai.png',
                                                width: 35,
                                                height: 30),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(homeRedCardNum),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                                'images/tournament/huangPai.png',
                                                width: 35,
                                                height: 30),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(homeYellowCardNum),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            Image.asset(
                                                'images/tournament/huangPai.png',
                                                width: 35,
                                                height: 30),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(awayYellowCardNum),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                                'images/tournament/hongPai.png',
                                                width: 35,
                                                height: 30),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(awayRedCardNum),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                                'images/tournament/jiaoQiu.png',
                                                width: 35,
                                                height: 30),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(awaycornerKickNum),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //第二个Container来计算每个Title的 巴仙
                            Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width * 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: PercentageBarPercentage2(
                                          percent2: percent_homePossession,
                                          percent2_text: percent_homePossession,
                                          width2: barWidth,
                                          height2: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Text(
                                        userModel.isCN == true
                                            ? '控球率'
                                            : "Possession",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(width: 1),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: PercentageBarPercentage(
                                          percent: percent_awayPossession,
                                          percent_text: percent_awayPossession,
                                          width: barWidth,
                                          height: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: userModel.isCN.value ? 10 : 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: PercentageBarPercentage2(
                                          percent2: (percent_homeAttack +
                                                      percent_awayAttack >
                                                  0)
                                              ? (percent_homeAttack /
                                                      (percent_homeAttack +
                                                          percent_awayAttack)) *
                                                  100
                                              : 0.0,
                                          percent2_text: percent_homeAttack,
                                          width2: barWidth,
                                          height2: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Text(
                                        userModel.isCN == true
                                            ? '危险进攻'
                                            : 'Danger',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(width: 1),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: PercentageBarPercentage(
                                          percent: (percent_homeAttack +
                                                      percent_awayAttack >
                                                  0)
                                              ? (percent_awayAttack /
                                                      (percent_homeAttack +
                                                          percent_awayAttack)) *
                                                  100
                                              : 0.0,
                                          percent_text: percent_awayAttack,
                                          width: barWidth,
                                          height: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: userModel.isCN.value ? 10 : 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: PercentageBarPercentage2(
                                          percent2: (percent_homeAttackNum +
                                                      percent_awayAttackNum >
                                                  0)
                                              ? (percent_homeAttackNum /
                                                      (percent_homeAttackNum +
                                                          percent_awayAttackNum)) *
                                                  100
                                              : 0.0,
                                          percent2_text: percent_homeAttackNum,
                                          width2: barWidth,
                                          height2: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Text(
                                        userModel.isCN == true
                                            ? '进攻'
                                            : 'Attack',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(width: 1),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: PercentageBarPercentage(
                                          percent: (percent_homeAttackNum +
                                                      percent_awayAttackNum >
                                                  0)
                                              ? (percent_awayAttackNum /
                                                      (percent_homeAttackNum +
                                                          percent_awayAttackNum)) *
                                                  100
                                              : 0.0,
                                          percent_text: percent_awayAttackNum,
                                          width: barWidth,
                                          height: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: userModel.isCN.value ? 10 : 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: PercentageBarOnTarget2(
                                          percent1: (percent1 + percent_1 > 0)
                                              ? (((percent1 /
                                                          (percent1 +
                                                              percent2)) *
                                                      ((percent1 + percent2) /
                                                          ((percent1 +
                                                                  percent2) +
                                                              (percent_1 +
                                                                  percent_2)))) *
                                                  100)
                                              : 0.0,
                                          percent2: (percent2 + percent_2 > 0)
                                              ? (((percent2 + percent1) /
                                                      ((percent2 + percent1) +
                                                          (percent_1 +
                                                              percent_2))) *
                                                  100)
                                              : 0.0,
                                          percent1_text: percent2 + percent1,
                                          percent2_text: percent1,
                                          width2: barWidth,
                                          height2: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      SizedBox(
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            userModel.isCN == true
                                                ? '射门(射正)'
                                                : "Shoot (Score)",
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: PercentageBarOnTarget(
                                          percent_1: (percent1 + percent_1 > 0)
                                              ? (((percent_1 /
                                                          (percent_1 +
                                                              percent_2)) *
                                                      ((percent_1 + percent_2) /
                                                          ((percent_1 +
                                                                  percent_2) +
                                                              (percent1 +
                                                                  percent2)))) *
                                                  100)
                                              : 0.0,
                                          percent_2: (percent2 + percent_2 > 0)
                                              ? (((percent_2 + percent_1) /
                                                      ((percent2 + percent1) +
                                                          (percent_1 +
                                                              percent_2))) *
                                                  100)
                                              : 0.0,
                                          percent_1_text: percent_1 + percent_2,
                                          percent_2_text: percent_1,
                                          width: barWidth,
                                          height: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: userModel.isCN.value ? 10 : 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: PercentageBarPercentage2(
                                          percent2: (percent_homeCountBall +
                                                      percent_awayCountBall >
                                                  0)
                                              ? (percent_homeCountBall /
                                                      (percent_homeCountBall +
                                                          percent_awayCountBall)) *
                                                  100
                                              : 0.0,
                                          percent2_text: percent_homeCountBall,
                                          width2: barWidth,
                                          height2: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Text(
                                        userModel.isCN == true
                                            ? '点球'
                                            : "Penalty",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(width: 1),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: PercentageBarPercentage(
                                          percent: (percent_homeCountBall +
                                                      percent_awayCountBall >
                                                  0)
                                              ? (percent_awayCountBall /
                                                      (percent_homeCountBall +
                                                          percent_awayCountBall)) *
                                                  100
                                              : 0.0,
                                          percent_text: percent_awayCountBall,
                                          width: barWidth,
                                          height: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

      case 3:
        // Return a ListView for Button 3

        return SingleChildScrollView(
            child: (footballLineupByMatchId['homeMatchLineUpList']?.isEmpty ??
                        false) ||
                    (footballLineupByMatchId['awayMatchLineUpList']?.isEmpty ??
                        false)
                ? userModel.isCN.value
                    ? InfoDisplay(
                        text: '无信息',
                        textColor: Colors.black,
                      )
                    : InfoDisplay(
                        text: 'No Information',
                        textColor: Colors.black,
                      )
                : isLoading
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20.0), // Adjust the value as needed
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 622.75,
                              decoration: ShapeDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "images/tournament/qiuChang.png"),
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              //阵容里面的排版
                              child: (widget.lineUp == 0)
                                  ? Center(
                                      child: userModel.isCN.value
                                          ? Padding(
                                              padding: EdgeInsets.all(
                                                  25.0), // Adjust the padding as needed
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '无阵容信息',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1,
                                                      letterSpacing: 0.46,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.all(
                                                  25.0), // Adjust the padding as needed
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'No Lineup Information',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1,
                                                      letterSpacing: 0.46,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    )
                                  : Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Image.network(
                                                    footballMatchById[
                                                        'homeTeamLogo'],
                                                    height: 25,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  //Lineup need to fetch from API
                                                  userModel.isCN.value
                                                      ? Text(
                                                          "${D_playerName.length}-${M_playerName.length}-${F_playerName.length}",
                                                          style: TextStyle(
                                                              color:
                                                                  kMainComponentColor,
                                                              fontFamily:
                                                                  'NotoSansSC',
                                                              fontSize:
                                                                  13, //*fem
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Text(
                                                          widget
                                                              .homeTeamFormation,
                                                          style: TextStyle(
                                                              color:
                                                                  kMainComponentColor,
                                                              fontFamily:
                                                                  'NotoSansSC',
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                ])
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Image.network(
                                                    //Get Image From Server
                                                    footballMatchById[
                                                        'awayTeamLogo'],

                                                    height: 25,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  userModel.isCN.value
                                                      ? Text(
                                                          "${AD_playerName.length}-${AM_playerName.length}-${AF_playerName.length}",
                                                          style: TextStyle(
                                                              color:
                                                                  kMainComponentColor,
                                                              fontFamily:
                                                                  'NotoSansSC',
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Text(
                                                          widget
                                                              .awayTeamFormation,
                                                          style: TextStyle(
                                                              color:
                                                                  kMainComponentColor,
                                                              fontFamily:
                                                                  'NotoSansSC',
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                ])
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //HOME TEAM LINE UP
                                            const SizedBox(
                                              height: 0,
                                            ),

                                            //第一排
                                            MapContents(
                                              numberOfItems:
                                                  G_shirtNumber.length,
                                              textColor: Colors.white,
                                              //Get 球员号码
                                              text: G_shirtNumber,
                                              circleColor: Color.fromARGB(
                                                  255, 232, 89, 1),
                                              labels:
                                                  //Get Name from Some where
                                                  G_playerName,
                                              // 设置圆圈颜色
                                              icon: G_captain,
                                            ),

                                            //第二排
                                            MapContents(
                                              numberOfItems:
                                                  D_shirtNumber.length,
                                              textColor: Colors.white,
                                              text: D_shirtNumber,
                                              circleColor: Color(0xFF1168B9),
                                              labels: D_playerName,
                                              icon: D_captain, // 设置圆圈颜色
                                            ),

                                            //第三排
                                            MapContents(
                                              numberOfItems:
                                                  M_shirtNumber.length,
                                              textColor: Colors.white,
                                              text: M_shirtNumber,
                                              circleColor: Color(0xFF1168B9),
                                              labels: M_playerName,
                                              icon: M_captain, // 设置圆圈颜色
                                            ),

                                            //第四排
                                            MapContents(
                                              numberOfItems:
                                                  F_shirtNumber.length,
                                              textColor: Colors.white,
                                              text: F_shirtNumber,
                                              circleColor: Color(0xFF1168B9),
                                              labels:
                                                  //Get the name from here
                                                  F_playerName,
                                              icon: F_captain, // 设置圆圈颜色
                                            ),

                                            //第五排
                                            MapContents(
                                              numberOfItems:
                                                  S_shirtNumber.length,
                                              textColor: Colors.white,
                                              text: S_shirtNumber,
                                              circleColor: Color(0xFF1168B9),
                                              labels:
                                                  //Get the name from here
                                                  S_playerName,
                                              icon: S_captain, // 设置圆圈颜色
                                            ),

                                            SizedBox(
                                              height: 15,
                                            ),

                                            //Away Team First Row
                                            //第一排
                                            MapContents(
                                              numberOfItems:
                                                  AS_shirtNumber.length,
                                              textColor: Colors.white,
                                              text: AS_shirtNumber,
                                              circleColor: Color(0xFF1168B9),
                                              labels:
                                                  //Get the name from here
                                                  AS_playerName,
                                              icon: AS_captain, // 设置圆圈颜色
                                            ),

                                            //第二排
                                            MapContents(
                                              numberOfItems:
                                                  AF_playerName.length,
                                              textColor: Colors.white,
                                              text: AF_shirtNumber,
                                              circleColor:
                                                  const Color(0xFFD043D3),
                                              labels: AF_playerName,
                                              icon: AF_captain, // 设置圆圈颜色
                                            ),

                                            //第三排
                                            MapContents(
                                              numberOfItems:
                                                  AM_playerName.length,
                                              textColor: Colors.white,
                                              text: AM_shirtNumber,
                                              circleColor: Color(0xFFD043D3),
                                              labels: AM_playerName,
                                              icon: AM_captain, // 设置圆圈颜色
                                            ),

                                            //第四排
                                            MapContents(
                                              numberOfItems:
                                                  AD_playerName.length,
                                              textColor: Colors.white,
                                              text: AD_shirtNumber,
                                              circleColor: Color(0xFFD043D3),
                                              labels: AD_playerName,
                                              icon: AD_captain, // 设置圆圈颜色
                                            ),

                                            //第五排
                                            MapContents(
                                              numberOfItems:
                                                  AG_playerName.length,
                                              textColor: Colors.white,
                                              text: AG_shirtNumber,
                                              circleColor: Color(0xFFFFC42B),
                                              labels: AG_playerName,
                                              icon: AG_captain, // 设置圆圈颜色
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          (widget.lineUp == 0)
                              ? Center()
                              : Padding(
                                  padding: EdgeInsets.fromLTRB(20, 18, 20, 30),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          userModel.isCN.value
                                              ? '替补阵容'
                                              : "Substitute",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            letterSpacing: 0.46,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 3, 0, 3),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                              image: NetworkImage(
                                                                  footballMatchById[
                                                                      'homeTeamLogo']), // Replace with your image path
                                                              fit: BoxFit.cover,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 110,
                                                                child: Text(
                                                                  footballMatchById[
                                                                          'homeTeamName']
                                                                      .toString(),
                                                                  maxLines: 3,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        "NotoSansSC",
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            51,
                                                                            51,
                                                                            51,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Expanded(
                                              child: Container(
                                                color: Colors.transparent,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 3, 0, 3),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 35,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                            image: NetworkImage(
                                                                footballMatchById[
                                                                    'awayTeamLogo']), // Replace with your image path
                                                            fit: BoxFit.cover,
                                                          )),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 110,
                                                              child: Text(
                                                                footballMatchById[
                                                                        'awayTeamName']
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "NotoSansSC",
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          51,
                                                                          51,
                                                                          51,
                                                                          1),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 3, 0, 3),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                              image: AssetImage(
                                                                  'images/tournament/defaultlogo.png'), // Replace with your image path
                                                              fit: BoxFit.cover,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              userModel.isCN
                                                                      .value
                                                                  ? Text(
                                                                      "${footballMatchById['homeCoach'].toString()}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            "NotoSansSC",
                                                                        color: Color.fromRGBO(
                                                                            51,
                                                                            51,
                                                                            51,
                                                                            1),
                                                                      ),
                                                                      maxLines:
                                                                          2, // 设置最大行数
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // 使用省略号来处理溢出
                                                                    )
                                                                  : Text(
                                                                      "${footballMatchById['homeCoach'].toString()}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            "NotoSansSC",
                                                                        color: Color.fromRGBO(
                                                                            51,
                                                                            51,
                                                                            51,
                                                                            1),
                                                                      ),
                                                                    ),
                                                              userModel.isCN
                                                                      .value
                                                                  ? Text(
                                                                      "主教练",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            "NotoSansSC",
                                                                        color: Color.fromRGBO(
                                                                            102,
                                                                            102,
                                                                            102,
                                                                            1),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      "Coach",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            "NotoSansSC",
                                                                        color: Color.fromRGBO(
                                                                            102,
                                                                            102,
                                                                            102,
                                                                            1),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Expanded(
                                              child: Container(
                                                color: Colors.transparent,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 3, 0, 3),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 35,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                            image: AssetImage(
                                                                'images/tournament/defaultlogo.png'), // Replace with your image path
                                                            fit: BoxFit.cover,
                                                          )),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            userModel.isCN.value
                                                                ? Text(
                                                                    "${footballMatchById['awayCoach'].toString()}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          "NotoSansSC",
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              51,
                                                                              51,
                                                                              51,
                                                                              1),
                                                                    ),
                                                                    maxLines:
                                                                        2, // 设置最大行数
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // 使用省略号来处理溢出
                                                                  )
                                                                : Text(
                                                                    "${footballMatchById['awayCoach'].toString()}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          "NotoSansSC",
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              51,
                                                                              51,
                                                                              51,
                                                                              1),
                                                                    ),
                                                                  ),
                                                            userModel.isCN.value
                                                                ? Text(
                                                                    "主教练",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          "NotoSansSC",
                                                                      color: Color.fromRGBO(
                                                                          102,
                                                                          102,
                                                                          102,
                                                                          1),
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    "Coach",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          "NotoSansSC",
                                                                      color: Color.fromRGBO(
                                                                          102,
                                                                          102,
                                                                          102,
                                                                          1),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        substituteList(
                                          id: widget.id,
                                          footballLineupByMatchId:
                                              footballLineupByMatchId,
                                          isLoading: isLoading,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ));

      default:
        return const Center(
          child: Text(""),
        );
    }
  }

  Column buildFileColumn(String image, String number) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
          child: Image.asset("images/$image.png"),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(number)
      ],
    );
  }
}
