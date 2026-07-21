import 'package:flutter/material.dart';

import 'package:pushtidham/model/kirtan_model.dart';

class KirtanDetailPage extends StatefulWidget {
  final List<KirtanModel> kirtanList;
  final int initialIndex;

  const KirtanDetailPage({
    super.key,
    required this.kirtanList,
    required this.initialIndex,
  });

  @override
  State<KirtanDetailPage> createState() => _KirtanDetailPageState();
}

class _KirtanDetailPageState extends State<KirtanDetailPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skipToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToNext() {
    if (_currentIndex < widget.kirtanList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
   
    final currentKirtan = widget.kirtanList[_currentIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "(${currentKirtan.number}) ${currentKirtan.title}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${currentKirtan.title} saved to favorites!"),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- MAIN IMAGE VIEWPORT (SWIPEABLE PAGEVIEW) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.kirtanList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = widget.kirtanList[index];
                        return InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.8,
                          maxScale: 4.0,
                          child: Center(
                            child: Image.asset(
                              item.imageAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_outlined,
                                      size: 60,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Kirtan sheet image unavailable",
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // --- PUSH SKIP CONTROLLER BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SKIP PREVIOUS BUTTON
                  IconButton.filledTonal(
                    onPressed: _currentIndex > 0 ? _skipToPrevious : null,
                    icon: const Icon(Icons.skip_previous_rounded),
                    tooltip: "Previous Kirtan",
                  ),

                  // KIRTAN COUNTER INDICATION
                  Text(
                    "${_currentIndex + 1} / ${widget.kirtanList.length}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),

                  // SKIP NEXT BUTTON
                  IconButton.filledTonal(
                    onPressed: _currentIndex < widget.kirtanList.length - 1
                        ? _skipToNext
                        : null,
                    icon: const Icon(Icons.skip_next_rounded),
                    tooltip: "Next Kirtan",
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
