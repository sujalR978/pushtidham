import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/pathavali_model.dart';

class PathavaliDetailPage extends StatefulWidget {
  final PathavaliItem item;

  const PathavaliDetailPage({super.key, required this.item});

  @override
  State<PathavaliDetailPage> createState() => _PathavaliDetailPageState();
}

class _PathavaliDetailPageState extends State<PathavaliDetailPage> {
  double _fontSize = 18.0;

  void _increaseFontSize() {
    if (_fontSize < 30.0) {
      setState(() {
        _fontSize += 2.0;
      });
    }
  }

  void _decreaseFontSize() {
    if (_fontSize > 14.0) {
      setState(() {
        _fontSize -= 2.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "(${widget.item.id}) ${widget.item.title}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            tooltip: "Decrease Font Size",
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            tooltip: "Increase Font Size",
            onPressed: _increaseFontSize,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.item.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.8,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}