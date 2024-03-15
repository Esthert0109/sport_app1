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
  final int followerId;
  final String followCreatedTime;
  final String followUpdatedTime;

  FollowData({
    required this.id,
    required this.anchorId,
    required this.streamingStatus,
    required this.anchorDetails,
    required this.followerId,
    required this.followCreatedTime,
    required this.followUpdatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anchorId': anchorId,
      'anchorDetails': anchorDetails,
      'streamingStatus': streamingStatus,
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
