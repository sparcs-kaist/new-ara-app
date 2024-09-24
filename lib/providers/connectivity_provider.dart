import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/utils/global_key.dart';
import 'package:new_ara_app/widgets/snackbar_noti.dart';

/// `ConnectivityProvider`는 인터넷 에러 관련 로직 및 스낵바를 관리하는 클래스입니다.
class ConnectivityProvider with ChangeNotifier {
  StreamSubscription<ConnectivityResult>? _connectSubscription;

  // 인터넷 연결 여부 표시
  bool _isConnected = false;

  ConnectivityProvider() {
    _initConnectivity();
  }

  /// isConnected는 인터넷 상태를 반환합니다. (true/false)
  bool get isConnected => _isConnected;

  /// 'connectivitySubscription'값을 갱신하고 update에 listen하도록 합니다
  void _initConnectivity() {
    _connectSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      showConnectivitySnackBar(result); //변화가 있을 시 snackBar 호출
    });
  }

  /// 인터넷 연결 상태에 따라 [showInternetErrorBySnackBar]를 실행합니다.
  void showConnectivitySnackBar(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      //인터넷 연결 없음
      _isConnected = false;

      showInternetErrorBySnackBar(LocaleKeys.userProvider_internetError.tr());
      debugPrint("Internet Connectivity Error");
    } else {
      //연결됨
      _isConnected = true;
      notifyListeners(); //인터넷 복구를 알림

      snackBarKey.currentState?.clearSnackBars();
      debugPrint("Connected to ${result.toString().split('.').last}");
    }
  }

  @override
  void dispose() {
    _connectSubscription?.cancel();
    super.dispose();
  }
}
