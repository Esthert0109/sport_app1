import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Model/followingModel.dart';
import 'package:sport_app/Model/userDataModel.dart';
import 'package:sport_app/Provider/anchorFollowProvider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Pages/TencentLiveStreamRoom/liveStreamChatRoom.dart';
import '../Tencent/liveStreamPlayer.dart';

class FollowingBlockComponent extends StatefulWidget {
  final bool isStreaming;
  final String? streamTitle;
  final String anchorName;
  final String anchorPic;
  final int anchorId;
  Function? onTapCallback;

  FollowingBlockComponent(
      {super.key,
      required this.isStreaming,
      this.streamTitle,
      required this.anchorName,
      required this.anchorPic,
      required this.anchorId,
      required this.onTapCallback});

  @override
  State<FollowingBlockComponent> createState() =>
      _FollowingBlockComponentState();
}

// Global variable
ValueNotifier<bool> followNotifier = ValueNotifier<bool>(false);

class _FollowingBlockComponentState extends State<FollowingBlockComponent> {
  // provider
  AnchorFollowProvider provider = AnchorFollowProvider();
  UserDataModel userModel = Get.find<UserDataModel>();

  Future<void> createUnfollow() async {
    CreateFollowModel? model =
        await provider.createFollow(widget.anchorId.toString());
    bool result = model?.data ?? false;
    if (result) {
      followNotifier.value = true;
      print("unfollow successfully");
    } else {
      print("unfollow unsuccessfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    bool isStreaming = widget.isStreaming;
    String? title = widget.streamTitle ?? "";
    String anchorName = widget.anchorName;
    String anchorPic = widget.anchorPic;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5 * fem),
      padding: EdgeInsets.symmetric(horizontal: 5 * fem, vertical: 10 * fem),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kMainComponentColor),
      height: 65 * fem,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 15,
            child: Center(
                child: CircleAvatar(
              backgroundColor: kLightGreyColor,
              radius: 40 * fem,
              backgroundImage: NetworkImage(anchorPic),
            )),
          ),
          Expanded(
            flex: isStreaming ? 43 : 63,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5 * fem, 0 * fem, 10 * fem, 0 * fem),
              child: isStreaming
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextScroll(
                          title,
                          mode: TextScrollMode.endless,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(20, 0)),
                          style: tLiveTitleComponent,
                          delayBefore: const Duration(milliseconds: 500),
                          pauseBetween: const Duration(milliseconds: 5000),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          anchorName,
                          style: tLiveAnchorNameComponent,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        anchorName,
                        style: tLiveTitleComponent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
            ),
          ),
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () async {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: white,
                          surfaceTintColor: white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          content: Text(
                            userModel.isCN.value ? "确认取关？" : "Unfollow Now? ",
                            style: tMain,
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10 * fem),
                                  width: 120 * fem,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kMainBackgroundColor)),
                                    child: Text(
                                      userModel.isCN.value ? "取消" : "Cancel",
                                      style: TextStyle(
                                        fontFamily: 'NotoSansSC',
                                        fontSize: 12 * fem,
                                        fontWeight: FontWeight.w600,
                                        color: kMainBottomNaviBtnColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10 * fem),
                                  width: 120 * fem,
                                  child: TextButton(
                                    onPressed: () async {
                                      await createUnfollow();

                                      if (widget.onTapCallback != null) {
                                        widget.onTapCallback!();
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kMainGreenColor)),
                                    child: Text(
                                      userModel.isCN.value ? "确认" : "Yes",
                                      style: TextStyle(
                                        fontFamily: 'NotoSansSC',
                                        fontSize: 12 * fem,
                                        fontWeight: FontWeight.w600,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      });
                });
              },
              child: Center(
                child: Container(
                  height: 22 * fem,
                  width: 60 * fem,
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * fem, vertical: 3 * fem),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: kFollowButtonColor),
                  child: Text(
                    AppLocalizations.of(context)!.unfollow,
                    textAlign: TextAlign.center,
                    style: tUnfollowText,
                  ),
                ),
              ),
            ),
          ),
          isStreaming
              ? Expanded(
                  flex: 22,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5 * fem),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                            () => LiveStreamChatRoom(
                                userLoginId: userModel.id.value,
                                avChatRoomId: "panda${widget.anchorId}",
                                anchor: widget.anchorName,
                                streamTitle: "",
                                anchorPic: widget.anchorPic ??
                                    "https://www.sinchew.com.my/wp-content/uploads/2022/05/e5bc80e79bb4e692ade68082e681bfe7b289e4b89dtage588b6e78987e696b9e5819ae68ea8e88d90-e69da8e8b685e8b68ae4b88de8aea4e8b4a6e981ade5bc80-scaled.jpg",
                                playMode: V2TXLivePlayMode.v2TXLivePlayModeLeb,
                                liveURL:
                                    "getStreamURL(footballLiveStreamList![j].pushCode)",
                                anchorId: '${widget.anchorId}'),
                            transition: Transition.fadeIn);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image:
                                const AssetImage("images/livepage/stream.png"),
                            height: 24 * fem,
                            width: 24 * fem,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1 * fem),
                            child: Container(
                              width: 70 * fem,
                              child: Text(
                                "${AppLocalizations.of(context)!.streaming}🔥",
                                style: tUnfollowText,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
