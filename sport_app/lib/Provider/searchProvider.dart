import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Constants/apiConstant.dart';
import 'package:sport_app/Model/userDataModel.dart';
import 'package:sport_app/Services/Utils/httpUtil.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Model/matchesModel.dart';
import '../Services/Utils/sharedPreferencesUtils.dart';

class SearchProvider extends ChangeNotifier {
  UserDataModel userDataModel = Get.find<UserDataModel>();
  CommonServices service = CommonServices();

  // basketball searching
  Future<SearchMatchesModel?> searchMatches(
      int page, int size, String search) async {
    String url = "";

    if (userDataModel.isFootball.value) {
      if (userDataModel.isCN.value) {
        url = ApiConstants.baseUrl +
            ApiConstants.searchFootballMatchTodayUrl +
            "?search=$search&page=$page&size=$size";
      } else {
        url = ApiConstants.baseUrl +
            ApiConstants.searchFootballMatchTodayENurl +
            "search=$search&page=$page&size=$size";
      }
    } else {
      if (userDataModel.isCN.value) {
        url = ApiConstants.baseUrl +
            ApiConstants.searchBasketballTodayUrl +
            "?search=$search&page=$page&size=$size";
      } else {
        url = ApiConstants.baseUrl +
            ApiConstants.searchBasketballTodayENurl +
            "?search=$search&page=$page&size=$size";
      }
    }

    final token = await SharedPreferencesUtils.getSavedToken();
    Map<String, String> headers = {};

    print("check token: $token");
    if (token == null) {
      headers = {
        'Content-Type': 'application/json; charset=utf-8',
      };
    } else {
      headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'token': token,
      };
    }

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<SearchMatchesData> responseData =
            jsonData.map((e) => SearchMatchesData.fromJson(e)).toList();

        SearchMatchesModel searchMatchesModel = SearchMatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return searchMatchesModel;
      } else {
        SearchMatchesModel searchMatchesModel =
            SearchMatchesModel(code: responseCode, msg: responseMsg, data: []);

        return searchMatchesModel;
      }
    } catch (e) {
      print("Error in search event: $e");
      return null;
    }
  }

  Future<PopularKeyWordsModel?> getAllPopularKeyWords() async {
    String url = ApiConstants.baseUrl + ApiConstants.getPopularSearchListUrl;

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];

        List<PopularKeyWordsData> responseData =
            jsonData.map((e) => PopularKeyWordsData.fromJson(e)).toList();

        PopularKeyWordsModel popularKeyWordsModel = PopularKeyWordsModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return popularKeyWordsModel;
      } else {
        PopularKeyWordsModel popularKeyWordsModel = PopularKeyWordsModel(
            code: responseCode, msg: responseMsg, data: []);

        return popularKeyWordsModel;
      }
    } catch (e) {
      print("Error in get popular keywords list: $e");
      return null;
    }
  }
}
