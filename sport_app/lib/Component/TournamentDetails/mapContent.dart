import 'package:flutter/material.dart';

class MapContents extends StatelessWidget {
  final int numberOfItems;
  final Color textColor;
  final List<String> text;
  final Color circleColor;
  final List<String> labels;
  final List<int> icon; // 新增的参数，用于控制是否显示图标

  MapContents({
    required this.numberOfItems,
    required this.textColor,
    required this.text,
    required this.circleColor,
    required this.labels,
    required this.icon, // 默认值为0，表示不显示图标
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 调整需要的填充
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(numberOfItems, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      child: Stack(
                        children: [
                          // 圆形
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: circleColor,
                            ),
                            child: Center(
                              child: Text(
                                text[index],
                                style:
                                    TextStyle(fontSize: 15, color: textColor),
                              ),
                            ),
                          ),
                          // 图标
                          if (icon[index] == 1) // 根据icon参数的值决定是否显示图标
                            Positioned(
                              left: -1,
                              bottom: -1,
                              child: Image.asset('images/C file.png',
                                  width: 10, height: 10),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  labels[index],
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
