class CollectionModel {
  final int code;
  final String msg;
  final CollectionData data;

  CollectionModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {"code": code, "msg": msg, "data": data};
  }

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}

class CollectionData {
  final int? id;
  final int? userId;
  final int? matchId;
  final String? category;
  final String? status;

  CollectionData({
    this.id,
    this.userId,
    this.matchId,
    this.category,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "matchId": matchId,
      "category": category,
      "status": status,
    };
  }

  factory CollectionData.fromJson(Map<String, dynamic> json) {
    return CollectionData(
      id: json['id'],
      userId: json['userId'],
      matchId: json['matchId'],
      category: json['category'],
      status: json['status'],
    );
  }
}

class DelCollectionModel {
  final int code;
  final String msg;
  final bool data;

  DelCollectionModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {"code": code, "msg": msg, "data": data};
  }

  factory DelCollectionModel.fromJson(Map<String, dynamic> json) {
    return DelCollectionModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}
