import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FixedTable extends StatefulWidget {
  final String id;
  final bool isHome;
  final List<dynamic>? homeTeamLineUp;
  final List<dynamic>? awayTeamLineUp;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final String homeTeamName;
  final String awayTeamName;

  const FixedTable({
    Key? key,
    required this.id,
    required this.homeTeamLineUp,
    required this.awayTeamLineUp,
    required this.isHome,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeTeamName,
    required this.awayTeamName,
  });

  @override
  State<FixedTable> createState() => _FixedTableState();
}

class _FixedTableState extends State<FixedTable> {
  UserDataModel userDataModel = Get.find<UserDataModel>();

  //Column
  List<dynamic> playerName = [];
  List<dynamic> minutes = [];
  List<dynamic> scores = [];
  List<dynamic> rebound = [];
  List<dynamic> assist = [];
  List<dynamic> fieldGoal = [];
  List<dynamic> threePointer = [];
  List<dynamic> freeThrow = [];
  List<dynamic> steal = [];
  List<dynamic> turnover = [];
  List<dynamic> blockShot = [];
  List<dynamic> foul = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // getPlayerName();
      // getMinutes();
      // getScores();
      // getRebound();
      // getAssist();
      // getFieldGoal();
      // getThreePointer();
      // getFreeThrow();
      // getSteal();
      // getTurnover();
      // getBlockShot();
      // getFoul();
    });
  }

