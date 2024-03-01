class MatchesModel {
  final int code;
  final String msg;
  final List<MatchesData> data;

  MatchesModel({
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

  factory MatchesModel.fromJson(Map<String, dynamic> json) {
    return MatchesModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<MatchesData>.from(
                json['data'].map((data) => MatchesData.fromJson(data)))
            : []);
  }
}

class StartedMatchesModel {
  final int code;
  final String msg;
  final StartedMatchesData data;

  StartedMatchesModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "msg": msg,
      "data": data,
    };
  }

  factory StartedMatchesModel.fromJson(Map<String, dynamic> json) {
    return StartedMatchesModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}

class StartedMatchesData {
  List<MatchesData>? start;

  StartedMatchesData({this.start});

  Map<String, dynamic> toJson() {
    return {'start': start?.map((item) => item.toJson()).toList()};
  }

  factory StartedMatchesData.fromJson(Map<String, dynamic> json) {
    return StartedMatchesData(
        start: json['start'] != null
            ? List<MatchesData>.from(
                json['start'].map((data) => MatchesData.fromJson(data)))
            : []);
  }
}

class MatchesData {
  final int? id;
  final int? competitionId;
  final String? competitionName;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? homeTeamName;
  final String? awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final String? matchTime;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? statusId;
  final String? matchTimeStr;
  final String? statusStr;
  final String? matchDate;
  final bool? hasCollected;

  MatchesData({
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
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "competitionId": competitionId,
      "competitionName": competitionName,
      "homeTeamId": homeTeamId,
      "awayTeamId": awayTeamId,
      "homeTeamName": homeTeamName,
      "awayTeamName": awayTeamName,
      "homeTeamScore": homeTeamScore,
      "awayTeamScore": awayTeamScore,
      "matchTime": matchTime,
      "homeTeamLogo": homeTeamLogo,
      "awayTeamLogo": awayTeamLogo,
      "statusId": statusId,
      "matchTimeStr": matchTimeStr,
      "statusStr": statusStr,
      "matchDate": matchDate,
      "hasCollected": hasCollected,
    };
  }

  factory MatchesData.fromJson(Map<String, dynamic> json) {
    return MatchesData(
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
    );
  }
}
