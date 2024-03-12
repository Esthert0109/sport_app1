class PopularGameModel {
  final int code;
  final String msg;
  final List<PopularGameData> data;

  PopularGameModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList()
    };
  }

  factory PopularGameModel.fromJson(Map<String, dynamic> json) {
    return PopularGameModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<PopularGameData>.from(
                json['data'].map((data) => PopularGameData.fromJson(data)))
            : []);
  }
}

class PopularGameData {
  final int id;
  final String gameNameEn;
  final String gameNameCn;
  final String gameLogo;
  final String gameAndroidUrl;
  final String gameIphoneUrl;
  final int sort;
  final int createdTime;
  final int updatedTime;

  PopularGameData({
    required this.id,
    required this.gameNameEn,
    required this.gameNameCn,
    required this.gameLogo,
    required this.gameAndroidUrl,
    required this.gameIphoneUrl,
    required this.sort,
    required this.createdTime,
    required this.updatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "gameNameEn": gameNameEn,
      "gameNameCn": gameNameCn,
      "gameLogo": gameLogo,
      "gameAndroidUrl": gameAndroidUrl,
      "gameIphoneUrl": gameIphoneUrl,
      "sort": sort,
      "createdTime": createdTime,
      "updatedTime": updatedTime,
    };
  }

  factory PopularGameData.fromJson(Map<String, dynamic> json) {
    return PopularGameData(
      id: json['id'],
      gameNameEn: json['gameNameEn'],
      gameNameCn: json['gameNameCn'],
      gameLogo: json['gameLogo'],
      gameAndroidUrl: json['gameAndroidUrl'],
      gameIphoneUrl: json['gameIphoneUrl'],
      sort: json['sort'],
      createdTime: json['createdTime'],
      updatedTime: json['updatedTime'],
    );
  }
}
