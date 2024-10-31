import 'package:flutter/material.dart';

//---This to switch theme from Switch button----
class ThemeProvider extends ChangeNotifier {

  //-----Store the theme of our app--
  ThemeMode themeMode = ThemeMode.light;

  //----If theme mode is equal to dark then we return True----
  //-----isDarkMode--is the field we will use in our switch---
  bool _isDarkMode = false;
  // bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isDarkMode => _isDarkMode;




  //---implement ToggleTheme function----
  void updateTheme() {

    _isDarkMode = !_isDarkMode;
    themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;

    //---notify material app to update UI----
    notifyListeners();
  }

}