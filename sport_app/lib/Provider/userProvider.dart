import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_app/Services/Utils/sharedPreferencesUtils.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Model/userDataModel.dart';
import '../Pages/AuthenticationPages/login.dart';
import '../Pages/AuthenticationPages/registration.dart';
import '../Services/Utils/tencent/tencentLiveUtils.dart';

class UserProvider extends ChangeNotifier {
  CommonServices service = CommonServices();
  UserDataModel userModel = Get.find<UserDataModel>();
  final String salt = '1a2b3c4d';

  Future<void> createUser(String userNickname, String phone, String password,
      String dialCode) async {
    final String url = ApiConstants.baseUrl + ApiConstants.createUserUrl;

    String encryptedPassword;

    encryptedPassword = hashPassword(password);

    final Map<String, String> liveStreamUserData = {
      'id': phone,
      'nickName': userNickname,
      'password': encryptedPassword,
      'head':
          'https://live-stream-1321239144.cos.ap-singapore.myqcloud.com/head/000153ed8cd649019e5659f9456419ae.png',
      'areaCode': dialCode
    };

    try {
      final response = await service.postRequest(url, liveStreamUserData);

      String phoneWithoutPlus = phone.replaceAll('+', '');

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();
      String? responseMsg;
      Register register = Register();

      //if the request of creating user success, sending request to get OTP
      if (code == '0') {
        print("success");
        bool isRegister = await registerTencent(phoneWithoutPlus, userNickname,
            "https://live-stream-1321239144.cos.ap-singapore.myqcloud.com/head/000153ed8cd649019e5659f9456419ae.png");

        userModel.userName.value = userNickname;
        userModel.id.value = phoneWithoutPlus;
        userModel.password.value = encryptedPassword;
      } else {
        if (response['code'] == '500215') {
          responseMsg = '手机号码已存在账号';
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> loginUser(String phoneNumber, String password) async {
    final String url = ApiConstants.baseUrl + ApiConstants.loginUrl;
    String phoneNumberWithoutPlus = phoneNumber.replaceAll('+', '');
    final prefs = await SharedPreferences.getInstance();

    String encryptedPassword;

    encryptedPassword = hashPassword(password);
    print("login: $encryptedPassword");

    final Map<String, String> userLoginData = {
      'mobile': phoneNumberWithoutPlus,
      'password': encryptedPassword
    };

    try {
      final response = await service.postRequest(url, userLoginData);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();
      String token = response['token'].toString();

      String? responseMsg;
      Login login = Login();

      if (code == '0') {
        print("successfully login");
        print(data);

        // Remove curly braces and split the string into key-value pairs
        List<String> keyValuePairs =
            data.replaceAll('{', '').replaceAll('}', '').split(', ');

        Map<String, String?> parsedData = {};

        // Iterate through key-value pairs to extract the values
        for (String keyValue in keyValuePairs) {
          List<String> parts = keyValue.split(': ');
          if (parts.length == 2) {
            String key = parts[0];
            String? value = parts[1];
            parsedData[key] = value;
          }
        }

        // Extract the desired values
        String? head = parsedData['head'];
        String? mobile = parsedData['mobile'];
        String? token = parsedData['token'];
        String? username = parsedData['username'];

        userModel.saveNameAndContact(token!, username!, mobile!, head!);
        userModel.isLogin.value = true;

        // Print the extracted values
        print('head: $head');
        print('mobile: $mobile');
        print('token: $token');
        print('username: $username');

        if (data != '') {
          Map<String, dynamic> data = response['data'];
          await prefs.setString('token', data['token']);
          SharedPreferencesUtils.saveTokenLocally(data['token']);
        }
        return true;
      } else {
        print("unsuccessfully login: $code");
        return false;
      }
    } catch (e) {
      print("unsuccessful in provider: $e");
      return false;
    }
  }

  Future<String> getOTP(String phoneNumber, String codes) async {
    String phoneNumberWithoutPlus = phoneNumber.replaceAll('+', '');
    final String url = ApiConstants.baseUrl +
        ApiConstants.sendMsgUrl +
        codes +
        "/" +
        '$phoneNumberWithoutPlus';

    final response = await service.getRequest(url);
    String code = response['code'].toString();
    String msg = response['msg'].toString();
    String data = response['data'].toString();

    String? responseMSg;

    if (code == '0') {
      print('OTP sent successfully');
      return code;
    } else if (code == '500215') {
      print("phone number existed");
      return code;
    } else if (code == '500313') {
      print("OTP hits limit");
      return code;
    } else if (code == '500214') {
      print("account not exist");
      return code;
    } else {
      return code;
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String OTP, String code) async {
    String phoneNumberWithoutPlus = phoneNumber.replaceAll('+', '');

    final String url =
        ApiConstants.baseUrl + ApiConstants.verifyMsgUrl + "/" + code;
    print("checking url in verifying OTP: $url");

    final Map<String, String> verifyOTPData = {
      'mobile': phoneNumberWithoutPlus,
      'code': OTP,
    };

    try {
      final response = await service.postRequest(url, verifyOTPData);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();

      if (code == '0') {
        print("successful");
        return true;
      } else {
        print("unsuccessful: $code");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfilePic(File file) async {
    final String url = ApiConstants.baseUrl + ApiConstants.uploadFileUrl;

    print("checking file path status: $file");

    try {
      final response = await service.postFileRequest(file, url);
      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();
      String userToken = userModel.token.value;

      bool isFinished = await pushImageToServer(userToken, data);

      if (isFinished == true) {
        print('Picture Upload to database Successful');
        return true;
      } else {
        if (code == '0') {
          print('Picture Upload Successful');
          return true;
        } else {
          print("Picture upload to database unsuccessful: $code");
          return false;
        }
      }
    } catch (e) {
      print('Picture Upload unsuccessful');
      return false;
    }
  }

  Future<bool> pushImageToServer(String usertToken, String imageToken) async {
    final String url =
        ApiConstants.baseUrl + ApiConstants.updateHeadUrl + usertToken;

    final String imageTokenUrl = imageToken;

    Map<String, dynamic> requestBody = {'head': imageTokenUrl};

    print("checking url in verifying OTP: $url");
    print(usertToken);
    print("checking url in imageurl: $requestBody");

    try {
      final response = await service.patchRequest(url, requestBody);

      bool isChangeAvatarTencent =
          await setAvatarTencent(userModel.id.value, imageTokenUrl);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();

      if (code == '0') {
        print("Picture upload to database successful");
        userModel.profilePicture.value = imageTokenUrl;
        return true;
      } else {
        print("Picture upload to database unsuccessful: $code");
        return false;
      }
    } catch (e) {
      print("Error when picture upload to database: $e");
      return false;
    }
  }

  Future<bool> updateUserNickname(String nickname) async {
    String userToken = userModel.token.value;
    final String url =
        ApiConstants.baseUrl + ApiConstants.updateNickNameUrl + userToken;

    Map<String, dynamic> requestBody = {'nickName': nickname};

    try {
      final response = await service.patchRequest(url, requestBody);

      bool isChangeNicknameTencent =
          await setNickNameTencent(userModel.id.value, nickname);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();

      if (code == '0') {
        print("nickname upload to database successful");
        userModel.userName.value = nickname;
        return true;
      } else {
        print("nickname upload to database unsuccessful: $code");
        return false;
      }
    } catch (e) {
      print("Error when nickname upload to database: $e");
      return false;
    }
  }

  Future<bool> updateUserPassword(String password) async {
    String encryptedPassword = hashPassword(password);

    String userToken = userModel.token.value;

    final String url =
        ApiConstants.baseUrl + ApiConstants.updatePasswordUrl + userToken;

    Map<String, dynamic> requestBody = {'password': encryptedPassword};

    try {
      final response = await service.patchRequest(url, requestBody);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();

      if (code == '0') {
        print("Password upload to database successful");
        return true;
      } else {
        print("Password upload to database unsuccessful: $code");
        return false;
      }
    } catch (e) {
      ("Error when Password upload to database: $e");
      return false;
    }
  }

  Future<bool> updateForgotPassword(String password, String phoneNumber) async {
    String encryptedPassword = hashPassword(password);

    final String url =
        ApiConstants.baseUrl + ApiConstants.updatePassByForgotUrl + phoneNumber;

    print("check url: $url & check hash password: $encryptedPassword");

    Map<String, dynamic> requestBody = {'password': encryptedPassword};
    print("check password: ${requestBody}");

    try {
      final response = await service.patchRequest(url, requestBody);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();

      if (code == '0') {
        print("New password created successfully");
        return true;
      } else {
        print("New password created unsuccessfully, code: $code, msg: $msg");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  String hashPassword(String password) {
    String saltedPassword =
        "" + salt[0] + salt[2] + password + salt[5] + salt[4];
    return md5.convert(utf8.encode(saltedPassword)).toString();
  }
}
