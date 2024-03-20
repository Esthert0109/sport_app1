import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Component/Tencent/liveStreamPlayer.dart';
import '../../Constants/colorConstant.dart';

class LiveStreamChatRoom2 extends StatefulWidget {
  final String userLoginId;
  final String avChatRoomId;
  final String anchor;
  final String streamTitle;
  final String anchorPic;
  final String liveURL;
  final V2TXLivePlayMode playMode;

  LiveStreamChatRoom2(
      {super.key,
      required this.userLoginId,
      required this.avChatRoomId,
      required this.anchor,
      required this.streamTitle,
      required this.anchorPic,
      required this.playMode,
      required this.liveURL});

  @override
  State<LiveStreamChatRoom2> createState() => _LiveStreamChatRoom2State();
}

class _LiveStreamChatRoom2State extends State<LiveStreamChatRoom2> {
  @override
  Widget build(BuildContext context) {
    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double height = MediaQuery.of(context).size.height;

    // Portrait or Landscape
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: kMainGreenColor, // Set status bar color
          ));
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: white,
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
                  size: 20,
                ),
              ),
            ),
          ),
        ));
  }
}
