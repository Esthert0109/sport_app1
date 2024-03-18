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

class FootballMatchesData {
  final int matchId;
  final String status;
  final String matchDate;
  final String matchTime;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLog;
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

  FootballMatchesData({
    required this.matchId,
    required this.status,
    required this.matchDate,
    required this.matchTime,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLog,
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

  factory FootballMatchesData.fromJson(Map<String, dynamic> json) {
    return FootballMatchesData(
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
