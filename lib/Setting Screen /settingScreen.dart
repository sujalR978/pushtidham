import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushtidham/Provider/theme_manager.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("App Customization")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Select Devotional Theme",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Day Theme Option
          RadioListTile<AppThemeMode>(
            title: const Text("Saffron Dawn (Day)"),
            value: AppThemeMode.day,
            groupValue: themeManager.CurrentTheme,
            onChanged: (value) {
              themeManager.setTheme(value!);
            },
          ),

          // Night Theme Option
          RadioListTile<AppThemeMode>(
            title: const Text("Midnight Dhyaan (Night)"),
            value: AppThemeMode.night,
            groupValue: themeManager.CurrentTheme,
            onChanged: (value) {
              themeManager.setTheme(value!);
            },
          ),

          // Premium Mandir Theme Option
          RadioListTile<AppThemeMode>(
            title: const Text("Sandstone Mandir (Traditional)"),
            value: AppThemeMode.mandir,
            groupValue: themeManager.CurrentTheme,
            onChanged: (value) {
              themeManager.setTheme(value!);
            },
          ),
        ],
      ),
    );
  }
}
