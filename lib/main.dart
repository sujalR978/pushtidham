import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushtidham/Provider/theme_manager.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/screen/Splesh%20Screen/spleshScreen.dart';
import 'package:pushtidham/theme/app_theme.dart'; // Ensure this exports AppThemes

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
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

    switch (themeManager.currentTheme) {
      case AppThemeMode.temple:
        lightTarget = AppThemes.templeTheme;
        darkTarget = AppThemes.templeTheme;
        activeSystemMode = ThemeMode.light;
        break;

      case AppThemeMode.mandir:
        lightTarget = AppThemes.mandirTheme;
        darkTarget = AppThemes.mandirTheme;
        activeSystemMode = ThemeMode.light;
        break;

      case AppThemeMode.night:
        lightTarget = AppThemes.nightTheme;
        darkTarget = AppThemes.nightTheme;
        activeSystemMode = ThemeMode.dark;
        break;

      case AppThemeMode.day:
        lightTarget = AppThemes.dayTheme;
        darkTarget = AppThemes.dayTheme;
        activeSystemMode = ThemeMode.light;
        break;

      case AppThemeMode.followSystem:
      default:
        // Defaults to Temple Gold for Light Mode and Night Theme for Dark Mode
        lightTarget = AppThemes.templeTheme;
        darkTarget = AppThemes.nightTheme;
        activeSystemMode = ThemeMode.system;
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