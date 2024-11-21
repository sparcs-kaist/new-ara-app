import 'package:flutter/material.dart';

/// 다크모드를 도입하기 위해 사용하는 Provider
/// isDarkMode에 맞게 ThemeMode를 변경합니다
class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode = null;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void setTheme(bool change) {
    _isDarkMode = change;
    themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateTheme() {
    _isDarkMode = !_isDarkMode;
    themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
