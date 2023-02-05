import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:new_ara_app/constants/constants.dart';

class AuthModel with ChangeNotifier {
  bool _isLogined = false;
  bool get isLogined => _isLogined;
  final CookieManager _cookieManager = CookieManager.instance();

  Future<void> login(String url) async {
    try {
      List<Cookie> cookies =
          await _cookieManager.getCookies(url: Uri.parse(UrlInfo.MAIN_URL));
      await _cookieManager.deleteAllCookies();

      _isLogined = true;
      notifyListeners();
    } catch (error) {
      print("$error");
    }
  }

  void logout() {
    _isLogined = false;
    notifyListeners();
  }
}
