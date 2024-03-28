import 'package:flutter/material.dart';

import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';

class ConcedeTableComponent extends StatefulWidget {
  ConcedeTableComponent({super.key});

  @override
  State<ConcedeTableComponent> createState() => _ConcedeTableComponentState();
}

class _ConcedeTableComponentState extends State<ConcedeTableComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kMainComponentColor,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "公司",
                      style: tTableTitleText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "初始",
                      style: tTableTitleText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        print("change");
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "即时",
                            style: tTableTitleText,
                            children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Image.asset(
                                    'images/tournament/arrowDrop.png',
                                    height: 3.5,
                                    width: 7,
                                  ))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Column(
                  children: List.generate(
                      50,
                      (index) => Container(
                            color: index % 2 == 0
                                ? kTableRowColor
                                : Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "名字名字名字名字名字名字",
                                      style: tTableTitleText,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: List.generate(
                                        3,
                                        (index) => Expanded(
                                            child: Text(
                                          "8",
                                          style: tTableContentText,
                                          textAlign: TextAlign.center,
                                        )),
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: List.generate(
                                        3,
                                        (index) => Expanded(
                                            child: Text(
                                          "8",
                                          style: tTableContentGreenText,
                                          textAlign: TextAlign.center,
                                        )),
                                      )),
                                ),
                              ],
                            ),
                          ))),
            )
          ]),
    );
  }
}
