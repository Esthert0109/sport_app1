import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';
import '../Model/liveStreamModel.dart';

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

  Future<LiveStreamModel?> getAllLiveStreamList() async {
    final String url =
        ApiConstants.baseUrl + ApiConstants.getAllLiveStreamListUrl;

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
}
