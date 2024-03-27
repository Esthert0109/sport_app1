import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sport_app/Component/Common/errorText.dart';
import 'package:sport_app/Component/Common/pressableWord.dart';
import 'package:sport_app/Component/Common/widthButton.dart';

import '../../Constants/colorConstant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Constants/textConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Pages/AuthenticationPages/forgotPassword.dart';
import '../../Provider/userProvider.dart';
import '../../Services/Utils/sharedPreferencesUtils.dart';
import '../../bottomNavigationBar.dart';
import 'loadingButton.dart';
import 'loadingScreen.dart';
import 'snackBar.dart';

class LoginAlertDialog extends StatefulWidget {
  const LoginAlertDialog({super.key});

  @override
  State<LoginAlertDialog> createState() => _LoginAlertDialogState();
}

class _LoginAlertDialogState extends State<LoginAlertDialog> {
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
  final bool _isLoading = false;
  bool isPandaLoading = false;

  // provider
  UserProvider provider = UserProvider();

  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

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
    return StatefulBuilder(
      builder: (context, setState) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            height: 700 * fem,
            color: kMainBackgroundColor,
            padding:
                EdgeInsets.symmetric(horizontal: 20 * fem, vertical: 0 * fem),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30 * fem),
                    child: Text(
                      AppLocalizations.of(context)!.loginContinue,
                      style: tContactUsTitle,
                    ),
                  ),
                  Container(
                    width: 375 * fem,
                    child: Container(
                      width: 343 * fem,
                      padding: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 0 * fem),
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
                        cursorColor: kMainGreenColor,
                        inputDecoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(15 * fem),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            hintText:
                                AppLocalizations.of(context)!.keyInPhoneNo,
                            hintStyle: tPhoneNoInput),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15 * fem),
                    child: TextFormField(
                      validator: (value) {
                        if (value == "" || value!.isEmpty) {
                          return AppLocalizations.of(context)!.passwordNotBlank;
                        } else {
                          return null;
                        }
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      cursorColor: kMainGreenColor,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15 * fem),
                        hintText: AppLocalizations.of(context)!.keyInPassword,
                        hintStyle: tPhoneNoInput,
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
                      style: const TextStyle(color: kMainTitleColor),
                      obscureText: _isHidden,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0 * fem),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ErrorText(Msg: _responseMsg)),
                        PressableWord(
                            text: AppLocalizations.of(context)!.forgotPassword,
                            fontWeight: FontWeight.w600,
                            color: kMainTitleColor,
                            onPressed: () {
                              Get.to(() => const ForgotPass());
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30 * fem),
                    child: _isLoading
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
                                      AppLocalizations.of(context)!
                                          .rightPassword,
                                      kComponentErrorTextColor);
                                }
                              } else {
                                print('Empty contant number or password');
                              }
                            }),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 0 * fem, horizontal: 0 * fem),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: kMainGreenColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.maybeLater,
                          style: tContinueAsGuest,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30 * fem),
                    child: Row(
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
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
