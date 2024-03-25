import 'package:flutter/material.dart';
import 'package:sport_app/Constants/apiConstant.dart';

import '../Model/infoModel.dart';
import '../Services/Utils/httpUtil.dart';

class InfoProvider extends ChangeNotifier {
  Future<InfoCategoryModel?> getInfoCategories() async {
    String url = ApiConstants.baseUrl + ApiConstants.getCategoriesList;

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<InfoCategoryData> responseData =
            jsonData.map((e) => InfoCategoryData.fromJson(e)).toList();

        InfoCategoryModel infoModel = InfoCategoryModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return infoModel;
      } else {
        InfoCategoryModel infoModel =
            InfoCategoryModel(code: responseCode, msg: responseMsg, data: []);

        return infoModel;
      }
    } catch (e) {
      print("Error in info cat: $e");
      return null;
    }
  }

  Future<InfoListModel?> getInfoList(int page, int size, int search) async {
    String url = ApiConstants.baseUrl +
        ApiConstants.getInfoList +
        "page=${page}&size=${size}&search=${search}";

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<InfoListData> responseData =
            jsonData.map((e) => InfoListData.fromJson(e)).toList();

        InfoListModel infoModel = InfoListModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return infoModel;
      } else {
        InfoListModel infoModel =
            InfoListModel(code: responseCode, msg: responseMsg, data: []);

        return infoModel;
      }
    } catch (e) {
      print("Error in info list: $e");
      return null;
    }
  }

  Future<InfoDetailsModel?> getInfoDetail(int id) async {
    String url = ApiConstants.baseUrl + ApiConstants.getInfoDetail + "${id}";

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        Map<String, dynamic> jsonData = response['data'];
        InfoListData responseData = InfoListData.fromJson(jsonData);

        InfoDetailsModel model = InfoDetailsModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return model;
      } else {
        Map<String, dynamic> jsonData = response['data'];
        InfoListData responseData = InfoListData.fromJson(jsonData);

        InfoDetailsModel model = InfoDetailsModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return model;
      }
    } catch (e) {
      print("Error in get info details: $e");
      return null;
    }
  }

  Future<InfoListModel?> getPopularInfoList(int id)async {
    String url = ApiConstants.baseUrl +
        ApiConstants.getPopularInfoList +
        "${id}";

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<InfoListData> responseData =
            jsonData.map((e) => InfoListData.fromJson(e)).toList();

        InfoListModel infoModel = InfoListModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return infoModel;
      } else {
        InfoListModel infoModel =
            InfoListModel(code: responseCode, msg: responseMsg, data: []);

        return infoModel;
      }
    } catch (e) {
      print("Error in popular info list: $e");
      return null;
    }
  }
}
