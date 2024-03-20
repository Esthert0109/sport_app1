class CreateFollowModel {
  final int code;
  final String msg;
  final bool data;

  CreateFollowModel(
      {required this.code, required this.msg, required this.data});

  Map<String, dynamic> toJson() {
    return {'code': code, 'msg': msg, 'data': data};
  }

  factory CreateFollowModel.fromJson(Map<String, dynamic> json) {
    return CreateFollowModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}

class FollowModel {
  final int code;
  final String msg;
  final List<FollowData> data;

  FollowModel({
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

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<FollowData>.from(
                json['data'].map((data) => FollowData.fromJson(data)))
            : []);
  }
}

class FollowData {
  final int id;
  final int anchorId;
  final AnchorDetails anchorDetails;
  final bool streamingStatus;
  final LiveStreamDetails? liveStreamDetails;
  final int followerId;
  final String followCreatedTime;
  final String followUpdatedTime;

  FollowData(
      {required this.id,
      required this.anchorId,
      required this.streamingStatus,
      required this.anchorDetails,
      required this.followerId,
      required this.followCreatedTime,
      required this.followUpdatedTime,
      this.liveStreamDetails});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anchorId': anchorId,
      'anchorDetails': anchorDetails,
      'streamingStatus': streamingStatus,
      'liveStreamDetails': liveStreamDetails,
      'followerId': followerId,
      'followCreatedTime': followCreatedTime,
      'followUpdatedTime': followUpdatedTime,
    };
  }

  factory FollowData.fromJson(Map<String, dynamic> json) {
    return FollowData(
      id: json['id'],
      anchorId: json['anchorId'],
      anchorDetails: AnchorDetails.fromJson(json['anchorDetails']),
      streamingStatus: json['streamingStatus'],
      liveStreamDetails: json['liveStreamDetails'] != null
          ? LiveStreamDetails.fromJson(json['liveStreamDetails'])
          : null,
      followerId: json['followerId'],
      followCreatedTime: json['followCreatedTime'],
      followUpdatedTime: json['followUpdatedTime'],
    );
  }
}

class AnchorDetails {
  final int id;
  final String nickName;
  final String head;

  AnchorDetails({
    required this.id,
    required this.nickName,
    required this.head,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickName': nickName,
      'head': head,
    };
  }

  factory AnchorDetails.fromJson(Map<String, dynamic> json) {
    return AnchorDetails(
      id: json['id'],
      nickName: json['nickName'],
      head: json['head'],
    );
  }
}

class LiveStreamDetails {
  final int id;
  final int userId;
  final String sportType;
  final String cover;
  final String title;
  final String pushHost;
  final String pushCode;
  final String isPopular;
  final String liveDate;

  LiveStreamDetails({
    required this.id,
    required this.userId,
    required this.sportType,
    required this.cover,
    required this.title,
    required this.pushHost,
    required this.pushCode,
    required this.isPopular,
    required this.liveDate,
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
    };
  }

  factory LiveStreamDetails.fromJson(Map<String, dynamic> json) {
    return LiveStreamDetails(
      id: json['id'],
      userId: json['userId'],
      sportType: json['sportType'],
      cover: json['cover'],
      title: json['title'],
      pushHost: json['pushHost'],
      pushCode: json['pushCode'],
      isPopular: json['isPopular'],
      liveDate: json['liveDate'],
    );
  }
}
