import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Model/matchesModel.dart';
import 'package:sport_app/Model/userDataModel.dart';
import 'package:sport_app/Services/Utils/sharedPreferencesUtils.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Services/Utils/httpUtil.dart';

class BasketballMatchProvider extends ChangeNotifier {
  UserDataModel userDataModel = Get.find<UserDataModel>();
  CommonServices service = CommonServices();

  Future<StartedMatchesModel?> getStartedEventList(int page, int size) async {
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getStartBasketballMatchUrl +
          "page=${page.toString()}&size=${size.toString()}";
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getStartBasketballMatchENurl +
          "page=${page.toString()}&size=${size.toString()}";
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
      print("response from started event");

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      print("started event: url: $url, response: $response");

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data']['start'];
        List<MatchesData> data =
            jsonData.map((e) => MatchesData.fromJson(e)).toList();

        StartedMatchesData responseData = StartedMatchesData(start: data);

        StartedMatchesModel startedMatchesModel = StartedMatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return startedMatchesModel;
      } else {
        StartedMatchesData responseData = StartedMatchesData(start: []);
        StartedMatchesModel startedMatchesModel = StartedMatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return startedMatchesModel;
      }
    } catch (e) {
      print("Errror in started event: $e");
      return null;
    }
  }

  Future<MatchesModel?> getEventByDate(
      String date, int page, int size, bool checkData) async {
    String formattedDate = date.replaceAll("-", "");
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getBasketballMatchByDateUrl +
          "$formattedDate?page=${page.toString()}&size=${size.toString()}&checkData=${checkData.toString()}";
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getBasketballMatchByDateENurl +
          "$formattedDate?page=${page.toString()}&size=${size.toString()}&checkData=${checkData.toString()}";
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
      print("response from event by date");

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      print("event by date: url: $url, response: $response");

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];

        List<MatchesData> responseData =
            jsonData.map((e) => MatchesData.fromJson(e)).toList();

        MatchesModel matchesModel = MatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        print("event by date: $matchesModel");

        return matchesModel;
      } else {
        MatchesModel matchesModel =
            MatchesModel(code: responseCode, msg: responseMsg, data: []);
        print("no data in event by date");
        return matchesModel;
      }
    } catch (e) {
      print("Errror in event by date list: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBasketballLiveData(String matchId) async {
    String url = '';

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getBasketballMatchLiveDataUrl +
          matchId;
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getBasketballMatchLiveDataENurl +
          matchId;
    }

    final response = await service.getRequest(url);

    String code = response['code'].toString();
    String msg = response['msg'].toString();
    Map<String, dynamic>? data = response['data'];

    if (code == '0') {
      return data;
    } else {
      debugPrint("Error: $msg");
      return {};
    }
  }

  Future<Map<String, dynamic>> getBasketballLineUp(String matchId) async {
    String url = '';
    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getBasketballMatchLineUpUrl +
          matchId;
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getBasketballLineUpENurl +
          matchId;
    }

    final response = await service.getRequest(url);

    String code = response['code'].toString();
    String msg = response['msg'].toString();
    Map<String, dynamic> data = response['data'];

    if (code == '0') {
      return data;
    } else {
      debugPrint("Error: $msg");
      return {};
    }
  }
}
