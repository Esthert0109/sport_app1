import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'GenerateTestUserSig.dart';

final int _sdkAppID = 20008621; // 前置条件中创建的IM应用SDKAppID

initAndLoginIm() {
  TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: _sdkAppID,
      loglevel: LogLevelEnum.V2TIM_LOG_ALL,
      listener: V2TimSDKListener());
}

Future<bool> userLogin(String userID) async {
  final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();

  int sdkAppId = 20008621;
  String key =
      "8361f9a2a0d838abf63b7a32f51acd896ca3d0ded3c5cefbd92009645ac83779";

  GenerateTestUserSig generateTestUserSig = GenerateTestUserSig(
    sdkappId: sdkAppId,
    key: key,
  );

  String userSig = GenerateTestUserSig.genTestSig(userID);

  var data = await coreInstance.login(
    userID: userID,
    userSig: userSig,
  );

  if (data.code != 0) {
    print("login tencent error");
    return false; // Return false if login failed
  }

  return true; // Return true if login was successful
}

Future<bool> setNickNameTencent(String userID, String nickName) async {
  final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
  bool isChangeNickname = await userLogin(userID);

  if (isChangeNickname) {
    V2TimCallback setSelfInfoRes = await coreInstance.setSelfInfo(
        userFullInfo: V2TimUserFullInfo.fromJson({
      "nickName": nickName,
    }));
    if (setSelfInfoRes.code == 0) {
      return true;
    }
    return false;
  }
  return false;
}

Future<bool> setAvatarTencent(String userID, String avatar) async {
  final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
  bool isChangeAvatar = await userLogin(userID);

  if (isChangeAvatar) {
    V2TimCallback setSelfInfoRes = await coreInstance.setSelfInfo(
        userFullInfo: V2TimUserFullInfo.fromJson({
      "faceUrl": avatar,
    }));
    if (setSelfInfoRes.code == 0) {
      return true;
    }
    return false;
  }
  return false;
}

Future<bool> registerTencent(
    String userID, String nickName, String avatar) async {
  final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
  bool isChangeRegister = await userLogin(userID);

  if (isChangeRegister) {
    V2TimCallback setSelfInfoRes = await coreInstance.setSelfInfo(
        userFullInfo: V2TimUserFullInfo.fromJson(
            {"nickName": nickName, "faceUrl": avatar}));
    if (setSelfInfoRes.code == 0) {
      return true;
    }
    return false;
  }
  return false;
}
