import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport_app/Component/Common/countdown.dart';
import 'package:sport_app/Pages/AuthenticationPages/login.dart';

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
import 'editPassword.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPVerification extends StatefulWidget {
  final String phone;
  final String userNickname;
  final String dialCode;
  final String password;
  final bool isChangePassword; //是否要换密码
  final bool isLogin; //是否登录过
  const OTPVerification(
      {required this.phone,
      required this.isChangePassword,
      required this.isLogin,
      required this.dialCode,
      required this.password,
      required this.userNickname});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  //return text from the controller
  TextEditingController textEditingController = TextEditingController();
  UserProvider provider = UserProvider();
  UserDataModel userModel = Get.find<UserDataModel>();
  final TextEditingController digit1Controller = TextEditingController();
  final TextEditingController digit2Controller = TextEditingController();
  final TextEditingController digit3Controller = TextEditingController();
  final TextEditingController digit4Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //variable
  bool verification = false;
  bool isbuttonDisabled = false;
  String countdownMsg = "";
  String _responseMsg = "";
  String _errorMsg = "";
  bool _isLoading = false;
  bool _isOTP = true;

  String previousPage = Get.previousRoute.toString();

  String getOtpCode() {
    String digit1 = digit1Controller.text;
    String digit2 = digit2Controller.text;
    String digit3 = digit3Controller.text;
    String digit4 = digit4Controller.text;

    return '$digit1$digit2$digit3$digit4';
  }

  void clearOtpField() {
    digit1Controller.clear();
    digit2Controller.clear();
    digit3Controller.clear();
    digit4Controller.clear();
    //再重新请求OTP后清空输入框
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    Countdown countdown = Countdown(30);
    bool isChangePassword = widget.isChangePassword;
    bool isLogin = widget.isLogin;
    String otpCode = getOtpCode();

    // 倒数计时
    void startCountdown() {
      countdown.start(
        (int seconds) {
          setState(() {
            countdownMsg =
                '$seconds' + AppLocalizations.of(context)!.afterSecond;
            // 展示多少秒后才能重发验证码
            isbuttonDisabled = true; // 禁用按钮
          });
        },
        () {
          setState(() {
            countdownMsg = ''; // 清空消息
            isbuttonDisabled = false; // 打开按钮
          });
        },
      );
    }

    void validateOTP() {
      if (otpCode.length != 4) {
        setState(() {
          _isOTP = false;
        });
      } else {
        setState(() {
          _isOTP = true;
        });
      }
    }

    Column verifySuccess = Column(
      children: <Widget>[
        SizedBox(
          height: 109 * fem,
        ),
        Center(
          child: Container(
            height: 100 * fem,
            width: 100 * fem,
            child: SvgPicture.asset('images/Successmark.svg'),
          ),
        )
      ],
    );

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
                //Back Button
                isLogin
                    ? GestureDetector(
                        onTap: () {
                          Get.back(); //回到前页面
                          Get.back();
                        },
                        child: SvgPicture.asset(
                          'images/Arrow.svg',
                          width: 24 * fem,
                          height: 24 * fem,
                        ),
                      )
                    : PrevBtn(),
                SizedBox(
                  height: 41 * fem,
                ),
                HeadingText(
                    text: verification
                        ? AppLocalizations.of(context)!.verifiedSuccessfully
                        : AppLocalizations.of(context)!.verifiedOTP),

                SizedBox(
                  height: 18 * fem,
                ),
                //SubText
                Text(verification ? '' : AppLocalizations.of(context)!.keyInOTP,
                    style: GoogleFonts.notoSansSc(
                      color: kMainGreyColor,
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w400,
                    )),

                SizedBox(
                  height: 30 * fem,
                ),
                //OTP Slots
                verification
                    ? verifySuccess
                    : Column(children: [
                        Form(
                          key: _formKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 60 * fem,
                                width: 70 * fem,
                                child: Align(
                                  child: TextFormField(
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    controller: digit1Controller,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else if (value.length == 0) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 50 * fem),
                                      focusColor: kMainGreenColor,
                                      filled: true,
                                      fillColor: kMainComponentColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide:
                                            BorderSide(color: kMainGreenColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            color: kComponentHintTextColor),
                                      ),
                                    ),
                                    style: GoogleFonts.notoSansSc(
                                      color: kMainTitleColor,
                                      fontSize: 22 * fem,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60 * fem,
                                width: 70 * fem,
                                child: TextFormField(
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: digit2Controller,
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value.length == 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 50 * fem),
                                    focusColor: kMainGreenColor,
                                    filled: true,
                                    fillColor: kMainComponentColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                          BorderSide(color: kMainGreenColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: kComponentHintTextColor),
                                    ),
                                  ),
                                  style: GoogleFonts.notoSansSc(
                                    color: kMainTitleColor,
                                    fontSize: 22 * fem,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 60 * fem,
                                width: 70 * fem,
                                child: TextFormField(
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: digit3Controller,
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value.length == 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 50 * fem),
                                    focusColor: kMainGreenColor,
                                    filled: true,
                                    fillColor: kMainComponentColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                          BorderSide(color: kMainGreenColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: kComponentHintTextColor),
                                    ),
                                  ),
                                  style: GoogleFonts.notoSansSc(
                                    color: kMainTitleColor,
                                    fontSize: 22 * fem,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 60 * fem,
                                width: 70 * fem,
                                child: TextFormField(
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: digit4Controller,
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).unfocus();
                                    } else if (value.length == 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 50 * fem),
                                    filled: true,
                                    fillColor: kMainComponentColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                          BorderSide(color: kMainGreenColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: kComponentHintTextColor),
                                    ),
                                  ),
                                  style: GoogleFonts.notoSansSc(
                                    color: kMainTitleColor,
                                    fontSize: 22 * fem,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15 * fem,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: ErrorText(Msg: _responseMsg)),
                        SizedBox(
                          height: 55 * fem,
                        ),
                        //Verify Button
                        _isLoading
                            ? LoadingLongButton()
                            : WidthButton(
                                text: AppLocalizations.of(context)!.verified,
                                onPressed: () async {
                                  setState(() {
                                    _responseMsg = "";
                                  });
                                  print(otpCode);
                                  validateOTP();
                                  if (_isOTP) {
                                    // VERIFY OTP FUNCTION PUT HERE

                                    // reset password
                                    if (isChangePassword == true &&
                                        isLogin == true) {
                                      showLoadingDialog(context);
                                      bool isOTPValid =
                                          await provider.verifyOTP(
                                              userModel.id.value, otpCode, "2");
                                      if (isOTPValid == true) {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          verification = true;
                                        });
                                        await Future.delayed(
                                            Duration(seconds: 3));

                                        Get.offUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPassword(
                                                    isLogin: isLogin,
                                                    phoneNumber: widget.phone,
                                                  )),
                                          ModalRoute.withName("/auth"),
                                        );
                                      } else {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _responseMsg =
                                              AppLocalizations.of(context)!
                                                  .verifiedUnsuccessfully;
                                        });
                                        openSnackbar(
                                            context,
                                            AppLocalizations.of(context)!
                                                .verifiedUnsuccessfully,
                                            kComponentErrorTextColor);
                                      }
                                    }
                                    // forgot password
                                    else if (isChangePassword == true &&
                                        isLogin == false) {
                                      validateOTP();
                                      if (_isOTP) {
                                        bool isVerifiedOTP =
                                            await provider.verifyOTP(
                                                widget.phone, otpCode, '3');
                                        if (isVerifiedOTP) {
                                          setState(() {
                                            verification = true;
                                          });
                                          await Future.delayed(
                                              Duration(seconds: 3));

                                          Get.offUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPassword(
                                                      isLogin: isLogin,
                                                      phoneNumber: widget.phone,
                                                    )),
                                            ModalRoute.withName("/auth"),
                                          );
                                        }
                                      }
                                    }
                                    // register
                                    else if (isChangePassword == false &&
                                        isLogin == false) {
                                      validateOTP();
                                      if (_isOTP) {
                                        bool isVerifiedOTP =
                                            await provider.verifyOTP(
                                                widget.phone, otpCode, '1');
                                        if (isVerifiedOTP) {
                                          setState(() {
                                            verification = true;
                                            provider.createUser(
                                                widget.userNickname,
                                                widget.phone,
                                                widget.password,
                                                widget.dialCode);
                                          });
                                          await Future.delayed(
                                              Duration(seconds: 3));
                                          Get.offUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()),
                                              ModalRoute.withName("/auth"));
                                        } else {
                                          setState(() {
                                            _responseMsg =
                                                AppLocalizations.of(context)!
                                                    .verifiedUnsuccessfully;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _responseMsg =
                                              AppLocalizations.of(context)!
                                                  .keyInOTP;
                                        });
                                      }
                                    } else {
                                      print(
                                          "got some errer not sure the otp operations");
                                    }
                                  } else {
                                    setState(() {
                                      _responseMsg =
                                          AppLocalizations.of(context)!
                                              .otpNotBlank;
                                    });
                                  }
                                }),

                        SizedBox(
                          height: 210 * fem,
                        ),
                        Text(
                          countdownMsg,
                          style: GoogleFonts.notoSansSc(
                              color: kMainGreyColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10 * fem,
                        ),
                        //Bottom Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.cntReceiveOTP,
                              style: GoogleFonts.notoSansSc(
                                fontSize: 14 * fem,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.14 * fem,
                                color: kMainTitleColor,
                              ),
                            ),
                            PressableWord(
                              text: AppLocalizations.of(context)!.resend,
                              onPressed: () {
                                if (!isbuttonDisabled) {
                                  setState(() {
                                    isbuttonDisabled = true;
                                  });

                                  startCountdown();
                                  clearOtpField();
                                  if (isChangePassword == true &&
                                      isLogin == true) {
                                    provider.getOTP(widget.phone, '2');
                                  } else if (isChangePassword == true &&
                                      isLogin == false) {
                                    provider.getOTP(widget.phone, '3');
                                  } else {
                                    provider.getOTP(widget.phone, '1');
                                  }

                                  // RESEND OTP FUNCTION PUT HERE
                                } else {
                                  null;
                                }
                              },
                              color: isbuttonDisabled
                                  ? Color.fromARGB(255, 17, 143, 47)
                                  : kMainGreenColor,
                            )
                          ],
                        ),
                      ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
