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
  final int? matchTime;
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

class FootballMatchesModel {
  final int code;
  final String msg;
  final List<FootballMatchesData> data;

  FootballMatchesModel({
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

  factory FootballMatchesModel.fromJson(Map<String, dynamic> json) {
    return FootballMatchesModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<FootballMatchesData>.from(
                json['data'].map((data) => FootballMatchesData.fromJson(data)))
            : []);
  }
}

class FootballStartedMatchesModel {
  final int code;
  final String msg;
  final FootballStartedMatchesData data;

  FootballStartedMatchesModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {'code': code, 'msg': msg, 'data': data};
  }

  factory FootballStartedMatchesModel.fromJson(Map<String, dynamic> json) {
    return FootballStartedMatchesModel(
        code: json['code'], msg: json['msg'], data: json['data']);
  }
}

class FootballStartedMatchesData {
  List<FootballMatchesData>? start;

  FootballStartedMatchesData({this.start});

  Map<String, dynamic> toJson() {
    return {'start': start?.map((item) => item.toJson()).toList()};
  }

  factory FootballStartedMatchesData.fromJson(Map<String, dynamic> json) {
    return FootballStartedMatchesData(
        start: json['start'] != null
            ? List<FootballMatchesData>.from(
                json['start'].map((data) => FootballMatchesData.fromJson(data)))
            : []);
  }
}

class FootballMatchesData {
  final int? id;
  final int? competitionId;
  final String? homeTeamName;
  final String? awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final int? matchTime;
  final String? competitionName;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? statusId;
  final String? matchTimeStr;
  final String? statusStr;
  final int? lineUp;
  final String? refereeName;
  final String? venueName;
  final String? homeFormation;
  final String? awayFormation;
  final String? matchDate;
  final bool? hasCollected;

  FootballMatchesData({
    this.id,
    this.competitionId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
    this.matchTime,
    this.competitionName,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.statusId,
    this.matchTimeStr,
    this.statusStr,
    this.lineUp,
    this.refereeName,
    this.venueName,
    this.homeFormation,
    this.awayFormation,
    this.matchDate,
    this.hasCollected,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "competitionId": competitionId,
      "homeTeamName": homeTeamName,
      "awayTeamName": awayTeamName,
      "homeTeamScore": homeTeamScore,
      "awayTeamScore": awayTeamScore,
      "matchTime": matchTime,
      "competitionName": competitionName,
      "homeTeamLogo": homeTeamLogo,
      "awayTeamLogo": awayTeamLogo,
      "statusId": statusId,
      "matchTimeStr": matchTimeStr,
      "statusStr": statusStr,
      "lineUp": lineUp,
      "refereeName": refereeName,
      "venueName": venueName,
      "homeFormation": homeFormation,
      "awayFormation": awayFormation,
      "matchDate": matchDate,
      "hasCollected": hasCollected
    };
  }

  factory FootballMatchesData.fromJson(Map<String, dynamic> json) {
    return FootballMatchesData(
      id: json['id'],
      competitionId: json['competitionId'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamScore: json['homeTeamScore'],
      awayTeamScore: json['awayTeamScore'],
      matchTime: json['matchTime'],
      competitionName: json['competitionName'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLogo: json['awayTeamLogo'],
      statusId: json['statusId'],
      matchTimeStr: json['matchTimeStr'],
      statusStr: json['statusStr'],
      lineUp: json['lineUp'],
      refereeName: json['refereeName'],
      venueName: json['venueName'],
      homeFormation: json['homeFormation'],
      awayFormation: json['awayFormation'],
      matchDate: json['matchDate'],
      hasCollected: json['hasCollected'],
    );
  }
}

// search model
class SearchMatchesModel {
  final int code;
  final String msg;
  final List<SearchMatchesData> data;

  SearchMatchesModel(
      {required this.code, required this.msg, required this.data});

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList()
    };
  }

  factory SearchMatchesModel.fromJson(Map<String, dynamic> json) {
    return SearchMatchesModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<SearchMatchesData>.from(
                json['data'].map((data) => SearchMatchesData.fromJson(data)))
            : []);
  }
}

class SearchMatchesData {
  final int? id;
  final int? competitionId;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? homeTeamName;
  final String? awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final String? matchTime;
  final String? competitionName;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? statusId;
  final String? matchTimeStr;
  final String? statusStr;
  final int? lineUp;
  final String? refereeName;
  final String? venueName;
  final String? homeFormation;
  final String? awayFormation;
  final String? matchDate;
  final bool? hasCollected;

  SearchMatchesData({
    this.id,
    this.competitionId,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
    this.matchTime,
    this.competitionName,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.statusId,
    this.matchTimeStr,
    this.statusStr,
    this.lineUp,
    this.refereeName,
    this.venueName,
    this.homeFormation,
    this.awayFormation,
    this.matchDate,
    this.hasCollected,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "competitionId": competitionId,
      "homeTeamId": homeTeamId,
      "awayTeamId": awayTeamId,
      "homeTeamName": homeTeamName,
      "awayTeamName": awayTeamName,
      "homeTeamScore": homeTeamScore,
      "awayTeamScore": awayTeamScore,
      "matchTime": matchTime,
      "competitionName": competitionName,
      "homeTeamLogo": homeTeamLogo,
      "awayTeamLogo": awayTeamLogo,
      "statusId": statusId,
      "matchTimeStr": matchTimeStr,
      "statusStr": statusStr,
      "lineUp": lineUp,
      "refereeName": refereeName,
      "venueName": venueName,
      "homeFormation": homeFormation,
      "awayFormation": awayFormation,
      "matchDate": matchDate,
      "hasCollected": hasCollected,
    };
  }

  factory SearchMatchesData.fromJson(Map<String, dynamic> json) {
    return SearchMatchesData(
      id: json['id'],
      competitionId: json['competitionId'],
      homeTeamId: json['homeTeamId'],
      awayTeamId: json['awayTeamId'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamScore: json['homeTeamScore'],
      awayTeamScore: json['awayTeamScore'],
      matchTime: json['matchTime'],
      competitionName: json['competitionName'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLogo: json['awayTeamLogo'],
      statusId: json['statusId'],
      matchTimeStr: json['matchTimeStr'],
      statusStr: json['statusStr'],
      lineUp: json['lineUp'],
      refereeName: json['refereeName'],
      venueName: json['venueName'],
      homeFormation: json['homeFormation'],
      awayFormation: json['awayFormation'],
      matchDate: json['matchDate'],
      hasCollected: json['hasCollected'],
    );
  }
}

class PopularKeyWordsModel {
  final int code;
  final String msg;
  final List<PopularKeyWordsData> data;

  PopularKeyWordsModel({
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

  factory PopularKeyWordsModel.fromJson(Map<String, dynamic> json) {
    return PopularKeyWordsModel(
        code: json['code'],
        msg: json['msg'],
        data: json['data'] != null
            ? List<PopularKeyWordsData>.from(
                json['data'].map((data) => PopularKeyWordsData.fromJson(data)))
            : []);
  }
}

class PopularKeyWordsData {
  final String popularKeywords;

  PopularKeyWordsData({required this.popularKeywords});

  Map<String, dynamic> toJson() {
    return {"popularKeywords": popularKeywords};
  }

  factory PopularKeyWordsData.fromJson(Map<String, dynamic> json) {
    return PopularKeyWordsData(popularKeywords: json['popularKeywords']);
  }
}
