import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Component/Common/errorText.dart';
import '../../Component/Common/loginDialog.dart';
import '../../Component/Common/pressableWord.dart';
import '../../Component/Common/tagDialog.dart';
import '../../Component/Common/widthButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/userDataModel.dart';
import '../../bottomNavigationBar.dart';
import '../AuthenticationPages/forgotPassword.dart';
import '../AuthenticationPages/login.dart';
import '../AuthenticationPages/registration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // controller and form key
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'MY');
  String dialCode = '';
  String phone = '';
  String countryCode = '';
  String _responseMsg = "";

  //common variables
  bool _isHidden = true;

  void checkContactNumber() {
    setState(() {
      _responseMsg = '';
    });
    if (phoneController.text.toString() == '') {
      setState(() {
        _responseMsg = AppLocalizations.of(context)!.notBlank;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    UserDataModel userModel = Get.find<UserDataModel>();

    return Scaffold(
      backgroundColor: kMainComponentColor,
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 50 * fem,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(15.0 * fem),
                height: MediaQuery.of(context).size.width * 1.3,
                width: 800 * fem,
                child: Transform.scale(
                    scale: 1.1,
                    child: SvgPicture.asset('images/opening/opening_pic.svg')),
              ),
            ),
            SizedBox(
              height: 18 * fem,
            ),
            WidthButton(
              text: AppLocalizations.of(context)!.login,
              onPressed: () {
                Get.to(() => const Login(), transition: Transition.fadeIn);
              },
            ),
            SizedBox(
              height: 15 * fem,
            ),
            WidthButton(
                text: AppLocalizations.of(context)!.reg,
                btnColor: kSecondaryBtnColor,
                fontColor: kMainGreenColor,
                onPressed: () {
                  Get.to(() => const Register(), transition: Transition.fadeIn);
                }),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: 0 * fem, horizontal: 10 * fem),
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    onSurface: kMainGreenColor,
                    foregroundColor: kMainGreenColor,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return TagDialog();
                        });
                    // Get.off(() => const BottomNaviBar());
                  },
                  child: Text(
                    "Continue as Guest",
                    style: tContinueAsGuest,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
