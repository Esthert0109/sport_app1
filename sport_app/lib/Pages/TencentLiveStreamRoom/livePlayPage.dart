import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';
import 'package:live_flutter_plugin/v2_tx_live_player_observer.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Component/Tencent/liveStreamPlayer.dart';
import '../../Constants/colorConstant.dart';
import '../../Services/Utils/tencent/tencentUrlUtils.dart';

class LivePlayPage2 extends StatefulWidget {
  final String streamId;
  final String title;

  const LivePlayPage2({
    Key? key,
    required this.streamId,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LivePlayPage2State();
}

class _LivePlayPage2State extends State<LivePlayPage2> {
  bool _ismuteState = false;
  bool _showAppBar = true;
  bool _isFullScreen = false;
  int? _localViewId;

  V2TXLivePlayer? _livePlayer;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    startPlay();
    countDownWidget();
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

  /// 提示浮层
  showToastText(text) {
    showToast(
      text,
      context: context,
      alignment: Alignment.center,
    );
  }

  /// 设置静音
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

  bool _isPlaying = false;

  void startPlay() async {
    if (_isPlaying) {
      return;
    }
    if (_localViewId != null) {
      debugPrint("_localViewId $_localViewId");
      var code = await _livePlayer?.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        debugPrint("StartPlay error： please check remoteView load");
      }
    }
    var url = URLUtils.generateRtmpPlayUrl(widget.streamId);
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

  pausePlay() async {
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

          var url = URLUtils.generateRtmpPlayUrl(widget.streamId);
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

  @override
  Widget build(BuildContext context) {
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: black,
          extendBodyBehindAppBar: true,
          appBar: _showAppBar
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    widget.title,
                    style: TextStyle(color: white),
                  ),
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
                      Icons.arrow_back_ios_rounded,
                      color: white,
                      size: 20,
                    ),
                  ),
                )
              : AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? GestureDetector(
                      onTap: () {
                        _showAppBar = true;
                        countDownWidget();
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              height: 280,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showAppBar = true;
                                      countDownWidget();
                                    });
                                  },
                                  child: renderView()),
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
                            Positioned(
                                top: 520 * fem,
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
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: height - 30,
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
                      ],
                    );
            },
          )),
    );
  }
}
