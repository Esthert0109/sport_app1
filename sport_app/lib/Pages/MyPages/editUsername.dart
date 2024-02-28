import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Component/Common/headingText.dart';
import '../../Component/Common/loadingScreen.dart';
import '../../Component/Common/previousButton.dart';
import '../../Component/Common/snackBar.dart';
import '../../Component/Common/widthButton.dart';
import '../../Constants/colorConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/userProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditUserNickname extends StatefulWidget {
  const EditUserNickname({Key? key}) : super(key: key);

  @override
  State<EditUserNickname> createState() => _EditUserNicknameState();
}

class _EditUserNicknameState extends State<EditUserNickname> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  String _responseMsg = '';

  UserProvider provider = UserProvider();
  UserDataModel userModel = Get.find<UserDataModel>();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: kMainComponentColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16 * fem, 24 * fem, 16 * fem, 8 * fem),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 返回按钮
                Align(alignment: Alignment.topLeft, child: PrevBtn()),
                SizedBox(
                  height: 41 * fem,
                ),
                Obx(
                  () => HeadingText(
                      text: AppLocalizations.of(context)!.editNickname),
                ),
                SizedBox(
                  height: 30 * fem,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus(); // 按外面使键盘收回
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.nickNameIsNotEmpty;
                      }
                      return null;
                    },
                    focusNode: _nameFocusNode,
                    controller: _userNameController,
                    textInputAction: TextInputAction.done, // 按enter使键盘收回
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(
                          18 * fem, 18 * fem, 18 * fem, 18 * fem),
                      hintText: AppLocalizations.of(context)!.newNickname,
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
                      errorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kComponentErrorTextColor)),
                    ),
                    style: const TextStyle(color: kMainTitleColor),
                  ),
                ),
                SizedBox(
                  height: 17 * fem,
                ),
                // 展示回应信息栏
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _responseMsg,
                    style: TextStyle(
                        fontFamily: 'NotoSansSC',
                        color: kComponentErrorTextColor,
                        fontSize: 15 * fem,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 65 * fem),

                // 确认更改名字按钮
                WidthButton(
                    text: AppLocalizations.of(context)!.updateNickname,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoadingDialog(context);
                        String newNickname = _userNameController.text;
                        bool isChangeNickname =
                            await provider.updateUserNickname(newNickname);
                        if (isChangeNickname != true) {
                          Navigator.of(context).pop();
                          openSnackbar(
                              context,
                              AppLocalizations.of(context)!.noInternet,
                              kComponentErrorTextColor);
                        } else {
                          Navigator.of(context).pop();
                          userModel.userName.value = newNickname;
                          openSnackbar(
                              context,
                              AppLocalizations.of(context)!.successNickname,
                              kComponentSuccessTextColor);
                        }

                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
