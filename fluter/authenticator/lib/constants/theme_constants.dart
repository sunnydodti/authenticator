import 'package:flutter/material.dart';

class ThemeConstants {
  DarkTheme get dark => DarkTheme();

  LightTheme get light => LightTheme();

  BlackTheme get black => BlackTheme();

  WhiteTheme get white => WhiteTheme();
}

class DarkTheme {
  Color appBarColor = Colors.black87;
  Color primaryColor = Colors.black;
  Color accentColor = Colors.deepPurple;
  Color backgroundColor = Colors.grey.shade900;
  Color buttonColor = Colors.deepPurple;
}

class BlackTheme {
  Color appBarColor = Colors.black;
  Color primaryColor = Colors.black;
  Color accentColor = Colors.red;
  Color backgroundColor = Colors.black;
  Color buttonColor = Colors.red;
}

class LightTheme {
  Color appBarColor = Colors.white;
  Color primaryColor = Colors.white;
  Color accentColor = Colors.blue;
  Color backgroundColor = Colors.grey[100]!;
  Color buttonColor = Colors.blue;
}

class WhiteTheme {
  Color appBarColor = Colors.white;
  Color primaryColor = Colors.white;
  Color accentColor = Colors.teal;
  Color backgroundColor = Colors.white;
  Color buttonColor = Colors.teal;
}
