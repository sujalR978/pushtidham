import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/database/database_helper.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/bethakji_model.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_detail_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/FavoritesScreen.dart';

// IMPORTANT: Uncomment to enable custom click sounds
// import 'package:pushtidham/services/sound_service.dart';

class BethakjiListPage extends StatefulWidget {
  const BethakjiListPage({super.key});

  @override
  State<BethakjiListPage> createState() => _BethakjiListPageState();
}

class _BethakjiListPageState extends State<BethakjiListPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<BethakjiModel> _allBethakjiList = [];
  List<BethakjiModel> _filteredList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBethakjiData();
  }

  Future<void> _fetchBethakjiData() async {
    try {
      final List<BethakjiModel> data = await _dbHelper.getAllBethakji();
      if (!mounted) return;

      setState(() {
        _allBethakjiList = data;
        _performFiltering(_searchController.text); // Populate filtered list
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching Bethakji data: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(BethakjiModel item) async {
    HapticFeedback.selectionClick();

    final int newFavoriteStatus = item.isFavorite == 1 ? 0 : 1;
    await _dbHelper.updateFavoriteStatus(item.id, newFavoriteStatus);
    if (!mounted) return;

    // Update the source of truth
    final index = _allBethakjiList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _allBethakjiList[index] = item.copyWith(isFavorite: newFavoriteStatus);
    }

    // Re-filter the list and update the UI
    setState(() {
      _performFiltering(_searchController.text);
    });
  }

  void _filterBethakji(String query) {
    if (!mounted) return;
    setState(() {
      _performFiltering(query);
    });
  }

  void _performFiltering(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      _filteredList = List.from(_allBethakjiList);
    } else {
      _filteredList = _allBethakjiList.where((item) {
        final nameMatch = item.name.toLowerCase().contains(cleanQuery);
        final numberMatch = item.number.toLowerCase().contains(cleanQuery);
        final addressMatch = item.address.toLowerCase().contains(cleanQuery);
        return nameMatch || numberMatch || addressMatch;
      }).toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Using CustomScrollView for a premium scrolling experience
      body: CustomScrollView(
        slivers: [
          // 1. Sleek Collapsible Search Header
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            title: Text(
              l10n.grid_bethakji_list,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_rounded),
                tooltip: "Favorites",
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesPage(),
                    ),
                  );
                  _fetchBethakjiData(); // Refresh on return
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: _buildSearchBar(theme, l10n),
            ),
          ),

          // 2. The Sacred Grid View (Replacing the List View)
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filteredList.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Bethakji Found",
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 Cards per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.78, // Adjusts the height of the cards
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildSacredGridCard(
                    context: context,
                    theme: theme,
                    bethak: _filteredList[index],
                  );
                }, childCount: _filteredList.length),
              ),
            ),
        ],
      ),
    );
  }

  // --- UPGRADED COMPONENTS ---

  Widget _buildSearchBar(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
        onChanged: _filterBethakji,
        decoration: InputDecoration(
          hintText: l10n.search_placeholder,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.primary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _searchController.clear();
                    _filterBethakji('');
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: theme.colorScheme.onPrimary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSacredGridCard({
    required BuildContext context,
    required ThemeData theme,
    required BethakjiModel bethak,
  }) {
    final bool isFav = bethak.isFavorite == 1;
    // Clean name: Strip out the "(1)" part if it exists so we can display it cleanly
    // This is now safer: if cleaning the name makes it empty, we revert to the original name.
    // This prevents items from appearing to have no title.
    final String tempName = bethak.name.replaceFirst(
      RegExp(r'^\(\d+\)\s*'),
      '',
    );
    final String cleanName = tempName.isNotEmpty ? tempName : bethak.name;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // SoundService().playClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BethakjiDetailPage(bethak: bethak),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 1. Faded Spiritual Watermark in the background
              Positioned(
                right: -20,
                bottom: -10,
                child: Icon(
                  Icons.spa_rounded,
                  size: 100,
                  color: theme.colorScheme.primary.withOpacity(0.04),
                ),
              ),

              // 2. Card Content
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Number Badge & Heart Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The Sacred Seal (Number Badge)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            bethak.number,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),

                        // Favorite Button
                        GestureDetector(
                          onTap: () => _toggleFavorite(bethak),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isFav
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav
                                  ? Colors.red
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.3,
                                    ),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Name of Bethakji
                    Text(
                      cleanName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Location / Address Row
                    if (bethak.address.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              bethak.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
