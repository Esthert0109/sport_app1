import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport_app/Model/userDataModel.dart';

class BasketballMatchProvider extends ChangeNotifier {
  UserDataModel userDataModel = Get.find<UserDataModel>();
}
