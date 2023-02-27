import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  toggleTheme() {
    themeMode = themeMode != ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  isDark() {
    return themeMode != ThemeMode.dark ? true : false;
  }
}
