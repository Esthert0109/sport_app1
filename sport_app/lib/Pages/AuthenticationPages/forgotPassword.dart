import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../Component/Common/errorText.dart';
import '../../Component/Common/headingText.dart';
import '../../Component/Common/loadingButton.dart';
import '../../Component/Common/pressableWord.dart';
import '../../Component/Common/previousButton.dart';
import '../../Component/Common/snackBar.dart';
import '../../Component/Common/widthButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/userProvider.dart';
import 'editPassword.dart';
import 'otpVerification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  // provider
  UserProvider provider = UserProvider();

  // controller and form key
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  //common variables
  bool _isLoading = false;
  bool _isFilled = true;
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'MY');
  String phone = '';
  String dialCode = '';
  String countryCode = '';
  String _responseMsg = '';

  // 验证表格不是空白
  void validateForm() {
    String number = phoneController.text;
    if (number.isEmpty || number == "") {
      setState(() {
        _isFilled = false;
      });
    } else {
      setState(() {
        _isFilled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(16 * fem, 24 * fem, 16 * fem, 8 * fem),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Back button
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 300 * fem, 28 * fem),
                    child: PrevBtn(),
                  ),
                  //Header Text
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 80 * fem, 0 * fem),
                    child: HeadingText(
                        text: AppLocalizations.of(context)!.forgotPassword),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  //SubText
                  Text(
                    AppLocalizations.of(context)!.keyInPhoneNoConnected,
                    style: TextStyle(
                      fontFamily: 'NotoSansSC',
                      color: kMainGreyColor,
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(
                    height: 30 * fem,
                  ),

                  Container(
                    width: 375 * fem,
                    child: Container(
                      width: 343 * fem,
                      padding: EdgeInsets.fromLTRB(
                          20 * fem, 0 * fem, 0 * fem, 0 * fem),
                      child: InternationalPhoneNumberInput(
                        initialValue: phoneNumber,
                        textFieldController: phoneController,
                        formatInput: true,
                        selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG),
                        onInputChanged: (PhoneNumber number) {
                          phone = number.phoneNumber.toString();
                          dialCode = number.dialCode.toString();
                          countryCode = number.isoCode.toString();
                        },
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Colors.black,
                        inputDecoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                          hintText: AppLocalizations.of(context)!.keyInPhoneNo,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 18 * fem,
                  ),

                  //Error Message
                  Align(
                      alignment: Alignment.centerLeft,
                      child: ErrorText(Msg: _responseMsg)),
                  SizedBox(
                    height: 40 * fem,
                  ),
                  //Send Code Button
                  _isLoading
                      ? LoadingLongButton()
                      : WidthButton(
                          text: AppLocalizations.of(context)!.sendOTP,
                          onPressed: () async {
                            setState(() {
                              _responseMsg = "";
                            });
                            validateForm();
                            if (_isFilled) {
                              // HERE PUT send OTP Function
                              String successOTP = "0";
                              await provider.getOTP(phone, '3');

                              if (successOTP == '500313') {
                                openSnackbar(
                                    context,
                                    AppLocalizations.of(context)!.otpHitLimit,
                                    kComponentErrorTextColor);
                              } else if (successOTP == '500214') {
                                openSnackbar(
                                    context,
                                    AppLocalizations.of(context)!.accNotExist,
                                    kComponentErrorTextColor);
                              } else {
                                Get.to(() => OTPVerification(
                                      phone: phone,
                                      isChangePassword: true,
                                      isLogin: false,
                                      dialCode: dialCode,
                                      password: '',
                                      userNickname: '',
                                    ));
                                // Get.to(() => EditPassword(
                                //       isLogin: false,
                                //       phoneNumber: "60127659785",
                                //     ));
                              }
                            } else {
                              setState(() {
                                _responseMsg =
                                    AppLocalizations.of(context)!.notBlank;
                              });
                            }
                          }),

                  SizedBox(
                    height: 220 * fem,
                  ),
                  //Bottom Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.rememberPw,
                          style: GoogleFonts.notoSansSc(
                            fontSize: 14 * fem,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.14 * fem,
                            color: kMainTitleColor,
                          )),
                      PressableWord(
                          text: AppLocalizations.of(context)!.login,
                          onPressed: () {
                            Get.back();
                          })
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
