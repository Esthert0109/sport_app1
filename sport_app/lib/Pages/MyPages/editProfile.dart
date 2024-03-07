import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Pages/MyPages/editUsername.dart';

import '../../Component/Common/loadingScreen.dart';
import '../../Component/Common/noticeDialog.dart';
import '../../Component/Common/snackBar.dart';
import '../../Constants/colorConstant.dart';
import '../../Constants/textConstant.dart';
import '../../Model/userDataModel.dart';
import '../../Provider/userProvider.dart';
import '../AuthenticationPages/otpVerification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _editProfileState();

  static void launch(BuildContext context) {}
}

class _editProfileState extends State<EditProfile> {
  UserProvider provider = UserProvider();
  UserDataModel userModel = Get.find<UserDataModel>();

  final ImagePicker _picker = ImagePicker();
  static String imagePath = "";
  int remainingTimeInSeconds = 120;

  void openImagePicker() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      showLoadingDialog(context);
      // 选择了图像
      File imageFile = File(image.path);
      bool isFinish = await provider.updateProfilePic(imageFile);
      if (isFinish == true) {
        // Close the loading indicator dialog
        Navigator.of(context).pop();
        openSnackbar(context, AppLocalizations.of(context)!.successProfilePic,
            kComponentSuccessTextColor);
      } else {
        openSnackbar(context, AppLocalizations.of(context)!.noInternet,
            kComponentErrorTextColor);
      }
    } else {
      // 用户取消了选择
    }
  }

  String userPhone = ''; // ADD PHONE NUMBER VARIABLE
  Widget sectionBox(String text, Function()? onTap) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343 * fem,
        height: 60 * fem,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * fem),
          color: kMainComponentColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(20 * fem),
          child: Row(children: [
            Text(text),
            Spacer(),
            SvgPicture.asset('images/common/right-arrow.svg'),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kMainGreenColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    String profilePicture = 'images/common/pandalogo.png';
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 56 * fem,
            color: kMainGreenColor,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(17 * fem, 16 * fem, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Get.back(); //回到前页面
                      },
                      child: SvgPicture.asset(
                        'images/common/arrow-white.svg',
                        width: 24 * fem,
                        height: 24 * fem,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.updateInfo,
                    style: tEditTitle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50 * fem,
          ),
          Stack(
            children: [
              Container(
                width: 114 * fem,
                height: 114 * fem,
              ),
              Obx(() => CircleAvatar(
                    backgroundImage: Image.network(
                      userModel.profilePicture.value,
                    ).image,
                    radius: 56 * fem,
                  )),
              Positioned(
                left: 80 * fem,
                top: 80 * fem,
                child: GestureDetector(
                  onTap: () {
                    openImagePicker();
                  },
                  child: SvgPicture.asset(
                    'images/common/camera.svg',
                    width: 28 * fem,
                    height: 28 * fem,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 50 * fem,
          ),
          sectionBox(AppLocalizations.of(context)!.editNickname, () {
            Get.to(() => const EditUserNickname(),
                transition: Transition.fadeIn);
          }),
          SizedBox(
            height: 14 * fem,
          ),
          // Obx(
          //   () =>

          sectionBox(AppLocalizations.of(context)!.editPassword, () {
            showNoticeDialog(
                context,
                AppLocalizations.of(context)!.updateConfirmation,
                AppLocalizations.of(context)!.yes, () async {
              Timer.periodic(Duration(seconds: 1), (timer) {
                setState(() async {
                  // showLoadingDialog(context);

                  String isGetOTP =
                      await provider.getOTP(userModel.id.value, "2");
                  remainingTimeInSeconds--;

                  if (remainingTimeInSeconds == 0) {
                    if (isGetOTP.isEmptyOrNull) {
                      openSnackbar(
                          context,
                          AppLocalizations.of(context)!.noInternet,
                          kComponentErrorTextColor);
                    } else {
                      if (isGetOTP == '500313') {
                        openSnackbar(
                            context,
                            AppLocalizations.of(context)!.otpHitLimit,
                            kComponentErrorTextColor);
                      } else {
                        timer.cancel();
                        Get.to(
                            () => OTPVerification(
                                  phone: userPhone,
                                  isChangePassword: true,
                                  isLogin: true,
                                  userNickname: '',
                                  dialCode: '',
                                  password: '',
                                ),
                            transition: Transition.fadeIn);
                        openSnackbar(
                            context,
                            AppLocalizations.of(context)!.otpSent,
                            kComponentSuccessTextColor);
                      }
                    }
                  } else {
                    if (!isGetOTP.isEmptyOrNull) {
                      if (isGetOTP == '500313') {
                        openSnackbar(
                            context,
                            AppLocalizations.of(context)!.otpHitLimit,
                            kComponentErrorTextColor);
                      } else {
                        timer.cancel();
                        Get.to(
                            () => OTPVerification(
                                  phone: userPhone,
                                  isChangePassword: true,
                                  isLogin: true,
                                  userNickname: '',
                                  dialCode: '',
                                  password: '',
                                ),
                            transition: Transition.fadeIn);
                        openSnackbar(
                            context,
                            AppLocalizations.of(context)!.otpSent,
                            kComponentSuccessTextColor);
                      }
                    }
                  }
                });
              });
            });
          }),
          // ),
          SizedBox(
            height: 14 * fem,
          ),
        ],
      )),
    );
  }
}
