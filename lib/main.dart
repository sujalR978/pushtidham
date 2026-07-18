import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushtidham/Provider/theme_manager.dart';
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

   ThemeData chosenTheme;
    switch (themeManager.CurrentTheme) {
      case AppThemeMode.night:
        chosenTheme = AppThemes.nightTheme;
        break;
      case AppThemeMode.mandir:
        chosenTheme = AppThemes.mandirTheme;
        break;
      case AppThemeMode.day:
      default:
        chosenTheme = AppThemes.dayTheme;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: chosenTheme,
      home: const Spleshscreen(),
    );
  }
}
