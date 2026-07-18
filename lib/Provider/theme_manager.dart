import 'package:flutter/material.dart';

enum AppThemeMode { day, night, mandir,FollowSystem, }

class ThemeManager extends ChangeNotifier {
  AppThemeMode _changeTheme = AppThemeMode.FollowSystem;

  AppThemeMode get CurrentTheme => _changeTheme;

  void setTheme(AppThemeMode AppTheme) {
    _changeTheme = AppTheme;
    notifyListeners();
  }
}
