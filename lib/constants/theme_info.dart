import 'package:flutter/material.dart';

class NewAraThemes {

  //-------------DARK THEME SETTINGS----
  static final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Color(0xff111111)),
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: Color(0xff111111),
    splashColor: Colors.transparent,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
      ),
    ),
  );


  //-------------light THEME SETTINGS----
  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.transparent,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.transparent,
    ),

  );



  static const Color darkMainText = Color(0xff000000);
  static const Color darkInputDecoration = Color(0xFF161616);
  static const Color darkInputHint = Color(0xff555555);

  static const Color lightInputDecoration = Color(0xFFF6F6F6);
  static const Color lightInputHint = Color(0xffbbbbbb);

  static const Color gry3 = Color(0xff333333);
  static const Color gry5 = Color(0xff555555);
  static const Color gryC = Color(0xffcccccc);
  static const Color gryB = Color(0xffbbbbbb);
  static const Color gry6 = Color(0xff666666);
  static const Color lightBRLine = Color(0xfff0f0f0);

  static const Color gryB1 = Color(0xffb1b1b1);
  static const Color gry61 = Color(0xff616161);

  static const Color gryDB = Color(0xffdbdbdb);
  static const Color gry36 = Color(0xff363636);

  static const Color gryA9 = Color(0xffa9a9a9);
  static const Color gry67 = Color(0xff676767);

  static const Color gry4A = Color(0xff4a4a4a);
  static const Color gryD5 = Color(0xffd5d5d5);

  static const Color gry64 = Color(0xff646464);
  static const Color gryEB = Color(0xffebebeb);

  static const Color darkBRLine = Color(0xff3f3f3f);

}