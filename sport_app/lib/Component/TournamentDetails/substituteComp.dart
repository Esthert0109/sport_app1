import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Model/userDataModel.dart';

UserDataModel UserModel = Get.find<UserDataModel>();

class SubstituteComp extends StatelessWidget {
  final Color textColor;
  final int shirtNo;
  final String playerName;
  final Color circleColor;
  final dynamic position;
  final Color backcolor;

  SubstituteComp({
    required this.textColor,
    required this.shirtNo,
    required this.playerName,
    required this.circleColor,
    required this.position,
    required this.backcolor,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Container(
      color: backcolor,
      padding: EdgeInsets.fromLTRB(0 * fem, 3 * fem, 0 * fem, 3 * fem),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5),
                  color: circleColor,
                ),
                child: Center(
                    child: Text(
                  "$shirtNo",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "NotoSansSC",
                    color: textColor,
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$playerName",
                    style: TextStyle(
                      fontSize: 15 * fem,
                      fontFamily: "NotoSansSC",
                      color: Color.fromRGBO(51, 51, 51, 1),
                    ),
                    maxLines: 2, // 设置最大行数
                    overflow: TextOverflow.ellipsis, // 使用省略号来处理溢出
                  ),
                  Text(
                    "$position",
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "NotoSansSC",
                      color: Color.fromRGBO(102, 102, 102, 1),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
