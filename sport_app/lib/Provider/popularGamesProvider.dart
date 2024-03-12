import 'package:flutter/material.dart';

import '../Constants/apiConstant.dart';
import '../Model/popularGameModel.dart';
import '../Services/Utils/httpUtil.dart';
import '../Services/commonServices.dart';

class PopularGameProvider extends ChangeNotifier {
  CommonServices service = CommonServices();

  Future<PopularGameModel?> getPopularGameList() async {
    String url = ApiConstants.localhost + ApiConstants.getPopularGameList;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    try {
      final response = await sendGetRequest(url, headers);

      int responseCode = response['code'];
      String responseMsg = response['msg'];

      if (responseCode == 0) {
        List<dynamic> jsonData = response['data'];
        List<PopularGameData> responseData =
            jsonData.map((e) => PopularGameData.fromJson(e)).toList();

        PopularGameModel popularGameModel = PopularGameModel(
            code: responseCode, msg: responseMsg, data: responseData);

        return popularGameModel;
      } else {
        PopularGameModel popularGameModel =
            PopularGameModel(code: responseCode, msg: responseMsg, data: []);

        return popularGameModel;
      }
    } catch (e) {
      print("Error in popular game list: $e");
      return null;
    }
  }
}
