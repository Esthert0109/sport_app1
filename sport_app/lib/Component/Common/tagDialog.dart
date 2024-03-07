import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

class TagDialog extends StatefulWidget {
  const TagDialog({super.key});

  @override
  State<TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<TagDialog> {
  List<String> tagList = [
    '最新',
    "热门",
    "足球",
    "NBA",
    "CBA",
    "英超",
    "中超",
    "意甲",
    "德甲",
    "日韩",
    "焦点",
    "澳超"
  ];

  int tagLength = 0;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    tagLength = tagList.length;

    return StatefulBuilder(builder: (context, setState) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        child: Container(
            height: 380 * fem,
            color: kMainComponentColor,
            padding:
                EdgeInsets.symmetric(horizontal: 20 * fem, vertical: 10 * fem),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 4 * fem,
                  width: 97 * fem,
                  alignment: Alignment.topCenter,
                  child: Image(
                      image: AssetImage("images/common/bottomSheetBar.png")),
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(0 * fem, 20 * fem, 0 * fem, 10 * fem),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "热门标签",
                    style: tDialogTitle,
                  ),
                ),
                Wrap(
                    spacing: 5 * fem,
                    runSpacing: 10 * fem,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(tagLength, (index) {
                      return InkWell(
                        onTap: () {
                          print("get this ${tagList[index]}");
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8 * fem, horizontal: 25 * fem),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: kLightGreyColor),
                          child: Text(
                            tagList[index],
                            textAlign: TextAlign.center,
                            style: tTagText,
                          ),
                        ),
                      );
                    }))
              ],
            )),
      );
    });
  }
}
