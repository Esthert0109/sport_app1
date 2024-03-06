import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sport_app/Provider/basketballMatchProvider.dart';
import 'package:sport_app/Provider/footballMatchProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Constants/Controller/layoutController.dart';
import 'Constants/colorConstant.dart';
import 'Model/userDataModel.dart';
import 'Pages/AuthenticationPages/forgotPassword.dart';
import 'Pages/AuthenticationPages/login.dart';
import 'Pages/AuthenticationPages/registration.dart';
import 'Pages/OnboardingPages/onboarding.dart';
import 'Pages/OnboardingPages/opening.dart';
import 'bottomNavigationBar.dart';

void main() {
  Get.put(UserDataModel());
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LayoutController());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FootballMatchProvider()),
          ChangeNotifierProvider(create: (context) => BasketballMatchProvider())
        ],
        child: GetMaterialApp(
          theme: ThemeData(primaryColor: kMainBackgroundColor),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: _locale,
          supportedLocales: [Locale('en'), Locale('zh')],
          initialRoute: '/opening',
          getPages: [
            GetPage(name: '/opening', page: () => const Opening()),
            GetPage(name: '/auth', page: () => const OnboardingPage()),
            GetPage(name: '/login', page: () => const Login()),
            GetPage(name: '/register', page: () => const Register()),
            GetPage(name: '/forgotpass', page: () => const ForgotPass()),
            GetPage(name: '/home', page: () => const BottomNaviBar()),
          ],
        ),
      ),
    );
  }
}
