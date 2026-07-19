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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    ThemeData lightTarget;
    ThemeData darkTarget;
    ThemeMode activeSystemMode;

    // Direct all configurations to populate target light/dark themes and the mode
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
      theme: lightTarget, // Applies when phone is in light mode
      darkTheme: darkTarget, // Applies when phone is in dark mode
      themeMode: activeSystemMode, // Controls system tracking behavior
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Spleshscreen(),
    );
  }
}
