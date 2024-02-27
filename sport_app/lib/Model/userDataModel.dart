import 'package:get/get.dart';

class UserDataModel extends GetxController {
  var token = ''.obs;
  var userName = ''.obs;
  var profilePicture = ''.obs;
  var id = ''.obs;
  var isFootball = false.obs; //保存token,名字与号码
  var isCN = true.obs;

  void saveNameAndContact(
      String newtoken, String newName, String newId, String newPicture) {
    token.value = newtoken;
    userName.value = newName;
    profilePicture.value = newPicture;
    id.value = newId;
  }
}
