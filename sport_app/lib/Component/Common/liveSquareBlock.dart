import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

class LiveSquareBlock extends StatefulWidget {
  final String title;
  final String anchor;
  final String anchorPhoto;
  final String livePhoto;
  const LiveSquareBlock({
    required this.title,
    required this.anchor,
    required this.anchorPhoto,
    required this.livePhoto,
  });

  @override
  State<LiveSquareBlock> createState() => _LiveSquareBlockState();
}

class _LiveSquareBlockState extends State<LiveSquareBlock> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Container(
      width: 165 * fem,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8 * fem)),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8 * fem),
                  topRight: Radius.circular(8 * fem)),
              child: Container(
                height: 92 * fem,
                width: 165 * fem,
                color: kLightGreyColor,
                child: Image.network(
                  "${widget.livePhoto}",
                  height: 92 * fem,
                  width: 165 * fem,
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(8 * fem)),
                color: kMainComponentColor),
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(10 * fem, 9 * fem, 10 * fem, 7 * fem),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      //主播头像
                      backgroundColor: kLightGreyColor,
                      radius: 18 * fem,
                      backgroundImage: widget.anchorPhoto == ''
                          ? null
                          : NetworkImage("${widget.anchorPhoto}"),
                    ),
                  ),
                  SizedBox(
                    width: 8 * fem,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20 * fem,
                          width: 100 * fem,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 0 * fem),
                            child: TextScroll(
                              widget.title,
                              mode: TextScrollMode.endless,
                              velocity:
                                  Velocity(pixelsPerSecond: Offset(20, 0)),
                              delayBefore: Duration(milliseconds: 500),
                              pauseBetween: Duration(milliseconds: 5000),
                              style: tLiveTitleComponent,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          height: 15 * fem,
                          width: 100 * fem,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 0 * fem),
                            child: Text(
                              widget.anchor,
                              style: tLiveAnchorNameComponent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 14 * fem,
          )
        ],
      ),
    );
  }
}
