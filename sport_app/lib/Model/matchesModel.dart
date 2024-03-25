class AllMatches {
  final int code;
  final String msg;
  final MatchList matchList;

  AllMatches({
    required this.code,
    required this.msg,
    required this.matchList,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "msg": msg,
      "matchList": matchList,
    };
  }

  factory AllMatches.fromJson(Map<String, dynamic> json) {
    return AllMatches(
      code: json['code'],
      msg: json['msg'],
      matchList: MatchList.fromJson(json['matchList']),
    );
  }
}

class MatchList {
  final List<MatchesData> matchList;

  MatchList({required this.matchList});

  Map<String, dynamic> toJson() {
    return {'matchList': matchList.map((e) => e.toJson()).toList()};
  }

  factory MatchList.fromJson(Map<String, dynamic> json) {
    return MatchList(
        matchList: json['matchList'] != null
            ? List<MatchesData>.from(
                json['matchList'].map((data) => MatchesData.fromJson(data)))
            : []);
  }
}

class AllMatchesFootball {
  final int code;
  final String msg;
  final MatchListFootball matchList;

  AllMatchesFootball({
    required this.code,
    required this.msg,
    required this.matchList,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "msg": msg,
      "matchList": matchList,
    };
  }

  factory AllMatchesFootball.fromJson(Map<String, dynamic> json) {
    return AllMatchesFootball(
      code: json['code'],
      msg: json['msg'],
      matchList: MatchListFootball.fromJson(json['matchList']),
    );
  }
}

class MatchListFootball {
  final List<FootballMatchesData> matchList;

  MatchListFootball({required this.matchList});

  Map<String, dynamic> toJson() {
    return {'matchList': matchList.map((e) => e.toJson()).toList()};
  }

  factory MatchListFootball.fromJson(Map<String, dynamic> json) {
    return MatchListFootball(
        matchList: json['matchList'] != null
            ? List<FootballMatchesData>.from(json['matchList']
                .map((data) => FootballMatchesData.fromJson(data)))
            : []);
  }
}

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
      hasCollected: json['hasCollected'] ?? false,
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
      hasCollected: json['hasCollected']?? false,
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
      hasCollected: json['hasCollected'] ?? false,
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

class BasketballLineUpModel {
  final int code;
  final String msg;
  final BasketballLineUpData data;

  BasketballLineUpModel({
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

  factory BasketballLineUpModel.fromJson(Map<String, dynamic> json) {
    return BasketballLineUpModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}

class BasketballLineUpData {
  final List<PlayerDetails> home;
  final List<PlayerDetails> away;

  BasketballLineUpData({required this.home, required this.away});

  Map<String, dynamic> toJson() {
    return {
      'home': home.map((e) => e.toJson()).toList(),
      'away': away.map((e) => e.toJson()).toList(),
    };
  }

  factory BasketballLineUpData.fromJson(Map<String, dynamic> json) {
    return BasketballLineUpData(
      home: json['home'] != null
          ? List<PlayerDetails>.from(
              json['data'].map((home) => PlayerDetails.fromJson(home)))
          : [],
      away: json['away'] != null
          ? List<PlayerDetails>.from(
              json['data'].map((away) => PlayerDetails.fromJson(away)))
          : [],
    );
  }
}

class PlayerDetails {
  final int id;
  final int type;
  final int playerId;
  final int matchId;
  final String playerName;
  final String minutes;
  final String point;
  final String assists;
  final String steals;
  final String totalRebounds;
  final String freeThrowsGoalsAttempts;
  final String freeThrowsGoalsMade;
  final String personalFouls;
  final String turnovers;
  final String threePoinGoalsAttempts;
  final String threePoinGoalsMade;
  final String blocks;
  final String fieldGoalsAttempts;
  final String fieldGoalMade;

  PlayerDetails({
    required this.id,
    required this.type,
    required this.playerId,
    required this.matchId,
    required this.playerName,
    required this.minutes,
    required this.point,
    required this.assists,
    required this.steals,
    required this.totalRebounds,
    required this.freeThrowsGoalsAttempts,
    required this.freeThrowsGoalsMade,
    required this.personalFouls,
    required this.turnovers,
    required this.threePoinGoalsAttempts,
    required this.threePoinGoalsMade,
    required this.blocks,
    required this.fieldGoalsAttempts,
    required this.fieldGoalMade,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "playerId": playerId,
      "matchId": matchId,
      "playerName": playerName,
      "minutes": minutes,
      "point": point,
      "assists": assists,
      "steals": steals,
      "totalRebounds": totalRebounds,
      "freeThrowsGoalsAttempts": freeThrowsGoalsAttempts,
      "freeThrowsGoalsMade": freeThrowsGoalsMade,
      "personalFouls": personalFouls,
      "turnovers": turnovers,
      "threePoinGoalsAttempts": threePoinGoalsAttempts,
      "threePoinGoalsMade": threePoinGoalsMade,
      "blocks": blocks,
      "fieldGoalsAttempts": fieldGoalsAttempts,
      "fieldGoalMade": fieldGoalMade,
    };
  }

  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
      id: json['id'],
      type: json['type'],
      playerId: json['playerId'],
      matchId: json['matchId'],
      playerName: json['playerName'],
      minutes: json['minutes'],
      point: json['point'],
      assists: json['assists'],
      steals: json['steals'],
      totalRebounds: json['totalRebounds'],
      freeThrowsGoalsAttempts: json['freeThrowsGoalsAttempts'],
      freeThrowsGoalsMade: json['freeThrowsGoalsMade'],
      personalFouls: json['personalFouls'],
      turnovers: json['turnovers'],
      threePoinGoalsAttempts: json['threePoinGoalsAttempts'],
      threePoinGoalsMade: json['threePoinGoalsMade'],
      blocks: json['blocks'],
      fieldGoalsAttempts: json['fieldGoalsAttempts'],
      fieldGoalMade: json['fieldGoalMade'],
    );
  }
}

class FootballMatchLineUpModel {
  final int code;
  final String msg;
  final FootballMatchLineUpData data;

  FootballMatchLineUpModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data,
    };
  }

  factory FootballMatchLineUpModel.fromJson(Map<String, dynamic> json) {
    return FootballMatchLineUpModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}

class FootballMatchLineUpData {
  final List<FootballPlayerDetails> homeMatchLineUpList;
  final List<FootballPlayerDetails> awayMatchLineUpList;

  FootballMatchLineUpData({
    required this.homeMatchLineUpList,
    required this.awayMatchLineUpList,
  });

  Map<String, dynamic> toJson() {
    return {
      "homeMatchLineUpList":
          homeMatchLineUpList.map((e) => e.toJson()).toList(),
      "awayMatchLineUpList":
          awayMatchLineUpList.map((e) => e.toJson()).toList(),
    };
  }

  factory FootballMatchLineUpData.fromJson(Map<String, dynamic> json) {
    return FootballMatchLineUpData(
      homeMatchLineUpList: json['homeMatchLineUpList'] != null
          ? List<FootballPlayerDetails>.from(json['homeMatchLineUpList'].map(
              (homeMatchLineUpList) =>
                  FootballPlayerDetails.fromJson(homeMatchLineUpList)))
          : [],
      awayMatchLineUpList: json['awayMatchLineUpList'] != null
          ? List<FootballPlayerDetails>.from(json['awayMatchLineUpList'].map(
              (awayMatchLineUpList) =>
                  FootballPlayerDetails.fromJson(awayMatchLineUpList)))
          : [],
    );
  }
}

class FootballPlayerDetails {
  final int id;
  final int type;
  final int playerId;
  final int matchId;
  final int teamId;
  final int first;
  final int captain;
  final String playerName;
  final String playerLogo;
  final int shirtNumber;
  final int position;
  final String rating;

  FootballPlayerDetails({
    required this.id,
    required this.type,
    required this.playerId,
    required this.matchId,
    required this.teamId,
    required this.first,
    required this.captain,
    required this.playerName,
    required this.playerLogo,
    required this.shirtNumber,
    required this.position,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "playerId": playerId,
      "matchId": matchId,
      "teamId": teamId,
      "first": first,
      "captain": captain,
      "playerName": playerName,
      "playerLogo": playerLogo,
      "shirtNumber": shirtNumber,
      "position": position,
      "rating": rating,
    };
  }

  factory FootballPlayerDetails.fromJson(Map<String, dynamic> json) {
    return FootballPlayerDetails(
      id: json['id'],
      type: json['type'],
      playerId: json['playerId'],
      matchId: json['matchId'],
      teamId: json['teamId'],
      first: json['first'],
      captain: json['captain'],
      playerName: json['playerName'],
      playerLogo: json['playerLogo'],
      shirtNumber: json['shirtNumber'],
      position: json['position'],
      rating: json['rating'],
    );
  }
}

