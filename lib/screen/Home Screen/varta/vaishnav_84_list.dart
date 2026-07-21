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
    VartaModel(
      id: '2',
      number: '૦૨',
      titleGujarati: 'કૃષ્ણદાસ મેઘનની વાર્તા',
      titleBraj: 'કૃષ્ણદાસ મેઘન કી વાર્તા',
      shloka: '',
      arth: '',
      vartaContent: '',
      saar: '',
    ),
    VartaModel(
      id: '3',
      number: '૦૩',
      titleGujarati: 'કનોજના દામોદરદાસ સંભલવારાની વાર્તા',
      titleBraj: 'દામોદરદાસ સંભલવાલે કી વાર્તા',
      shloka: '',
      arth: '',
      vartaContent: '',
      saar: '',
    ),
    VartaModel(
      id: '4',
      number: '૦૪',
      titleGujarati: 'કનોજીઆ બ્રાહ્મણ પદ્મનાભદાસની વાર્તા',
      titleBraj: 'પદ્મનાભદાસ કી વાર્તા',
      shloka: 'પઠનીયં પ્રયત્નેન સર્વહેતુવિવર્જિતમ્ ॥ ૧ ॥\nવૃત્યર્થ નૈવ યુંજીત પ્રાણૈઃ કંઠગતૈરપિ ।\nતદભાવે યથૈવ સ્યાત્તથા નિર્વાહમાચરેત્ ॥ ૨ ॥',
      arth: 'અથવા હંમેશ શ્રીમદ્ ભાગવત શાસ્ત્રનો પ્રયત્ન કરીને કોઈ પણ હેતુરહિત (ઈચ્છા વિના) આદરપૂર્વક પાઠ કરવો (૧) કંઠે પ્રાણ આવે તો પણ શ્રીમદ્ ભાગવતનો વૃત્તિ ( ઉદરપોષણ) ના અર્થે ઉપયોગ ન કરવો, તેના અભાવમાં જે રીતે બની શકે તે રીતે નિર્વાહ કરી લેવો.',
      vartaContent: 'આ શ્લોક પદ્મનાભદાસજીએ સાંભળ્યો. પછી પોતે દશમસ્કંધની કથા કહી તે પણ પદ્મનાભદાસે સાંભળી. જ્યારે શ્રી મહાપ્રભુજી કથા કહી રહ્યા. ત્યારે પદ્મનાભદાસે જળની અંજુલિ ભરી શ્રી મહાપ્રભુજીના આગળ સંકલ્પ કર્યો કે "આજથી કથા કહી વૃત્તિ નહિ કરું !" શ્રી મહાપ્રભુજીએ શ્રી મુખથી કહ્યું. "તમારી વૃત્તિ છે, તમે બ્રાહ્મણ છો, તેથી મહાભારત વગેરે તો કહેવાં. પણ શ્રીમદ્ ભાગવત વૃત્તિ અર્થે કહેવું નહિ. પદ્મનાભદાસે કહ્યું હવે તે સંકલ્પ કર્યો તેથી કંઈ પણ નહિ કહું. ત્યારે પોતે કહ્યું તમે તે ગ્રહસ્થ છે તેથી કેવી રીતે નિર્વાહ કરશો? પદ્મનાભદાસે કહ્યું, "મહારાજ યજમાનને ઘેરથી વૃત્તિ કરી લાવીશ તેથી નિર્વાહ કરીશ. પદ્મનાભદાસ યજમાનને ઘેર વૃત્તિ અર્થે ગયા. તેમણે બહુજ આદર કર્યો. તે પણ પદ્મનાભદાસના મનમાં વલાની આવી કે પહેલાં તો મેં કોઈ વખતે ભિક્ષા કરી નહોતી અને હવે વૈષ્ણવ થયા પછી ભિક્ષા માગવા નીકળ્યો તે બરાબર નહિ. પહેલાં તે કેવળ ઉપવિતજ ગળામાં હતી. તેથી ભિક્ષા કરવી તેતો ઉચિત હતી પણ હમણાં તે ગળામાં માળા પહેરી છે. તેથી ભિક્ષાવૃત્તિ કરવી તે બરાબર નથી. તેથી ફરી સંકલ્પ કર્યો કે ભિક્ષાવૃત્તિ કરીને પણ નિર્વાહ નહિ કરું. ત્યારે ફરીથી શ્રી આચાર્યજીએ પૂછ્યું કે હવે નિર્વાહ શી રીતે કરશો? પદ્મનાભદાસે કહ્યું "મહારાજ, વૈશ્યવૃત્તિ કરીને નિર્વાહ કરીશ. પછી કેડી વેચતા, લાકડાં લઈ આવતા. પણ બીજું કંઈ પણ રીતે પિતાનું ગુજરાન કર્યું નહિ એ પ્રમાણે દેહ રહ્યા ત્યાં સુધી નિર્વાહ કર્યો. એવા ટેકી ભગવદીય હતા.',
      saar: 'શુદ્ધ કૃપા પાત્ર જીવોને વારંવાર કહેવામાં આવતું નથી. એક વાર શ્રવણ કર્યું કે તરતજ તે કરવા ઉપર ચોટ લાગે છે. દુનિયાનાં સર્વ સુખ એક બાજુએ નષ્ટ થતાં હોય અને બીજી બાજુએ ધર્મ રહે તો ધર્મને ગ્રહણ કરી બધાં લૌકિક સુખનું ઉલ્લંઘન કરે તે જ સાચા ભગવદીયનાં લક્ષણ છે.',
    ),
    VartaModel(
      id: '5',
      number: '૦૫',
      titleGujarati: 'રજો ક્ષત્રાણીની વાર્તા',
      titleBraj: 'રજો ક્ષત્રાણી કી વાર્તા',
      shloka: '',
      arth: '',
      vartaContent: '',
      saar: '',
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