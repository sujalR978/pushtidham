import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  // Curated list of high-quality image paths or network URLs for Shri Mahaprabhuji
  final List<String> galleryImages = const [
    'https://upload.wikimedia.org/wikipedia/commons/4/4b/Vallabhacharya.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Om_symbol.svg/512px-Om_symbol.svg.png',
    'https://upload.wikimedia.org/wikipedia/commons/4/4b/Vallabhacharya.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Om_symbol.svg/512px-Om_symbol.svg.png',
    'https://upload.wikimedia.org/wikipedia/commons/4/4b/Vallabhacharya.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Om_symbol.svg/512px-Om_symbol.svg.png',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("મીડિયા ગેલેરી (Gallery)", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Curated Gallery Top Subtitle Label
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "શ્રી મહાપ્રભુજી દિવ્ય દર્શન",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "A curated static gallery for high-quality visual content.",
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Responsive Image Grid Engine
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 Columns for a clean gallery setup
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0, // Perfect Squares
                ),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openFullScreenViewer(context, index),
                    child: Card(
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        galleryImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            child: Icon(Icons.image, color: theme.colorScheme.primary),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Interactive Full-Screen Image Overlay Viewer
  void _openFullScreenViewer(BuildContext context, int initialIndex) {
    final theme = Theme.of(context);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text("દર્શન", style: TextStyle(color: Colors.white)),
          ),
          body: Center(
            child: PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: galleryImages.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0, // Allows users to pinch-to-zoom into photos
                  child: Image.network(
                    galleryImages[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 60, color: Colors.white38);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}