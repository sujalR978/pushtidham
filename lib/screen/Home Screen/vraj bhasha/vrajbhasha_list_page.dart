import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'dart:async';
import 'package:pushtidham/model/vraj_model.dart';
import 'package:pushtidham/database/database_helper.dart';
import 'package:pushtidham/screen/Home%20Screen/vraj%20bhasha/vrajbhasha_detail_page.dart'; // Adjust if needed
// IMPORT YOUR MODEL AND DETAIL PAGE HERE:
// import 'package:pushtidham/model/vrajbhasha_model.dart';
// import 'package:pushtidham/screen/Home%20Screen/vrajbhasha/vrajbhasha_detail_page.dart';

class VrajbhashaListPage extends StatefulWidget {
  const VrajbhashaListPage({super.key});

  @override
  State<VrajbhashaListPage> createState() => _VrajbhashaListPageState();
}

class _VrajbhashaListPageState extends State<VrajbhashaListPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;
  Timer? _debounce;

  List<VrajbhashaModel> _allPads = [];
  List<VrajbhashaModel> _filteredPads = [];
  final Set<String> _favoritePadIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadPads();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  Future<void> _loadPads() async {
    // Assumes you create `getAllVrajbhashaPads` in your DatabaseHelper
    final allItems = await _dbHelper.getAllVrajbhashaPads();
    final favoriteIds = allItems
        .where((pad) => pad.isFavorite)
        .map((pad) => pad.id)
        .toSet();
    if (!mounted) return;

    _favoritePadIds.clear();
    _favoritePadIds.addAll(favoriteIds);

    for (var pad in allItems) {
      pad.isFavorite = _favoritePadIds.contains(pad.id);
    }

    setState(() {
      _allPads = allItems;
      _filteredPads = allItems;
      _isLoading = false;
    });
  }

  void _filterPads(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredPads = _allPads;
      } else {
        _filteredPads = _allPads.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase()) ||
              item.number.contains(query);
        }).toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterPads(query);
    });
  }

  Future<void> _toggleFavorite(VrajbhashaModel item) async {
    setState(() {
      item.isFavorite = !item.isFavorite;
      if (item.isFavorite) {
        _favoritePadIds.add(item.id);
      } else {
        _favoritePadIds.remove(item.id);
      }
    });
    // Assumes you create `updateVrajbhashaFavoriteStatus` in your DatabaseHelper
    await _dbHelper.updateVrajbhashaFavoriteStatus(item.id, item.isFavorite);
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _debounce?.cancel();
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
        title: const Text(
          "વ્રજભાષા પદ", // Change title as needed
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. DYNAMIC THEMED SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              color: theme.colorScheme.primary,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.colorScheme.onPrimary),
                onChanged: _onSearchChanged,
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
                            _filterPads('');
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

            // 2. VRAJBHASHA LIST VIEW
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : _filteredPads.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 60,
                            color: theme.colorScheme.onSurface.withOpacity(0.2),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.search_placeholder,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      itemCount: _filteredPads.length,
                      itemBuilder: (context, index) {
                        final item = _filteredPads[index];

                        return Card(
                          color: theme.cardTheme.color,
                          elevation: theme.cardTheme.elevation ?? 1,
                          shape:
                              theme.cardTheme.shape ??
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.1),
                              child: Text(
                                item.number,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _favoritePadIds.contains(item.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favoritePadIds.contains(item.id)
                                        ? Colors.red
                                        : theme.colorScheme.onSurface
                                              .withOpacity(0.4),
                                  ),
                                  onPressed: () => _toggleFavorite(item),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to the Vrajbhasha Detail Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VrajbhashaDetailPage(item: item),
                                ),
                              ).then((_) {
                                // When returning, check if the favorite status is out of sync
                                // and rebuild the widget state if necessary.
                                final isListedAsFavorite = _favoritePadIds
                                    .contains(item.id);
                                if (item.isFavorite != isListedAsFavorite) {
                                  _toggleFavorite(item);
                                } else {
                                  setState(() {});
                                }
                              });
                            },
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
}
