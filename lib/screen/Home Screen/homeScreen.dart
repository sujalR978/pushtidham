import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_list_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/contectScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/jupMalaCounter.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/kirtan/kirtan_list_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/mhaprbhuji_info.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/reviewScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/calander/calendar_page.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/FavoritesScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/galleryScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/notesScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/offlineContantScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/settingScreen.dart';
import 'package:pushtidham/screen/Home%20Screen/pathavli/pathavli_list.dart';
import 'package:pushtidham/screen/Home%20Screen/varta/vaishnav_84_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const Text("ૐ ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(
              l10n.app_title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            tooltip: l10n.nav_favorites,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.nav_settings,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      // Decorative Sacred Drawer
      drawer: _buildSacredDrawer(context, theme, l10n),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Daily Suvichar & Quick Action Hero Banner
              SliverToBoxAdapter(
                child: _buildDailyDarshanHeader(context, theme, l10n),
              ),

              // 2. Search Bar Integration
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: l10n.search_placeholder,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Featured Sacred Experiences (Horizontal Carousel Cards)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, theme, l10n.section_sacred_highlights, Icons.stars_rounded),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildHeroFeatureCard(
                            context: context,
                            title: l10n.grid_about_mahaprabhuji,
                            subtitle: l10n.sub_mahaprabhuji_charitra,
                            icon: Icons.auto_awesome_rounded,
                            badge: l10n.badge_path,
                            onTap: () => _navigateTo(context, const AboutMahaprabhujiPage()),
                          ),
                          _buildHeroFeatureCard(
                            context: context,
                            title: l10n.grid_bethakji_list,
                            subtitle: l10n.sub_bethakji_yatra,
                            icon: Icons.place_rounded,
                            badge: l10n.badge_yatra,
                            onTap: () => _navigateTo(context, const BethakjiListPage()),
                          ),
                          _buildHeroFeatureCard(
                            context: context,
                            title: l10n.grid_calendar,
                            subtitle: l10n.sub_calendar_details,
                            icon: Icons.calendar_month_rounded,
                            badge: l10n.badge_today,
                            onTap: () => _navigateTo(context, const TippaniCalendarPage()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Category 1: Nitya Seva & Path
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildSectionTitle(
                    context,
                    theme,
                    l10n.section_daily_worship,
                    Icons.menu_book_rounded,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildHorizontalCategoryRow(context, theme, [
                  {
                    "title": l10n.grid_pathavali,
                    "subtitle": l10n.sub_pathavali_stotra,
                    "icon": Icons.menu_book_outlined,
                    "screen": const PathavaliListPage(),
                  },
                  {
                    "title": l10n.grid_kirtan,
                    "subtitle": l10n.sub_kirtan_pad,
                    "icon": Icons.music_note_rounded,
                    "screen": const KirtanListPage(),
                  },
                  {
                    "title": l10n.grid_jap_mala,
                    "subtitle": l10n.sub_jap_mala_count,
                    "icon": Icons.touch_app_rounded,
                    "screen": const JapMalaScreen(),
                  },
                ]),
              ),

              // 5. Category 2: Pushti Varta & Literature
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildSectionTitle(
                    context,
                    theme,
                    l10n.section_sacred_stories,
                    Icons.auto_stories_rounded,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildVerticalListGroup(context, theme, [
                  {
                    "title": l10n.grid_84_vaishnav,
                    "subtitle": l10n.sub_84_varta,
                    "icon": Icons.groups_rounded,
                    "screen": const ChorasiVartaListPage(),
                  },
                  {
                    "title": l10n.grid_84_vaishnav_vraj,
                    "subtitle": l10n.sub_vrajbhakt_charitra,
                    "icon": Icons.explore_rounded,
                    "screen": const ChorasiVartaListPage(),
                  },
                  {
                    "title": l10n.grid_252_vaishnav,
                    "subtitle": l10n.sub_252_varta,
                    "icon": Icons.collections_bookmark_rounded,
                    "screen": const ChorasiVartaListPage(),
                  },
                ]),
              ),

              // 6. Category 3: Community & Seva Tools
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildSectionTitle(
                    context,
                    theme,
                    l10n.section_community_seva,
                    Icons.hub_rounded,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTileCard(
                          context: context,
                          theme: theme,
                          title: l10n.nav_gallery,
                          icon: Icons.photo_library_rounded,
                          onTap: () => _navigateTo(context, const GalleryPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTileCard(
                          context: context,
                          theme: theme,
                          title: l10n.nav_notes,
                          icon: Icons.note_alt_rounded,
                          onTap: () => _navigateTo(context, const NotesPage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTileCard(
                          context: context,
                          theme: theme,
                          title: l10n.grid_review,
                          icon: Icons.rate_review_rounded,
                          onTap: () => _navigateTo(context, const ReviewPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTileCard(
                          context: context,
                          theme: theme,
                          title: l10n.grid_contact,
                          icon: Icons.contact_support_rounded,
                          onTap: () => _navigateTo(context, const ContactPage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding for float bar
            ],
          ),

          // Quick Access Floating Nam-Smaran Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildQuickJaapFloatingBar(context, theme, l10n),
          ),
        ],
      ),
    );
  }

  // --- HELPER COMPONENTS ---

  void _navigateTo(BuildContext context, Widget targetScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  // Daily Darshan Header Banner with Spiritual Suvichar
  Widget _buildDailyDarshanHeader(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quote_salutation,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.quote_mantra,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.spa_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.format_quote_rounded, color: theme.colorScheme.onPrimary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.quote_suvichar,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Header with Accent Dot
  Widget _buildSectionTitle(BuildContext context, ThemeData theme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // Large Hero Feature Cards
  Widget _buildHeroFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: theme.cardTheme.color,
        elevation: theme.cardTheme.elevation ?? 2,
        shape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                      radius: 20,
                      child: Icon(icon, color: theme.colorScheme.primary, size: 22),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary == Colors.black87
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Horizontal Category Row
  Widget _buildHorizontalCategoryRow(
    BuildContext context,
    ThemeData theme,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      height: 115,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              color: theme.cardTheme.color,
              elevation: theme.cardTheme.elevation ?? 2,
              shape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _navigateTo(context, item["screen"]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item["icon"], color: theme.colorScheme.primary, size: 26),
                      const SizedBox(height: 8),
                      Text(
                        item["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        item["subtitle"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Vertical List Group for Books/Varta
  Widget _buildVerticalListGroup(
    BuildContext context,
    ThemeData theme,
    List<Map<String, dynamic>> items,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              color: theme.cardTheme.color,
              elevation: theme.cardTheme.elevation ?? 1,
              shape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(item["icon"], color: theme.colorScheme.primary, size: 20),
                ),
                title: Text(
                  item["title"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  item["subtitle"],
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                onTap: () => _navigateTo(context, item["screen"]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Simple Tile Card for 2x2 grid section
  Widget _buildTileCard({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation ?? 1,
      shape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Action Sticky Bottom Bar for Jaap Mala
  Widget _buildQuickJaapFloatingBar(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.ads_click_rounded, color: theme.colorScheme.onPrimary, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.grid_jap_mala,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    l10n.quick_jaap_start_sub,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => _navigateTo(context, const JapMalaScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onPrimary,
              foregroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
            child: Text(
              l10n.quick_jaap_start_btn,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Drawer Menu with Sacred Styling
  Widget _buildSacredDrawer(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Drawer(
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
                  radius: 36,
                  backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                  child: Text(
                    "ૐ",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
            leading: Icon(Icons.home_rounded, color: theme.colorScheme.primary),
            title: Text(l10n.nav_home, style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.bookmark_rounded, color: theme.colorScheme.primary),
            title: Text(l10n.nav_favorites, style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const FavoritesPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.note_alt_rounded, color: theme.colorScheme.primary),
            title: Text(l10n.nav_notes, style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const NotesPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library_rounded, color: theme.colorScheme.primary),
            title: Text(l10n.nav_gallery, style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const GalleryPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.download_for_offline_rounded, color: theme.colorScheme.primary),
            title: Text(l10n.nav_offline, style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const OfflineContentPage());
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            title: Text(l10n.nav_settings, style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const SettingsPage());
            },
          ),
        ],
      ),
    );
  }
}