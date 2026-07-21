import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_list_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/contectScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/jupMalaCounter.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/kirtan/kirtan_detail_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/kirtan/kirtan_list_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/mhaprbhuji_info.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/reviewScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/FavoritesScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/galleryScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/notesScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/offlineContantScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/settingScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController searchController = TextEditingController();

    // Dynamically localized Grid Items List
    final List<Map<String, dynamic>> gridItems = [
      {
        "title": l10n.grid_about_mahaprabhuji,
        "icon": Icons.person,
        "screen": const AboutMahaprabhujiPage(),
      },
      {
        "title": l10n.grid_bethakji_list,
        "icon": Icons.grid_view,
        "screen": const BethakjiListPage(),
      },
      {
        "title": l10n.grid_kirtan,
        "icon": Icons.queue_music,
        "screen": const KirtanListPage(),
      },
      {
        "title": l10n.grid_pathavali,
        "icon": Icons.menu_book,
        "screen": const JapMalaScreen(),
      },
      {
        "title": l10n.grid_calendar,
        "icon": Icons.calendar_month,
        "screen": const JapMalaScreen(),
      },
      {
        "title": l10n.grid_jap_mala,
        "icon": Icons.ads_click,
        "screen": const JapMalaScreen(),
      },
      {
        "title": l10n.grid_84_vaishnav,
        "icon": Icons.rate_review,
        "screen": const JapMalaScreen(),
      },
      {
        "title": l10n.grid_84_vaishnav_vraj,
        "icon": Icons.chrome_reader_mode,
        "screen": const JapMalaScreen(),
      },
      {
        "title": l10n.grid_252_vaishnav,
        "icon": Icons.menu_book_outlined,
        "screen": const JapMalaScreen(),
      },
      {
        "title": l10n.grid_review,
        "icon": Icons.comment,
        "screen": const ReviewPage(),
      },
      {
        "title": l10n.grid_contact,
        "icon": Icons.contact_phone,
        "screen": const ContactPage(),
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.app_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      // Drawer Menu
      drawer: Drawer(
        backgroundColor: theme.colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.onPrimary.withOpacity(
                      0.2,
                    ),
                    child: Text(
                      "ૐ",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.app_title,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: theme.colorScheme.primary),
              title: Text(
                l10n.nav_home,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: theme.colorScheme.primary),
              title: Text(
                l10n.nav_favorites,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.note_alt, color: theme.colorScheme.primary),
              title: Text(
                l10n.nav_notes,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.collections,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                l10n.nav_gallery,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GalleryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.download_for_offline,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                l10n.nav_offline,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OfflineContentPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              title: Text(
                l10n.nav_settings,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(12.0),
            color: theme.colorScheme.primary,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: l10n.search_placeholder,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onPrimary.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onPrimary,
                ),
                filled: true,
                fillColor: theme.colorScheme.onPrimary.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),

          // Quick Access Chips Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickActionButton(
                  context,
                  Icons.collections,
                  l10n.nav_gallery,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GalleryPage(),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  context,
                  Icons.cloud_download,
                  l10n.nav_offline,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OfflineContentPage(),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  context,
                  Icons.edit_note,
                  l10n.nav_notes,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Grid View Content Area
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                final item = gridItems[index];
                return Card(
                  color: theme.cardTheme.color,
                  elevation: theme.cardTheme.elevation ?? 2,
                  shape: theme.cardTheme.shape,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (item["screen"] != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => item["screen"],
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"],
                            size: 40,
                            color: theme.colorScheme.secondary == Colors.black87
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item["title"],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    return ActionChip(
      avatar: Icon(icon, size: 18, color: theme.colorScheme.primary),
      label: Text(
        label,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 12),
      ),
      backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
      side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2)),
      onPressed: onPressed,
    );
  }
}
