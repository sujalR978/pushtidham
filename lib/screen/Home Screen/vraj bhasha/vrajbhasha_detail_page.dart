import 'package:flutter/material.dart';
import 'package:pushtidham/model/vraj_model.dart';
import 'package:pushtidham/database/database_helper.dart';
// IMPORT YOUR MODEL HERE:
// import 'package:pushtidham/model/vrajbhasha_model.dart';

class VrajbhashaDetailPage extends StatefulWidget {
  final VrajbhashaModel item;

  const VrajbhashaDetailPage({super.key, required this.item});

  @override
  State<VrajbhashaDetailPage> createState() => _VrajbhashaDetailPageState();
}

class _VrajbhashaDetailPageState extends State<VrajbhashaDetailPage> {
  double _fontSize = 17.0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _toggleFavorite() async {
    setState(() {
      widget.item.isFavorite = !widget.item.isFavorite;
    });
    // Assumes you create `updateVrajbhashaFavoriteStatus` in your DatabaseHelper
    await _dbHelper.updateVrajbhashaFavoriteStatus(
      widget.item.id,
      widget.item.isFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.item.title,
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
              widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.item.isFavorite
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
              // 1. Subtle Header Banner showing the Number
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  "પદ ક્રમાંક: ${widget.item.number}",
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
                    // 2. VRAJBHASHA PAD BLOCK (Highlighted like poetry)
                    if (widget.item.padText.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 28,
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
                          widget.item.padText,
                          textAlign: TextAlign
                              .center, // Center aligned for poetry/pads
                          style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold,
                            height: 1.8,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // 3. BHAVARTH (MEANING) BLOCK (Sleek left border design)
                    if (widget.item.bhavarth.isNotEmpty) ...[
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
                                text: "ભાવાર્થ: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: widget.item.bhavarth,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // 4. PRASANG / CONTEXT STORY (Optional bottom block)
                    if (widget.item.prasang.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.secondaryContainer
                                .withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  color: theme.colorScheme.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "પ્રસંગ / કથા",
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.item.prasang,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: _fontSize,
                                height: 1.7,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.85,
                                ),
                                fontWeight: FontWeight.w400,
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