//====================== Get Column Data ======================================//

  List<dynamic> getPlayerName() {
    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        playerName.add(widget.homeTeamLineUp![i]['playerName']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        playerName.add(widget.awayTeamLineUp![i]['playerName']);
      }
    }

    return playerName;
  }

  List<dynamic> getMinutes() {
    // if (userDataModel.isCN.value) {
    //   minutes = ['时间'];
    // } else {
    minutes = [AppLocalizations.of(context)!.time];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        minutes.add(widget.homeTeamLineUp![i]['minutes']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        minutes.add(widget.awayTeamLineUp![i]['minutes']);
      }
    }

    return minutes;
  }

  List<dynamic> getScores() {
    // if (userDataModel.isCN.value) {
    //   scores = ['得分'];
    // } else {
    scores = [AppLocalizations.of(context)!.score];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        scores.add(widget.homeTeamLineUp![i]['point']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        scores.add(widget.awayTeamLineUp![i]['point']);
      }
    }

    return scores;
  }

  List<dynamic> getRebound() {
    // if (userDataModel.isCN.value) {
    //   rebound = ['篮板'];
    // } else {
    rebound = [AppLocalizations.of(context)!.rebound];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        rebound.add(widget.homeTeamLineUp![i]['totalRebounds']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        rebound.add(widget.awayTeamLineUp![i]['totalRebounds']);
      }
    }

    return rebound;
  }

  List<dynamic> getAssist() {
    // if (userDataModel.isCN.value) {
    //   assist = ['助攻'];
    // } else {
    assist = [AppLocalizations.of(context)!.assist];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        assist.add(widget.homeTeamLineUp![i]['assists']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        assist.add(widget.awayTeamLineUp![i]['assists']);
      }
    }

    return assist;
  }

  List<dynamic> getFieldGoal() {
    // if (userDataModel.isCN.value) {
    //   fieldGoal = ['投篮'];
    // } else {
    fieldGoal = [AppLocalizations.of(context)!.fieldGoal];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        String fieldGoalTemp =
            "${widget.homeTeamLineUp![i]['fieldGoalsMade']} - ${widget.homeTeamLineUp![i]['fieldGoalsAttempts']}";
        fieldGoal.add(fieldGoalTemp);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        String fieldGoalTemp =
            "${widget.awayTeamLineUp![i]['fieldGoalsMade']} - ${widget.awayTeamLineUp![i]['fieldGoalsAttempts']}";
        fieldGoal.add(fieldGoalTemp);
      }
    }

    return fieldGoal;
  }

  List<dynamic> getThreePointer() {
    // if (userDataModel.isCN.value) {
    //   threePointer = ['三分'];
    // } else {
    threePointer = [AppLocalizations.of(context)!.threePointer];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        String threePointerTemp =
            "${widget.homeTeamLineUp![i]['threePointGoalsMade']} - ${widget.homeTeamLineUp![i]['threePointGoalsAttempts']}";

        threePointer.add(threePointerTemp);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        String threePointerTemp =
            "${widget.awayTeamLineUp![i]['threePointGoalsMade']} - ${widget.awayTeamLineUp![i]['threePointGoalsAttempts']}";

        threePointer.add(threePointerTemp);
      }
    }

    return threePointer;
  }

  List<dynamic> getFreeThrow() {
    // if (userDataModel.isCN.value) {
    //   freeThrow = ['罚球'];
    // } else {
    freeThrow = [AppLocalizations.of(context)!.freeThrow];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        String freeThrowTemp =
            "${widget.homeTeamLineUp![i]['freeThrowsGoalsMade']} - ${widget.homeTeamLineUp![i]['freeThrowsGoalsAttempts']}";

        freeThrow.add(freeThrowTemp);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        String freeThrowTemp =
            "${widget.awayTeamLineUp![i]['freeThrowsGoalsMade']} - ${widget.awayTeamLineUp![i]['freeThrowsGoalsAttempts']}";

        freeThrow.add(freeThrowTemp);
      }
    }

    return freeThrow;
  }

  List<dynamic> getSteal() {
    // if (userDataModel.isCN.value) {
    //   steal = ['抢断'];
    // } else {
    steal = [AppLocalizations.of(context)!.steal];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        steal.add(widget.homeTeamLineUp![i]['steals']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        steal.add(widget.awayTeamLineUp![i]['steals']);
      }
    }

    return steal;
  }

  List<dynamic> getTurnover() {
    // if (userDataModel.isCN.value) {
    //   turnover = ['失误'];
    // } else {
    turnover = [AppLocalizations.of(context)!.turnover];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        turnover.add(widget.homeTeamLineUp![i]['turnovers']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        turnover.add(widget.awayTeamLineUp![i]['turnovers']);
      }
    }

    return turnover;
  }

  List<dynamic> getBlockShot() {
    // if (userDataModel.isCN.value) {
    //   blockShot = ['盖帽'];
    // } else {
    blockShot = [AppLocalizations.of(context)!.blockShot];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        blockShot.add(widget.homeTeamLineUp![i]['blocks']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        blockShot.add(widget.awayTeamLineUp![i]['blocks']);
      }
    }

    return blockShot;
  }

  List<dynamic> getFoul() {
    // if (userDataModel.isCN.value) {
    //   foul = ['犯规'];
    // } else {
    foul = [AppLocalizations.of(context)!.foul];
    // }

    if (widget.isHome) {
      for (int i = 0; i < widget.homeTeamLineUp!.length; i++) {
        foul.add(widget.homeTeamLineUp![i]['personalFouls']);
      }
    } else {
      for (int i = 0; i < widget.awayTeamLineUp!.length; i++) {
        foul.add(widget.awayTeamLineUp![i]['personalFouls']);
      }
    }

    return foul;
  }

  //=================================================================================//

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    String homeTeamLogo = widget.homeTeamLogo;
    String awayTeamLogo = widget.awayTeamLogo;
    String homeTeamName = widget.homeTeamName;
    String awayTeamName = widget.awayTeamName;

    //sizing
    double baseWidth = 375;
    double screenWidth = MediaQuery.of(context).size.width;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    //test index number
    final int number = 5;
    final int number2 = number + 1;

    //provider
    List<dynamic>? homeTeamLineUp = widget.homeTeamLineUp;
    List<dynamic>? awayTeamLineUp = widget.awayTeamLineUp;
    int homeTeamCount = homeTeamLineUp!.length;
    int awayTeamCount = awayTeamLineUp!.length;

    getPlayerName();
    getMinutes();
    getScores();
    getRebound();
    getAssist();
    getFieldGoal();
    getThreePointer();
    getFreeThrow();
    getSteal();
    getTurnover();
    getBlockShot();
    getFoul();

    Color getRowBackgroundColor(int i) {
      return i.isOdd ? Colors.white : tableMainColor;
    }

    Color getDataRowBackgroundColor(int i) {
      if (i == 0) {
        return Colors.white;
      } else {
        return i.isEven ? Colors.white : tableMainColor;
      }
    }

    //get height of data container
    double getDataContainerHeight() {
      if (widget.isHome) {
        return 40 * (homeTeamCount + 1);
      } else {
        return 40 * (awayTeamCount + 1);
      }
    }

    return Container(
      width: screenWidth,
      height: getDataContainerHeight() + 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.2),
          color: Colors.white),
      child: Column(
        children: [
          Container(
            width: screenWidth * 1,
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 2,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    width: 0.08 * screenWidth,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.isHome ? homeTeamLogo : awayTeamLogo),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 0.7 * screenWidth,
                  child: Container(
                    child: Text(widget.isHome ? homeTeamName : awayTeamName),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: getDataContainerHeight() + 1,
              child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.1, color: Colors.grey)),
                      child: Row(
                        children: [
                          Container(
                            width: 100 * fem,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.1, color: Colors.transparent)),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.0,
                                          color: Colors.transparent),
                                      color: kMainComponentColor),
                                ),
                                ...List.generate(
                                    widget.isHome
                                        ? homeTeamCount
                                        : awayTeamCount,
                                    (index) => Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.1,
                                              color: Colors.transparent),
                                          color: getRowBackgroundColor(index),
                                        ),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              child: Text(
                                                "${playerName[index].toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                              ),
                                            ))))
                              ],
                            ),
                          ),
                          Container(
                              width: 240 * fem,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0, color: Colors.transparent)),
                              child: Column(
                                children: [
                                  Container(
                                    width: 240 * fem,
                                    height: getDataContainerHeight(),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0,
                                            color: Colors.transparent)),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${minutes[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${scores[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${rebound[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${assist[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${fieldGoal[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${threePointer[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${freeThrow[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${steal[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${turnover[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${blockShot[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                        Container(
                                          width: 80 * fem,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: Column(children: [
                                            ...List.generate(
                                                widget.isHome
                                                    ? (homeTeamCount + 1)
                                                    : (awayTeamCount + 1),
                                                (index) => Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent),
                                                          color:
                                                              getDataRowBackgroundColor(
                                                                  index)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "${foul[index].toString()}"),
                                                      ),
                                                    ))
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ))))
        ],
      ),
    );
    // return
  }
}
