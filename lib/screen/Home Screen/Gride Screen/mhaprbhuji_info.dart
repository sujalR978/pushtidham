import 'dart:ui'; // For ImageFilter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutMahaprabhujiPage extends StatefulWidget {
  const AboutMahaprabhujiPage({super.key});

  @override
  State<AboutMahaprabhujiPage> createState() => _AboutMahaprabhujiPageState();
}

class _AboutMahaprabhujiPageState extends State<AboutMahaprabhujiPage> {
  final List<String> galleryImages = const [
    'assets/images/spleshScreen_image.png',
  ];

  Future<void> _openPdf() async {
    HapticFeedback.lightImpact();

    const String pdfUrl =
        'https://www.scribd.com/document/29720575/ShriMahaPrabhuji-Tavasmi';
    final Uri uri = Uri.parse(pdfUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode:
              LaunchMode.externalApplication, // Opens in default browser/viewer
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open PDF link.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // The background color is now part of the decoration in the Container below
      // to allow for a gradient that blends with the scaffold color.
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: CustomScrollView(
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
                              color: theme.colorScheme.primary.withOpacity(0.1),
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
                            begin: Alignment.topCenter, // Start from top
                            end: Alignment.bottomCenter,
                            stops: const [
                              0.0,
                              0.6,
                              1.0,
                            ], // Control gradient points
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Adding a subtle "divine glow" effect
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 1.0,
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.2),
                              Colors.transparent,
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
                    _buildPdfResourceCard(context, theme, l10n), // Kept as is
                    const SizedBox(height: 24),

                    // NEW: Biography presented as a vertical timeline
                    _buildBiographyTimeline(context, theme, l10n),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfResourceCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    // UPGRADED: Frosted glass effect for a more premium feel.
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: InkWell(
            onTap: _openPdf,
            borderRadius: BorderRadius.circular(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.grid_pathavali,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.grid_about_mahaprabhuji,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiographyTimeline(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final List<String> biographyParagraphs = [
      l10n.mahaprabhuji_bio_p1,
      l10n.mahaprabhuji_bio_p2,
      l10n.mahaprabhuji_bio_p3,
      l10n.mahaprabhuji_bio_p4,
      l10n.mahaprabhuji_bio_p5,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          theme,
          l10n.sub_mahaprabhuji_charitra,
          Icons.auto_stories_outlined,
        ),
        const SizedBox(height: 8),
        ...List.generate(biographyParagraphs.length, (index) {
          return _buildTimelineEvent(
            theme,
            biographyParagraphs[index],
            isFirst: index == 0,
            isLast: index == biographyParagraphs.length - 1,
          );
        }),
      ],
    );
  }

  Widget _buildTimelineEvent(
    ThemeData theme,
    String text, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 12,
                  color: isFirst
                      ? Colors.transparent
                      : theme.colorScheme.primary.withOpacity(0.3),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                    // UPGRADED: Added a glow effect to the timeline dot.
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.7),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // UPGRADED: Timeline cards now use a frosted glass effect.
            child: Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      text,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: theme.colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
