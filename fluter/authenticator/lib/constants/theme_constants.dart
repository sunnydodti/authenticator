import 'package:flutter/material.dart';

class ThemeConstants {
  DarkTheme get dark => DarkTheme();

  LightTheme get light => LightTheme();

  BlackTheme get black => BlackTheme();

  WhiteTheme get white => WhiteTheme();

  ThemeData get darkTheme => _darkTheme;
  ThemeData get lightTheme => _lightTheme;
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

MaterialColor accentColor = Colors.blue;

ThemeData _lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: accentColor,
    surface: Colors.grey.shade200,
  ),
  useMaterial3: true,
);

ThemeData _darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: accentColor,
    surface: Colors.grey.shade900,
  ),
  useMaterial3: true,
);

