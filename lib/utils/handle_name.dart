import 'package:flutter/material.dart';

/// 익명인 경우 '익명', '글쓴이'로 표기되는 닉네임을 로케일에 맞게 변경해준다.
/// 익명(nameType == 2)이면서 nickname이 '익명', '글쓴이'이고 locale이 en인 경우를 제외하면
/// 원래 nickname을 그대로 리턴한다.
String getName(int? nameType, String nickname, Locale locale) {
  String res = nickname;

  // 익명이면서 로케일이 en인 경우 상황에 따라 nickname 변경.
  if (nameType == 2 && locale == const Locale('en')) {
    if (nickname == '익명') {
      res = 'Anonymous';
    }
    else if (nickname == '글쓴이') {
      res = 'Author';
    }
  }

  return res;
}