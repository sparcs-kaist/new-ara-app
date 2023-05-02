import 'package:flutter/material.dart';

class ColorsInfo {
  static const Color background = Colors.white;
  static const Color newara = Color.fromRGBO(237, 58, 58, 1);
  static const Color newaraSoft = Color.fromRGBO(255, 112, 112, 1);
  static const Color gradBegin = Color.fromRGBO(237, 58, 58, 0.1);
  static const Color gradEnd = Color.fromRGBO(237, 58, 58, 0);
}

class UrlInfo {
  static const BASE_URL = 'https://newara.dev.sparcs.org/api';
  static const MAIN_URL = 'https://newara.dev.sparcs.org';

  static const WEBVIEW_INIT =
      "https://newara.dev.sparcs.org/api/users/sso_login/?next=https://newara.dev.sparcs.org/login-handler";

  static const MAIN_AUTHORITY = 'newara.dev.sparcs.org';
  static const AUTH_AUTHORITY = 'sparcssso.kaist.ac.kr';
  static const KAISTIAM_AUTHORITY = 'iam2.kaist.ac.kr';
}
