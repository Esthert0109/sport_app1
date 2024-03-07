import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Model/userDataModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 弹出提醒栏
void showNoticeDialog(BuildContext context, String message, String btnText,
    Function() onPressed) {
  UserDataModel userModel = Get.find<UserDataModel>();

  double baseWidth = 375;
  double fem = MediaQuery.of(context).size.width / baseWidth;
  Color Blue = Color(0xff0075FE);
  Color lightBlue = Color(0xffEBF3FF);
  Color White = Color(0xffFFFfff);
  showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.start,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 112 * fem,
                  height: 40 * fem,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 215, 236, 191))),
                      child: Text(
                        userModel.isCN.value ? "取消" : "Cancel",
                        style: TextStyle(
                          fontFamily: 'NotoSansSC',
                          fontSize: 12 * fem,
                          fontWeight: FontWeight.w600,
                          color: greenColor,
                        ),
                      )),
                ),
                Container(
                  width: 112 * fem,
                  height: 40 * fem,
                  child: TextButton(
                      onPressed: () {
                        onPressed();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(greenColor)),
                      child: Text(
                        btnText,
                        style: TextStyle(
                          fontFamily: 'NotoSansSC',
                          fontSize: 12 * fem,
                          fontWeight: FontWeight.w600,
                          color: White,
                        ),
                      )),
                ),
              ],
            ),
          ],
        );
      }));
}
