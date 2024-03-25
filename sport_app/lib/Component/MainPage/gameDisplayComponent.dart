import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Model/userDataModel.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/collectionModel.dart';
import '../../Provider/collectionProvider.dart';
import '../Common/loginDialog.dart';

class GameDisplayComponent extends StatefulWidget {
  final int id;
  final String competitionType;
  final String duration;
  final String teamAName;
  final String teamALogo;
  final String teamAScore;
  final String teamBName;
  final String teamBLogo;
  final String teamBScore;
  final bool isSaved;
  // Function? saveGameCallBack;

  GameDisplayComponent({
    super.key,
    required this.id,
    required this.competitionType,
    required this.duration,
    required this.teamAName,
    required this.teamALogo,
    required this.teamAScore,
    required this.teamBName,
    required this.teamBLogo,
    required this.teamBScore,
    required this.isSaved,
    // this.saveGameCallBack
  });

  @override
  State<GameDisplayComponent> createState() => _GameDisplayComponentState();
}

class _GameDisplayComponentState extends State<GameDisplayComponent> {
  //services and provider
  BookmarkProvider bookmarkProvider = BookmarkProvider();
  UserDataModel userModel = Get.find<UserDataModel>();

  // required variables
  bool isSaved = false;

  // save bookmark
  Future<void> createBookmark(int matchId) async {
    CollectionModel? collectionModel =
        await bookmarkProvider.createCollection(matchId);
  }

  Future<void> delBookmark(int matchId) async {
    DelCollectionModel? delCollectionModel =
        await bookmarkProvider.deleteCollection(matchId);
  }

  void isSavedAssigning() {
    setState(() {
      isSaved = widget.isSaved;
    });
  }

  @override
  void initState() {
    super.initState();

    isSavedAssigning();
  }

  @override
  Widget build(BuildContext context) {
    // set standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    // fetch data from previous page
    int id = widget.id;
    String competitionType = widget.competitionType;
    String duration = widget.duration;
    String teamAName = widget.teamAName;
    String teamALogo = widget.teamALogo;
    String teamAScore = widget.teamAScore;
    String teamBName = widget.teamBName;
    String teamBLogo = widget.teamBLogo;
    String teamBScore = widget.teamBScore;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
      padding: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 10 * fem),
      height: 100 * fem,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kMainComponentColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: 340 * fem,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 220 * fem,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Container(
                        height: 20 * fem,
                        margin: EdgeInsets.symmetric(horizontal: 2 * fem),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.symmetric(horizontal: 8 * fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kLightGreyColor,
                        ),
                        child: Text(
                          competitionType,
                          style: tTagButton,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      // color: Colors.amber,
                      height: 20 * fem,
                      width: 50 * fem,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(horizontal: 5 * fem),
                      child: Text(
                        duration,
                        style: tDate,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Container(
                    width: 30 * fem,
                    // color: Colors.amber,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (userModel.isLogin.value) {
                              if (isSaved) {
                                delBookmark(id);
                                isSaved = !isSaved;
                              } else {
                                createBookmark(id);
                                isSaved = !isSaved;
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (context) {
                                    return LoginAlertDialog();
                                  });
                            }
                            print("isSaved: $isSaved");
                          });
                        },
                        child: Container(
                          width: 24 * fem,
                          height: 24 * fem,
                          alignment: Alignment.topRight,
                          child: isSaved
                              ? SvgPicture.asset('images/common/Bookmark-1.svg')
                              : SvgPicture.asset(
                                  'images/common/Bookmark-0.svg'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(right: 8 * fem),
                      alignment: Alignment.centerRight,
                      child: Text(
                        teamAName,
                        style: tGroupName,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image(image: NetworkImage(teamALogo)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1 * fem),
                      alignment: Alignment.center,
                      child: Text(
                        "$teamAScore - $teamBScore",
                        style: tScore,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image(image: NetworkImage(teamBLogo)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: 8 * fem),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        teamBName,
                        style: tGroupName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
