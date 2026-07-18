import 'package:flutter/material.dart';

enum AppThemeMode { day, night, mandir }

class ThemeManager extends ChangeNotifier {
  AppThemeMode _changeTheme = AppThemeMode.day;

  AppThemeMode get CurrentTheme => _changeTheme;

  void setTheme(AppThemeMode AppTheme) {
    _changeTheme = AppTheme;
    notifyListeners();
  }
}
