import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/database/database_helper.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/pathavali_model.dart';
import 'package:pushtidham/screen/Home%20Screen/pathavli/pathavli_detail.dart';
import 'package:pushtidham/model/bethakji_model.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_detail_screen.dart';

// IMPORTANT: Uncomment this to enable your custom sounds!
// import 'package:pushtidham/services/sound_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Data lists for the different tabs
  List<BethakjiModel> _favoriteBethakjis = [];
  bool _isLoadingBethakjis = true;

  List<PathavaliItem> _favoritePathavalis = [];
  bool _isLoadingPathavalis = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteBethakjis();
    _fetchFavoritePathavalis();
  }

  // Fetch favorite Bethakjis directly from SQLite DB (isFavorite = 1)
  Future<void> _fetchFavoriteBethakjis() async {
    try {
      final List<BethakjiModel> data = await _dbHelper.getFavoriteBethakji();
      setState(() {
        _favoriteBethakjis = data;
        _isLoadingBethakjis = false;
      });
    } catch (e) {
      debugPrint("Error fetching Bethakji favorites: $e");
      setState(() {
        _isLoadingBethakjis = false;
      });
    }
  }

  // Fetch favorite Pathavalis from SQLite DB
  Future<void> _fetchFavoritePathavalis() async {
    try {
      final List<PathavaliItem> data = await _dbHelper.getFavoritePathavalis();
      if (!mounted) return;
      setState(() {
        _favoritePathavalis = data;
        _isLoadingPathavalis = false;
      });
    } catch (e) {
      debugPrint("Error fetching Pathavali favorites: $e");
      if (!mounted) return;
      setState(() {
        _isLoadingPathavalis = false;
      });
    }
  }

  // Remove Bethakji from favorites
  Future<void> _removeBethakjiFavorite(int index) async {
    HapticFeedback.mediumImpact();
    // SoundService().playClick();

    final removedItem = _favoriteBethakjis[index];

    // Update SQLite database (isFavorite = 0)
    await _dbHelper.updateFavoriteStatus(removedItem.id, 0);

    setState(() {
      _favoriteBethakjis.removeAt(index);
    });

    if (!mounted) return;

    // Show beautiful premium SnackBar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.heart_broken_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Removed ${removedItem.name}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Remove Pathavali from favorites
  Future<void> _removePathavaliFavorite(int index) async {
    HapticFeedback.mediumImpact();
    // SoundService().playClick();

    final removedItem = _favoritePathavalis[index];

    // Update SQLite database (isFavorite = 0)
    await _dbHelper.updatePathavaliFavoriteStatus(removedItem.id, false);

    setState(() {
      _favoritePathavalis.removeAt(index);
    });

    if (!mounted) return;

    // Show beautiful premium SnackBar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.bookmark_remove_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Removed ${removedItem.title}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 6, // We now have 6 categorized sections!
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        // NestedScrollView allows the AppBar to collapse, but keeps the TabBar pinned to the top!
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: innerBoxIsScrolled ? 4 : 0,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                centerTitle: true,
                title: Text(
                  l10n.nav_favorites,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                bottom: TabBar(
                  isScrollable:
                      true, // Crucial! Allows the 6 tabs to scroll horizontally
                  indicatorColor: theme.colorScheme.onPrimary,
                  indicatorWeight: 3,
                  labelColor: theme.colorScheme.onPrimary,
                  unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(
                    0.6,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabAlignment: TabAlignment.start,
                  onTap: (_) {
                    HapticFeedback.lightImpact();
                    // SoundService().playClick();
                  },
                  tabs: const [
                    Tab(text: "Bethakji"),
                    Tab(text: "Kirtan"),
                    Tab(text: "Pathavali"),
                    Tab(text: "84 Varta"),
                    Tab(text: "84 Vrajbhasha"),
                    Tab(text: "252 Varta"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Tab 1: Bethakji (Fully Implemented)
              _buildBethakjiTab(theme),

              // Tabs 2-6: Beautiful Placeholders ready for your DB logic later
              _buildPlaceholderTab(
                theme,
                "Kirtans",
                "Save your favorite Pushtimarg Kirtans here.",
                Icons.music_note_rounded,
              ),
              _buildPathavaliTab(theme),
              _buildPlaceholderTab(
                theme,
                "84 Vaishnav Varta",
                "Save sacred stories of the 84 Vaishnavs.",
                Icons.groups_rounded,
              ),
              _buildPlaceholderTab(
                theme,
                "84 Vrajbhasha",
                "Save Vrajbhasha literature and stories.",
                Icons.explore_rounded,
              ),
              _buildPlaceholderTab(
                theme,
                "252 Vaishnav Varta",
                "Bookmark stories of the 252 Vaishnavs.",
                Icons.collections_bookmark_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB IMPLEMENTATIONS ---

  Widget _buildBethakjiTab(ThemeData theme) {
    if (_isLoadingBethakjis) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }
    if (_favoriteBethakjis.isEmpty) {
      return _buildEmptyState(
        theme,
        "No Favorite Bethakjis",
        "Tap the heart icon on any Bethakji to save it here for quick darshan.",
        Icons.place_rounded,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      itemCount: _favoriteBethakjis.length,
      itemBuilder: (context, index) {
        final item = _favoriteBethakjis[index];
        return _buildPremiumFavoriteCard(theme, item, index);
      },
    );
  }

  Widget _buildPathavaliTab(ThemeData theme) {
    if (_isLoadingPathavalis) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }
    if (_favoritePathavalis.isEmpty) {
      return _buildEmptyState(
        theme,
        "No Favorite Pathavali",
        "Tap the heart icon on any Pathavali to save it here for quick access.",
        Icons.menu_book_rounded,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      itemCount: _favoritePathavalis.length,
      itemBuilder: (context, index) {
        final item = _favoritePathavalis[index];
        return _buildPathavaliFavoriteCard(theme, item, index);
      },
    );
  }

  // Generic placeholder for categories you haven't built databases for yet
  Widget _buildPlaceholderTab(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return _buildEmptyState(theme, "No Favorite $title", subtitle, icon);
  }

  // --- UPGRADED UI COMPONENTS ---

  // Beautiful Spiritual Empty State (Dynamic)
  Widget _buildEmptyState(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: Colors.red.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Premium Custom Card for Bethakji items
  Widget _buildPremiumFavoriteCard(
    ThemeData theme,
    BethakjiModel item,
    int index,
  ) {
    String cleanName = item.name.replaceFirst(RegExp(r'^\(\d+\)\s*'), '');

    return Padding(
      key: ValueKey(item.id),
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.heart_broken_rounded, color: Colors.white, size: 28),
              SizedBox(height: 4),
              Text(
                "Remove",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) => _removeBethakjiFavorite(index),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // SoundService().playClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BethakjiDetailPage(bethak: item),
              ),
            ).then((_) {
              // Refresh the list when returning, in case they unfavorited it inside the details page
              _fetchFavoriteBethakjis();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Sacred Number Badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.number,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cleanName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (item.address.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Un-Favorite Action Button
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 22,
                    ),
                    onPressed: () => _removeBethakjiFavorite(index),
                    tooltip: "Remove from Favorites",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Premium Custom Card for Pathavali items
  Widget _buildPathavaliFavoriteCard(
    ThemeData theme,
    PathavaliItem item,
    int index,
  ) {
    return Padding(
      key: ValueKey(item.id),
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_remove_rounded,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(height: 4),
              Text(
                "Remove",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) => _removePathavaliFavorite(index),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // SoundService().playClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PathavaliDetailPage(item: item),
              ),
            ).then((_) {
              // Refresh the list when returning, in case they unfavorited it inside the details page
              _fetchFavoritePathavalis();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Sacred Number Badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.id,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Text Details
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),

                // Un-Favorite Action Button
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 22,
                    ),
                    onPressed: () => _removePathavaliFavorite(index),
                    tooltip: "Remove from Favorites",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
