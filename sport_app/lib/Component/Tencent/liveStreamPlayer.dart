import 'dart:async';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';
import 'package:live_flutter_plugin/v2_tx_live_player_observer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_controller.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../Constants/colorConstant.dart';
import '../../Model/UserDataModel.dart';
import '../VideoPlayer/danmakuInput.dart';
import '../VideoPlayer/fullScreenPlayer.dart';

enum V2TXLivePlayMode {
  /// 标准直播拉流
  v2TXLivePlayModeStand,

  /// RTC拉流
  v2TXLivePlayModeRTC,

  /// 快直播拉流
  v2TXLivePlayModeLeb,
}

/// 直播拉流
class LivePlayPage extends StatefulWidget {
  final V2TXLivePlayMode playMode;
  final String streamerName;
  final String streamTitle;
  final String loginUserID;
  final String avChatRoomID;
  final String streamerAvatar;

  const LivePlayPage({
    Key? key,
    required this.playMode,
    required this.streamTitle,
    required this.streamerName,
    required this.loginUserID,
    required this.avChatRoomID,
    required this.streamerAvatar,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LivePlayPageState();
}

class _LivePlayPageState extends State<LivePlayPage> {
  int? _localViewId;
  V2TXLivePlayer? _livePlayer;
  bool _isPlaying = false;
  bool isDanmakuOn = true;
  bool isFullScreen = false;
  bool _muteState = false;
  UserDataModel userModel = Get.find<UserDataModel>();
  var url = "rtmp://play.mindark.cloud/live/hd-zh-2-3735975";
  final TencentCloudAvChatRoomController controller =
      TencentCloudAvChatRoomController();

  Future<void> startPlay() async {
    if (_isPlaying) {
      return;
    }
    if (_localViewId != null) {
      debugPrint("_localViewId $_localViewId");
      var code = await _livePlayer?.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        debugPrint("StartPlay error: please check remoteView load");
      }
    }
    debugPrint("play url: $url");
    var playStatus = await _livePlayer?.startLivePlay(url);
    if (playStatus == null || playStatus != V2TXLIVE_OK) {
      debugPrint("play error: $playStatus url: $url");
      return;
    }
    await _livePlayer?.setPlayoutVolume(100);
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    renderView();
  }

  @override
  void deactivate() {
    debugPrint("Live-Play deactivate");
    _livePlayer?.removeListener(onPlayerObserver);
    _livePlayer?.stopPlay();
    _livePlayer?.destroy();
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint("Live-Play dispose");
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePlayer = await V2TXLivePlayer.create();
    _livePlayer?.addListener(onPlayerObserver);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    debugPrint("CreatePlayer result is ${_livePlayer?.status}");
  }

  onPlayerObserver(V2TXLivePlayerListenerType type, param) {
    debugPrint("==player listener type= ${type.toString()}");
    debugPrint("==player listener param= $param");
  }

  /// 设置静音
  void setMuteState(bool isMute) async {
    var code = await _livePlayer?.snapshot();
    debugPrint("result code $code");
    if (isMute) {
      _livePlayer?.setPlayoutVolume(0);
    } else {
      _livePlayer?.setPlayoutVolume(100);
    }
    setState(() {
      _muteState = isMute;
    });
  }

  stopPlay() async {
    await _livePlayer?.stopPlay();
    setState(() {
      _isPlaying = false;
    });
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
          var playStatus = await _livePlayer?.startLivePlay(url);
          if (playStatus == null || playStatus != V2TXLIVE_OK) {
            debugPrint("play error: $playStatus url: $url");
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    //variable for Live Stream Room
    String streamerName = widget.streamerName;
    String streamTitle = widget.streamTitle;

    return MaterialApp(
      home: Scaffold(
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 280,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: renderView(),
                    color: Colors.black,
                  ),
                  !_isPlaying
                      ? Container(
                          height: 280,
                          alignment: Alignment.center,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                        )
                      : Container(),
                  Positioned.fill(
                    top: 200 * fem,
                    right: 320 * fem,
                    child: InkWell(
                      onTap: () {
                        if (_isPlaying) {
                          stopPlay();
                        } else {
                          startPlay();
                        }
                      },
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.arrow_right_rounded,
                        size: _isPlaying ? 30 : 60,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 200 * fem,
                    left: 240 * fem,
                    child: InkWell(
                      onTap: () {
                        setMuteState(!_muteState);
                      },
                      child: Icon(
                        _muteState ? Icons.volume_off : Icons.volume_up,
                        size: 30,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Positioned.fill(
                      top: 200 * fem,
                      left: 320 * fem,
                      child: InkWell(
                        onTap: () {
                          deactivate();

                          LivePlayFullScreenPage(
                                  streamTitle: streamTitle,
                                  muteState: _muteState,
                                  localViewId: _localViewId,
                                  isPlaying: _isPlaying,
                                  url: url)
                              .launch(context);
                        },
                        child: Icon(
                          Icons.fullscreen,
                          size: 30,
                          color: Colors.white70,
                        ),
                      ))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              15 * fem, 13 * fem, 10 * fem, 5 * fem),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                height: 50 * fem,
                                width: 70 * fem,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        1 * fem, 6 * fem, 1 * fem, 3 * fem),
                                    child: TextScroll(
                                      streamerName,
                                      mode: TextScrollMode.endless,
                                      velocity: Velocity(
                                          pixelsPerSecond: Offset(20, 0)),
                                      delayBefore: Duration(milliseconds: 500),
                                      pauseBetween: Duration(milliseconds: 500),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Container(
                                  height: 30 * fem,
                                  width: 68 * fem,
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        4 * fem, 8 * fem, 1 * fem, 0 * fem),
                                    child: ElevatedButton(
                                      child: Text(
                                        "关注",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: kMainGreenColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: kButtonOffSecondaryColor,
                                          side: BorderSide.none,
                                          elevation: 0.3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () {
                                        //点击关注
                                      },
                                    ),
                                  )),
                              SizedBox(
                                width: 30 * fem,
                              ),
                              Container(
                                height: 30 * fem,
                                width: 124 * fem,
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 5 * fem, 1 * fem, 0 * fem),
                                child: DanmakuInput(
                                  isOn: isDanmakuOn,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              15 * fem, 1 * fem, 5 * fem, 1 * fem),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30 * fem,
                                width: 250 * fem,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      5 * fem, 1 * fem, 1 * fem, 3 * fem),
                                  child: TextScroll(
                                    streamTitle,
                                    mode: TextScrollMode.endless,
                                    velocity: Velocity(
                                        pixelsPerSecond: Offset(20, 0)),
                                    delayBefore: Duration(milliseconds: 500),
                                    pauseBetween: Duration(milliseconds: 500),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50 * fem,
                              ),
                              Container(
                                  height: 25 * fem,
                                  width: 45 * fem,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isDanmakuOn = !isDanmakuOn;
                                      });
                                    },
                                    child: Container(
                                        width: 72 * fem,
                                        height: 30 * fem,
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          color: isDanmakuOn
                                              ? kButtonOnColor
                                              : kSecondaryBtnColor,
                                          borderRadius:
                                              BorderRadius.circular(15 * fem),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AnimatedAlign(
                                                curve: Curves.bounceInOut,
                                                alignment: isDanmakuOn
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                duration:
                                                    Duration(milliseconds: 80),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 0 * fem,
                                                    vertical: 0 * fem,
                                                  ),
                                                  width: 24 * fem,
                                                  height: 24 * fem,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        isDanmakuOn
                                                            ? BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        196,
                                                                        196,
                                                                        196),
                                                                offset: Offset(
                                                                    -1, 0),
                                                                blurRadius: 0.5,
                                                                spreadRadius:
                                                                    0.1,
                                                              )
                                                            : BoxShadow(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    60,
                                                                    134,
                                                                    62),
                                                                offset: Offset(
                                                                    1, 0),
                                                                blurRadius: 0.5,
                                                                spreadRadius:
                                                                    0.1,
                                                              )
                                                      ],
                                                      border: Border.all(
                                                        color: isDanmakuOn
                                                            ? kButtonOnSecondaryColor
                                                            : kMainGreenColor,
                                                        width: 5,
                                                      ),
                                                      color: isDanmakuOn
                                                          ? Colors.white
                                                          : Colors.white),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0.5 * fem,
                                                            0 * fem,
                                                            2 * fem,
                                                            2 * fem),
                                                    child: Text(
                                                      "开",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 11 * fem,
                                                          color: isDanmakuOn
                                                              ? kButtonOnColor
                                                              : kMainGreenColor,
                                                          fontWeight:
                                                              isDanmakuOn
                                                                  ? FontWeight
                                                                      .w500
                                                                  : FontWeight
                                                                      .w400),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6 * fem,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0.5 * fem,
                                                            0 * fem,
                                                            0 * fem,
                                                            2 * fem),
                                                    child: Text(
                                                      "关",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11 * fem,
                                                        color: isDanmakuOn
                                                            ? kButtonOnWordColor
                                                            : kSecondaryBtnColor,
                                                        fontWeight: isDanmakuOn
                                                            ? FontWeight.w500
                                                            : FontWeight.w400,
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

            ],
          )),
    );
  }
}
