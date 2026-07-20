import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { day, night, mandir, FollowSystem }

class ThemeManager extends ChangeNotifier {
  AppThemeMode _changeTheme = AppThemeMode.FollowSystem;
  Locale _appLocale = const Locale('gu'); // Default language: Gujarati ('gu')

  AppThemeMode get CurrentTheme => _changeTheme;
  Locale get appLocale => _appLocale;

  ThemeManager() {
    _loadSavedPreferences();
  }

  // Load saved theme and language on app startup
  Future<void> _loadSavedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    // 1. Load saved language index (0: 'gu', 1: 'en', 2: 'hi')
    int langIndex = sp.getInt('lan_any') ?? 0;
    List<String> languages = ['gu', 'en', 'hi'];
    if (langIndex >= 0 && langIndex < languages.length) {
      _appLocale = Locale(languages[langIndex]);
    }

    // 2. Load saved theme mode
    int? themeIndex = sp.getInt('theme_mode');
    if (themeIndex != null && themeIndex >= 0 && themeIndex < AppThemeMode.values.length) {
      _changeTheme = AppThemeMode.values[themeIndex];
    }

    notifyListeners();
  }

  // Change and save app theme
  Future<void> setTheme(AppThemeMode appTheme) async {
    _changeTheme = appTheme;
    notifyListeners();

    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('theme_mode', appTheme.index);
  }

  // Change and save app language
  Future<void> changeLanguage(int index) async {
    List<String> languages = ['gu', 'en', 'hi'];
    if (index >= 0 && index < languages.length) {
      _appLocale = Locale(languages[index]);
      notifyListeners(); // Rebuilds MaterialApp with new locale instantly

      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setInt('lan_any', index);
    }
  }
}