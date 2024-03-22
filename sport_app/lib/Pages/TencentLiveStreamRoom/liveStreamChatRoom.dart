import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/v2_tx_live_player_observer.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sport_app/Model/followingModel.dart';
import 'package:sport_app/Provider/anchorFollowProvider.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/config/display_config.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/gift.dart';
import 'package:tencent_cloud_av_chat_room/model/anchor_info.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_controller.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_custom_widget.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_theme.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../Component/Loading/emptyResultComponent.dart';
import '../../Component/Tencent/liveStreamPlayer.dart';
import '../../Constants/colorConstant.dart';
import '../../../Model/userDataModel.dart';
import '../../Services/Utils/tencent/tencentUrlUtils.dart';

class LiveStreamChatRoom extends StatefulWidget {
  final String userLoginId;
  final String avChatRoomId;
  final String anchor;
  final String streamTitle;
  final String anchorPic;
  final String liveURL;
  final String anchorId;
  final V2TXLivePlayMode playMode;

  const LiveStreamChatRoom(
      {Key? key,
      required this.userLoginId,
      required this.avChatRoomId,
      required this.anchor,
      required this.streamTitle,
      required this.anchorPic,
      required this.playMode,
      required this.anchorId,
      required this.liveURL})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveStreamChatRoomState();
}

class _LiveStreamChatRoomState extends State<LiveStreamChatRoom> {
  //variable for live stream
  bool _isPlaying = false;
  bool _ismuteState = false;
  bool _isDanmakuOn = false;
  bool _isFullScreen = false;
  bool _showAppBar = true;
  bool isFollowed = false;
  int? _localViewId;
  double _currentPage = 1;

  //live stream player
  V2TXLivePlayer? _livePlayer;

  //get user information
  UserDataModel userModel = Get.find<UserDataModel>();

  // provider
  AnchorFollowProvider provider = AnchorFollowProvider();

  //tencent controller
  final TencentCloudAvChatRoomController controller =
      TencentCloudAvChatRoomController();
  final PageController _pageController = PageController(initialPage: 1);

  Future<void> createFollow() async {
    CreateFollowModel? followModel =
        await provider.createFollow(widget.anchorId);
  }

