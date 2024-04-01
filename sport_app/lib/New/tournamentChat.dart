import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../Constants/colorConstant.dart';
import '../Constants/textConstant.dart';

class TournamentChatComponent extends StatefulWidget {
  TournamentChatComponent({super.key});

  @override
  State<TournamentChatComponent> createState() =>
      _TournamentChatComponentState();
}

class _TournamentChatComponentState extends State<TournamentChatComponent>
    with TickerProviderStateMixin {
  //chat
  late final Animation<double> _fadeAnimation;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    //chat
    _fadeController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                  height: 30,
                  color: kTournamentChatBannerColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Image(
                          image: AssetImage('images/tournament/bannerIcon.png'),
                          height: 14,
                          width: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          '禁止任何联系方式、群、广告、违规者封号处理',
                          style: tBannerText,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )),
            ),
            Container(
              height: 350,
              alignment: Alignment.bottomLeft,
              // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              // color: yellow,
              child: ListView.builder(
                itemCount: 20,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      child: Expanded(
                        child: RichText(
                          text: TextSpan(
                              text: '用户A: ',
                              style: tChatUserNameText,
                              children: [
                                TextSpan(
                                  text:
                                      "${index} 案文案文案案文案文案案文案文案案文案文案案文案文案文案文案",
                                  style: tChatContentText,
                                )
                              ]),
                        ),
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
