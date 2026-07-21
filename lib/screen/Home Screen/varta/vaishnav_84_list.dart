import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
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

  final List<VartaModel> _allVartas = [
    VartaModel(
      id: '1',
      number: '૦૧',
      titleGujarati: 'દામોદરદાસ હરસાનીની વાર્તા',
      titleBraj: 'દામોદરદાસ હરસાની કી વાર્તા',
      shloka: 'पठनीयं प्रयत्नैन सर्वहेतुविवर्जितम् ॥ १ ॥',
      arth: 'શ્રીમદ્ ભાગવત શાસ્ત્રનો પ્રયત્ન કરીને પાઠ કરવો.',
      vartaContent: 'દામોદરદાસ હરસાની મહાપ્રભુજીના પ્રથમ શિષ્ય હતા...',
      saar: 'શુદ્ધ કૃપા પાત્ર જીવોને વારંવાર કહેવામાં આવતું નથી.',
    ),
    
  ];

  List<VartaModel> _filteredVartas = [];

  @override
  void initState() {
    super.initState();
    _filteredVartas = _allVartas;
  }

  void _filterVartas(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredVartas = _allVartas;
      } else {
        _filteredVartas = _allVartas.where((item) {
          final title = widget.isBrajLanguage ? item.titleBraj : item.titleGujarati;
          return title.toLowerCase().contains(query.toLowerCase()) ||
              item.number.contains(query);
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
                onChanged: _filterVartas,
                decoration: InputDecoration(
                  hintText: l10n.search_placeholder,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: theme.colorScheme.onPrimary),
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

            // Varta List
            Expanded(
              child: _filteredVartas.isEmpty
                  ? Center(
                      child: Text(
                        l10n.search_placeholder,
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredVartas.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.8),
                      itemBuilder: (context, index) {
                        final varta = _filteredVartas[index];
                        final displayTitle = widget.isBrajLanguage
                            ? varta.titleBraj
                            : varta.titleGujarati;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            "(${varta.number}) $displayTitle",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
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