class FootballMatchLiveData {
  final int matchId;
  final String status;
  final String matchDate;
  final String matchTime;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final String refereeName;
  final String venueName;
  final String homeFormation;
  final String awayFormation;
  final String homeCoach;
  final String awayCoach;
  final int homeAttackNum;
  final int awayAttackNum;
  final int homeAttackDangerNum;
  final int awayAttackDangerNum;
  final String homePossessionRate;
  final String awayPossessionRate;
  final int homeShootGoalNum;
  final int awayShootGoalNum;
  final int homeBiasNum;
  final int awayBiasNum;
  final int homeCornerKickNum;
  final int awayCornerKickNum;
  final int homeRedCardNum;
  final int awayRedCardNum;
  final int homeYellowCardNum;
  final int awayYellowCardNum;
  final int homeScore;
  final int awayScore;
  final int homePenaltyNum;
  final int awayPenaltyNum;

  FootballMatchLiveData({
    required this.matchId,
    required this.status,
    required this.matchDate,
    required this.matchTime,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.refereeName,
    required this.venueName,
    required this.homeFormation,
    required this.awayFormation,
    required this.homeCoach,
    required this.awayCoach,
    required this.homeAttackNum,
    required this.awayAttackNum,
    required this.homeAttackDangerNum,
    required this.awayAttackDangerNum,
    required this.homePossessionRate,
    required this.awayPossessionRate,
    required this.homeShootGoalNum,
    required this.awayShootGoalNum,
    required this.homeBiasNum,
    required this.awayBiasNum,
    required this.homeCornerKickNum,
    required this.awayCornerKickNum,
    required this.homeRedCardNum,
    required this.awayRedCardNum,
    required this.homeYellowCardNum,
    required this.awayYellowCardNum,
    required this.homeScore,
    required this.awayScore,
    required this.homePenaltyNum,
    required this.awayPenaltyNum,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'status': status,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamLogo': homeTeamLogo,
      'awayTeamLogo': awayTeamLogo,
      'refereeName': refereeName,
      'venueName': venueName,
      'homeFormation': homeFormation,
      'awayFormation': awayFormation,
      'homeCoach': homeCoach,
      'awayCoach': awayCoach,
      'homeAttackNum': homeAttackNum,
      'awayAttackNum': awayAttackNum,
      'homeAttackDangerNum': homeAttackDangerNum,
      'awayAttackDangerNum': awayAttackDangerNum,
      'homePossessionRate': homePossessionRate,
      'awayPossessionRate': awayPossessionRate,
      'homeShootGoalNum': homeShootGoalNum,
      'awayShootGoalNum': awayShootGoalNum,
      'homeBiasNum': homeBiasNum,
      'awayBiasNum': awayBiasNum,
      'homeCornerKickNum': homeCornerKickNum,
      'awayCornerKickNum': awayCornerKickNum,
      'homeRedCardNum': homeRedCardNum,
      'awayRedCardNum': awayRedCardNum,
      'homeYellowCardNum': homeYellowCardNum,
      'awayYellowCardNum': awayYellowCardNum,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'homePenaltyNum': homePenaltyNum,
      'awayPenaltyNum': awayPenaltyNum,
    };
  }

  factory FootballMatchLiveData.fromJson(Map<String, dynamic> json) {
    return FootballMatchLiveData(
      matchId: json['matchId'],
      status: json['status'],
      matchDate: json['matchDate'],
      matchTime: json['matchTime'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLogo: json['awayTeamLogo'],
      refereeName: json['refereeName'],
      venueName: json['venueName'],
      homeFormation: json['homeFormation'],
      awayFormation: json['awayFormation'],
      homeCoach: json['homeCoach'],
      awayCoach: json['awayCoach'],
      homeAttackNum: json['homeAttackNum'],
      awayAttackNum: json['awayAttackNum'],
      homeAttackDangerNum: json['homeAttackDangerNum'],
      awayAttackDangerNum: json['awayAttackDangerNum'],
      homePossessionRate: json['homePossessionRate'],
      awayPossessionRate: json['awayPossessionRate'],
      homeShootGoalNum: json['homeShootGoalNum'],
      awayShootGoalNum: json['awayShootGoalNum'],
      homeBiasNum: json['homeBiasNum'],
      awayBiasNum: json['awayBiasNum'],
      homeCornerKickNum: json['homeCornerKickNum'],
      awayCornerKickNum: json['awayCornerKickNum'],
      homeRedCardNum: json['homeRedCardNum'],
      awayRedCardNum: json['awayRedCardNum'],
      homeYellowCardNum: json['homeYellowCardNum'],
      awayYellowCardNum: json['awayYellowCardNum'],
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      homePenaltyNum: json['homePenaltyNum'],
      awayPenaltyNum: json['awayPenaltyNum'],
    );
  }
}
