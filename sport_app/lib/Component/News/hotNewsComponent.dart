import 'package:flutter/material.dart';

import '../../Constants/textConstant.dart';

class HotNewsComponent extends StatefulWidget {
  final int index;
  final String title;
  final int read;

  HotNewsComponent(
      {required this.index, required this.title, required this.read});

  @override
  State<HotNewsComponent> createState() => _HotNewsComponentState();
}

class _HotNewsComponentState extends State<HotNewsComponent> {
  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    String title = widget.title;
    int index = widget.index;
    int read = widget.read;

    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 5 * fem),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2 * fem),
                child: Text(
                  index.toString(),
                  style: tHotIndex,
                  textAlign: TextAlign.left,
                ),
              )),
          Expanded(
              flex: 65,
              child: Container(
                width: 225 * fem,
                child: Text(
                  title,
                  style: tHotNewsTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          Expanded(
            flex: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 12 * fem,
                  child: Image(image: AssetImage('images/info/fire.png')),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8 * fem),
                  child: Text(
                    read.toString(),
                    style: tTimeRead,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  height: 12 * fem,
                  alignment: Alignment.bottomCenter,
                  child: Image(image: AssetImage('images/info/boom.png')),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
