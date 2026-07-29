import 'package:flutter/material.dart';
import 'package:pushtidham/database/database_helper.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/bethakji_model.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<BethakjiModel> _favoriteItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  // Fetch favorite items directly from SQLite DB (isFavorite = 1)
  Future<void> _fetchFavorites() async {
    try {
      final List<BethakjiModel> data = await _dbHelper.getFavoriteBethakji();
      setState(() {
        _favoriteItems = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Remove item from favorites (Updates DB & local state)
  Future<void> _removeFavorite(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final removedItem = _favoriteItems[index];

    // Update SQLite database (isFavorite = 0)
    await _dbHelper.updateFavoriteStatus(removedItem.id, 0);

    setState(() {
      _favoriteItems.removeAt(index);
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${removedItem.name} - ${l10n.btn_delete}"),
        action: SnackBarAction(
          label: l10n.btn_undo,
          textColor: Theme.of(context).colorScheme.secondary,
          onPressed: () async {
            // Restore in SQLite database (isFavorite = 1)
            await _dbHelper.updateFavoriteStatus(removedItem.id, 1);
            setState(() {
              _favoriteItems.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.nav_favorites,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favoriteItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.nav_favorites,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _favoriteItems.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                itemBuilder: (context, index) {
                  final item = _favoriteItems[index];

                  return Padding(
                    key: ValueKey(item.id),
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) => _removeFavorite(index),
                      child: Card(
                        color: theme.cardTheme.color,
                        elevation: theme.cardTheme.elevation ?? 2,
                        shape: theme.cardTheme.shape,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.08),
                            child: Text(
                              item.number,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: item.address.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    item.address,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () => _removeFavorite(index),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BethakjiDetailPage(bethak: item),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
