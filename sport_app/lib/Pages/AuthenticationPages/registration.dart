import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:libphonenumber_plugin/libphonenumber_plugin.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Component/Common/customTextFormField.dart';
import '../../Component/Common/errorText.dart';
import '../../Component/Common/headingText.dart';
import '../../Component/Common/loadingButton.dart';
import '../../Component/Common/loadingScreen.dart';
import '../../Component/Common/pressableWord.dart';
import '../../Component/Common/previousButton.dart';
import '../../Component/Common/snackBar.dart';
import '../../Component/Common/widthButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/userProvider.dart';
import 'otpVerification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  UserDataModel userModel = Get.find<UserDataModel>();
  //variables
  final formKey = GlobalKey<FormState>();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'MY');
  String phone = '';
  String dialCode = '';
  String countryCode = '';
  String _responseMsg = '';
  String _errorMsg = '';
  bool _isHidden1 = true;
  bool _isHidden2 = true;
  bool isLoading = false;

  final RegExp _passwordPattern = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%^&*+=`~?><,.])[A-Za-z\d@#$!%^&`+=*?><.,]{8,}$');
  final _nameFocusNode = FocusNode();

  UserProvider provider = UserProvider();

  //controller
  TextEditingController userNicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();

  bool arePasswordsEqual() {
    String password = passwordController.text;
    String confirmedPassword = confirmedPasswordController.text;

    return password == confirmedPassword;
  }

  @override
  void dispose() {
    phoneController.dispose();
    userNicknameController.dispose();
    passwordController.dispose();
    confirmedPasswordController.dispose();
    super.dispose();
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
              padding:
                  EdgeInsets.fromLTRB(16 * fem, 24 * fem, 16 * fem, 8 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PrevBtn(),
                  SizedBox(
                    height: 42 * fem,
                  ),
                  HeadingText(text: AppLocalizations.of(context)!.welcome),
                  SizedBox(
                    height: 30 * fem,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                          controller: userNicknameController,
                          hintText: AppLocalizations.of(context)!.keyInUsername,
                          errorText:
                              AppLocalizations.of(context)!.usernameNotBlank,
                          textInputAction: TextInputAction.next,
                          focusNode: _nameFocusNode,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(0, 12 * fem, 0, 12 * fem),
                          child: Container(
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
                                    selectorType:
                                        PhoneInputSelectorType.DIALOG),
                                onInputChanged: (PhoneNumber number) {
                                  phone = number.phoneNumber.toString();
                                  dialCode = number.dialCode.toString();
                                  countryCode = number.isoCode.toString();
                                },
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                inputDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  hintText: AppLocalizations.of(context)!
                                      .keyInPhoneNo,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmptyOrNull) {
                              return AppLocalizations.of(context)!.pwNotBlank;
                            } else if (!_passwordPattern.hasMatch(value!)) {
                              return AppLocalizations.of(context)!.pwEditRule2;
                            }
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  18 * fem, 18 * fem, 18 * fem, 18 * fem),
                              hintText:
                                  AppLocalizations.of(context)!.keyInPassword,
                              hintStyle: TextStyle(
                                  fontSize: 16 * fem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25 * fem,
                                  color: kComponentHintTextColor),
                              filled: true,
                              fillColor: kMainComponentColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(12 * fem),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isHidden1 = !_isHidden1;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 15 * fem,
                                      height: 15 * fem,
                                      child: SvgPicture.asset(
                                        _isHidden1
                                            ? 'images/common/fluent_eye-20-filled(1).svg'
                                            : 'images/common/fluent_eye-20-filled.svg',
                                        width: 15 * fem,
                                        height: 15 * fem,
                                        color: kMainGreyColor,
                                      ),
                                    )),
                              )),
                          style: TextStyle(color: kMainTitleColor),
                          obscureText: _isHidden1,
                        ),
                        SizedBox(
                          height: 12 * fem,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .confirmPwNotBlank;
                            }
                            return null;
                          },
                          controller: confirmedPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  18 * fem, 18 * fem, 18 * fem, 18 * fem),
                              hintText:
                                  AppLocalizations.of(context)!.keyInAgain,
                              hintStyle: TextStyle(
                                fontSize: 16 * fem,
                                fontWeight: FontWeight.w400,
                                height: 1.25 * fem,
                                color: kComponentHintTextColor,
                              ),
                              filled: true,
                              fillColor: kMainComponentColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(12.0 * fem),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isHidden2 = !_isHidden2;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        _isHidden2
                                            ? 'images/common/fluent_eye-20-filled(1).svg'
                                            : 'images/common/fluent_eye-20-filled.svg',
                                        width: 15 * fem,
                                        height: 15 * fem,
                                        color: kMainGreyColor,
                                      ),
                                    )),
                              )),
                          style: TextStyle(color: kMainTitleColor),
                          obscureText: _isHidden2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10 * fem),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ErrorText(Msg: _responseMsg),
                  ),
                  SizedBox(height: 10 * fem),
                  isLoading
                      ? LoadingLongButton()
                      : WidthButton(
                          text: AppLocalizations.of(context)!.reg,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              bool passwordsMatch = arePasswordsEqual();
                              if (passwordsMatch) {
                                String successOTP =
                                    await provider.getOTP(phone, "1");

                                if (successOTP == '500215') {
                                  Navigator.of(context).pop();
                                  openSnackbar(
                                      context,
                                      AppLocalizations.of(context)!
                                          .phoneNoExist,
                                      kComponentErrorTextColor);
                                } else if (successOTP == '500313') {
                                  Navigator.of(context).pop();
                                  openSnackbar(
                                      context,
                                      AppLocalizations.of(context)!.otpHitLimit,
                                      kComponentErrorTextColor);
                                } else {
                                  Navigator.of(context).pop();
                                  OTPVerification(
                                    phone: phone,
                                    isChangePassword: false,
                                    isLogin: false,
                                    dialCode: dialCode,
                                    password: passwordController.text,
                                    userNickname: userNicknameController.text,
                                  ).launch(context);
                                }
                              } else {
                                setState(() {
                                  _responseMsg = AppLocalizations.of(context)!
                                      .passwordNotSame;

                                  openSnackbar(context, _responseMsg,
                                      kComponentErrorTextColor);
                                });
                                print("password not same");
                              }
                            } else {
                              bool passwordsMatch = arePasswordsEqual();
                              if (!passwordsMatch) {
                                setState(() {
                                  _responseMsg = AppLocalizations.of(context)!
                                      .passwordNotSame;
                                });
                                print("password not same");
                              }
                              print("fail");
                            }
                          }),
                  SizedBox(
                    height: 85 * fem,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.accExist,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 14 * fem,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.14 * fem,
                          color: kMainTitleColor,
                        ),
                      ),
                      PressableWord(
                          text: AppLocalizations.of(context)!.loginNow,
                          onPressed: () {
                            Get.offNamed('/login');
                          })
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Future<bool?> validatePhoneNumber(
      String phoneNumber, String countryCode) async {
    try {
      final isValid =
          await PhoneNumberUtil.isValidPhoneNumber(phoneNumber, countryCode);
      return isValid;
    } catch (e) {
      return false;
    }
  }
}
