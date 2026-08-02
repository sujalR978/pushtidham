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

class _JapMalaScreenState extends State<JapMalaScreen> {
  int _beadCount = 0;
  int _malaCountToday = 0;
  final int _maxBeads = 108;

  // History Tracking
  Map<String, int> _malaHistory = {};

  // Interactive Bead Drag State
  double _dragOffset = 0.0;
  final double _dragThreshold =
      70.0; // Distance required to complete 1 bead count
  bool _hasTriggered = false; // Prevents duplicate count per slide gesture

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

    final String? historyJson = prefs.getString('mala_history');
    if (historyJson != null) {
      _malaHistory = Map<String, int>.from(json.decode(historyJson));
    }

    final todayKey = _getTodayKey();
    setState(() {
      _beadCount = prefs.getInt('current_bead_count') ?? 0;
      _malaCountToday = _malaHistory[todayKey] ?? 0;
    });
  }

  Future<void> _saveMalaData() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();

    await prefs.setInt('current_bead_count', _beadCount);
    _malaHistory[todayKey] = _malaCountToday;
    await prefs.setString('mala_history', json.encode(_malaHistory));
  }

  // --- CLEAR HISTORY DIALOG ---
  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Clear History",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to clear your spiritual history? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('mala_history');
                setState(() {
                  _malaHistory.clear();
                  _malaCountToday = 0;
                });
                Navigator.pop(context);
              },
              child: const Text("Clear All"),
            ),
          ],
        );
      },
    );
  }

  // --- MALA LOGIC ---

  void _incrementBeadSingle() {
    HapticFeedback.lightImpact();

    setState(() {
      if (_beadCount < _maxBeads - 1) {
        _beadCount++;
      } else {
        _beadCount = 0;
        _malaCountToday++;
        HapticFeedback.heavyImpact();
        _showMalaCompletionSnackbar();
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

  void _showMalaCompletionSnackbar() {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final progressPercentage = _beadCount / _maxBeads;

    final sortedKeys = _malaHistory.keys.toList()
      ..sort((a, b) => b.compareTo(a));

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
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Reset Counter",
            onPressed: _resetCounter,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. Top Section: Active Mantra Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.jap_active_mantra,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.jap_default_mantra,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. Middle Section: Visual Bead Progress Dial
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(0.04),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: progressPercentage,
                      strokeWidth: 8,
                      backgroundColor: theme.colorScheme.onSurface.withOpacity(
                        0.06,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.jap_bead_count,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$_beadCount",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "/ $_maxBeads",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Today's Total Count Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.brightness_7_rounded,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Today's Malas: ",
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "$_malaCountToday",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 3. Interactive Mala Bead Thread (With incoming top bead animation)
              Text(
                "Slide bead down to chant",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 170,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Sacred Mala Thread
                    Container(
                      width: 4,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // INCOMING BEAD (Enters smoothly from top as active bead moves down)
                    Transform.translate(
                      offset: Offset(0, -70 + (_dragOffset * 0.8)),
                      child: Opacity(
                        opacity: (_dragOffset / _dragThreshold).clamp(0.0, 1.0),
                        child: _buildSacredMalaBead(theme, scale: 0.85),
                      ),
                    ),

                    // ACTIVE BEAD (Dragged down by user)
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          if (details.delta.dy > 0 || _dragOffset > 0) {
                            _dragOffset += details.delta.dy;

                            if (_dragOffset > 85) {
                              _dragOffset = 85;
                            }

                            // Trigger exactly once when threshold met
                            if (_dragOffset >= _dragThreshold &&
                                !_hasTriggered) {
                              _hasTriggered = true;
                              _incrementBeadSingle();
                            }
                          }
                        });
                      },
                      onVerticalDragEnd: (details) {
                        // Reset bead position back to top after finger release
                        setState(() {
                          _dragOffset = 0.0;
                          _hasTriggered = false;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(0, _dragOffset),
                        child: _buildSacredMalaBead(theme, scale: 1.0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(indent: 24, endIndent: 24),
              const SizedBox(height: 16),

              // 4. Spiritual History Section Below Mala (With Clear History Button)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.history_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Spiritual History",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        if (sortedKeys.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            color: Colors.redAccent.withOpacity(0.8),
                            tooltip: "Clear History",
                            onPressed: _clearHistory,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (sortedKeys.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Your journey begins today.\nStart chanting to build your history.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, index) {
                          final dateStr = sortedKeys[index];
                          final malas = _malaHistory[dateStr] ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.08,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateStr == _getTodayKey() ? "Today" : dateStr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "$malas",
                                      style: TextStyle(
                                        fontSize: 18,
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
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper Widget to create a Sacred Mala Bead Symbol
  Widget _buildSacredMalaBead(ThemeData theme, {required double scale}) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFFFB74D), // Warm Amber inner core
              theme.colorScheme.primary, // Primary Mala color
              const Color(0xFF5D4037), // Deep Rudraksha border
            ],
            center: const Alignment(-0.25, -0.25),
            radius: 0.85,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFFFD54F).withOpacity(0.6),
            width: 2.5,
          ),
        ),
        child: const Center(
          child: Text(
            "ॐ", // Sacred Om symbol inside bead
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
