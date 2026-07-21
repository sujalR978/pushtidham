import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_detail_screen.dart';

class BethakjiModel {
  final String id;
  final String number;
  final String name;
  final String address;
  final List<Map<String, String>> contacts;
  final String mahatmy;
  final String directions;
  final List<String> rules;

  BethakjiModel({
    required this.id,
    required this.number,
    required this.name,
    required this.address,
    required this.contacts,
    required this.mahatmy,
    required this.directions,
    required this.rules,
  });
}

class BethakjiListPage extends StatefulWidget {
  const BethakjiListPage({super.key});

  @override
  State<BethakjiListPage> createState() => _BethakjiListPageState();
}

class _BethakjiListPageState extends State<BethakjiListPage> {
  final TextEditingController _searchController = TextEditingController();

  // Dataset of Bethakji matching reference screenshot content
  final List<BethakjiModel> _allBethakjiList = [
    BethakjiModel(
      id: '1',
      number: '૦૧',
      name: 'શ્રીમદ ગોકુળ પહેલી બેઠક - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, શ્રીમદ ગોકુળ ગોવિંદઘાટ, (બ્રહ્મસંબંધ બેઠકજી), ગોકુળ, જીલ્લો મથુરા (ઉ. પ્ર.)',
      contacts: [
        {'name': 'શ્રી પવનકુમાર', 'phone': '9897330142'},
        {'name': 'શ્રી છેલ બિહારી મુખ્યાજી', 'phone': '9045305051'},
      ],
      mahatmy:
          'યમુનાજીએ સાક્ષાત દર્શન આપી મહાપ્રભુજી, દામોદરદાસજીને ગોવિંદઘાટ અને ઠકુરાણીઘાટ વિશે શંકાનું નિવારણ કર્યું.\n\nવિશેષ મહાત્મ્ય: પુષ્ટિમાર્ગ પ્રાગટ્યદિને અર્થાત શ્રાવણ સુદી ૧૧ - પવિત્રા ૧૧ - મહાપ્રભુજીને શ્રી ઠાકોરજીએ સાક્ષાત દર્શન આપી દૈવીજીવોનાં ઉદ્ધારની ચિંતાનું નિવારણ કરી બ્રહ્મસંબંધ આપવાની આજ્ઞા કરી. શ્રી મહાપ્રભુજીએ પવિત્રું શ્રીજીને ધરાવી મીશ્રીભોગ ધરીને શ્રાવણ સુદ-૧૨ના રોજ શ્રી મહાપ્રભુજીએ દમોદરદાસને પ્રથમ બ્રહ્મસંબંધ આપી પુષ્ટિમાર્ગ પ્રગટ કર્યો.',
      directions:
          'મથુરાથી ૧૨ કિ.મી. દૂર ગોકુળમાં બિરાજે છે. યમુનાજી પર ગોવિંદઘાટ પર છોકર વૃક્ષ નીચે બિરાજમાન છે. અહિ શ્રી ગુસાઈજી, શ્રી હરિલક્ષ્મીજી તેમજ દામોદરદાસજીનાં બેઠકજી ઠકુરાણી ઘાટ પર આવેલા છે.\n\nNearby Railway Station:\nMathura (From Mathura to Gokul 12 Km.)',
      rules: [
        'વૈષ્ણવો અપરસ કરતા પહેલા કાર્યાલયમાં ઝારીજી ભરવાની ભેટની પહોંચ મેળવી લેવી.',
        'ઠાકોરજીને સન્મુખ ભેટ અને મુખ્યાજી ને સવેકી અલગ આપવી.',
        'ઝારીજી ભરવા માટે તે દિવસે ઉપવાસ કરવો જરૂરી છે.',
      ],
    ),
    BethakjiModel(
      id: '2',
      number: '૦૨',
      name: 'શ્રીમદ ગોકુળ બીજી બેઠક - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, ઠકુરાણી ઘાટ, ગોકુળ, જીલ્લો મથુરા (ઉ. પ્ર.)',
      contacts: [
        {'name': 'મંદિર કાર્યાલય', 'phone': '9897000000'},
      ],
      mahatmy: 'ઠકુરાણી ઘાટ ઉપર આવેલી પવિત્ર બેઠકજીનો મહિમા.',
      directions: 'ગોકુળ સ્થિત ઠકુરાણી ઘાટ પાસે.',
      rules: ['ઝારીજી ભરવા માટે યોગ્ય નિયમોનું પાલન કરવું.'],
    ),
    BethakjiModel(
      id: '3',
      number: '૦૩',
      name: 'શ્રીમદ ગોકુળ ત્રીજી બેઠક - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'ગોકુળ, મથુરા',
      contacts: [],
      mahatmy: 'શ્રીમદ ગોકુળ ત્રીજી બેઠક મહાત્મ્ય',
      directions: 'ગોકુળ, મથુરા',
      rules: [],
    ),
    BethakjiModel(
      id: '4',
      number: '૦૪',
      name: 'બંસીબટ (વૃંદાવન) - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'બંસીબટ, વૃંદાવન',
      contacts: [],
      mahatmy: 'બંસીબટ કથા અને મહાત્મ્ય',
      directions: 'વૃંદાવન',
      rules: [],
    ),
    BethakjiModel(
      id: '5',
      number: '૦૫',
      name: 'વિશ્રામઘાટ - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'વિશ્રામઘાટ, મથુરા',
      contacts: [],
      mahatmy: 'મથુરા વિશ્રામઘાટ સ્થાન',
      directions: 'મથુરા',
      rules: [],
    ),
  ];

  List<BethakjiModel> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = _allBethakjiList;
  }

  void _filterBethakji(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredList = _allBethakjiList;
      } else {
        _filteredList = _allBethakjiList
            .where((item) =>
                item.name.toLowerCase().contains(query.toLowerCase()) ||
                item.number.contains(query) ||
                item.address.toLowerCase().contains(query.toLowerCase()))
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
          l10n.grid_bethakji_list,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH BAR CONTAINER
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
                          icon: Icon(Icons.clear, color: theme.colorScheme.onPrimary),
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

            // BETHAKJI LIST VIEW
            Expanded(
              child: _filteredList.isEmpty
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
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
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
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            "(${bethak.number}) ${bethak.name.replaceFirst('(${bethak.number}) ', '')}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
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
}