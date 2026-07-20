import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

class FavoriteItem {
  final String id;
  final String title;
  final String category;
  final IconData icon;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
  });
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<FavoriteItem> _favoriteItems = [
    FavoriteItem(id: '1', title: 'શ્રી યમુનાષ્ટક સ્તોત્ર પાઠ', category: 'ગ્રંથ', icon: Icons.menu_book),
    FavoriteItem(id: '2', title: 'દૃઢ ઇન ચરનન કેરો ભરોસો', category: 'કિર્તન', icon: Icons.queue_music),
    FavoriteItem(id: '3', title: '૮૪ વૈષ્ણવ વાર્તા - પ્રસંગ ૧', category: 'વાર્તા', icon: Icons.rate_review),
  ];

  void _removeFavorite(int index) {
    final l10n = AppLocalizations.of(context)!;
    final removedItem = _favoriteItems[index];
    setState(() {
      _favoriteItems.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${removedItem.title} - ${l10n.btn_delete}"),
        action: SnackBarAction(
          label: l10n.btn_undo,
          textColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
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
        title: Text(l10n.nav_favorites, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: _favoriteItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.nav_favorites,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _favoriteItems.length,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                itemBuilder: (context, index) {
                  final item = _favoriteItems[index];
                  
                  return Padding(
                    key: Key(item.id),
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.favorite_border, color: Colors.white),
                      ),
                      onDismissed: (direction) => _removeFavorite(index),
                      child: Card(
                        color: theme.cardTheme.color,
                        elevation: theme.cardTheme.elevation ?? 2,
                        shape: theme.cardTheme.shape,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                            child: Icon(item.icon, color: theme.colorScheme.primary),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.category,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.favorite,
                            color: theme.colorScheme.primary,
                          ),
                          onTap: () {
                            // Navigate directly to the item details page
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