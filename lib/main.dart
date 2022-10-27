import 'dart:io'; // 사용자 OS가 ios, android인지 확인가능(추후에 사용)

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // easy_localization이 안되면 flutter run 다시 시작하기
//import 'package:flutter/cupertino.dart';

import 'package:new_ara_app/home.dart';
import 'package:new_ara_app/constants/colors.dart';

final supportedLocales = [
  const Locale('en', 'US'),
  const Locale('ko', 'KR'),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ko', 'KR'),
      startLocale: const Locale('ko', 'KR'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: _setThemeData(),
      home: NewAraHome(), // 나중에 로그인 관련 처리를 해야함(일단 로그인 되었다고 가정)
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
