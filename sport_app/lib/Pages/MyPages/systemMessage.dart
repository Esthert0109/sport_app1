import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../Constants/colorConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SystemMessagePage extends StatefulWidget {
  const SystemMessagePage({super.key});

  @override
  State<SystemMessagePage> createState() => _SystemMessagePageState();
}

class _SystemMessagePageState extends State<SystemMessagePage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
        backgroundColor: kMainBackgroundColor,
        body: SafeArea(
          child: Column(children: [
            Container(
              height: 56 * fem,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ],
                color: kMainGreenColor,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(17 * fem, 16 * fem, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(
                          'images/common/arrow-white.svg',
                          width: 24 * fem,
                          height: 24 * fem,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "系统消息",
                      style: TextStyle(
                        fontFamily: 'NotoSansSC',
                        fontSize: 18 * fem,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3 * fem,
                        color: kMainComponentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10 * fem),
                  child: LazyLoadScrollView(
                    onEndOfPage: () {
                      print("huh");
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            30,
                            (index) => BubbleSpecialOne(
                              color: kSecondaryBtnColor,
                              text:
                                  " ${index}: 【系统消息】：尊敬的用户，我们将在今晚（2024年3月11日）进行系统维护，维护时间预计为北京时间晚上10点至次日凌晨2点。在此期间，我们的服务可能会受到影响，可能会出现一些短暂的中断或延迟。我们感谢您的理解和支持，给您带来的不便，我们深表歉意。感谢您的耐心等待，祝您使用愉快！",
                              isSender: false,
                              tail: true,
                            ),
                          )),
                    ),
                  )),
            )
          ]),
        ));
  }
}
