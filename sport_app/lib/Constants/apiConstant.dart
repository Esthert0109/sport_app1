class ApiConstants {
  //Base Url for all API
  static const String baseUrl = 'http://103.224.93.197:8080';

  static const String localhost = 'http://localhost:8080';

  //Login
  static const String loginBaseUrl = '/api/v1/login';

  static const String login = '/do-login';

  static const String loginUrl = loginBaseUrl + login; //login

  //Live Stream User
  static const String liveStreamUserBaseUrl = '/api/v1/users';

  static const String updatePassword = '/updatePass/';

  static const String updateForgotPassword = '/updatePassByForgot/';

  static const String createUser = '/create';

  static const String findUserById = '/';

  static const String updateNickName = '/updateNickName/';

  static const String updateHead = '/updateHead/';

  static const String updatePasswordUrl =
      liveStreamUserBaseUrl + updatePassword; //update password

  static const String updatePassByForgotUrl = liveStreamUserBaseUrl +
      updateForgotPassword; // update forgot password on the login page

  static const String createUserUrl =
      liveStreamUserBaseUrl + createUser; //create user

  static const String findUserByIdUrl =
      liveStreamUserBaseUrl + findUserById; //find user by id

  static const String updateNickNameUrl =
      liveStreamUserBaseUrl + updateNickName; //update nick name

  static const String updateHeadUrl =
      liveStreamUserBaseUrl + updateHead; //update profile pic

  //Basketball CN--------------------------------------------------------------------------------------------//
  static const String basketballBaseUrl = '/api/v1/basketballs/match';

  static const String searchBasketballToday = '/now-list';

  static const String getStartBasketballMatch = '/list-start?';

  static const String getFutureBasketballMatch = '/list-future?';

  static const String getPastBasketballMatch = '/list-past?';

  static const String getBasketballMatchByDate = '/list/';

  static const String getBasketballMatchLineUp = '/line-up/';

  static const String getBasketballMatchLiveData = '/livedata/';

  static const String getBasketballLiveAddress = '/address/';

  static const String getBasketballMatchLineUpUrl = basketballBaseUrl +
      getBasketballMatchLineUp; //get matches line up in matches status

  static const String getBasketballMatchLiveDataUrl =
      basketballBaseUrl + getBasketballMatchLiveData; //get matches live data

  static const String getBasketballLiveAddressUrl =
      basketballBaseUrl + getBasketballLiveAddress; //get live address

  static const String getBasketballMatchByDateUrl =
      basketballBaseUrl + getBasketballMatchByDate; //get all matches by date

  static const String getPastBasketballMatchUrl =
      basketballBaseUrl + getPastBasketballMatch; //get past matches

  static const String getFutureBasketballMatchUrl =
      basketballBaseUrl + getFutureBasketballMatch; // get future matches

  static const String getStartBasketballMatchUrl =
      basketballBaseUrl + getStartBasketballMatch; // get Today started matches

  static const String searchBasketballTodayUrl = basketballBaseUrl +
      searchBasketballToday; // get today's matchs via matches or team name

  //---Basketball EN-----------------------------------------------------------------------------------------//

  static const String EN = '/en';

  static const String searchBasketballTodayENurl =
      basketballBaseUrl + EN + searchBasketballToday;

  static const String getBasketballMatchByDateENurl =
      basketballBaseUrl + EN + getBasketballMatchByDate;

  static const String getStartBasketballMatchENurl =
      basketballBaseUrl + EN + getStartBasketballMatch;

  static const String getFutureBasketballMatchENurl =
      basketballBaseUrl + EN + getFutureBasketballMatch;

  static const String getPastBasketballMatchENurl =
      basketballBaseUrl + EN + getPastBasketballMatch;

  static const String getBasketballLineUpENurl =
      basketballBaseUrl + EN + getBasketballMatchLineUp;

  static const String getBasketballMatchLiveDataENurl =
      basketballBaseUrl + EN + getBasketballMatchLiveData;

  //Football CN----------------------------------------------------------------------------------------------//
  static const String footballBaseUrl = '/api/v1/footballs';

  static const String getFootballMatchList = '/match/list?';

  static const String getFootballMatchLineUp = '/match/line-up/';

  static const String searchFootballMatchToday = '/match/now-list';

  static const String getFootballMatchById = '/match/livedata/';

  static const String getFootballLiveAddress = '/address/';

  static const String getStartFootballMatch = '/match/list-start?';

  static const String getFutureFootballMatch = '/match/list-future?';

  static const String getPassFootballMatch = '/match/list-past?';

  static const String getMatchByDate = '/match/list/';

  static const String getMatchByDateUrl =
      footballBaseUrl + getMatchByDate; //get football matches by date

  static const String getFootballMatchListUrl =
      footballBaseUrl + getFootballMatchList; //get football match list

  static const String getStartFootballMatchListUrl =
      footballBaseUrl + getStartFootballMatch; //get start football match

  static const String getFutureFootballMatchListUrl =
      footballBaseUrl + getFutureFootballMatch; //get future football match

  static const String getPassFootballMatchListUrl =
      footballBaseUrl + getPassFootballMatch; //get pass football match

  static const String getFootballMatchLineUpUrl =
      footballBaseUrl + getFootballMatchLineUp; //get football match line up

  static const String searchFootballMatchTodayUrl =
      footballBaseUrl + searchFootballMatchToday; //search football match

  static const String getFootballMatchByIdUrl =
      footballBaseUrl + getFootballMatchById; // get Football match by Id

  static const String getFootballLiveAddressUrl =
      footballBaseUrl + getFootballLiveAddress;

//--------------------------------------------------------------------------------------------------------------------//
//Football EN---------------------------------------------------------------------------------------------------------//

  static const String searchFootballMatchTodayEn = '/match/en/now-list?';

  static const String getFootballMatchLineUpEN = "/match/en/line-up/";

  static const String getFootballMatchListEN = '/match/en/list';

  static const String getFootballMatchListByDateEN = '/match/en/list/';

  static const String getStartFootballMatchListEN = '/match/en/list-start?';

  static const String getFutureFootballMatchListEN = '/match/en/list-future?';

  static const String getPastFootballMatchListEN = '/match/en/list-past?';

  static const String getFootballMatchByIdEN = '/match/en/livedata/';

  static const String getFootballMatchByIdENurl =
      footballBaseUrl + getFootballMatchByIdEN;

  static const String getPastFootballMatchListENurl =
      footballBaseUrl + getPastFootballMatchListEN;

  static const String getFutureFootballMatchListENurl =
      footballBaseUrl + getFutureFootballMatchListEN;

  static const String getStartFootballMatchListENurl =
      footballBaseUrl + getStartFootballMatchListEN;

  static const String getFootballMatchListByDateENurl =
      footballBaseUrl + getFootballMatchListByDateEN;

  static const String getFootballMatchListENurl =
      footballBaseUrl + getFootballMatchListEN;

  static const String searchFootballMatchTodayENurl =
      footballBaseUrl + searchFootballMatchTodayEn;

  static const String getFootballMatchLineUpENurl =
      footballBaseUrl + getFootballMatchLineUpEN;

//---------------------------------------------------------------------------------------------------------------------//

  //Live Stream Collection
  static const String liveStreamCollectionBaseUrlFootball =
      '/api/v1/collections/football';

  static const String liveStreamCollectionBaseUrlBasketball =
      '/api/v1/collections/basketball';

  static const String liveStreamCollectionBaseUrl = '/api/v1/collections';

  static const String getAllStreamCollectionList = '/list';

  static const String getMatch = '/{matchId}';

  static const String deleteCollectionByMatchId = '/';

  static const String createCollection = '/';

  static const String getAllStreamCollectionListFootballUrl =
      liveStreamCollectionBaseUrlFootball +
          getAllStreamCollectionList; //get football all stream collection list

  static const String getAllStreamCollectionListBasketballUrl =
      liveStreamCollectionBaseUrlBasketball +
          getAllStreamCollectionList; //get all basketball collection list

  static const String getFootballMatchUrl =
      liveStreamCollectionBaseUrlFootball + getMatch; //get football match

  static const String getBasketballMatchUrl =
      liveStreamCollectionBaseUrlBasketball + getMatch; //get basketball match

  static const String deleteCollectionByMatchIdUrl =
      liveStreamCollectionBaseUrl +
          deleteCollectionByMatchId; //delete collection by id

  static const String createCollectionUrl =
      liveStreamCollectionBaseUrl + createCollection; //create collection

  //Live Stream Collection (English)-------------------------------------------------------------------------------------//
  static const String liveStreamCollectionBaseEngUrl = '/api/v1/en/collections';

  static const String getAllStreamCollectionEngListFootball = '/football/list';

  static const String getAllStreamCollectionEngListBasketball =
      '/basketball/list';

  static const String getFootballEngMatch = '/football/{matchId}';

  static const String getBasketballEngMatch = '/basketball/{matchId}';

  static const String deleteCollectionEngByMatchId = '/';

  static const String createCollectionEng = '/';

  static const String createCollectionEngUrl = liveStreamCollectionBaseEngUrl +
      createCollectionEng; //create collection English ver

  static const String getAllStreamCollectionListEngUrlFootball =
      liveStreamCollectionBaseEngUrl +
          getAllStreamCollectionEngListFootball; //get all football stream collection list English ver

  static const String getAllStreamCollectionListEngUrlBasketball =
      liveStreamCollectionBaseEngUrl +
          getAllStreamCollectionEngListBasketball; //get all basketball stream collection list English ver

  static const String getFootballMatchEngUrl = liveStreamCollectionBaseEngUrl +
      getFootballEngMatch; //get football match English ver

  static const String getBasketballMatchEngUrl =
      liveStreamCollectionBaseEngUrl +
          getBasketballEngMatch; //get basketball match English ver

  static const String deleteCollectionEngByMatchIdUrl =
      liveStreamCollectionBaseEngUrl +
          deleteCollectionEngByMatchId; //delete collection English ver by id

  //Live Stream Message
  static const liveStreamMessageBaseUrl = '/api/v1/messages';

  static const getLiveStreamMessageList = '/list';

  static const getLiveStreamMessageById = '/{id}';

  static const getLiveStreamMessageListUrl = liveStreamMessageBaseUrl +
      getLiveStreamMessageList; //get live stream message list

  static const getLiveStreamMessageByIdUrl = liveStreamMessageBaseUrl +
      getLiveStreamMessageById; //get live stream message by id

  //sms
  static const smsBaseUrl = '/api/v1/sms';

  static const sendMsgRegister = '/send/1/';

  static const sendMsgReset = '/send/2/';

  static const sendMsgForgot = '/send/3/';

  static const sendMsg = '/send/';

  static const verifyMsgRegister = '/verify/mobile/1';

  static const verifyMsgReset = '/verify/mobile/2';

  static const verifyMsgForgot = '/verify/mobile/3';

  static const verifyMsg = '/verify/mobile';

  static const sendMsgUrl = smsBaseUrl + sendMsg; //send 3 types of OTP

  static const sendMsgRegisterUrl =
      smsBaseUrl + sendMsgRegister; //send registration OTP

  static const sendMsgResetUrl =
      smsBaseUrl + sendMsgReset; //send reset password OTP

  static const sendMsgForgotUrl =
      smsBaseUrl + sendMsgForgot; //send forgot password OTP

  static const verifyMsgRegisterUrl =
      smsBaseUrl + verifyMsgRegister; //verify register msg OTP

  static const verifyMsgResetUrl =
      smsBaseUrl + verifyMsgRegister; //verify reset msg OTP

  static const verifyMsgForgotUrl =
      smsBaseUrl + verifyMsgRegister; //verify forgot msg OTP

  static const verifyMsgUrl = smsBaseUrl + verifyMsg; //verify 3 types of OTP

  //Upload File
  static const uploadFileBaseUrl = '/api/v1/files';

  static const uploadFile = '';

  static const deleteFile = '/delete/{fileName}';

  static const uploadFileUrl = uploadFileBaseUrl + uploadFile; //upload file

  static const deleteFileUrl = uploadFileBaseUrl + deleteFile; //delete file

  //Popular Search
  static const popularSearchBaseUrl = '/api/v1/populars';

  static const getPopularSearchList = '/list';

  static const createPopularSearchList = '/';

  static const getPopularSearchListUrl =
      popularSearchBaseUrl + getPopularSearchList;

  static const createPopularSearchListUrl =
      popularSearchBaseUrl + createPopularSearchList;

  //Live Stream

  static const liveStreamBaseUrl = '/api/v1/pushAndPlay/list';

  static const getPopularLiveStreamList = '/popular';

  static const getAllLiveStreamList = '';

  static const getAllLiveStreamListUrl = liveStreamBaseUrl +
      getAllLiveStreamList; //get all live stream at live page

  static const getPopularLiveStreamListUrl = liveStreamBaseUrl +
      getPopularLiveStreamList; // get popular live stream page at home page

  // Popular Games - Ads
  static const getPopularGameList = '/api/v1/popular-games/getAll';

  // follow anchor
  static const getFollowingList = '/api/v1/follow/following';

  static const createFollow = "/api/v1/follow/create";
}
