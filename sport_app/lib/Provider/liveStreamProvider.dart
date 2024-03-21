import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Model/liveStreamModel.dart';
import '../Services/Utils/httpUtil.dart';

class LiveStreamProvider extends ChangeNotifier {
  CommonServices service = CommonServices();

  Future<LiveStreamModel?> getPopularLiveStreamList() async {
    final String url =
        ApiConstants.baseUrl + ApiConstants.getPopularLiveStreamListUrl;

    try {
      final response = await service.getRequest(url);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<LiveStreamData> responseData =
            jsonData.map((e) => LiveStreamData.fromJson(e)).toList();

        LiveStreamModel liveStreamModel = LiveStreamModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return liveStreamModel;
      } else {
        LiveStreamModel liveStreamModel =
            LiveStreamModel(code: responseCode, msg: responseMsg, data: []);
        return liveStreamModel;
      }
    } catch (e) {
      print("Errror in get live stream: $e");
      return null;
    }
  }

  Future<LiveStreamModel?> getAllLiveStreamList(int page, int size) async {
    final String url = ApiConstants.baseUrl +
        ApiConstants.getAllLiveStreamListUrl +
        "?page=$page&size=$size";

    try {
      final response = await service.getRequest(url);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<LiveStreamData> responseData =
            jsonData.map((e) => LiveStreamData.fromJson(e)).toList();

        LiveStreamModel liveStreamModel = LiveStreamModel(
            code: responseCode, msg: responseMsg, data: responseData);
        return liveStreamModel;
      } else {
        LiveStreamModel liveStreamModel =
            LiveStreamModel(code: responseCode, msg: responseMsg, data: []);
        return liveStreamModel;
      }
    } catch (e) {
      print("Errror in get live stream: $e");
      return null;
    }
  }

  Future<AnimationStreamModel?> getAnimationUrl(
      String sportType, String matchId) async {
    String url = ApiConstants.baseUrl +
        ApiConstants.getAnimationUrl +
        "${sportType}/${matchId}";

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);
      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        String responseData = response['data'];

        AnimationStreamModel model = AnimationStreamModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return model;
      } else {
        AnimationStreamModel model = AnimationStreamModel(
            code: responseCode, msg: responseMsg, data: "");
        return model;
      }
    } catch (e) {
      print("Error in animation url: $e");
      return null;
    }
  }

  Future<AnimationStreamModel?> getLiveUrl(
      String sportType, String matchId) async {
    String url = ApiConstants.baseUrl +
        ApiConstants.getLiveUrl +
        "${sportType}/${matchId}";

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);
      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        String responseData = response['data'];

        AnimationStreamModel model = AnimationStreamModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return model;
      } else {
        AnimationStreamModel model = AnimationStreamModel(
            code: responseCode, msg: responseMsg, data: "");
        return model;
      }
    } catch (e) {
      print("Error in live url: $e");
      return null;
    }
  }
}
