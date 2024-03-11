import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

class FollowingBlockComponent extends StatefulWidget {
  final bool isStreaming;
  final String? streamTitle;
  final String anchorName;
  final String anchorPic;

  const FollowingBlockComponent(
      {required this.isStreaming,
      this.streamTitle,
      required this.anchorName,
      required this.anchorPic});

  @override
  State<FollowingBlockComponent> createState() =>
      _FollowingBlockComponentState();
}

class _FollowingBlockComponentState extends State<FollowingBlockComponent> {
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
            flex: isStreaming ? 45 : 65,
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
                          velocity: Velocity(pixelsPerSecond: Offset(20, 0)),
                          style: tLiveTitleComponent,
                          delayBefore: Duration(milliseconds: 500),
                          pauseBetween: Duration(milliseconds: 5000),
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
              onTap: () {
                print("unfollow");
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
                    "取消关注",
                    textAlign: TextAlign.center,
                    style: tUnfollowText,
                  ),
                ),
              ),
            ),
          ),
          isStreaming
              ? Expanded(
                  flex: 20,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5 * fem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/livepage/stream.png"),
                          height: 24 * fem,
                          width: 24 * fem,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1 * fem),
                          child: Text(
                            "正在直播🔥",
                            style: tUnfollowText,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
