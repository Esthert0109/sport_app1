// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Component/Common/headingText.dart';
import '../../Component/Common/previousButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/userDataModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'mindark@gmail.com',
  query: encodeQueryParameters(<String, String>{
    'subject': 'Contact Us Here!',
  }),
);

class _ContactUsState extends State<ContactUs> {
  UserDataModel userModel = Get.find<UserDataModel>();

  @override
  Widget build(BuildContext context) {
    UserDataModel UserModel = Get.find<UserDataModel>();
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
        backgroundColor: kMainBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16 * fem, 24 * fem, 16 * fem, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrevBtn(),
                  SizedBox(
                    height: 41 * fem,
                  ),
                  HeadingText(text: AppLocalizations.of(context)!.contactUs),
                  SizedBox(
                    height: 30 * fem,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            print("navi to instagram");
                            var instaUrl =
                                'https://www.instagram.com/sinchewdaily?igsh=dzNsazlrcGF3MWtz';
                            launchUrl(Uri.parse(instaUrl));
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image:
                                        AssetImage("images/myPage/insta.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'Instagram',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("navi to facebook");
                            var fbUrl =
                                'https://www.facebook.com/RandomFunnyPages/';
                            launchUrl(Uri.parse(fbUrl));
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image: AssetImage("images/myPage/fb.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'Facebook',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("navi to whatsApp");
                            var phone = "601159122104";
                            var whatsappUrl =
                                "https://wa.me/${phone}?text=Hello";
                            launchUrl(Uri.parse(whatsappUrl));
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image: AssetImage(
                                        "images/myPage/whatsapp.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'WhatsApp',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("navi to telegram");
                            var telegramUrl = "https://web.telegram.org/a/";
                            launchUrl(Uri.parse(telegramUrl));
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image: AssetImage(
                                        "images/myPage/telegram.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'Telegram',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("navi to twitter");
                            var twitterUrl = "https://twitter.com/";
                            launchUrl(Uri.parse(twitterUrl));
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image:
                                        AssetImage("images/myPage/twitter.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'Twitter',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("navi to line");
                            var lineUrl = "https://line.me/tw/";
                            launchUrl(Uri.parse(lineUrl));
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image: AssetImage("images/myPage/line.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'Line',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("navi to email");
                            launchUrl(emailLaunchUri);
                          },
                          child: Container(
                            height: 65 * fem,
                            width: 65 * fem,
                            padding: EdgeInsets.symmetric(
                                vertical: 5 * fem, horizontal: 10 * fem),
                            margin: EdgeInsets.symmetric(vertical: 0 * fem),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Image(
                                    image:
                                        AssetImage("images/myPage/email.png"),
                                    width: 56 * fem,
                                    height: 56 * fem,
                                  ),
                                ),
                                Expanded(
                                    flex: 70,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20 * fem),
                                        child: Text(
                                          'Email',
                                          style: tSocialMediaTitle,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(10 * fem),
                                      child: Image(
                                        image: AssetImage(
                                            'images/common/right-arrow-black.png'),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                  
                ]),
          ),
        ));
  }
}
