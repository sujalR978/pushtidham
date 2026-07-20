import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

class AboutMahaprabhujiPage extends StatelessWidget {
  const AboutMahaprabhujiPage({super.key});

  final List<String> galleryImages = const [
    'assets/images/spleshScreen_image.png',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. Dynamic Top Image Banner with Localized Title
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.grid_about_mahaprabhuji,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: galleryImages.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        galleryImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: theme.colorScheme.primary,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Content & Media Resource Block
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Intro Section
                  Text(
                    l10n.grid_about_mahaprabhuji,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.welcome_tagline,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Interactive PDF Resource Card
                  Card(
                    color: theme.colorScheme.primary.withOpacity(0.06),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        l10n.grid_pathavali,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        l10n.grid_about_mahaprabhuji,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          // PDF opening or download logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.download, size: 16),
                        label: Text(l10n.btn_open),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Localized Biography Paragraph Blocks
                  _buildContentParagraph(theme, l10n.mahaprabhuji_bio_p1),
                  _buildContentParagraph(theme, l10n.mahaprabhuji_bio_p2),
                  _buildContentParagraph(theme, l10n.mahaprabhuji_bio_p3),
                  _buildContentParagraph(theme, l10n.mahaprabhuji_bio_p4),
                  _buildContentParagraph(theme, l10n.mahaprabhuji_bio_p5),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentParagraph(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: theme.colorScheme.onSurface.withOpacity(0.85),
        ),
      ),
    );
  }
}