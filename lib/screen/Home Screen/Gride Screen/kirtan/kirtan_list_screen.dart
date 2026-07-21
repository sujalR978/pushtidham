import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/kirtan_model.dart';
import 'package:pushtidham/screen/Home Screen/Gride Screen/kirtan/kirtan_detail_screen.dart';

class KirtanListPage extends StatefulWidget {
  const KirtanListPage({super.key});

  @override
  State<KirtanListPage> createState() => _KirtanListPageState();
}

class _KirtanListPageState extends State<KirtanListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<KirtanModel> _allKirtans = [
    KirtanModel(
      id: '1',
      number: '૦૧',
      title: 'યમુનાષ્ટક',
      imageAsset: 'assets/images/spleshScreen_image.png',
    ),
    
  ];

  List<KirtanModel> _filteredKirtans = [];

  @override
  void initState() {
    super.initState();
    _filteredKirtans = _allKirtans;
  }

  void _filterKirtan(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredKirtans = _allKirtans;
      } else {
        _filteredKirtans = _allKirtans
            .where(
              (item) =>
                  item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.number.contains(query),
            )
            .toList();
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
          l10n.grid_kirtan,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(12.0),
              color: theme.colorScheme.primary,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.colorScheme.onPrimary),
                onChanged: _filterKirtan,
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
                            _filterKirtan('');
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

            // Kirtan List
            Expanded(
              child: _filteredKirtans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_outlined,
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
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredKirtans.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, thickness: 0.8),
                      itemBuilder: (context, index) {
                        final kirtan = _filteredKirtans[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          title: Text(
                            "(${kirtan.number}) ${kirtan.title}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          trailing: Icon(
                            Icons.play_arrow_rounded,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    KirtanDetailPage(kirtanList: _filteredKirtans, initialIndex: index),
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
}
