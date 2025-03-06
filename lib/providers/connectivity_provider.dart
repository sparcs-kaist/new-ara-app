import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/providers/theme_provider.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/utils/global_key.dart';
import 'package:new_ara_app/widgets/snackbar_noti.dart';

/// `ConnectivityProvider`는 인터넷 에러 관련 로직 및 스낵바를 관리하는 클래스입니다.
class ConnectivityProvider with ChangeNotifier {
  final ThemeProvider themeProvider;

  StreamSubscription<List<ConnectivityResult>>? _connectSubscription;

  // 인터넷 연결 여부 표시
  bool _isConnected = true;

  ConnectivityProvider(this.themeProvider) {
    _initConnectivity();
  }

  /// isConnected는 인터넷 상태를 반환합니다. (true/false)
  bool get isConnected => _isConnected;

  /// 'connectivitySubscription'값을 갱신하고 update에 listen하도록 합니다
  void _initConnectivity() {
    _connectSubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        showConnectivitySnackBar(results); // 변화가 있을 시 snackBar 호출
      },
    );
  }

  /// 인터넷 연결 상태에 따라 [showInternetErrorBySnackBar]를 실행합니다.
  void showConnectivitySnackBar(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.mobile)) {
      // 연결됨
      _isConnected = true;
      notifyListeners(); // 인터넷 복구를 알림
      snackBarKey.currentState?.hideCurrentSnackBar();
      debugPrint("Connected to ${result.last.toString().split('.').last}");
    } else {
      // 인터넷 연결 없음
      _isConnected = false;
      showInternetErrorBySnackBar(
          LocaleKeys.userProvider_internetError.tr(), themeProvider.isDarkMode);
      debugPrint("Internet Connectivity Error");
    }
  }

  @override
  void dispose() {
    _connectSubscription?.cancel();
    super.dispose();
  }
}
