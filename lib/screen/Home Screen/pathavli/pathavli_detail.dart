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
    // final l10n = AppLocalizations.of(context)!; // Uncomment if needed for localization strings

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.item.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // 1. Added Favorite Toggle to AppBar
          IconButton(
            icon: Icon(
              widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.item.isFavorite
                  ? Colors.redAccent
                  : theme.colorScheme.onPrimary,
            ),
            tooltip: "Favorite",
            onPressed: () {
              setState(() {
                widget.item.isFavorite = !widget.item.isFavorite;
              });
            },
          ),
          // 2. Font Size Controls
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
        child: Column(
          children: [
            // Optional: A small elegant header band showing the ID
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                "पाठ क्रमांक: ${widget.item.id}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.item.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _fontSize,
                      height:
                          1.9, // Increased line height slightly for better readability
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight
                          .w500, // Reduced from w600 for easier long-form reading
                    ),
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
