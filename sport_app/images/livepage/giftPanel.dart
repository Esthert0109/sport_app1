// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/gift.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

final defaultGifts = [
  GiftItem("images/pandalook.gif", "疑问", 3, "images/pandalook.json",
      "1e8913f8c6d804972887fc179fa1fbd7.png"),
  GiftItem("images/pandahappy.gif", "开心", 2, "images/pandahappy.json",
      "5e175b792cd652016aa87327b278402b.png"),
  GiftItem("images/pandasad.gif", "伤心", 3, "images/pandasad.json",
      "5e175b792cd652016aa87327b278402b.png"),
  GiftItem("images/panda404.gif", "404", 1, "images/panda404.json",
      "8f25a2cdeae92538b1e0e8a04f86841a.png"),
];

class GiftPanel extends StatelessWidget {
  final Function(GiftItem item) onTap;

  const GiftPanel({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TIM_t("送礼物"),
            style: const TextStyle(
                color: Colors.white, fontSize: 21, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 20,
            children: defaultGifts
                .map((e) => GestureDetector(
                      onTap: () {
                        onTap(e);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                      e.icon,
                                      // package: "tencent_av_chat_room_kit",
                                    )),
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            TIM_t(e.name),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6)),
                          )
                        ],
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
