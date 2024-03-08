import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Constants/colorConstant.dart';

class HotNewsPage extends StatefulWidget {
  const HotNewsPage({super.key});

  @override
  State<HotNewsPage> createState() => _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: kMainHotNewsColor));

    // standard size
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      backgroundColor: kSecondaryHotNewsColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 121 * fem,
              color: kSecondaryHotNewsColor,
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: kSecondaryHotNewsColor,
                scrolledUnderElevation: 0.0,
                elevation: 0.0,
                flexibleSpace: ClipRRect(
                  child: Container(
                    height: 121 * fem,
                    // width: 375 * fem,
                    color: kSecondaryHotNewsColor,
                    alignment: Alignment.topCenter,
                    child: Image(
                      image: AssetImage('images/info/hotNewsBanner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                actions: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
