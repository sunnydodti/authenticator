import 'package:authenticator/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class ThemeProvider extends ChangeNotifier {
  Box box = Hive.box("box");
  bool _isDarkMode = true;
  ThemeData _theme = Constants.theme.darkTheme;

  ThemeProvider() {
    _isDarkMode = box.get("is_dark_mode", defaultValue: true);
    _theme = _isDarkMode
        ? Constants.theme.darkTheme
        : Constants.theme.lightTheme;
  }

  ThemeData get theme => _theme;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    box.put("is_dark_mode", _isDarkMode);
    _theme = _isDarkMode
        ? Constants.theme.darkTheme
        : Constants.theme.lightTheme;
    notifyListeners();
  }
}
