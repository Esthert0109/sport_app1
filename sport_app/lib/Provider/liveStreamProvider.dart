import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sport_app/Services/commonServices.dart';

import '../Constants/apiConstant.dart';

class LiveStreamProvider extends ChangeNotifier {
  CommonServices service = CommonServices();

  Future<List<dynamic>?> getPopularLiveStreamList() async {
    final String url =
        ApiConstants.baseUrl + ApiConstants.getPopularLiveStreamListUrl;

    final response = await service.getRequest(url);

    String code = response['code'].toString();
    String msg = response['msg'].toString();
    List<dynamic>? data = response['data'];

    if (code == '0') {
      print('get popular live stream successfully');
      return data;
    } else {
      print('error $msg');
      return [];
    }
  }

  Future<List<dynamic>?> getAllLiveStreamList() async {
    final String url =
        ApiConstants.baseUrl + ApiConstants.getAllLiveStreamListUrl;

    final response = await service.getRequest(url);

    String code = response['code'].toString();
    String msg = response['msg'].toString();
    List<dynamic>? data = response['data'];

    if (code == '0') {
      print('get all live stream successfully');
      return data;
    } else {
      print('error $msg');
      return [];
    }
  }
}
