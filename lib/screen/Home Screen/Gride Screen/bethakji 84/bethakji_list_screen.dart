import 'package:flutter/material.dart';
import 'package:pushtidham/database/database_helper.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/bethakji_model.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_detail_screen.dart';
import 'package:pushtidham/screen/Home%20Screen/drawer%20Menu%20Screens/Setting%20Screen%20/FavoritesScreen.dart';

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
      setState(() {
        _allBethakjiList = data;
        _isLoading = false;
      });
      // Re-apply search filter in case user had typed something
      _filterBethakji(_searchController.text);
    } catch (e) {
      debugPrint("Error fetching Bethakji data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(BethakjiModel item) async {
    final int newFavoriteStatus = item.isFavorite == 1 ? 0 : 1;

    // 1. Update SQLite DB
    await _dbHelper.updateFavoriteStatus(item.id, newFavoriteStatus);

    // 2. Update Master List State
    setState(() {
      final index = _allBethakjiList.indexWhere(
        (element) => element.id == item.id,
      );
      if (index != -1) {
        _allBethakjiList[index] = item.copyWith(isFavorite: newFavoriteStatus);
      }
    });

    // 3. Re-filter to keep search results in sync
    _filterBethakji(_searchController.text);
  }

  void _filterBethakji(String query) {
    final cleanQuery = query.trim().toLowerCase();
    setState(() {
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
    });
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
      appBar: AppBar(
        title: Text(
          l10n.grid_bethakji_list,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
              // Refresh when coming back from favorites screen
              _fetchBethakjiData();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Container
            Container(
              padding: const EdgeInsets.all(12.0),
              color: theme.colorScheme.primary,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.colorScheme.onPrimary),
                onChanged: _filterBethakji,
                decoration: InputDecoration(
                  hintText: l10n.search_placeholder,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onPrimary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: theme.colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterBethakji('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.onPrimary.withOpacity(0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // List View
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredList.isEmpty
                  ? Center(
                      child: Text(
                        l10n.search_placeholder,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _filteredList.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 0.8,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final bethak = _filteredList[index];
                        final bool isFav = bethak.isFavorite == 1;

                        // Safely display title without crashing string replace
                        final String displayTitle = itemTitle(bethak);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            displayTitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: bethak.address.isNotEmpty
                              ? Text(
                                  bethak.address,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav
                                  ? Colors.red
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.4,
                                    ),
                            ),
                            onPressed: () => _toggleFavorite(bethak),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BethakjiDetailPage(bethak: bethak),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Safe helper method for title formatting
  String itemTitle(BethakjiModel item) {
    if (item.name.startsWith("(${item.number})")) {
      return item.name;
    }
    return "(${item.number}) ${item.name}";
  }
}
