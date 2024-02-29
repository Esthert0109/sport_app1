import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Model/userDataModel.dart';

class SearchEventProvider extends ChangeNotifier {
  CommonServices service = CommonServices();
  UserDataModel userModel = Get.find<UserDataModel>();

  Future<List> searchLiveCompetitionStream(
      String matchName, String searchPages) async {
    String url = "";
    if (userModel.isCN == true) {
      if (userModel.isFootball.value) {
        url = ApiConstants.baseUrl + ApiConstants.searchFootballMatchTodayUrl;
      } else {
        url = ApiConstants.baseUrl + ApiConstants.searchBasketballTodayUrl;
      }
    } else {
      if (userModel.isFootball.value) {
        url = ApiConstants.baseUrl + ApiConstants.searchFootballMatchTodayENurl;
      } else {
        url = ApiConstants.baseUrl + ApiConstants.searchBasketballTodayENurl;
      }
    }

    final Map<String, String> searchMatchData = {
      'competitionName': matchName,
      'page': searchPages,
    };

    try {
      final Uri combineUrI =
          Uri.parse(url).replace(queryParameters: searchMatchData);
      final String fullUrI = combineUrI.toString();
      print(fullUrI);
      final response = await service.getRequest(fullUrI);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      List<dynamic> data = [];
      if (response['data'] != null) {
        data = response['data'];
      }
      String token = response['token'].toString();
      String? responseMsg;

      if (code == '0') {
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

  Future<List> searchLiveTeamStream(
      String matchName, String searchPages) async {
    String url = "";
    if (userModel.isCN == true) {
      if (userModel.isFootball == true) {
        url = ApiConstants.baseUrl + ApiConstants.searchFootballMatchTodayUrl;
      } else {
        url = ApiConstants.baseUrl + ApiConstants.searchBasketballTodayUrl;
      }
    } else if (userModel.isFootball == true) {
      url = ApiConstants.baseUrl + ApiConstants.searchFootballMatchTodayENurl;
    } else {
      url = ApiConstants.baseUrl + ApiConstants.searchBasketballTodayENurl;
    }

    final Map<String, String> searchMatchData = {
      'teamName': matchName,
      'page': searchPages,
    };

    try {
      final Uri combineUrI =
          Uri.parse(url).replace(queryParameters: searchMatchData);
      final String fullUrI = combineUrI.toString();
      print(fullUrI);
      final response = await service.getRequest(fullUrI);

      String code = response['code'].toString();
      String msg = response['msg'].toString();
      List<dynamic> data = [];
      if (response['data'] != null) {
        data = response['data'];
      }
      String token = response['token'].toString();
      String? responseMsg;

      if (code == '0') {
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

  Future<List<dynamic>?> getPopularSearchList() async {
    String url = '';

    if (userModel.isCN.value == true) {
      url = ApiConstants.baseUrl + ApiConstants.getPopularSearchListUrl;
    } else {
      //English version
      url = ApiConstants.baseUrl + ApiConstants.getPopularSearchListUrl;
    }

    final response = await service.getRequest(url);
    String code = response['code'].toString();
    String msg = response['msg'].toString();
    List<dynamic>? popularSearchList = response['data'];

    return popularSearchList;
  }

  //=======================================Basketball======================================//
  Future<List> searchTodayBasketballMatches(
      String matchName, int currentPage, int pageSize) async {
    String url = '';
    if (userModel.isCN == true) {
      url = ApiConstants.baseUrl + ApiConstants.searchBasketballTodayUrl;
    }

    final response = await service.getRequest(url);
    String code = response['code'].toString();
    String msg = response['success'].toString();
    List<dynamic> data = response['data'];

    if (code == '0') {
      return data;
    } else {
      debugPrint("Error: $msg");
      return [];
    }
  }
}
