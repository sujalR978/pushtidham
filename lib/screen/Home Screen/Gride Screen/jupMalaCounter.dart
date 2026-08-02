import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

class JapMalaScreen extends StatefulWidget {
  const JapMalaScreen({super.key});

  @override
  State<JapMalaScreen> createState() => _JapMalaScreenState();
}

class _JapMalaScreenState extends State<JapMalaScreen>
    with SingleTickerProviderStateMixin {
  int _beadCount = 0;
  int _malaCountToday = 0;
  final int _maxBeads = 108;

  // History Tracking
  Map<String, int> _malaHistory = {};

  // Interactive Bead Drag State
  double _dragOffset = 0.0;
  final double _dragThreshold = 60.0; // How far to swipe before a bead counts

  @override
  void initState() {
    super.initState();
    _loadMalaData();
  }

  // --- DATA MANAGEMENT ---

  String _getTodayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadMalaData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load History
    final String? historyJson = prefs.getString('mala_history');
    if (historyJson != null) {
      _malaHistory = Map<String, int>.from(json.decode(historyJson));
    }

    // Load Today's state
    final todayKey = _getTodayKey();
    setState(() {
      _beadCount = prefs.getInt('current_bead_count') ?? 0;
      _malaCountToday = _malaHistory[todayKey] ?? 0;
    });
  }

  Future<void> _saveMalaData() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();

    // Save current beads
    await prefs.setInt('current_bead_count', _beadCount);

    // Save history
    _malaHistory[todayKey] = _malaCountToday;
    await prefs.setString('mala_history', json.encode(_malaHistory));
  }

  // --- MALA LOGIC ---

  void _incrementBeads() {
    HapticFeedback.lightImpact(); // Minimal haptic on single bead

    setState(() {
      if (_beadCount < _maxBeads - 1) {
        _beadCount++;
      } else {
        // Completed 108 beads
        _beadCount = 0;
        _malaCountToday++;
        HapticFeedback.heavyImpact(); // Strong vibration on full Mala
        _showMalaCompletionDialog();
      }
    });

    _saveMalaData();
  }

  void _resetCounter() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.jap_reset_title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.jap_reset_msg,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.btn_no,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _beadCount = 0;
                });
                _saveMalaData();
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                l10n.btn_yes,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMalaCompletionDialog() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.spa_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.jap_completed_msg)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openHistorySheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Sort history by date descending
        final sortedKeys = _malaHistory.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Spiritual History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (sortedKeys.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text(
                      "Your journey begins today.\nStart chanting to build your history.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      final dateStr = sortedKeys[index];
                      final malas = _malaHistory[dateStr] ?? 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateStr == _getTodayKey() ? "Today" : dateStr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "$malas",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Malas",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final progressPercentage = _beadCount / _maxBeads;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.grid_jap_mala,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: "History",
            onPressed: _openHistorySheet,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Reset Counter",
            onPressed: _resetCounter,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Top Section: Mantra Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.jap_active_mantra,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.jap_default_mantra,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Middle Section: Digital Visual Counter Ring
            Stack(
              alignment: Alignment.center,
              children: [
                // Inner Glow Background
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.03),
                  ),
                ),
                // Progress Indicator Ring
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progressPercentage,
                    strokeWidth: 8,
                    backgroundColor: theme.colorScheme.onSurface.withOpacity(
                      0.05,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                // Counter Text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.jap_bead_count,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$_beadCount",
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                        height: 1.1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "/ $_maxBeads",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Score Counter Bar: Total Malas Done Today
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.brightness_7_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Today's Malas: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$_malaCountToday",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // --- THE INTERACTIVE MALA PULL SECTION ---
            Text(
              "Slide bead down to chant",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // The Thread behind the beads
                  Container(
                    width: 4,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.8),
                          theme.colorScheme.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),

                  // The Interactive Draggable Bead
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        // Only allow dragging downwards
                        if (details.delta.dy > 0 || _dragOffset > 0) {
                          _dragOffset += details.delta.dy;

                          // If dragged past threshold, snap back and increment
                          if (_dragOffset > _dragThreshold) {
                            _incrementBeads();
                            _dragOffset =
                                0.0; // Instantly snap a new bead to the top
                          }
                        }
                      });
                    },
                    onVerticalDragEnd: (details) {
                      // Snap back to top if released before threshold
                      setState(() {
                        _dragOffset = 0.0;
                      });
                    },
                    child: Transform.translate(
                      offset: Offset(0, _dragOffset),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // Premium 3D Bead Look
                          gradient: RadialGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.6),
                              theme.colorScheme.primary,
                            ],
                            center: const Alignment(-0.3, -0.3),
                            radius: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
