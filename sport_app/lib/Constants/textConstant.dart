import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport_app/Constants/colorConstant.dart';

//main page
const tSearch = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: kMainComponentColor);
const tLiveTitle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: kMainComponentColor,
  height: 1.12,
  shadows: [
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 3.0,
      color: const Color.fromARGB(255, 116, 116, 116),
    ),
  ],
);
const tLiveAnchorName = TextStyle(
  fontFamily: 'Inter',
  fontSize: 10,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.3,
  height: 1.0,
  overflow: TextOverflow.ellipsis,
  color: kMainComponentColor,
  shadows: [
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 3.0,
      color: const Color.fromARGB(255, 116, 116, 116),
    ),
  ],
);
const tMain = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kMainTitleColor);
const tSelectedButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kMainComponentColor);
const tUnselectedButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kUnselectedTextColor);

//bottom navigation button
const tSelectedBottomNaviBtn = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: kMainGreenColor);

const tUnselectedBottomNaviBtn = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: kMainBottomNaviBtnColor);

//main page selection button component
const tTodayDateButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kComponentSelectedDateColor);
const tOtherUnselectedDateButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kComponentDateColor);
const tOtherSelectedDateButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kComponentSelectedDateColor);

//main page component
const tTagButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: kComponentTagTitleColor,
    overflow: TextOverflow.ellipsis);
const tDate = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kComponentDateColor);
const tGroupName = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kMainTitleColor);
const tScore = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kMainTitleColor);

//live page
const tShowAll = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kComponentSelectedDateColor);
const tLiveTitleComponent = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kMainTitleColor);
const tLiveAnchorNameComponent = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kComponentLiveAnchorColor);

const tSelectedTitleText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kMainTitleColor);

const tUnselectedTitleText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kMainGreyColor);

const tUnfollowText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kMainTitleColor);

//search page
const tSearchBarText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: kComponentSearchBarTextColor);
const tSearchingText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: kMainTitleColor);
const tCancelSearch = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kMainComponentColor);
const tClearSearchHistory = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kComponentClearSearchColor);
const tSearchTag = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kComponentClearSearchColor);

// game detail page
const tGameTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: kMainComponentColor);
const tGameDate = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.46,
    color: kComponentFullDateColor);
const tGameStatus = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.46,
    color: kComponentFullDateColor);
const tGameGroupName = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kMainComponentColor);
const tGameScore = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.42,
    color: kMainComponentColor);
const tGameScoreComponent = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: kMainTitleColor);
const tGamePercentage = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: kMainTitleColor);
const tGameScoreTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: kMainTitleColor);
const tGameStatisticTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w500,
    color: kMainTitleColor);

//info page
const tInfoTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w500,
    color: kMainTitleColor);

const tRead = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kComponentTagTitleColor);

const tInfoDetailTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w500,
    color: kMainComponentColor);

const tNewsTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 17,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w600,
    color: kMainTitleColor);

const tNewsDetails = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainGreyColor);

const tSwiperTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w500,
    color: kMainComponentColor);

//my page
const tUsername = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainTitleColor);
const tPhoneNo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainGreyColor);
const tCollectionBtn = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainComponentColor);
const tMyPageBtn = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainTitleColor);
const tHotGames = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainGreyColor);
const tHotsGameName = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400,
    color: kMainTitleColor);

// collection page
const tCollectionDateTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: kMainTitleColor);

// contact us page
const tContactUsTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: kMainTitleColor);

const tSocialMediaTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: kMainTitleColor);

// edit profile page
const tEditTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: kMainComponentColor);

// login page
const tContinueAsGuest = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: kMainGreenColor,
    decoration: TextDecoration.underline,
    decorationColor: kMainGreenColor);
const tPhoneNoInput = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kComponentHintTextColor,
);

// tag dialog
const tDialogTitle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 18,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.3,
  color: kMainTitleColor,
);

const tTagText = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.3,
  color: kComponentErrorTextColor,
);

const tSelectedTagTitle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.3,
  color: Colors.transparent,
  decoration: TextDecoration.underline,
  decorationColor: kMainGreenColor,
  decorationThickness: 4.0,
  shadows: [Shadow(color: kMainTitleColor, offset: Offset(0, -5))],
);

const tUnselectedTagTitle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.3,
  color: kMainGreyColor,
);

const tNewsTopTitle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.3,
  color: kMainTitleColor,
);

const tPinNews = TextStyle(
  fontFamily: 'Inter',
  fontSize: 10,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.3,
  color: kTopNewsTextColor,
);

const tTimeRead = TextStyle(
  fontFamily: 'Inter',
  fontSize: 10,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.3,
  color: kUnselectedTextColor,
);

const tHotNewsTitle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.3,
  color: kMainTitleColor,
);

const tHotIndex = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.3,
  color: kIndexColor,
);

// follow page
const tFollowNull = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: kUnselectedTextColor);
