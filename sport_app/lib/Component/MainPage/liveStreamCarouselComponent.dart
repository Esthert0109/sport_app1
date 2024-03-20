import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_app/Constants/textConstant.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../Constants/colorConstant.dart';

class LiveStreamCarousel extends StatefulWidget {
  final String title;
  final String anchor;
  final String anchorPhoto;
  final String liveStreamPhoto;

  const LiveStreamCarousel(
      {required this.title,
      required this.anchor,
      required this.anchorPhoto,
      required this.liveStreamPhoto});

  @override
  State<LiveStreamCarousel> createState() => _LiveStreamCarouselState();
}

class _LiveStreamCarouselState extends State<LiveStreamCarousel> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Container(
      width: 328 * fem,
      height: 183 * fem,
      margin: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 10 * fem, 5 * fem),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8 * fem),
            child: Container(
              width: 328 * fem,
              height: 183 * fem,
              child: Image.network(
                "${widget.liveStreamPhoto}",
                fit: BoxFit.cover,
                width: 328 * fem,
                height: 183 * fem,
              ),
            ),
          ),
          Align(
            alignment: const FractionalOffset(0.0, 1.0),
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(15 * fem, 134 * fem, 50 * fem, 19 * fem),
              child: Container(
                height: 180 * fem,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      //主播头像
                      backgroundColor: kMainComponentColor,
                      backgroundImage: NetworkImage(widget.anchorPhoto),
                    ),
                    SizedBox(
                      width: 8 * fem,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20 * fem,
                          width: 200 * fem,
                          child: Padding(
                            padding: EdgeInsets.all(0 * fem),
                            child: TextScroll(
                              widget.title,
                              mode: TextScrollMode.endless,
                              velocity:
                                  Velocity(pixelsPerSecond: Offset(20, 0)),
                              delayBefore: Duration(milliseconds: 500),
                              pauseBetween: Duration(milliseconds: 5000),
                              style: tLiveTitle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          height: 10 * fem,
                          width: 150 * fem,
                          child: Padding(
                            padding: EdgeInsets.all(0 * fem),
                            child: Text(widget.anchor, style: tLiveAnchorName),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
