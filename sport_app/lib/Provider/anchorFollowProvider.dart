import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Constants/apiConstant.dart';
import 'package:sport_app/Services/Utils/httpUtil.dart';

import '../Model/followingModel.dart';
import '../Model/userDataModel.dart';
import '../Services/Utils/sharedPreferencesUtils.dart';
import '../Services/commonServices.dart';

class AnchorFollowProvider extends ChangeNotifier {
  UserDataModel userDataModel = Get.find<UserDataModel>();
  CommonServices service = CommonServices();

  Future<CreateFollowModel?> createFollow(String anchorId) async {
    final String url = ApiConstants.baseUrl + ApiConstants.createFollow;
    final Map<String, String> body = {'anchorId': anchorId};

    final token = await SharedPreferencesUtils.getSavedToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'token': token!,
    };

    try {
      final response = await sendPostRequest(url, headers, body);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        bool responseData = response['data'];
        CreateFollowModel createFollowModel = CreateFollowModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return createFollowModel;
      } else {
        CreateFollowModel createFollowModel = CreateFollowModel(
            code: responseCode, msg: responseMsg, data: false);
        return createFollowModel;
      }
    } catch (e) {
      print("Error in create follow: $e");
      return null;
    }
  }

  Future<FollowModel?> getFollowingList() async {
    String url = ApiConstants.baseUrl + ApiConstants.getFollowingList;

    final token = await SharedPreferencesUtils.getSavedToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'token': token!,
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];

        print("check list: ${jsonData}");
        List<FollowData> responseData =
            jsonData.map((e) => FollowData.fromJson(e)).toList();

        FollowModel followModel = FollowModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return followModel;
      } else {
        FollowModel followModel =
            FollowModel(code: responseCode, msg: responseMsg, data: []);
        return followModel;
      }
    } catch (e) {
      print("Error in get following list: $e");
      return null;
    }
  }
}
