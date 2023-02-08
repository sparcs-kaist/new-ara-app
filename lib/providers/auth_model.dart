import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/dio_info.dart';

class AuthModel with ChangeNotifier {
  bool _isLogined = false;
  bool get isLogined => _isLogined;
  final CookieManager _cookieManager = CookieManager.instance();
  final _storage = const FlutterSecureStorage();

  Future<void> login(String url) async {
    try {
      List<Cookie> cookies =
          await _cookieManager.getCookies(url: Uri.parse(UrlInfo.MAIN_URL));
      await _cookieManager.deleteAllCookies();
      String cookieStr =
          cookies.map((cookie) => "${cookie.name}=${cookie.value}").join(';');
      String csrftokenStr =
          cookies.firstWhere((cookie) => cookie.name == 'csrftoken').value;

      await _storage.write(key: 'Cookie', value: cookieStr);
      await _storage.write(key: 'X-CSRFToken', value: csrftokenStr);

      DioInfo().updateOptions(cookieStr, csrftokenStr);

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
