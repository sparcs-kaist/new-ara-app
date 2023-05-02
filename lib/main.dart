import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/pages/newAra_home_page.dart';
import 'package:new_ara_app/pages/login_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';

final supportedLocales = [
  const Locale('en'),
  const Locale('ko'),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ko'),
      startLocale: const Locale('ko'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: _setThemeData(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child!,
          );
        },

        /// hasData true -> newarahomepage, false -> loginpage.
        home: context.watch<UserProvider>().hasData ? NewAraHomePage() : LoginPage());
  }

  ThemeData _setThemeData() {
    return ThemeData(
      appBarTheme:
          const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
      //scaffoldBackgroundColor: Colors.white,
      fontFamily: 'NotoSansKR',
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
