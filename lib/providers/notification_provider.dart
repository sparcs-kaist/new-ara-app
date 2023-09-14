/// 'notification_provider.dart'
/// [NotificationProvider]를 정의함.
/// [NotificationProvider] 속 [checkIsNotReadExist] 메서드를 이용하여 새로운 알림을 감지하고
/// Listener에게 알려줌.
/// 
/// Author: 김상오(alvin)
/// 

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/url_info.dart';

class NotificationProvider with ChangeNotifier {
  bool _isNotReadExist = false;
  bool get isNotReadExist => _isNotReadExist;

  String _cookieString = "";

  void updateCookie(String newCookieString) {
    _cookieString = newCookieString;
  }

  Future<void> checkIsNotReadExist() async {
    bool res = false;

    var dio = Dio()
        ..options.headers["Cookie"] = _cookieString;

    // 알림이 몇 페이지 인지 확인
    int curPage = 1;
    bool hasNext = false;
    do {
      try {
        var response = await dio.get(
          "$newAraDefaultUrl/api/notifications/?page=$curPage"
        );
        hasNext = response.data["next"] == null ? false : true;
        List<dynamic> resultsJson = response.data["results"];
        for (var json in resultsJson) {
          if (!(json['is_read'] ?? true)) {
            res = true;
            break;
          }
        }
      } catch (error) {
        debugPrint("$error");
        res = true;
        break;
      }
      curPage += 1;
    } while (hasNext);

    _isNotReadExist = res;
    notifyListeners();
  }
}
