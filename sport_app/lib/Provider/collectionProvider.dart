import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Model/collectionModel.dart';
import 'package:sport_app/Services/Utils/httpUtil.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Model/userDataModel.dart';
import '../Services/Utils/sharedPreferencesUtils.dart';

class BookmarkProvider extends ChangeNotifier {
  // services
  CommonServices service = CommonServices();

  // get user info
  UserDataModel userModel = Get.find<UserDataModel>();

  Future<CollectionModel?> createCollection(int matchId) async {
    String url = "";
    String category = "";

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

    final Map<String, dynamic> collectionData = {
      'matchId': matchId,
      'category': category,
    };

    try {
      final response = await service.postRequestWithToken(url, collectionData);
      print("response from create collection");

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      print("create collection: url:$url, response: $response");

      if (responseCode == 0) {
        CollectionData responseData = CollectionData.fromJson(response['data']);

        CollectionModel collectionModel = CollectionModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return collectionModel;
      } else {
        CollectionData responseData = CollectionData.fromJson(response['data']);
        CollectionModel collectionModel = CollectionModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return collectionModel;
      }
    } catch (e) {
      print("Error in create collection: $e");
      return null;
    }
  }

  Future<DelCollectionModel?> deleteCollection(int matchId) async {
    String url = '';

    if (userModel.isCN.value) {
      url = ApiConstants.baseUrl +
          ApiConstants.deleteCollectionByMatchIdUrl +
          "${matchId.toString()}";
    } else {
      url = ApiConstants.baseUrl +
          ApiConstants.deleteCollectionEngByMatchIdUrl +
          "${matchId.toString()}";
    }

    try {
      final response = await service.deleteRequest(url);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      print("delete collection: url:$url, response: $response");

      if (responseCode == 0) {
        bool responseData = response['data'];
        DelCollectionModel delCollectionModel = DelCollectionModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return delCollectionModel;
      } else {
        bool responseData = response['data'];
        DelCollectionModel delCollectionModel = DelCollectionModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return delCollectionModel;
      }
    } catch (e) {
      print("Error in delete collection: $e");
      return null;
    }
  }

  Future<CollectMatchesModel?> getThreeCollection() async {
    String url = ApiConstants.baseUrl +
        ApiConstants.getAllStreamCollectionListEngUrlBasketball +
        '/3';

    final token = await SharedPreferencesUtils.getSavedToken();

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'token': token!,
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<CollectMatchesData> responseData =
            jsonData.map((e) => CollectMatchesData.fromJson(e)).toList();

        CollectMatchesModel collectMatchesModel = CollectMatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return collectMatchesModel;
      } else {
        CollectMatchesModel collectMatchesModel =
            CollectMatchesModel(code: responseCode, msg: responseMsg, data: []);

        return collectMatchesModel;
      }
    } catch (e) {
      print("Errror in get 3 collections: $e");
      return null;
    }
  }

  Future<AllCollectMatchesModel?> getAllBasketballCollection(
      int page, int size) async {
    String url = ApiConstants.baseUrl +
        ApiConstants.getAllStreamCollectionListEngUrlBasketball +
        "?page=${page}&size=${size}";

    final token = await SharedPreferencesUtils.getSavedToken();

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'token': token!,
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<AllCollectMatchesData> responseData =
            jsonData.map((e) => AllCollectMatchesData.fromJson(e)).toList();

        AllCollectMatchesModel allCollectMatchesModel = AllCollectMatchesModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return allCollectMatchesModel;
      } else {
        AllCollectMatchesModel allCollectMatchesModel = AllCollectMatchesModel(
            code: responseCode, msg: responseMsg, data: []);

        return allCollectMatchesModel;
      }
    } catch (e) {
      print("Error in get all collections: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> liveStreamSaveBookmark(String matchId) async {
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
