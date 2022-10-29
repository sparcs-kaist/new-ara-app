import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/home.dart';
import 'package:new_ara_app/constants/colors.dart';

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
      child: MyApp(),
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
      home: NewAraHome(), // 추후에 로그인 여부 관련 처리 필요
    );
  }

  ThemeData _setThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        headline1: TextStyle(
            color: NEWARA_COLOR, fontSize: 23, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
