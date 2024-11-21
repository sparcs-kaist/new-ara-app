import 'package:flutter/material.dart';

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
g
    notifyListeners();
  }

}