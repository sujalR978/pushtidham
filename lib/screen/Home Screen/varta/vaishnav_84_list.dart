import 'package:flutter/material.dart';
import 'dart:async'; // Import the async library for Timer
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/database/database_helper.dart';
import 'package:pushtidham/model/varta_model.dart';
import 'package:pushtidham/screen/Home%20Screen/varta/vaishnav_84_detail.dart';

class ChorasiVartaListPage extends StatefulWidget {
  final bool isBrajLanguage;

  const ChorasiVartaListPage({super.key, this.isBrajLanguage = false});

  @override
  State<ChorasiVartaListPage> createState() => _ChorasiVartaListPageState();
}

class _ChorasiVartaListPageState extends State<ChorasiVartaListPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;

  List<VartaModel> _allVartas = [];
  Timer? _debounce;
  List<VartaModel> _filteredVartas = [];
  final Set<String> _favoriteVartaIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadVartas();
  }

  Future<void> _loadVartas() async {
    final allItems = await _dbHelper.getAll84Vartas();
    final favoriteIds = allItems
        .where((varta) => varta.isFavorite)
        .map((varta) => varta.id)
        .toSet();
    if (!mounted) return;

    _favoriteVartaIds.clear();
    _favoriteVartaIds.addAll(favoriteIds);

    for (var varta in allItems) {
      varta.isFavorite = _favoriteVartaIds.contains(varta.id);
    }

    setState(() {
      _allVartas = allItems;
      // This is the key fix: Initialize the filtered list with all items.
      _filteredVartas = allItems;
      _isLoading = false;
    });
  }

  void _filterVartas(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredVartas = _allVartas;
      } else {
        _filteredVartas = _allVartas.where((item) {
          final title = widget.isBrajLanguage
              ? item.titleBraj
              : item.titleGujarati;
          return title.toLowerCase().contains(query.toLowerCase()) ||
              item.number.contains(query);
        }).toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterVartas(query);
    });
  }

  Future<void> _toggleFavorite(VartaModel varta) async {
    final wasFavorite = _favoriteVartaIds.contains(varta.id);
    final isNowFavorite = !wasFavorite;

    setState(() {
      if (isNowFavorite) {
        _favoriteVartaIds.add(varta.id);
      } else {
        _favoriteVartaIds.remove(varta.id);
      }
      // This is crucial: update the isFavorite property on the model
      // in both the main list and the filtered list.
      varta.isFavorite = isNowFavorite;
    });
    await _dbHelper.update84VartaFavoriteStatus(varta.id, isNowFavorite);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final appBarTitle = widget.isBrajLanguage
        ? "૮૪ વૈષ્ણવની વાર્તા (વ્રજ ભાષા)"
        : "૮૪ વૈષ્ણવની વાર્તા";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                            _filterVartas('');
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

            // 2. VARTA LIST VIEW
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : _filteredVartas.isEmpty
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
                              fontSize: 16,
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
                      itemCount: _filteredVartas.length,
                      itemBuilder: (context, index) {
                        final varta = _filteredVartas[index];
                        final displayTitle = widget.isBrajLanguage
                            ? varta.titleBraj
                            : varta.titleGujarati;

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
                                varta.number,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            title: Text(
                              displayTitle,
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
                                    _favoriteVartaIds.contains(varta.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favoriteVartaIds.contains(varta.id)
                                        ? Colors.red
                                        : theme.colorScheme.onSurface
                                              .withOpacity(0.4),
                                  ),
                                  onPressed: () => _toggleFavorite(varta),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChorasiVartaDetailPage(
                                    varta: varta,
                                    isBrajLanguage: widget.isBrajLanguage,
                                  ),
                                ),
                              ).then((_) {
                                // When returning from the detail page, we only need to update the UI
                                // for the favorite status, as the `varta` object's `isFavorite`
                                // property was already updated on the detail page.
                                final isNowFavorite = varta.isFavorite;
                                final isListedAsFavorite = _favoriteVartaIds
                                    .contains(varta.id);

                                // If the state is inconsistent, sync it and rebuild the widget.
                                if (isNowFavorite != isListedAsFavorite) {
                                  _toggleFavorite(varta);
                                } else
                                  setState(() {});
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
