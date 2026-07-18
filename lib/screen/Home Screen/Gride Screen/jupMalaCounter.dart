import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JapMalaScreen extends StatefulWidget {
  const JapMalaScreen({super.key});

  @override
  State<JapMalaScreen> createState() => _JapMalaScreenState();
}

class _JapMalaScreenState extends State<JapMalaScreen> {
  int _beadCount = 0;
  int _malaCount = 0;
  final int _maxBeads = 108;

  void _incrementBeads() {
    HapticFeedback.lightImpact(); // Subtle vibration feel on bead click
    
    setState(() {
      if (_beadCount < _maxBeads - 1) {
        _beadCount++;
      } else {
        // Completed 108 beads, reset bead counter and increment Mala round
        _beadCount = 0;
        _malaCount++;
        HapticFeedback.heavyImpact(); // Stronger vibration signaling completed Mala
        _showMalaCompletionDialog();
      }
    });
  }

  void _resetCounter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text("રીસેટ કરો?", style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
          content: Text("શું તમે જાપ કાઉન્ટર શૂન્ય કરવા માંગો છો?", style: TextStyle(color: theme.colorScheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ના (No)", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _beadCount = 0;
                  _malaCount = 0;
                });
                Navigator.pop(context);
              },
              child: Text("હા (Yes)", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showMalaCompletionDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("જય શ્રી કૃષ્ણ! ૧ માળા પૂર્ણ થઈ. 🙏"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressPercentage = _beadCount / _maxBeads;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("જપ માળા કાઉન્ટર", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: "Reset Counter",
            onPressed: _resetCounter,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Top Section: Mantra Placeholder Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    Text(
                      "મંત્ર (Active Mantra)",
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "શ્રી કૃષ્ણઃ શરણં મમ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),

            // Middle Section: Digital Visual Counter Ring
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ambient ring
                Container(
                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.02),
                  ),
                ),
                // Core Progress Indicator Ring
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: progressPercentage,
                    strokeWidth: 10,
                    backgroundColor: theme.colorScheme.onSurface.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  ),
                ),
                // Inner Text Metric Elements
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "મણકો (Beads)",
                      style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "$_beadCount",
                      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, height: 1.1),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "/ $_maxBeads",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Score Counter Bar: Total Malas Done
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: theme.cardTheme.color,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.brightness_7, color: theme.colorScheme.secondary == Colors.black87 ? theme.colorScheme.primary : theme.colorScheme.secondary, size: 24),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("કુલ માળા (Total Mala)", style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                            Text("$_malaCount", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Large Ergonomic Tap Button Area
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GestureDetector(
                onTap: _incrementBeads,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.touch_app, size: 40, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        "જાપ કરો\n(TAP HERE)",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, height: 1.2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}