class FootballLiveDataModel {
  final int code;
  final String msg;
  final FootballLiveData data;

  FootballLiveDataModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {'code': code, 'msg': msg, 'data': data};
  }

  factory FootballLiveDataModel.fromJson(Map<String, dynamic> json) {
    return FootballLiveDataModel(
        code: json['code'],
        msg: json['msg'],
        data: FootballLiveData.fromJson(json['data']));
  }
}

class FootballLiveData {
  final int? matchId;
  final String? status;
  final String? matchDate;
  final String? matchTime;
  final String? homeTeamName;
  final String? awayTeamName;
  final String? homeTeamLogo;
  final String? awayTeamLog;
  final String? refereeName;
  final String? venueName;
  final String? homeFormation;
  final String? awayFormation;
  final String? homeCoach;
  final String? awayCoach;
  final int? homeAttackNum;
  final int? awayAttackNum;
  final int? homeAttackDangerNum;
  final int? awayAttackDangerNum;
  final String? homePossessionRate;
  final String? awayPossessionRate;
  final int? homeShootGoalNum;
  final int? awayShootGoalNum;
  final int? homeBiasNum;
  final int? awayBiasNum;
  final int? homeCornerKickNum;
  final int? awayCornerKickNum;
  final int? homeRedCardNum;
  final int? awayRedCardNum;
  final int? homeYellowCardNum;
  final int? awayYellowCardNum;
  final int? homeScore;
  final int? awayScore;
  final int? homePenaltyNum;
  final int? awayPenaltyNum;

  FootballLiveData({
    this.matchId,
    this.status,
    this.matchDate,
    this.matchTime,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamLogo,
    this.awayTeamLog,
    this.refereeName,
    this.venueName,
    this.homeFormation,
    this.awayFormation,
    this.homeCoach,
    this.awayCoach,
    this.homeAttackNum,
    this.awayAttackNum,
    this.homeAttackDangerNum,
    this.awayAttackDangerNum,
    this.homePossessionRate,
    this.awayPossessionRate,
    this.homeShootGoalNum,
    this.awayShootGoalNum,
    this.homeBiasNum,
    this.awayBiasNum,
    this.homeCornerKickNum,
    this.awayCornerKickNum,
    this.homeRedCardNum,
    this.awayRedCardNum,
    this.homeYellowCardNum,
    this.awayYellowCardNum,
    this.homeScore,
    this.awayScore,
    this.homePenaltyNum,
    this.awayPenaltyNum,
  });

  Map<String, dynamic> toJson() {
    return {
      "matchId": matchId,
      "status": status,
      "matchDate": matchDate,
      "matchTime": matchTime,
      "homeTeamName": homeTeamName,
      "awayTeamName": awayTeamName,
      "homeTeamLogo": homeTeamLogo,
      "awayTeamLog": awayTeamLog,
      "refereeName": refereeName,
      "venueName": venueName,
      "homeFormation": homeFormation,
      "awayFormation": awayFormation,
      "homeCoach": homeCoach,
      "awayCoach": awayCoach,
      "homeAttackNum": homeAttackNum,
      "awayAttackNum": awayAttackNum,
      "homeAttackDangerNum": homeAttackDangerNum,
      "awayAttackDangerNum": awayAttackDangerNum,
      "homePossessionRate": homePossessionRate,
      "awayPossessionRate": awayPossessionRate,
      "homeShootGoalNum": homeShootGoalNum,
      "awayShootGoalNum": awayShootGoalNum,
      "homeBiasNum": homeBiasNum,
      "awayBiasNum": awayBiasNum,
      "homeCornerKickNum": homeCornerKickNum,
      "awayCornerKickNum": awayCornerKickNum,
      "homeRedCardNum": homeRedCardNum,
      "awayRedCardNum": awayRedCardNum,
      "homeYellowCardNum": homeYellowCardNum,
      "awayYellowCardNum": awayYellowCardNum,
      "homeScore": homeScore,
      "awayScore": awayScore,
      "homePenaltyNum": homePenaltyNum,
      "awayPenaltyNum": awayPenaltyNum,
    };
  }

  factory FootballLiveData.fromJson(Map<String, dynamic> json) {
    return FootballLiveData(
      matchId: json['matchId'],
      status: json['status'],
      matchDate: json['matchDate'],
      matchTime: json['matchTime'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLog: json['awayTeamLog'],
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

class FootballLineUpModel {
  final int code;
  final String msg;
  final FootballLineUpData data;

  FootballLineUpModel({
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

  factory FootballLineUpModel.fromJson(Map<String, dynamic> json) {
    return FootballLineUpModel(
      code: json['code'],
      msg: json['msg'],
      data: FootballLineUpData.fromJson(json['data']),
    );
  }
}

class FootballLineUpData {
  final List<LineUpList> homeMatchLineUpList;
  final List<LineUpList> awayMatchLineUpList;

  FootballLineUpData({
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

  factory FootballLineUpData.fromJson(Map<String, dynamic> json) {
    return FootballLineUpData(
      homeMatchLineUpList: json['homeMatchLineUpList'] != null
          ? List<LineUpList>.from(json['homeMatchLineUpList']
              .map((data) => LineUpList.fromJson(data)))
          : [],
      awayMatchLineUpList: json['awayMatchLineUpList'] != null
          ? List<LineUpList>.from(json['awayMatchLineUpList']
              .map((data) => LineUpList.fromJson(data)))
          : [],
    );
  }
}

class LineUpList {
  final int id;
  final int type;
  final int playerId;
  final int matchId;
  final int first;
  final int captain;
  final String playerName;
  final int shirtNumber;
  final int position;
  final String rating;

  LineUpList({
    required this.id,
    required this.type,
    required this.playerId,
    required this.matchId,
    required this.first,
    required this.captain,
    required this.playerName,
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
      "first": first,
      "captain": captain,
      "playerName": playerName,
      "shirtNumber": shirtNumber,
      "position": position,
      "rating": rating,
    };
  }

  factory LineUpList.fromJson(Map<String, dynamic> json) {
    return LineUpList(
      id: json['id'],
      type: json['type'],
      playerId: json['playerId'],
      matchId: json['matchId'],
      first: json['first'],
      captain: json['captain'],
      playerName: json['playerName'],
      shirtNumber: json['shirtNumber'],
      position: json['position'],
      rating: json['rating'],
    );
  }
}
