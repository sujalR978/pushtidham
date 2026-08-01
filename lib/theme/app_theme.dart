import 'package:flutter/material.dart';

class AppThemes {
  // ---------------------------------------------------------------------------
  // 1. NEW THEME: Temple Gold (Traditional Pushtimarg Palette)
  // ---------------------------------------------------------------------------
  static ThemeData get templeTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Core Color Scheme Mapping
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFC89B3C), // Temple Gold
        secondary: Color(0xFFE68A2E), // Saffron
        surface: Color(0xFFFFFFFF), // White
        error: Color(0xFFB53A3A), // Deep Red
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF4B3426), // Dark Brown
        onError: Colors.white,
        outline: Color(0xFFE8D6A8), // Light Gold (Divider)
      ),

      // Backgrounds
      scaffoldBackgroundColor: const Color(0xFFFFF9F2), // Ivory
      // App Bar Styling
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFC89B3C), // Temple Gold
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Card Theme (Cream background with subtle gold border)
      cardTheme: CardThemeData(
        color: const Color(0xFFF8F1E7), // Card Cream
        elevation: 1,
        shadowColor: const Color(0xFFC89B3C).withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFE8D6A8), // Light Gold Divider
            width: 0.8,
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF4B3426)), // Dark Brown Text
        bodyMedium: TextStyle(color: Color(0xFF4B3426)),
        titleMedium: TextStyle(
          color: Color(0xFF4B3426),
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(color: Color(0xFF8D7A6B)), // Subtitle Warm Grey
      ),

      // Divider & Progress Indicators
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8D6A8), // Light Gold
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFC89B3C), // Temple Gold
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. DAY THEME: Saffron Dawn (Bright, Energetic, Pure)
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // 3. NIGHT THEME: Midnight Dhyaan (Calm, Meditative, Deep)
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // 4. EXTRA PREMIUM THEME: Sandstone Mandir (Traditional Heritage Textures)
  // ---------------------------------------------------------------------------
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
