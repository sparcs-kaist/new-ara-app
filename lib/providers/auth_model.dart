import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:collection/collection.dart';

import 'package:new_ara_app/dio_info.dart';

class AuthModel with ChangeNotifier {
  bool _isLogined = false;
  bool get isLogined => _isLogined;

  Future<void> login(String url) async {
    try {
      final cookieManager = WebviewCookieManager();
      List<Cookie> cookies = await cookieManager.getCookies(url);
      cookieManager.clearCookies();

      String sessionid = cookies
          .firstWhereOrNull((cookie) => cookie.name == 'sessionid')
          .toString();
      String csrftoken = cookies
          .firstWhereOrNull((cookie) => cookie.name == 'csrftoken')
          .toString();

      DioInfo().updateOptions(sessionid, csrftoken);

      _isLogined = true;
      notifyListeners();
    } catch (error) {
      debugPrint(
          "************************************************\nAuthModel Error: $error************************************************\n");
    }
  }

  void logout() {
    _isLogined = false;
    notifyListeners();
  }
}
