import 'package:flutter/material.dart';
import 'package:pushtidham/model/varta_model.dart';
import 'package:pushtidham/database/database_helper.dart';

class ChorasiVartaDetailPage extends StatefulWidget {
  final VartaModel varta;
  final bool isBrajLanguage;

  const ChorasiVartaDetailPage({
    super.key,
    required this.varta,
    this.isBrajLanguage = false,
  });

  @override
  State<ChorasiVartaDetailPage> createState() => _ChorasiVartaDetailPageState();
}

class _ChorasiVartaDetailPageState extends State<ChorasiVartaDetailPage> {
  double _fontSize = 17.0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _toggleFavorite() async {
    setState(() {
      widget.varta.isFavorite = !widget.varta.isFavorite;
    });
    await _dbHelper.update84VartaFavoriteStatus(
      widget.varta.id,
      widget.varta.isFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = widget.isBrajLanguage
        ? widget.varta.titleBraj
        : widget.varta.titleGujarati;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.varta.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.varta.isFavorite
                  ? Colors.red
                  : theme.colorScheme.onPrimary,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.text_decrease),
            tooltip: "Decrease Font Size",
            onPressed: () {
              if (_fontSize > 13.0) setState(() => _fontSize -= 2.0);
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            tooltip: "Increase Font Size",
            onPressed: () {
              if (_fontSize < 28.0) setState(() => _fontSize += 2.0);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtle header banner showing the number
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  "વાર્તા ક્રમાંક: ${widget.varta.number}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. SANSKRIT SHLOKA BLOCK
                    if (widget.varta.shloka.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(
                            0.4,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          widget.varta.shloka,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold,
                            height: 1.6,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 2. ARTH (MEANING) BLOCK
                    if (widget.varta.arth.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              theme.cardTheme.color ??
                              theme.colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border(
                            left: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 4,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: _fontSize,
                              height: 1.6,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.9,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: "અર્થ: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: widget.varta.arth,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // 3. VARTA STORY PARAGRAPH
                    if (widget.varta.vartaContent.isNotEmpty) ...[
                      Text(
                        widget.varta.vartaContent,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: _fontSize,
                          height:
                              1.8, // Increased line height for better reading
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // 4. SAAR (SUMMARY) BLOCK
                    if (widget.varta.saar.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.secondaryContainer,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: theme.colorScheme.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "સારાંશ",
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.varta.saar,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: _fontSize,
                                height: 1.6,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.85,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
