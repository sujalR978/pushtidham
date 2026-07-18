import 'package:flutter/material.dart';
import 'package:pushtidham/Setting%20Screen%20/settingScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Grid Data matching your image items
  final List<Map<String, dynamic>> gridItems = [
    {"title": "શ્રી મહાપ્રભુજી વિશે", "icon": Icons.person},
    {"title": "શ્રી મહાપ્રભુજીના બેઠકજી ની યાદી", "icon": Icons.grid_view},
    {"title": "કિર્તન", "icon": Icons.queue_music},
    {"title": "પાઠાવલી (ષોડશ ગ્રંથ)", "icon": Icons.menu_book},
    {"title": "ટિપ્પણી (Calendar)", "icon": Icons.calendar_month},
    {"title": "૮૪ વૈષ્ણવની વાર્તા", "icon": Icons.rate_review},
    {
      "title": "૮૪ વૈષ્ણવની વાર્તા (વ્રજ ભાષા)",
      "icon": Icons.chrome_reader_mode,
    },
    {"title": "૨૫૨ વૈષ્ણવની વાર્તા", "icon": Icons.menu_book_outlined},
    {"title": "અભિપ્રાય (Review)", "icon": Icons.comment},
    {"title": "સંપર્ક", "icon": Icons.contact_phone},
    {"title": "સંપર્ક", "icon": Icons.contact_phone},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "પુષ્ટિધામ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Action for Quick Favorites Access
            },
          ),
        ],
      ),
      // 1. DRAWER MENU STRUCTURE (Matching your reference image structure)
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
                    child: Icon(
                      Icons.brightness_7,
                      size: 45,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "પુષ્ટિધામ",
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
                "હોમ",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: theme.colorScheme.primary),
              title: Text(
                "મારા મનપસંદ (Favorites)",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.note_alt, color: theme.colorScheme.primary),
              title: Text(
                "વ્યક્તિગત નોંધો (Personal Notes)",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.collections,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                "મીડિયા ગેલેરી (Gallery)",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.download_for_offline,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                "ઓફલાઇન કન્ટેન્ટ",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              title: Text(
                "સેટીંગ્સ",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 2. GLOBAL SEARCH BAR IMPLEMENTATION
          Container(
            padding: const EdgeInsets.all(12.0),
            color: theme.colorScheme.primary,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "શોધો (Search content...)",
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
              onChanged: (value) {
                // Implement search logic filtering grid items here
              },
            ),
          ),

          // Quick Access Mini-Bar for Personalization Features
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickActionButton(context, Icons.collections, "ગેલેરી"),
                _buildQuickActionButton(
                  context,
                  Icons.cloud_download,
                  "ઓફલાઇન",
                ),
                _buildQuickActionButton(context, Icons.edit_note, "નોંધો"),
              ],
            ),
          ),

          // 3. GRID CONTENT AREA (Matching layout structure of the reference image)
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
                      // Handle section navigation
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
      onPressed: () {},
    );
  }
}
