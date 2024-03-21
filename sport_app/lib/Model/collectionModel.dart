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

class CollectMatchesModel {
  final int code;
  final String msg;
  final List<CollectMatchesData> data;

  CollectMatchesModel(
      {required this.code, required this.msg, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList()
    };
  }

  factory CollectMatchesModel.fromJson(Map<String, dynamic> json) {
    return CollectMatchesModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<CollectMatchesData>.from(
                json['data'].map((data) => CollectMatchesData.fromJson(data)))
            : []);
  }
}

class AllCollectMatchesModel {
  final int code;
  final String msg;
  final List<AllCollectMatchesData> data;

  AllCollectMatchesModel(
      {required this.code, required this.msg, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList()
    };
  }

  factory AllCollectMatchesModel.fromJson(Map<String, dynamic> json) {
    return AllCollectMatchesModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<AllCollectMatchesData>.from(json['data']
                .map((data) => AllCollectMatchesData.fromJson(data)))
            : []);
  }
}

class AllCollectMatchesData {
  final String date;
  final List<CollectMatchesData> data;

  AllCollectMatchesData({required this.date, required this.data});

  Map<String, dynamic> toJson() {
    return {'date': date, 'data': data.map((item) => item.toJson()).toList()};
  }

  factory AllCollectMatchesData.fromJson(Map<String, dynamic> json) {
    return AllCollectMatchesData(
        date: json['date'],
        data: json['data'] != null
            ? List<CollectMatchesData>.from(
                json['data'].map((data) => CollectMatchesData.fromJson(data)))
            : []);
  }
}

class CollectMatchesData {
  final int? id;
  final int? competitionId;
  final String? competitionName;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? homeTeamName;
  final String? awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final int? matchTime;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? statusId;
  final String? matchTimeStr;
  final String? statusStr;
  final String? matchDate;
  final bool? hasCollected;
  final String? homeFormation;
  final String? awayFormation;
  final int? lineUp;

  CollectMatchesData({
    this.id,
    this.competitionId,
    this.competitionName,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
    this.matchTime,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.statusId,
    this.matchTimeStr,
    this.statusStr,
    this.matchDate,
    this.hasCollected,
    this.awayFormation,
    this.homeFormation,
    this.lineUp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competitionId': competitionId,
      'competitionName': competitionName,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamScore': homeTeamScore,
      'awayTeamScore': awayTeamScore,
      'matchTime': matchTime,
      'homeTeamLogo': homeTeamLogo,
      'awayTeamLogo': awayTeamLogo,
      'statusId': statusId,
      'matchTimeStr': matchTimeStr,
      'statusStr': statusStr,
      'matchDate': matchDate,
      'hasCollected': hasCollected,
      "awayFormation": awayFormation,
      "homeFormation": homeFormation,
      "lineUp": lineUp,
    };
  }

  factory CollectMatchesData.fromJson(Map<String, dynamic> json) {
    return CollectMatchesData(
      id: json['id'],
      competitionId: json['competitionId'],
      competitionName: json['competitionName'],
      homeTeamId: json['homeTeamId'],
      awayTeamId: json['awayTeamId'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamScore: json['homeTeamScore'],
      awayTeamScore: json['awayTeamScore'],
      matchTime: json['matchTime'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLogo: json['awayTeamLogo'],
      statusId: json['statusId'],
      matchTimeStr: json['matchTimeStr'],
      statusStr: json['statusStr'],
      matchDate: json['matchDate'],
      hasCollected: json['hasCollected'],
      awayFormation: json['awayFormation'],
      homeFormation: json['homeFormation'],
      lineUp: json['lineUp'],
    );
  }
}
