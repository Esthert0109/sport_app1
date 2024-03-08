import 'package:flutter/material.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

class TopHotNewsComponent extends StatefulWidget {
  final String hotLogo;
  final String title;
  final int read;

  TopHotNewsComponent(
      {super.key,
      required this.hotLogo,
      required this.title,
      required this.read});

  @override
  State<TopHotNewsComponent> createState() => _TopHotNewsComponentState();
}

class _TopHotNewsComponentState extends State<TopHotNewsComponent> {
  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    String hotLogo = widget.hotLogo;
    String title = widget.title;
    int read = widget.read;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50 * fem,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Image(image: AssetImage(hotLogo)),
                  )),
              Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 10 * fem,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: tHotNewsTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                10 * fem, 5 * fem, 0 * fem, 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 12 * fem,
                                  child: Image(
                                      image:
                                          AssetImage('images/info/fire.png')),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8 * fem),
                                  child: Text(
                                    read.toString(),
                                    style: tTimeRead,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  height: 12 * fem,
                                  alignment: Alignment.bottomCenter,
                                  child: Image(
                                      image:
                                          AssetImage('images/info/boom.png')),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ))
            ],
          ),
        ),
        Divider(
          color: kDividerColor,
          thickness: 1,
        ),
      ],
    );
  }
}
