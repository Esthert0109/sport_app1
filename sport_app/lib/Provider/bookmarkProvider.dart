import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Model/userDataModel.dart';

class BookmarkProvider extends ChangeNotifier {
  // services
  CommonServices service = CommonServices();

  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  Future<Map<String, dynamic>> liveStreamSaveBookmark(
      String matchId, String categoryId) async {
    String url = '';
    String category = '';

    if (userModel.isCN.value) {
      url = ApiConstants.baseUrl + ApiConstants.createCollectionUrl;
      if (userModel.isFootball.value) {
        category = '0';
      } else {
        category = '1';
      }
    } else {
      url = ApiConstants.baseUrl + ApiConstants.createCollectionEngUrl;
      if (userModel.isFootball.value) {
        category = '0';
      } else {
        category = '1';
      }
    }

    final Map<String, String> collectionData = {
      'matchId': matchId,
      'category': category,
    };
    try {
      final response = await service.postRequestWithToken(url, collectionData);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      Map<String, dynamic> data = response['data'];
      String token = response['token'].toString();
      String? responseMsg;
      //if the request of creating user success, sending request to get OTP
      if (code == '0') {
        print("success");
        return data;
      } else {
        print('unsuccessful: $code');
        if (response['code'] == '500100') {
          return {};
        }
      }
      print('$response');

      return {};
    } catch (e) {
      print("unsuccessful in provider");
      return {};
    }
  }

  Future<List> getLiveStreamBookmark() async {
    String url = "";
    if (userModel.isCN == true) if (userModel.isFootball.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getAllStreamCollectionListFootballUrl;
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getAllStreamCollectionListBasketballUrl;
    }
    else if (userModel.isFootball.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getAllStreamCollectionListEngUrlFootball;
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getAllStreamCollectionListEngUrlBasketball;
    }

    //for english searchFootballMatchTodayENurl API
    print(url);
    try {
      final response = await service.getRequestWithToken(url);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      List<dynamic> data = [];
      if (response['data'] != null) {
        data = response['data'];
      }
      String token = response['token'].toString();
      String? responseMsg;

      if (code == '0') {
        print("Msg: $msg");
        return data;
      } else {
        print("Error Code: $code");
        print("Msg: $msg");
        return [];
      }
    } catch (e) {
      print("unsuccessful in provider");
      return [];
    }
  }

  Future<bool> deleteStreamSaveBookmark(String matchId) async {
    String url = '';

    if (userModel.isCN.value) {
      url = ApiConstants.baseUrl + ApiConstants.deleteCollectionByMatchIdUrl;
    } else {
      url = ApiConstants.baseUrl + ApiConstants.deleteCollectionEngByMatchIdUrl;
    }

    final newUrl = url.replaceAll("{matchId}", matchId);

    try {
      final response = await service.deleteRequest(newUrl);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      String data = response['data'].toString();
      String token = response['token'].toString();
      String? responseMsg;
      print(data);
      //if the request of creating user success, sending request to get OTP
      if (code == '0') {
        print("success");
        return true;
      } else {
        print('unsuccessful: $code');
        return false;
      }
    } catch (e) {
      print("unsuccessful in provider");
      return false;
    }
  }
}
