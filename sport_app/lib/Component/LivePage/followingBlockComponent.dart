import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Model/followingModel.dart';
import 'package:sport_app/Provider/anchorFollowProvider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image(
                image: NetworkImage(anchorPic),
                fit: BoxFit.cover,
                height: 40 * fem,
                width: 40 * fem,
              ),
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
                print("unfollow");

                setState(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          content: Text(
                            "确认取关？",
                            style: tMain,
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  // margin:
                                  //     EdgeInsets.symmetric(horizontal: 5 * fem),
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
                                                Color.fromARGB(
                                                    255, 215, 236, 191))),
                                    child: Text(
                                      "取消",
                                      style: TextStyle(
                                        fontFamily: 'NotoSansSC',
                                        fontSize: 12 * fem,
                                        fontWeight: FontWeight.w600,
                                        color: greenColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // margin:
                                  //     EdgeInsets.symmetric(horizontal: 5 * fem),
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
                                      "确认",
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage("images/livepage/stream.png"),
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
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
