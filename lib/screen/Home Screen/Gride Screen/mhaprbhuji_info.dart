import 'package:flutter/material.dart';

class AboutMahaprabhujiPage extends StatelessWidget {
  const AboutMahaprabhujiPage({super.key});

  // Dummy list of high-quality image paths or network URLs for the gallery
  final List<String> galleryImages = const [
    'https://upload.wikimedia.org/wikipedia/commons/4/4b/Vallabhacharya.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Om_symbol.svg/512px-Om_symbol.svg.png',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. Dynamic Top Image Gallery Banner
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "શ્રી મહાપ્રભુજી વિશે",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black54, offset: Offset(0, 2))],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: galleryImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        galleryImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            child: Icon(Icons.image, size: 50, color: theme.colorScheme.primary),
                          );
                        },
                      );
                    },
                  ),
                  // Bottom subtle gradient overlay for text readability
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
                    "Shri Mahaprabhuji",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Information about Shri Mahaprabhuji and his divine mission.",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Interactive PDF Resource Access Box
                  Card(
                    color: theme.colorScheme.primary.withOpacity(0.06),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                        child: Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
                      ),
                      title: const Text(
                        "PDF Resource Available",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        "Shri Mahaprabhuji Tavasmi",
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          // Connect PDF opening or offline download feature logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text("Open"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Biography Paragraph Blocks
                  _buildContentParagraph(
                    theme,
                    "Shri Vallabhacharyaji Mahaprabhuji is the founder of Pushtimarg, the Path of Divine Grace. According to Pushtimarg tradition, He incarnated on Earth by the divine command of Bhagwan Shri Krishna to guide souls toward loving devotion, selfless seva, and complete surrender. His philosophy of Shuddhadvaita Brahmavad emphasizes that Bhagwan's grace is the highest means of attaining spiritual bliss.",
                  ),
                  _buildContentParagraph(
                    theme,
                    "Born on Chaitra Vad Ekadashi, Vikram Samvat 1535 (1479 CE) in Champaranya, Shri Mahaprabhuji was the son of Shri Lakshman Bhatt and Shrimati Illammagaru. Even as a child, He displayed extraordinary wisdom and mastered the Vedas, Upanishads, Puranas, and various philosophical traditions by the age of eleven. His remarkable knowledge and devotion earned Him great respect throughout India.",
                  ),
                  _buildContentParagraph(
                    theme,
                    "Throughout His life, Shri Mahaprabhuji travelled across India three times on foot, spreading the message of Pushtimarg and establishing the philosophy of Shuddhadvaita. He guided countless devotees through the sacred initiation of Brahmasambandh, teaching that true devotion begins with complete surrender of one's body, mind, wealth, and soul to Shri Krishna. His teachings continue to inspire devotees to perform seva with love, humility, and unwavering faith.",
                  ),
                  _buildContentParagraph(
                    theme,
                    "Shri Mahaprabhuji also composed many sacred scriptures, including the Shodash Granth, Shri Yamunashtakam, Siddhanta Rahasya, and Subodhiniji, which remain the foundation of Pushtimarg philosophy. Despite being honoured by kings and scholars, He lived a life of simplicity, dedicating every moment to Bhagwan and the spiritual upliftment of devotees.",
                  ),
                  _buildContentParagraph(
                    theme,
                    "After completing His divine mission, Shri Mahaprabhuji accepted the path of renunciation and spent His final days in Kashi. On Rath Yatra of Vikram Samvat 1587, at the age of 52, He entered the sacred River Ganga. According to Pushtimarg tradition, His divine form merged into a radiant light, signifying His return to the eternal abode of Bhagwan Shri Krishna. His life remains a timeless source of devotion, wisdom, and divine grace for followers of Pushtimarg around the world.",
                  ),
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