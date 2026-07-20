import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushtidham/Provider/theme_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Helper to map Locale code to human-readable string
  String _getLanguageLabel(String languageCode) {
    switch (languageCode) {
      case 'en':
        return "English";
      case 'hi':
        return "हिन्दी (Hindi)";
      case 'gu':
      default:
        return "ગુજરાતી (Gujarati)";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeManager = Provider.of<ThemeManager>(context);

    // Current language display string based on Provider's active locale
    final currentLanguageText = _getLanguageLabel(
      themeManager.appLocale.languageCode,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "સેટિંગ્સ (Settings)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(), // Pop to go back cleanly without rebuilding HomePage
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Section 1: Themes
          _buildSectionHeader(
            context,
            Icons.palette_outlined,
            "થીમ પસંદ કરો / Select Theme",
          ),
          const SizedBox(height: 12),

          _buildThemeCard(
            context: context,
            title: "સિસ્ટમ પ્રમાણે (Follow System)",
            subtitle: "Switches with phone settings",
            value: AppThemeMode.FollowSystem,
            groupValue: themeManager.CurrentTheme,
            onChanged: (val) => themeManager.setTheme(val!),
          ),
          _buildThemeCard(
            context: context,
            title: "સૂર્યોદય સિંહાસન (Saffron Dawn)",
            subtitle: "Bright, traditional daytime look",
            value: AppThemeMode.day,
            groupValue: themeManager.CurrentTheme,
            onChanged: (val) => themeManager.setTheme(val!),
          ),
          _buildThemeCard(
            context: context,
            title: "અર્ધરાત્રિ ધ્યાન (Midnight Dhyaan)",
            subtitle: "Calm, eye-friendly dark look",
            value: AppThemeMode.night,
            groupValue: themeManager.CurrentTheme,
            onChanged: (val) => themeManager.setTheme(val!),
          ),
          _buildThemeCard(
            context: context,
            title: "પાવન મંદિર થીમ (Sandstone Mandir)",
            subtitle: "Premium traditional heritage aesthetic",
            value: AppThemeMode.mandir,
            groupValue: themeManager.CurrentTheme,
            onChanged: (val) => themeManager.setTheme(val!),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Section 2: Languages
          _buildSectionHeader(
            context,
            Icons.language_outlined,
            "ભાષા બદલો / Language Settings",
          ),
          const SizedBox(height: 12),

          Card(
            color: theme.cardTheme.color,
            elevation: theme.cardTheme.elevation ?? 2,
            shape: theme.cardTheme.shape,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.translate, color: theme.colorScheme.primary),
              ),
              title: const Text(
                "એપ્લિકેશનની ભાષા (App Language)",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                currentLanguageText,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _showLanguagePicker(context, themeManager),
            ),
          ),
        ],
      ),
    );
  }

  // Section Label Helper
  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Custom Card design for Theme choices
  Widget _buildThemeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required AppThemeMode value,
    required AppThemeMode groupValue,
    required ValueChanged<AppThemeMode?> onChanged,
  }) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: OutlinedButton(
        onPressed: () => onChanged(value),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: isSelected
              ? theme.colorScheme.primary.withOpacity(0.06)
              : theme.cardTheme.color,
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.12),
            width: isSelected ? 2.0 : 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Radio<AppThemeMode>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  // Language selection slide-up bottom sheet linked to Provider
  void _showLanguagePicker(BuildContext context, ThemeManager themeManager) {
    final theme = Theme.of(context);

    // Mapped languages matching indices [0: 'gu', 1: 'en', 2: 'hi']
    final languages = [
      {"label": "ગુજરાતી (Gujarati)", "index": 0, "code": "gu"},
      {"label": "English", "index": 1, "code": "en"},
      {"label": "हिन्दी (Hindi)", "index": 2, "code": "hi"},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ભાષા પસંદ કરો (Choose Language)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                ...languages.map((langMap) {
                  final int index = langMap["index"] as int;
                  final String code = langMap["code"] as String;
                  final String label = langMap["label"] as String;
                  final isCurrent = themeManager.appLocale.languageCode == code;

                  return ListTile(
                    title: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrent
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: isCurrent
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      // Call ThemeManager to update live app locale & write to SharedPreferences
                      themeManager.changeLanguage(index);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
