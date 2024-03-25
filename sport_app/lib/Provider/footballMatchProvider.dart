import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Constants/apiConstant.dart';
import 'package:sport_app/Model/userDataModel.dart';

import '../Model/footballMatchesModel.dart';
import '../Model/matchesModel.dart';
import '../Pages/FootballPages/footballTournamentDetails.dart';
import '../Services/Utils/httpUtil.dart';
import '../Services/Utils/sharedPreferencesUtils.dart';
import '../Services/commonServices.dart';

class FootballMatchProvider extends ChangeNotifier {
  UserDataModel userDataModel = Get.find<UserDataModel>();
  CommonServices service = CommonServices();

  Future<AllMatchesFootball?> getAllFootballMatchesInSevens(
      int page, int size) async {
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.footballMatchesInSevenDays +
          "page=${page}&size=${size}";
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.footballMatchesInSevenDaysEn +
          "page=${page}&size=${size}";
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
        Map<String, dynamic> jsonData = response['data'];

        print("check data seven: ${jsonData}");
        MatchListFootball responseData = MatchListFootball.fromJson(jsonData);

        AllMatchesFootball model = AllMatchesFootball(
            code: responseCode, msg: responseMsg, matchList: responseData);

        return model;
      } else {
        Map<String, dynamic> jsonData = response['data'];
        MatchListFootball responseData = MatchListFootball.fromJson(jsonData);

        AllMatchesFootball model = AllMatchesFootball(
            code: responseCode, msg: responseMsg, matchList: responseData);

        return model;
      }
    } catch (e) {
      print("Error in get all data: $e");
      return null;
    }
  }

  Future<FootballStartedMatchesModel?> getStartedEventList(
      int page, int size) async {
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getStartFootballMatchListUrl +
          "page=${page.toString()}&size=${size.toString()}";
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getStartFootballMatchListENurl +
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
        List<FootballMatchesData> data =
            jsonData.map((e) => FootballMatchesData.fromJson(e)).toList();

        FootballStartedMatchesData responseData =
            FootballStartedMatchesData(start: data);

        FootballStartedMatchesModel startedMatchesModel =
            FootballStartedMatchesModel(
                code: responseCode, msg: responseMsg, data: responseData);

        return startedMatchesModel;
      } else {
        FootballStartedMatchesData responseData =
            FootballStartedMatchesData(start: []);
        FootballStartedMatchesModel startedMatchesModel =
            FootballStartedMatchesModel(
                code: responseCode, msg: responseMsg, data: responseData);

        return startedMatchesModel;
      }
    } catch (e) {
      print("Errror in started event: $e");
      return null;
    }
  }

  Future<FootballMatchesModel?> getEventByDate(
      String date, int page, int size, bool checkData) async {
    String formattedDate = date.replaceAll("-", "");
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.getMatchByDateUrl +
          "$formattedDate?page=${page.toString()}&size=${size.toString()}&checkData=${checkData.toString()}";
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.getFootballMatchListByDateENurl +
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

        List<FootballMatchesData> responseData =
            jsonData.map((e) => FootballMatchesData.fromJson(e)).toList();

        FootballMatchesModel matchesModel = FootballMatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        print("event by date: $matchesModel");

        return matchesModel;
      } else {
        FootballMatchesModel matchesModel = FootballMatchesModel(
            code: responseCode, msg: responseMsg, data: []);
        print("no data in event by date");
        return matchesModel;
      }
    } catch (e) {
      print("Error in event by date list: $e");
      return null;
    }
  }

  Future<FootballLiveDataModel?> getFootballLiveData(String id) async {
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl + ApiConstants.getFootballMatchByIdUrl + id;
    } else {
      url = ApiConstants.baseUrl + ApiConstants.getFootballMatchByIdENurl + id;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        Map<String, dynamic> jsonData = response['data'];
        FootballLiveData responseData = FootballLiveData.fromJson(jsonData);

        FootballLiveDataModel liveDataModel = FootballLiveDataModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return liveDataModel;
      } else {
        Map<String, dynamic> jsonData = response['data'];
        FootballLiveData responseData = FootballLiveData.fromJson(jsonData);
        FootballLiveDataModel liveDataModel = FootballLiveDataModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return liveDataModel;
      }
    } catch (e) {
      print("Error in get live data: $e");
      return null;
    }
  }

  Future<FootballLineUpModel?> getFootballLineUp(String id) async {
    String url = "";

    if (userDataModel.isCN.value) {
      url = ApiConstants.baseUrl + ApiConstants.getFootballMatchLineUpUrl + id;
    } else {
      url =
          ApiConstants.baseUrl + ApiConstants.getFootballMatchLineUpENurl + id;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        Map<String, dynamic> jsonData = response['data'];
        FootballLineUpData responseData = FootballLineUpData.fromJson(jsonData);
        FootballLineUpModel lineUpModel = FootballLineUpModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return lineUpModel;
      } else {
        FootballLineUpData responseData = response['data'];
        FootballLineUpModel lineUpModel = FootballLineUpModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return lineUpModel;
      }
    } catch (e) {
      print("Error in get line up data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getFootballMatchbyId(
      String id, bool isCN) async {
    if (isCN) {
      final String url =
          ApiConstants.baseUrl + ApiConstants.getFootballMatchByIdUrl + id;

      final response = await service.getRequest(url);
      Map<String, dynamic>? data = response['data'];
      String msg = response['msg'].toString();
      String code = response['code'].toString();

      if (response['data'] == null) {
        return null;
      }

      TournamentDetails tournamentDetails = TournamentDetails(
        id: id,
        matchDate: '',
        matchStatus: '',
        matchName: '',
        homeTeamFormation: '',
        awayTeamFormation: '',
        lineUp: 1,
      );

      return data;
    } else {
      final String url =
          ApiConstants.baseUrl + ApiConstants.getFootballMatchByIdENurl + id;

      final response = await service.getRequest(url);
      Map<String, dynamic>? dataEN = response['data'];
      String msg = response['msg'].toString();
      String code = response['code'].toString();

      if (response['data'] == null) {
        return null;
      }

      return dataEN;
    }
  }

  Future<Map<String, dynamic>> getFootballLineup(
      String matchId, bool isCN) async {
    if (isCN) {
      final String url = ApiConstants.baseUrl +
          ApiConstants.getFootballMatchLineUpUrl +
          matchId;

      final response = await service.getRequest(url);

      String code = response['code'].toString();
      Map<String, dynamic> data = response['data'];
      String msg = response['msg'].toString();

      return data;
    } else {
      final String url = ApiConstants.baseUrl +
          ApiConstants.getFootballMatchLineUpENurl +
          matchId;

      final response = await service.getRequest(url);

      String code = response['code'].toString();
      Map<String, dynamic> dataEN = response['data'];
      String msg = response['msg'].toString();

      return dataEN;
    }
  }
}
