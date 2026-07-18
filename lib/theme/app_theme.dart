import 'package:flutter/material.dart';

class AppThemes {
  // 1. DAY THEME: Saffron Dawn (Bright, Energetic, Pure)
  static ThemeData get dayTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFE67E22), // Radiant Saffron
        secondary: Color(0xFFF1C40F), // Marigold Yellow
        surface: Color(0xFFFFFDF9), // Milky White / Pure Linen
        error: Color(0xFFC0392B),
        onPrimary: Colors.white,
        onSecondary: Colors.black87,
        onSurface: Color(0xFF2C3E50), // Deep slate for readable text
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFDF9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE67E22),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // 2. NIGHT THEME: Midnight Dhyaan (Calm, Meditative, Deep)
  static ThemeData get nightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFF39C12), // Soft Saffron Glow
        secondary: Color(0xFFE67E22),
        surface: Color(0xFF121824), // Deep Spiritual Night Sky Blue/Grey
        error: Color(0xFFE74C3C),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Color(0xFFECEFF1), // Soft white for eye strain reduction
      ),
      scaffoldBackgroundColor: const Color(0xFF0D1117), // Near black base
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121824),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E2736),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // 3. EXTRA PREMIUM THEME: Sandstone Mandir (Traditional Heritage Textures)
  static ThemeData get mandirTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF800000), // Deep Royal Maroon / Kumkum
        secondary: Color(0xFFD4AF37), // Temple Metallic Gold
        surface: Color(0xFFF5EBE6), // Warm Vedic Sandstone
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Color(0xFF3E2723), // Deep Sandalwood Brown text
      ),
      scaffoldBackgroundColor: const Color(0xFFFDF8F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF800000),
        foregroundColor: Color(0xFFD4AF37), // Gold icons/titles on Maroon
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFF5EBE6),
        elevation: 3,
        shadowColor: const Color(0xFF800000).withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFD4AF37),
            width: 0.5,
          ), // Subtle gold borders
        ),
      ),
    );
  }
}
