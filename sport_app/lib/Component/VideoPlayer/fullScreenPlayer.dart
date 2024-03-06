import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/v2_tx_live_player_observer.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:text_scroll/text_scroll.dart';

class LivePlayFullScreenPage extends StatefulWidget {
  final String streamTitle;
  final String url;
  final bool muteState;
  final bool isPlaying;
  final int? localViewId;

  const LivePlayFullScreenPage(
      {Key? key,
      required this.streamTitle,
      required this.muteState,
      required this.localViewId,
      required this.isPlaying,
      required this.url})
      : super(key: key);

  @override
  State<LivePlayFullScreenPage> createState() => _LivePlayFullScreenPageState();
}

class _LivePlayFullScreenPageState extends State<LivePlayFullScreenPage> {
  V2TXLivePlayer? livePlayer;
  V2TXLiveVideoResolutionMode resolutionMode =
      V2TXLiveVideoResolutionMode.v2TXLiveVideoResolutionModePortrait;
  V2TXLiveRotation rotation = V2TXLiveRotation.v2TXLiveRotation90;
  bool _isPlaying = true;
  int? _localViewId;
  bool showAppBar = true;
  bool _muteState = false;

  @override
  void initState() {
    super.initState();

    _isPlaying = widget.isPlaying;
    _localViewId = widget.localViewId;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);


    if (_isPlaying == true) {
    }

    countDownAppBar();
  }

  void countDownAppBar() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showAppBar = false;
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  onPlayerObserver(V2TXLivePlayerListenerType type, param) {
    debugPrint("==player listener type = ${type.toString()}");
    debugPrint("==player listener param = $param");
  }

  Future<void> initPlatformState() async {
    livePlayer = await V2TXLivePlayer.create();
    livePlayer?.addListener(onPlayerObserver);

    if (!mounted) {
      return;
    }
  }

  Future<void> startPlayPortrait() async {
    if (widget.isPlaying == false) {
      return;
    }
    if (_localViewId != null) {
      var code = await livePlayer?.setRenderViewID(_localViewId!);

      if (code != V2TXLIVE_OK) {
        debugPrint("StartPlay error: please check remoteView ID");
        return;
      }
    }
    var playStatus = await livePlayer?.startLivePlay(widget.url);
    if (playStatus == null || playStatus != V2TXLIVE_OK) {
      debugPrint("error: $playStatus, url: ${widget.url}");
      return;
    }
    setState(() {
      _isPlaying = true;
    });
  }

  stopPlayPortrait() async {
    await livePlayer?.stopPlay();
    setState(() {
      _isPlaying = false;
    });
  }

  void setMuteState(bool isMute) async {
    var code = await livePlayer?.snapshot();
    debugPrint("result code $code");
    if (isMute) {
      livePlayer?.setPlayoutVolume(0);
    } else {
      livePlayer?.setPlayoutVolume(100);
    }
    setState(() {
      _muteState = isMute;
    });
  }

  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        print("play error: $viewId");
        if (viewId != null) {
          _localViewId = viewId;
          var code = await livePlayer?.setRenderViewID(widget.localViewId!);
          print("play error2: $code");
          if (code != V2TXLIVE_OK) {
            debugPrint("Start Play error");
          }
          var playStatus = await livePlayer?.startLivePlay(widget.url);

          print("play error3: $playStatus");
          if (playStatus == null || playStatus != V2TXLIVE_OK) {
            debugPrint("play error: $playStatus url: ${widget.url}");
            return;
          }
          await livePlayer?.setPlayoutVolume(100);
          setState(() {
            _isPlaying = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = MediaQuery.of(context).size.width * 0.7;
    double height = MediaQuery.of(context).size.height;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black),
    );

    String streamTitle = widget.streamTitle;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: showAppBar
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    title: Container(
                        height: 50 * fem,
                        width: 500 * fem,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5 * fem, 15 * fem, 0, 0),
                          child: TextScroll(
                            widget.streamTitle,
                            mode: TextScrollMode.endless,
                            velocity: Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: Duration(milliseconds: 500),
                            pauseBetween: Duration(milliseconds: 500),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    leading: IconButton(
                      onPressed: () => {Navigator.pop(context)},
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                  )
                : null,
            body: GestureDetector(
                onTap: () {
                  setState(() {
                    showAppBar = !showAppBar;
                    countDownAppBar();
                  });
                },
                child: Stack(
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
                            alignment: Alignment.center,
                            width: double.infinity,
                            color: black.withOpacity(0.5),
                          ),
                    showAppBar
                        ? Positioned(
                            top: 240 * fem,
                            right: 560 * fem,
                            child: InkWell(
                              onTap: () {
                                if (_isPlaying) {
                                  stopPlayPortrait();
                                } else {
                                  startPlayPortrait();
                                }
                              },
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause
                                    : Icons.arrow_right_rounded,
                                size: _isPlaying ? 30 : 60,
                                color: Colors.white70,
                              ),
                            ),
                          )
                        : Container(),
                    showAppBar
                        ? Positioned(
                            top: 240 * fem,
                            left: 500 * fem,
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
                          )
                        : Container(),
                  ],
                ))));
  }
}
