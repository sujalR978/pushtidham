import 'package:flutter/material.dart';
import 'package:pushtidham/model/gita_model.dart';
// IMPORT YOUR MODEL HERE:
// import 'package:pushtidham/model/gita_model.dart';

class GitaDetailPage extends StatefulWidget {
  final GitaShlokModel item;

  const GitaDetailPage({
    super.key,
    required this.item,
  });

  @override
  State<GitaDetailPage> createState() => _GitaDetailPageState();
}

class _GitaDetailPageState extends State<GitaDetailPage> {
  double _fontSize = 17.0;

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
              // 1. CHAPTER BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  widget.item.chapterVerse,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. SANSKRIT SHLOK CONTAINER (Centered & Highlighted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        widget.item.sanskritShlok,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _fontSize + 3,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 3. GUJARATI ARTH (MEANING) BLOCK
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color ?? theme.colorScheme.surface,
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
                            color: theme.colorScheme.onSurface.withOpacity(0.9),
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
                              text: widget.item.GujaratiArth,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 4. TATPARYA / COMMENTARY BLOCK (Optional)
                    if (widget.item.tatparya.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
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
                                  "તાત્પર્ય / વિવેચન",
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
                              widget.item.tatparya,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: _fontSize,
                                height: 1.7,
                                color: theme.colorScheme.onSurface.withOpacity(0.85),
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