  //create live stream player--------------------from Tencent----------------------------------//
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePlayer = await V2TXLivePlayer.create();
    _livePlayer?.addListener(onPlayerObserver);
    if (!mounted) return;
    debugPrint("CreatePlayer result is ${_livePlayer?.status}");
  }

  onPlayerObserver(V2TXLivePlayerListenerType type, param) {
    debugPrint("==player listener type= ${type.toString()}");
    debugPrint("==player listener param= $param");
  }

  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        if (viewId != null) {
          _localViewId = viewId;
          var code = await _livePlayer?.setRenderViewID(_localViewId!);
          if (code != V2TXLIVE_OK) {
            debugPrint("Start Play error");
          }

          var url = URLUtils.generateRtmpPlayUrl(widget.liveURL);
          var playStatus = await _livePlayer?.startLivePlay(url);
          print("check player 3: $playStatus");
          if (playStatus == null || playStatus != V2TXLIVE_OK) {
            debugPrint("play error: $playStatus url: ${url}");
            return;
          }
          await _livePlayer?.setPlayoutVolume(100);
          setState(() {
            _isPlaying = true;
          });
        }
        var code = await _livePlayer?.setRenderViewID(_localViewId!);
      },
    );
  }

  //--------------------------full screen danmaku------------------------------------------------//
  _initPageControllerListener() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 1.0;
      });
    });
  }

  Widget scrollableDanmaku({required Stack child}) {
    return PageView.builder(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        itemCount: 2,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              // color: Colors.transparent,
              width: double.infinity,
              child: Stack(children: [
                Positioned(
                  top: 280,
                  right: 680,
                  child: InkWell(
                    onTap: () {
                      if (_isPlaying) {
                        pausePlay();
                      } else {
                        startPlay();
                      }
                    },
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.not_started_rounded,
                      size: _isPlaying ? 30 : 30,
                      color: Colors.white70,
                    ),
                  ),
                )
              ]),
            );
          } else {
            return Opacity(
              opacity: _currentPage,
              child: child,
            );
          }
        });
  }

  //--------------------------------------------------------------------------------------------//

  //live stream start play
  Future<void> startPlay() async {
    if (_isPlaying) {
      return;
    }
    if (_localViewId != null) {
      var code = await _livePlayer?.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        debugPrint("Start Play error: check the remote view Id");
      }
    }

    var url = URLUtils.generateRtmpPlayUrl(widget.liveURL);
    var playStatus = await _livePlayer?.startLivePlay(url);

    print("check live url: ${widget.liveURL}");
    if (playStatus == null || playStatus != V2TXLIVE_OK) {
      return;
    }
    await _livePlayer?.setPlayoutVolume(100);
    setState(() {
      _isPlaying = true;
    });
  }

  //live stream stop playing
  pausePlay() async {
    await _livePlayer?.stopPlay();
    setState(() {
      _isPlaying = false;
    });
  }

  //mute live stream
  void setMuteState(bool isMute) async {
    var code = await _livePlayer?.snapshot();
    if (isMute) {
      _livePlayer?.setPlayoutVolume(0);
    } else {
      _livePlayer?.setPlayoutVolume(100);
    }

    setState(() {
      _ismuteState = isMute;
    });
  }

  //Countdown widget
  void countDownWidget() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showAppBar = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    renderView();
    startPlay();
    countDownWidget();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  void deactivate() {
    _livePlayer?.removeListener(onPlayerObserver);
    _livePlayer?.stopPlay();
    _livePlayer?.destroy();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    deactivate();
  }

  @override
  Widget build(BuildContext context) {
    String anchorPhoto = widget.anchorPic;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    //size of widget
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double height = MediaQuery.of(context).size.height;
    //Portrait or Landscape
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
        onWillPop: () async {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: kMainGreenColor, // Set status bar color
          ));
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return true;
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: kMainBackgroundColor,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: isPortrait
                        ? () => {
                              Navigator.pop(context),
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                statusBarColor:
                                    kMainGreenColor, // Set status bar color
                              ))
                            }
                        : () => SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: white,
                      size: 20,
                    ),
                  ),
                ),
                body: OrientationBuilder(builder: (context, orientation) {
                  return orientation == Orientation.portrait
                      ? GestureDetector(
                          onTap: () {
                            _showAppBar = true;
                            countDownWidget();
                          },
                          child: Stack(
                            children: [
                              _isDanmakuOn
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0 * fem,
                                          vertical: 10 * fem),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10 * fem,
                                          vertical: 50 * fem),
                                      alignment: Alignment.bottomCenter,
                                      child: searchEmptyWidget(),
                                    )
                                  : Positioned(
                                      right: -15,
                                      bottom: 25,
                                      child: Lottie.asset(
                                        'images/livepage/hearts.json',
                                        width: 100,
                                        height: 400,
                                        repeat: true,
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15 * fem),

                                //see if wan use container to set the size and background color
                                child: _isDanmakuOn
                                    ? Positioned(
                                        bottom: 25,
                                        right: -15,
                                        child: Container())
                                    : TencentCloudAVChatRoom(
                                        theme: TencentCloudAvChatRoomTheme(
                                          backgroundColor: white,
                                          hintColor: Colors.black45,
                                          textTheme:
                                              TencentCloudAvChatRoomTextTheme(),
                                          accentColor: Colors.black45,
                                          isDark: false,
                                          secondaryColor: kMainGreenColor,
                                          highlightColor: kMainGreenColor,
                                        ),
                                        controller: controller,
                                        config: TencentCloudAvChatRoomConfig(
                                            avChatRoomID: widget.avChatRoomId,
                                            loginUserID: widget.userLoginId,
                                            giftHttpBase:
                                                "https://live-stream-1321239144.cos.ap-singapore.myqcloud.com/head/",
                                            displayConfig: DisplayConfig(
                                              showAnchor: false,
                                              showOnlineMemberCount: false,
                                              showTextFieldGiftAction: true,
                                              showTextFieldThumbsUpAction: true,
                                            )),
                                        customWidgets:
                                            TencentCloudAvChatRoomCustomWidgets(
                                          giftsPanelBuilder: (context) {
                                            return GiftPanel(onTap: (item) {
                                              final customInfo = {
                                                "version": 1.0, // 协议版本号
                                                "businessID":
                                                    "flutter_live_kit", // 业务标识字段
                                                "data": {
                                                  "cmd":
                                                      "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
                                                  "cmdInfo": {
                                                    "type": item.type,
                                                    "giftUrl": item.giftUrl,
                                                    "giftCount": 1,
                                                    "giftSEUrl": item.seUrl,
                                                    "giftName": item.name,
                                                    "giftUnits": "朵",
                                                  }
                                                },
                                              };
                                              controller.sendGiftMessage(
                                                  jsonEncode(customInfo));
                                              Navigator.pop(context);
                                            });
                                          },
                                          textFieldDecoratorBuilder: (context) {
                                            return Container(
                                              width: 230 * fem,
                                              height: 40 * fem,
                                              child: RoundedContainer(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 6),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 4 * fem,
                                                    ),
                                                    Text(
                                                      userModel.isCN.value
                                                          ? "输入内容..."
                                                          : "Say Something...",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color.fromARGB(
                                                              255,
                                                              141,
                                                              141,
                                                              141),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        data: TencentCloudAvChatRoomData(
                                          isSubscribe: false,
                                          notification: userModel.isCN.value
                                              ? "欢迎来到直播间！严禁未成年人直播、打赏或向末成年人销售酒类商品。若主播销售酒类商品，请未成年人在监护人陪同下观看。直播间内严禁出现违法违规、低俗色情、吸烟酗酒、人身伤害等内容。如主播在直播中以不当方式诱导打赏私下交易请谨慎判断以防人身财产损失购买商品请点击下方购物车按钮，请勿私下交易，请大家注意财产安全，谨防网络诈骗。"
                                              : "Welcome to the live broadcast room! It is strictly prohibited for minors to live stream, tip or sell alcoholic products to under-adults. If the anchor sells alcohol, minors are asked to watch with the supervision of a guardian. Contents that violate laws and regulations, vulgar pornography, smoking, alcoholism, personal injury, etc. are strictly prohibited in the live broadcast room. If the anchor improperly induces rewards during the live broadcast and makes private transactions, please use caution to prevent personal and property losses. To purchase goods, please click the shopping cart button below. Please do not make private transactions. Please pay attention to property safety and beware of online fraud.",
                                          anchorInfo: AnchorInfo(
                                              subscribeNum: 200,
                                              fansNum: 5768,
                                              nickName: TIM_t(widget.anchor),
                                              avatarUrl: "${widget.anchorPic}"),
                                        ),
                                      ),
                              ),
                              Container(
                                height: 400,
                                alignment: Alignment.center,
                                width: double.infinity,
                                color: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 280,
                                      alignment: Alignment.center,
                                      child: renderView(),
                                    ),
                                    Container(
                                      height: 120,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: double.infinity,
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15 * fem,
                                                      13 * fem,
                                                      10 * fem,
                                                      5 * fem),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            kLightGreyColor,
                                                        backgroundImage:
                                                            anchorPhoto == ''
                                                                ? null
                                                                : NetworkImage(
                                                                    "${anchorPhoto}"),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Container(
                                                        height: 50 * fem,
                                                        width: 140 * fem,
                                                        child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    1 * fem,
                                                                    6 * fem,
                                                                    1 * fem,
                                                                    3 * fem),
                                                            child: TextScroll(
                                                              widget.anchor,
                                                              mode:
                                                                  TextScrollMode
                                                                      .endless,
                                                              velocity: const Velocity(
                                                                  pixelsPerSecond:
                                                                      Offset(20,
                                                                          0)),
                                                              delayBefore:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              pauseBetween:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          5000),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Obx(
                                                        () => Container(
                                                            height: 30 * fem,
                                                            width: userModel
                                                                        .isCN
                                                                        .value ==
                                                                    true
                                                                ? 78 * fem
                                                                : 90 * fem,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5 *
                                                                              fem,
                                                                      vertical:
                                                                          1 * fem),
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: isFollowed
                                                                        ? kMainGreenColor
                                                                        : kButtonOffSecondaryColor,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10 *
                                                                                fem),
                                                                    side: BorderSide
                                                                        .none,
                                                                    elevation:
                                                                        0.3,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(30))),
                                                                onPressed: () {
                                                                  //点击关注
                                                                  setState(() {
                                                                    createFollow();
                                                                    isFollowed =
                                                                        !isFollowed;
                                                                  });
                                                                },
                                                                child: Obx(
                                                                  () => Text(
                                                                    userModel
                                                                            .isCN
                                                                            .value
                                                                        ? isFollowed
                                                                            ? "已关注"
                                                                            : "关注"
                                                                        : isFollowed
                                                                            ? "Following"
                                                                            : "Follow",
                                                                    style: TextStyle(
                                                                        fontSize: userModel.isCN.value ==
                                                                                true
                                                                            ? 13
                                                                            : 12,
                                                                        color: isFollowed
                                                                            ? white
                                                                            : kMainGreenColor,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 30 * fem,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15 * fem,
                                                      1 * fem,
                                                      5 * fem,
                                                      1 * fem),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 30 * fem,
                                                        width: 250 * fem,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  5 * fem,
                                                                  1 * fem,
                                                                  1 * fem,
                                                                  3 * fem),
                                                          child: TextScroll(
                                                            widget.streamTitle,
                                                            mode: TextScrollMode
                                                                .endless,
                                                            velocity:
                                                                const Velocity(
                                                                    pixelsPerSecond:
                                                                        Offset(
                                                                            20,
                                                                            0)),
                                                            delayBefore:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            pauseBetween:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50 * fem,
                                                      ),
                                                      Container(
                                                          height: 25 * fem,
                                                          width: 45 * fem,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _isDanmakuOn =
                                                                    !_isDanmakuOn;
                                                              });
                                                            },
                                                            child: Container(
                                                                width: 72 * fem,
                                                                height:
                                                                    30 * fem,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _isDanmakuOn
                                                                      ? kButtonOnColor
                                                                      : kSecondaryBtnColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(15 *
                                                                              fem),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      AnimatedAlign(
                                                                        curve: Curves
                                                                            .bounceInOut,
                                                                        alignment: _isDanmakuOn
                                                                            ? Alignment.centerRight
                                                                            : Alignment.centerLeft,
                                                                        duration:
                                                                            Duration(milliseconds: 80),
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                0 * fem,
                                                                            vertical:
                                                                                0 * fem,
                                                                          ),
                                                                          width:
                                                                              24 * fem,
                                                                          height:
                                                                              24 * fem,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              boxShadow: [
                                                                                _isDanmakuOn
                                                                                    ? const BoxShadow(
                                                                                        color: Color.fromARGB(255, 196, 196, 196),
                                                                                        offset: Offset(-1, 0),
                                                                                        blurRadius: 0.5,
                                                                                        spreadRadius: 0.1,
                                                                                      )
                                                                                    : const BoxShadow(
                                                                                        color: Color.fromARGB(255, 60, 134, 62),
                                                                                        offset: Offset(1, 0),
                                                                                        blurRadius: 0.5,
                                                                                        spreadRadius: 0.1,
                                                                                      )
                                                                              ],
                                                                              border: Border.all(
                                                                                color: _isDanmakuOn ? kButtonOnSecondaryColor : kMainGreenColor,
                                                                                width: 5,
                                                                              ),
                                                                              color: _isDanmakuOn ? Colors.white : Colors.white),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                0.5 * fem,
                                                                                0 * fem,
                                                                                2 * fem,
                                                                                2 * fem),
                                                                            child:
                                                                                Text(
                                                                              "开",
                                                                              style: GoogleFonts.inter(fontSize: 11 * fem, color: _isDanmakuOn ? kButtonOnColor : kMainGreenColor, fontWeight: _isDanmakuOn ? FontWeight.w500 : FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                6 * fem,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                0.5 * fem,
                                                                                0 * fem,
                                                                                0 * fem,
                                                                                2 * fem),
                                                                            child:
                                                                                Text(
                                                                              "关",
                                                                              style: GoogleFonts.inter(
                                                                                fontSize: 11 * fem,
                                                                                color: _isDanmakuOn ? kButtonOnWordColor : kSecondaryBtnColor,
                                                                                fontWeight: _isDanmakuOn ? FontWeight.w500 : FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                          ))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              !_isPlaying
                                  ? Container(
                                      height: 280,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      color: Colors.black.withOpacity(0.5),
                                    )
                                  : Container(),
                              Positioned(
                                  top: 230 * fem,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        10 * fem, 0 * fem, 10 * fem, 10 * fem),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Positioned(
                                            top: 210 * fem,
                                            right: 330 * fem,
                                            child: InkWell(
                                              onTap: () {
                                                if (_isPlaying) {
                                                  pausePlay();
                                                } else {
                                                  startPlay();
                                                }
                                              },
                                              child: Icon(
                                                _isPlaying
                                                    ? Icons
                                                        .pause_circle_filled_rounded
                                                    : Icons.not_started_rounded,
                                                size: _isPlaying ? 30 : 30,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 250 * fem,
                                          ),
                                          Positioned(
                                            top: 210 * fem,
                                            left: 280 * fem,
                                            child: InkWell(
                                              onTap: () {
                                                setMuteState(!_ismuteState);
                                              },
                                              child: Icon(
                                                _ismuteState
                                                    ? Icons.volume_off
                                                    : Icons.volume_up,
                                                size: 30,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10 * fem,
                                          ),
                                          Positioned(
                                              top: 210 * fem,
                                              left: 330 * fem,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _isFullScreen = true;
                                                  });

                                                  if (_isFullScreen) {
                                                    SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .landscapeLeft,
                                                      DeviceOrientation
                                                          .landscapeRight
                                                    ]);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.fullscreen,
                                                  size: 30,
                                                  color: Colors.white70,
                                                ),
                                              )),
                                        ]),
                                  ))
                            ],
                          ))
                      : Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              height: height,
                              width: double.infinity,
                              child: renderView(),
                              color: Colors.black,
                            ),
                            _isPlaying
                                ? Container()
                                : Container(
                                    height: height,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    color: black.withOpacity(0.5),
                                  ),
                            scrollableDanmaku(
                                child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      10 * fem, 10 * fem, 10 * fem, 10 * fem),
                                  child: Positioned(
                                    top: 145 * fem,
                                    left: 10 * fem,
                                    child: TencentCloudAVChatRoom(
                                      theme: TencentCloudAvChatRoomTheme(
                                        backgroundColor:
                                            Color.fromARGB(255, 100, 100, 100)
                                                .withOpacity(0.5),
                                        hintColor: Colors.black45,
                                        textTheme:
                                            TencentCloudAvChatRoomTextTheme(
                                                barrageTitleStyle: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 84, 193, 244),
                                                    fontWeight: FontWeight
                                                        .bold), // 弹幕消息发送人名称主题
                                                barrageTextStyle: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold) // 弹幕消息内容主题
                                                ),
                                        accentColor: Colors.black45,
                                        isDark: true,
                                        secondaryColor:
                                            Color.fromARGB(255, 84, 193, 244),
                                        highlightColor: Colors.white,
                                      ),
                                      controller: controller,
                                      config: TencentCloudAvChatRoomConfig(
                                          avChatRoomID: widget.avChatRoomId,
                                          loginUserID: widget.userLoginId,
                                          giftHttpBase:
                                              "https://live-stream-1321239144.cos.ap-singapore.myqcloud.com/head/",
                                          displayConfig: DisplayConfig(
                                            showAnchor: false,
                                            showOnlineMemberCount: true,
                                            showTextFieldGiftAction: true,
                                            showTextFieldThumbsUpAction: true,
                                          )),
                                      customWidgets:
                                          TencentCloudAvChatRoomCustomWidgets(
                                        onlineMemberListPanelBuilder:
                                            (context, groupID) {
                                          return const Text(
                                              "onlineMemberListPanelBuilder");
                                        },
                                        giftsPanelBuilder: (context) {
                                          return GiftPanel(onTap: (item) {
                                            final customInfo = {
                                              "version": 1.0, // 协议版本号
                                              "businessID":
                                                  "flutter_live_kit", // 业务标识字段
                                              "data": {
                                                "cmd":
                                                    "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
                                                "cmdInfo": {
                                                  "type": item.type,
                                                  "giftUrl": item.giftUrl,
                                                  "giftCount": 1,
                                                  "giftSEUrl": item.seUrl,
                                                  "giftName": item.name,
                                                  "giftUnits": "朵",
                                                }
                                              },
                                            };
                                            controller.sendGiftMessage(
                                                jsonEncode(customInfo));
                                            Navigator.pop(context);
                                          });
                                        },
                                        textFieldDecoratorBuilder: (context) {
                                          return Container(
                                            width: 230 * fem,
                                            height: 15 * fem,
                                            child: RoundedContainer(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 6),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 4 * fem,
                                                  ),
                                                  Text(
                                                    userModel.isCN.value
                                                        ? "输入内容..."
                                                        : "Say Something...",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                  // TextFormField(
                                                  //   decoration: InputDecoration(
                                                  //     hintText:
                                                  //         // AppLocalizations.of(
                                                  //         //         context)!
                                                  //         //     .saySmthg,
                                                  //         "输入内容...",
                                                  //     hintStyle:
                                                  //         const TextStyle(
                                                  //             fontSize: 14,
                                                  //             color: Color
                                                  //                 .fromARGB(
                                                  //                     255,
                                                  //                     255,
                                                  //                     255,
                                                  //                     255),
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .w500),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      data: TencentCloudAvChatRoomData(
                                        isSubscribe: false,
                                        notification:
                                            // AppLocalizations.of(context)!
                                            //     .welcomeStream,
                                            userModel.isCN.value
                                                ? "欢迎来到直播间！严禁未成年人直播、打赏或向末成年人销售酒类商品。若主播销售酒类商品，请未成年人在监护人陪同下观看。直播间内严禁出现违法违规、低俗色情、吸烟酗酒、人身伤害等内容。如主播在直播中以不当方式诱导打赏私下交易请谨慎判断以防人身财产损失购买商品请点击下方购物车按钮，请勿私下交易，请大家注意财产安全，谨防网络诈骗。"
                                                : "Welcome to the live broadcast room! It is strictly prohibited for minors to live stream, tip or sell alcoholic products to under-adults. If the anchor sells alcohol, minors are asked to watch with the supervision of a guardian. Contents that violate laws and regulations, vulgar pornography, smoking, alcoholism, personal injury, etc. are strictly prohibited in the live broadcast room. If the anchor improperly induces rewards during the live broadcast and makes private transactions, please use caution to prevent personal and property losses. To purchase goods, please click the shopping cart button below. Please do not make private transactions. Please pay attention to property safety and beware of online fraud.",
                                        anchorInfo: AnchorInfo(
                                            subscribeNum: 200,
                                            fansNum: 5768,
                                            nickName: TIM_t(widget.anchor),
                                            avatarUrl:
                                                "https://qcloudimg.tencent-cloud.cn/raw/9c6b6806f88ee33b3685f0435fe9a8b3.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ],
                          // )
                        );
                }))));
  }

  static void launch() {}
}
