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
  final String weatherEn;
  final String leagueEn;
  final String roundCn;
  final String leagueChtShort;
  final String subLeagueEn;
  final int awayCorner;
  final String leagueEnShort;
  final int homeRed;
  final int leagueId;
  final String subLeagueCht;
  final String season;
  final String explainEn;
  final int state;
  final int homeHalfScore;
  final String homeRankEn;
  final String subLeagueId;
  final int homeId;
  final int awayRed;
  final String leagueChsShort;
  final int kind;
  final String subLeagueChs;
  final String matchTime;
  final String grouping;
  final String homeEn;
  final int injuryTime;
  final String awayChs;
  final String awayRankEn;
  final String awayCht;
  final String weatherCn;
  final String roundEn;
  final String color;
  final int awayHalfScore;
  final int homeCorner;
  final String extraExplain;
  final int awayScore;
  final String locationEn;
  final String explainCn;
  final String homeRankCn;
  final String startTime;
  final int matchId;
  final bool isNeutral;
  final String temp;
  final int homeScore;
  final String locationCn;
  final int awayId;
  final int awayYellow;
  final String updateTime;
  final int homeYellow;
  final String homeChs;
  final bool isHidden;
  final String homeCht;
  final String awayEn;
  final String awayRankCn;
  final String hasLineup;

  FootballMatchesData({
    required this.weatherEn,
    required this.leagueEn,
    required this.roundCn,
    required this.leagueChtShort,
    required this.subLeagueEn,
    required this.awayCorner,
    required this.leagueEnShort,
    required this.homeRed,
    required this.leagueId,
    required this.subLeagueCht,
    required this.season,
    required this.explainEn,
    required this.state,
    required this.homeHalfScore,
    required this.homeRankEn,
    required this.subLeagueId,
    required this.homeId,
    required this.awayRed,
    required this.leagueChsShort,
    required this.kind,
    required this.subLeagueChs,
    required this.matchTime,
    required this.grouping,
    required this.homeEn,
    required this.injuryTime,
    required this.awayChs,
    required this.awayRankEn,
    required this.awayCht,
    required this.weatherCn,
    required this.roundEn,
    required this.color,
    required this.awayHalfScore,
    required this.homeCorner,
    required this.extraExplain,
    required this.awayScore,
    required this.locationEn,
    required this.explainCn,
    required this.homeRankCn,
    required this.startTime,
    required this.matchId,
    required this.isNeutral,
    required this.temp,
    required this.homeScore,
    required this.locationCn,
    required this.awayId,
    required this.awayYellow,
    required this.updateTime,
    required this.homeYellow,
    required this.homeChs,
    required this.isHidden,
    required this.homeCht,
    required this.awayEn,
    required this.awayRankCn,
    required this.hasLineup,
  });

  Map<String, dynamic> toJson() {
    return {
      'weatherEn': weatherEn,
      'leagueEn': leagueEn,
      'roundCn': roundCn,
      'leagueChtShort': leagueChtShort,
      'subLeagueEn': subLeagueEn,
      'awayCorner': awayCorner,
      'leagueEnShort': leagueEnShort,
      'homeRed': homeRed,
      'leagueId': leagueId,
      'subLeagueCht': subLeagueCht,
      'season': season,
      'explainEn': explainEn,
      'state': state,
      'homeHalfScore': homeHalfScore,
      'homeRankEn': homeRankEn,
      'subLeagueId': subLeagueId,
      'homeId': homeId,
      'awayRed': awayRed,
      'leagueChsShort': leagueChsShort,
      'kind': kind,
      'subLeagueChs': subLeagueChs,
      'matchTime': matchTime,
      'grouping': grouping,
      'homeEn': homeEn,
      'injuryTime': injuryTime,
      'awayChs': awayChs,
      'awayRankEn': awayRankEn,
      'awayCht': awayCht,
      'weatherCn': weatherCn,
      'roundEn': roundEn,
      'color': color,
      'awayHalfScore': awayHalfScore,
      'homeCorner': homeCorner,
      'extraExplain': extraExplain,
      'awayScore': awayScore,
      'locationEn': locationEn,
      'explainCn': explainCn,
      'homeRankCn': homeRankCn,
      'startTime': startTime,
      'matchId': matchId,
      'isNeutral': isNeutral,
      'temp': temp,
      'homeScore': homeScore,
      'locationCn': locationCn,
      'awayId': awayId,
      'awayYellow': awayYellow,
      'updateTime': updateTime,
      'homeYellow': homeYellow,
      'homeChs': homeChs,
      'isHidden': isHidden,
      'homeCht': homeCht,
      'awayEn': awayEn,
      'awayRankCn': awayRankCn,
      'hasLineup': hasLineup,
    };
  }

  factory FootballMatchesData.fromJson(Map<String, dynamic> json) {
    return FootballMatchesData(
      weatherEn: json['weatherEn'],
      leagueEn: json['leagueEn'],
      roundCn: json['roundCn'],
      leagueChtShort: json['leagueChtShort'],
      subLeagueEn: json['subLeagueEn'],
      awayCorner: json['awayCorner'],
      leagueEnShort: json['leagueEnShort'],
      homeRed: json['homeRed'],
      leagueId: json['leagueId'],
      subLeagueCht: json['subLeagueCht'],
      season: json['season'],
      explainEn: json['explainEn'],
      state: json['state'],
      homeHalfScore: json['homeHalfScore'],
      homeRankEn: json['homeRankEn'],
      subLeagueId: json['subLeagueId'],
      homeId: json['homeId'],
      awayRed: json['awayRed'],
      leagueChsShort: json['leagueChsShort'],
      kind: json['kind'],
      subLeagueChs: json['subLeagueChs'],
      matchTime: json['matchTime'],
      grouping: json['grouping'],
      homeEn: json['homeEn'],
      injuryTime: json['injuryTime'],
      awayChs: json['awayChs'],
      awayRankEn: json['awayRankEn'],
      awayCht: json['awayCht'],
      weatherCn: json['weatherCn'],
      roundEn: json['roundEn'],
      color: json['color'],
      awayHalfScore: json['awayHalfScore'],
      homeCorner: json['homeCorner'],
      extraExplain: json['extraExplain'],
      awayScore: json['awayScore'],
      locationEn: json['locationEn'],
      explainCn: json['explainCn'],
      homeRankCn: json['homeRankCn'],
      startTime: json['startTime'],
      matchId: json['matchId'],
      isNeutral: json['isNeutral'],
      temp: json['temp'],
      homeScore: json['homeScore'],
      locationCn: json['locationCn'],
      awayId: json['awayId'],
      awayYellow: json['awayYellow'],
      updateTime: json['updateTime'],
      homeYellow: json['homeYellow'],
      homeChs: json['homeChs'],
      isHidden: json['isHidden'],
      homeCht: json['homeCht'],
      awayEn: json['awayEn'],
      awayRankCn: json['awayRankCn'],
      hasLineup: json['hasLineup'],
    );
  }
}
