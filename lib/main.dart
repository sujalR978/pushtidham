import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushtidham/Provider/theme_manager.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/screen/Splesh%20Screen/spleshScreen.dart';
import 'package:pushtidham/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeManager(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    ThemeData lightTarget;
    ThemeData darkTarget;
    ThemeMode activeSystemMode;

    switch (themeManager.CurrentTheme) {
      case AppThemeMode.FollowSystem:
        lightTarget = AppThemes.dayTheme;
        darkTarget = AppThemes.nightTheme;
        activeSystemMode = ThemeMode.system;
        break;
      case AppThemeMode.night:
        lightTarget = AppThemes.nightTheme;
        darkTarget = AppThemes.nightTheme;
        activeSystemMode = ThemeMode.dark;
        break;
      case AppThemeMode.mandir:
        lightTarget = AppThemes.mandirTheme;
        darkTarget = AppThemes.mandirTheme;
        activeSystemMode = ThemeMode.light;
        break;
      case AppThemeMode.day:
      default:
        lightTarget = AppThemes.dayTheme;
        darkTarget = AppThemes.dayTheme;
        activeSystemMode = ThemeMode.light;
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTarget,
      darkTheme: darkTarget,
      themeMode: activeSystemMode,
      
      // Dynamic locale powered by ThemeManager & SharedPreferences
      locale: themeManager.appLocale,
      
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Spleshscreen(),
    );
  }
}