class LiveStreamModel {
  final int code;
  final String msg;
  final List<LiveStreamData> data;

  LiveStreamModel({required this.code, required this.msg, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList()
    };
  }

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<LiveStreamData>.from(
                json['data'].map((data) => LiveStreamData.fromJson(data)))
            : []);
  }
}

class LiveStreamData {
  final int? id;
  final int? userId;
  final String? sportType;
  final String? cover;
  final String? title;
  final String? pushHost;
  final String? pushCode;
  final String? isPopular;
  final String? liveDate;
  final String? nickName;
  final String? avatar;

  LiveStreamData({
    this.id,
    this.userId,
    this.sportType,
    this.cover,
    this.title,
    this.pushHost,
    this.pushCode,
    this.isPopular,
    this.liveDate,
    this.nickName,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "sportType": sportType,
      "cover": cover,
      "title": title,
      "pushHost": pushHost,
      "pushCode": pushCode,
      "isPopular": isPopular,
      "liveDate": liveDate,
      "nickName": nickName,
      "avatar": avatar,
    };
  }

  factory LiveStreamData.fromJson(Map<String, dynamic> json) {
    return LiveStreamData(
      id: json['id'],
      userId: json['userId'],
      sportType: json['sportType'],
      cover: json['cover'],
      title: json['title'],
      pushHost: json['pushHost'],
      pushCode: json['pushCode'],
      isPopular: json['isPopular'],
      liveDate: json['liveDate'],
      nickName: json['nickName'],
      avatar: json['avatar'],
    );
  }
}
