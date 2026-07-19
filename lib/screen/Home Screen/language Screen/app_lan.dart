import 'package:flutter/material.dart';
import 'package:pushtidham/screen/Home%20Screen/homeScreen.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  // Available language choices mapped to text representations
  final List<Map<String, String>> _languages = [
    {"name": "ગુજરાતી", "sub": "Gujarati"},
    {"name": "ગુજરાતી (વ્રજ ભાષા)", "sub": "Vraj Bhasha"},
    {"name": "English", "sub": "English"},
    {"name": "हिन्दी", "sub": "Hindi"},
  ];

  int _selectedLanguageIndex = 0; // Default selection: Gujarati

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              
              // Top Divine Symbol Banner
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  "ૐ",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Headers
              Text(
                "ભાષા પસંદ કરો",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Select App Language",
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 32),

              // Language List Builder
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedLanguageIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedLanguageIndex = index;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          backgroundColor: isSelected 
                              ? theme.colorScheme.primary.withOpacity(0.06) 
                              : theme.cardTheme.color,
                          side: BorderSide(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.12),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _languages[index]["name"]!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _languages[index]["sub"]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24)
                            else
                              Icon(Icons.circle_outlined, color: theme.colorScheme.onSurface.withOpacity(0.2), size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Action Trigger
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to home and replace the stack so the user cannot back into this screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "આગળ વધો (Continue)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}