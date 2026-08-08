import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/vraj_model.dart';
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

  // Dummy data - Move this to your vrajbhasha_model.dart file later
  final List<VrajbhashaModel> _allPads = [
    VrajbhashaModel(
      id: '1',
      number: '૦૧',
      title: 'દ્રઢ ઇન ચરનન કેરો ભરોસો',
      padText: 'દ્રઢ ઇન ચરનન કેરો ભરોસો...\nશ્રી વલ્લભ નખ ચંદ્ર છટા બિન,\nસબ જગ માંઝ અંધેરો...',
      bhavarth: 'શ્રી મહાપ્રભુજીના ચરણારવિંદનો જ મને દ્રઢ ભરોસો છે. તેમના નખની ચંદ્ર સમાન કાંતિ વિના આખા જગતમાં અંધકાર છે.',
      prasang: 'આ પદ શ્રી સૂરદાસજીએ શ્રી મહાપ્રભુજીના આશ્રયનો દ્રઢ મહિમા સમજાવવા ગાયું હતું.',
    ),
    // Add more Vrajbhasha pads here...
  ];

  List<VrajbhashaModel> _filteredPads = [];

  @override
  void initState() {
    super.initState();
    _filteredPads = _allPads;
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              color: theme.colorScheme.primary,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.colorScheme.onPrimary),
                onChanged: _filterPads,
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
              child: _filteredPads.isEmpty
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
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: _filteredPads.length,
                      itemBuilder: (context, index) {
                        final item = _filteredPads[index];

                        return Card(
                          color: theme.cardTheme.color,
                          elevation: theme.cardTheme.elevation ?? 1,
                          shape: theme.cardTheme.shape ??
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
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
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
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                            onTap: () {
                              // Navigate to the Vrajbhasha Detail Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VrajbhashaDetailPage(item: item),
                                ),
                              );
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