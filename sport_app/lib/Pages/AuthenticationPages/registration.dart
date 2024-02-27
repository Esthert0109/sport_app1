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
                  HeadingText(text: '欢迎注册， 开始使用!'),
                  SizedBox(
                    height: 30 * fem,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                          controller: userNicknameController,
                          hintText: '请输入用户名',
                          errorText: '用户名不可为空',
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
                                  hintText: '请输入手机号',
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmptyOrNull) {
                              return '密码不可为空';
                            } else if (!_passwordPattern.hasMatch(value!)) {
                              return '最少为8个字符,至少一个大写字母、数字和特殊字符';
                            }
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  18 * fem, 18 * fem, 18 * fem, 18 * fem),
                              hintText: '请输入密码',
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
                              return '确认密码不可为空';
                            }
                            return null;
                          },
                          controller: confirmedPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  18 * fem, 18 * fem, 18 * fem, 18 * fem),
                              hintText: '请再次输入密码',
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
                          text: '注册',
                          onPressed: () async {
                            showLoadingDialog(context);
                            if (formKey.currentState!.validate()) {
                              bool passwordsMatch = arePasswordsEqual();
                              if (passwordsMatch) {
                                String successOTP =
                                    await provider.getOTP(phone, "1");

                                if (successOTP == '500215') {
                                  Navigator.of(context).pop();
                                  openSnackbar(context, '手机号码已存在账号',
                                      kComponentErrorTextColor);
                                } else if (successOTP == '500313') {
                                  Navigator.of(context).pop();
                                  openSnackbar(context, '验证码申请次数已达到上限',
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
                                Navigator.of(context).pop();
                                setState(() {
                                  _responseMsg = '请确保密码的一致性';
                                });
                                print("password not same");
                              }
                            } else {
                              Navigator.of(context).pop();
                              openSnackbar(context, '请填写必要的资料',
                                  kComponentErrorTextColor);
                            }
                          }),
                  SizedBox(
                    height: 85 * fem,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '已有帐号？',
                        style: GoogleFonts.notoSansSc(
                          fontSize: 14 * fem,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.14 * fem,
                          color: kMainTitleColor,
                        ),
                      ),
                      PressableWord(
                          text: '现在登入',
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
