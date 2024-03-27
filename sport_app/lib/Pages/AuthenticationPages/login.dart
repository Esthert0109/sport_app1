import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sport_app/Provider/userProvider.dart';

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
import '../../Services/Utils/sharedPreferencesUtils.dart';
import '../../bottomNavigationBar.dart';
import 'forgotPassword.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // provider
  UserProvider provider = UserProvider();

  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  // controller and form key
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // focus node
  final _contactFocusNode = FocusNode();

  //common variables
  bool _isHidden = true;
  bool _isLoading = false;
  bool isPandaLoading = false;
  String _responseMsg = "";
  String contactNumber = '';
  String dialCode = '';
  String phone = '';
  String countryCode = '';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'MY');

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
                const PrevBtn(),
                SizedBox(
                  height: 41 * fem,
                ),

                //Header Text
                HeadingText(text: AppLocalizations.of(context)!.welcomeBack),
                SizedBox(
                  height: 30 * fem,
                ),

                Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                                hintText:
                                    AppLocalizations.of(context)!.keyInPhoneNo,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 14 * fem,
                        ),
                        //输入密码
                        TextFormField(
                          validator: (value) {
                            if (value == "" || value!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .passwordNotBlank;
                            } else {
                              return null;
                            }
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          focusNode: _contactFocusNode,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                18 * fem, 18 * fem, 18 * fem, 18 * fem),
                            hintText:
                                AppLocalizations.of(context)!.keyInPassword,
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
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 15 * fem,
                                    height: 15 * fem,
                                    child: SvgPicture.asset(
                                      _isHidden
                                          ? 'images/fluent_eye-20-filled(1).svg'
                                          : 'images/fluent_eye-20-filled.svg',
                                      width: 15 * fem,
                                      height: 15 * fem,
                                      color: kMainGreyColor,
                                    ),
                                  )),
                            ),
                          ),
                          style: TextStyle(color: kMainTitleColor),
                          obscureText: _isHidden,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20 * fem,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: ErrorText(Msg: _responseMsg)),
                    //忘记密码按钮
                    PressableWord(
                        text: AppLocalizations.of(context)!.forgotPassword,
                        fontWeight: FontWeight.w600,
                        color: kMainTitleColor,
                        onPressed: () {
                          Get.to(() => const ForgotPass());
                        }),
                  ],
                ),

                SizedBox(
                  height: 27 * fem,
                ),
                _isLoading
                    ? LoadingLongButton()
                    : WidthButton(
                        text: AppLocalizations.of(context)!.login,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {

                            checkContactNumber();

                            bool isPasswordValid = await provider.loginUser(
                                phone, passwordController.text);

                            if (isPasswordValid == true) {
                              SharedPreferencesUtils.saveUsername(phone);
                              SharedPreferencesUtils.savePasswordLocally(
                                  passwordController.text);
                              print(
                                  "check token saved: ${SharedPreferencesUtils.getSavedToken().toString()}");

                              Navigator.of(context).pop();
                              userModel.isLogin.value = true;
                              Get.off(() => const BottomNaviBar());
                            } else {
                              Navigator.of(context).pop();
                              openSnackbar(
                                  context,
                                  AppLocalizations.of(context)!.rightPassword,
                                  kComponentErrorTextColor);
                            }
                          } else {
                            print('Empty contant number or password');
                          }
                        }),
                SizedBox(
                  height: 250 * fem,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.noAcc,
                      style: TextStyle(
                        fontFamily: 'NotoSansSC',
                        fontSize: 15 * fem,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.14 * fem,
                        color: kMainGreyColor,
                      ),
                    ),
                    PressableWord(
                        text: AppLocalizations.of(context)!.regNow,
                        onPressed: () {
                          Get.offNamed('/register');
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
