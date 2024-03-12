// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport_app/Pages/OnboardingPages/onboarding.dart';

import '../../Component/Common/errorText.dart';
import '../../Component/Common/headingText.dart';
import '../../Component/Common/loadingButton.dart';
import '../../Component/Common/loadingScreen.dart';
import '../../Component/Common/snackBar.dart';
import '../../Component/Common/widthButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/userProvider.dart';
import '../../bottomNavigationBar.dart';
import 'login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPassword extends StatefulWidget {
  final bool isLogin;
  final String phoneNumber;
  const EditPassword({
    required this.isLogin,
    required this.phoneNumber,
  });

  @override
  State<StatefulWidget> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  TextEditingController textEditingController = TextEditingController();
  UserProvider provider = UserProvider();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSuccess = false;
  bool isobscureText1 = true;
  bool isobscureText2 = true;
  bool passNotSame = false;
  bool _isFilled = true;
  bool _isLoading = false;
  String responseMsg = '';

  final RegExp _passwordPattern = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%^&*+=`~?><,.])[A-Za-z\d@#$!%^&`+=*?><.,]{8,}$');

  UserDataModel userModel = Get.find<UserDataModel>();

  // 验证表格不是空白
  void validateForm() {
    String pass1 = _passwordController.text;
    String pass2 = _confirmPasswordController.text;
    if (pass1 == "" || pass2 == "" || pass1.isEmpty || pass2.isEmpty) {
      setState(() {
        _isFilled = false;
      });
    } else {
      setState(() {
        _isFilled = true;
      });
    }
  }

  // 验证密码是否一致
  bool arePasswordsEqual() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    return password == confirmPassword;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    bool isLogin = widget.isLogin;
    void backToPrevPage(bool isLogin) {
      isLogin
          ? Get.offUntil(
              MaterialPageRoute(builder: (context) => BottomNaviBar()),
              ModalRoute.withName("/home"),
            )
          : Get.offUntil(
              MaterialPageRoute(builder: (context) => Login()),
              ModalRoute.withName("/auth"),
            );
    }

    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: isSuccess
              ? Container(
                  padding: EdgeInsets.fromLTRB(
                      16 * fem, 24 * fem, 16 * fem, 8 * fem),
                  width: double.infinity,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 214 * fem,
                    ),
                    Container(
                        height: 100 * fem,
                        width: 100 * fem,
                        child:
                            SvgPicture.asset('images/common/Successmark.svg')),
                    SizedBox(
                      height: 35 * fem,
                    ),
                    HeadingText(
                        text: AppLocalizations.of(context)!.pwEditSuccess),
                    SizedBox(
                      height: 6 * fem,
                    ),
                    //SubText

                    SizedBox(
                      height: 40 * fem,
                    ),
                    WidthButton(
                        text: isLogin
                            ? AppLocalizations.of(context)!.returnProfile
                            : AppLocalizations.of(context)!.returnLogin,
                        onPressed: () {
                          backToPrevPage(isLogin);
                        }),
                  ]),
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(
                      22 * fem, 14 * fem, 14 * fem, 8 * fem),
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Back Button
                        GestureDetector(
                          onTap: () {
                            backToPrevPage(isLogin);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 300 * fem, 28 * fem),
                            child: SvgPicture.asset(
                              'images/common/Arrow.svg',
                              width: 24 * fem,
                              height: 24 * fem,
                            ),
                          ),
                        ),
                        //Header Text
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 25 * fem, 0 * fem),
                          child: HeadingText(
                              text: AppLocalizations.of(context)!.createNewPw),
                        ),

                        SizedBox(
                          height: 18,
                        ),
                        //SubText
                        Text(AppLocalizations.of(context)!.pwEditRule,
                            style: GoogleFonts.notoSansSc(
                              color: kMainGreyColor,
                              fontSize: 16 * fem,
                              fontWeight: FontWeight.w400,
                            )),

                        SizedBox(
                          height: 32 * fem,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          18 * fem,
                                          18 * fem,
                                          18 * fem,
                                          18 * fem),
                                      hintText: AppLocalizations.of(context)!
                                          .password,
                                      hintStyle: GoogleFonts.notoSansSc(
                                        fontSize: 16 * fem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.25 * fem,
                                        color: kComponentHintTextColor,
                                      ),
                                      filled: true,
                                      fillColor: kMainComponentColor,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.all(12.0 * fem),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isobscureText1 =
                                                    !isobscureText1;
                                              });
                                            },
                                            child: SizedBox(
                                              width: 10,
                                              height: 5,
                                              child: SvgPicture.asset(
                                                isobscureText1
                                                    ? 'images/common/fluent_eye-20-filled(1).svg'
                                                    : 'images/common/fluent_eye-20-filled.svg',
                                                width: 24 * fem,
                                                height: 24 * fem,
                                              ),
                                            )),
                                      )),
                                  style: TextStyle(color: kMainTitleColor),
                                  obscureText: isobscureText1,
                                ),
                                SizedBox(
                                  height: 12 * fem,
                                ),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          18 * fem,
                                          18 * fem,
                                          18 * fem,
                                          18 * fem),
                                      hintText: AppLocalizations.of(context)!
                                          .confirmPw,
                                      hintStyle: TextStyle(
                                        fontSize: 16 * fem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.25 * fem,
                                        color: kComponentHintTextColor,
                                      ),
                                      filled: true,
                                      fillColor: kMainComponentColor,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.all(12.0 * fem),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isobscureText2 =
                                                    !isobscureText2;
                                              });
                                            },
                                            child: SizedBox(
                                              width: 10,
                                              height: 5,
                                              child: SvgPicture.asset(
                                                isobscureText2
                                                    ? 'images/common/fluent_eye-20-filled(1).svg'
                                                    : 'images/common/fluent_eye-20-filled.svg',
                                                width: 24 * fem,
                                                height: 24 * fem,
                                              ),
                                            )),
                                      )),
                                  style: TextStyle(color: kMainTitleColor),
                                  obscureText: isobscureText2,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 18 * fem,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: ErrorText(Msg: responseMsg)),

                        SizedBox(
                          height: 18 * fem,
                        ),
                        _isLoading
                            ? LoadingLongButton()
                            : WidthButton(
                                text: AppLocalizations.of(context)!.resetPw,
                                onPressed: () async {
                                  setState(() {
                                    responseMsg = '';
                                  });
                                  validateForm();
                                  if (_isFilled) {
                                    bool passwordsMatch = arePasswordsEqual();
                                    if (passwordsMatch) {
                                      String newPassword =
                                          _passwordController.text;
                                      if (_passwordPattern
                                          .hasMatch(newPassword)) {
                                        // showLoadingDialog(context);
                                        bool isChangedPassword =
                                            await provider.updateForgotPassword(
                                                newPassword,
                                                widget.phoneNumber);
                                        if (isChangedPassword != true) {
                                          Navigator.of(context).pop();
                                          openSnackbar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .noInternet,
                                              kComponentErrorTextColor);
                                        } else {
                                          // Navigator.of(context).pop();
                                          Get.offAll(OnboardingPage());
                                          setState(() {
                                            isSuccess = true;
                                            openSnackbar(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .pwReset,
                                                kComponentSuccessTextColor);
                                          });
                                        }
                                      } else if (!_passwordPattern
                                          .hasMatch(newPassword)) {
                                        print("最少为8个字符,至少一个大写字母、数字和特殊字符");
                                        setState(() {
                                          responseMsg =
                                              AppLocalizations.of(context)!
                                                  .pwEditRule2;
                                        });
                                      }

                                      // sendChgPassRequest();
                                    } else if (!passwordsMatch) {
                                      print('Passwords are not same');
                                      setState(() {
                                        responseMsg =
                                            AppLocalizations.of(context)!
                                                .pwNotSame;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      responseMsg =
                                          AppLocalizations.of(context)!
                                              .pwNotBlank;
                                    });
                                    print('Passwords are empty!');
                                  }
                                }),
                      ]),
                ),
        ),
      ),
    );
  }
}
