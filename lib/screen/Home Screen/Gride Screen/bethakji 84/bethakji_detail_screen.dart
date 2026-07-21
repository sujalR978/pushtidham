import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/screen/Home%20Screen/Gride%20Screen/bethakji%2084/bethakji_list_screen.dart';

class BethakjiDetailPage extends StatelessWidget {
  final BethakjiModel bethak;

  const BethakjiDetailPage({super.key, required this.bethak});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Title Header Card
              _buildHeaderCard(theme, "(${bethak.number}) ${bethak.name}"),

              // 1. Address Section
              const SizedBox(height: 12),
              _buildSectionHeader(theme, "સરનામું"),
              _buildContentCard(
                theme,
                child: Text(
                  bethak.address,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),

              // 2. Contacts Section
              if (bethak.contacts.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildSectionHeader(theme, "સંપર્ક (ફોન / મોબાઇલ)"),
                _buildContentCard(
                  theme,
                  child: Column(
                    children: bethak.contacts.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final contact = entry.value;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${contact['name']}  ${contact['phone']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.phone,
                                    color: theme.colorScheme.primary),
                                onPressed: () {
                                  // Call logic
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.chat_bubble_outline,
                                    color: theme.colorScheme.primary),
                                onPressed: () {
                                  // Message logic
                                },
                              ),
                            ],
                          ),
                          if (idx < bethak.contacts.length - 1)
                            const Divider(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],

              // 3. Mahatmy Section
              if (bethak.mahatmy.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildSectionHeader(theme, "બેઠકજીનું મહાત્મ્ય"),
                _buildContentCard(
                  theme,
                  child: Text(
                    bethak.mahatmy,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],

              // 4. Directions Section
              if (bethak.directions.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildSectionHeader(theme, "બેઠકજી જવા માટે માર્ગદર્શન"),
                _buildContentCard(
                  theme,
                  child: Text(
                    bethak.directions,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],

              // 5. Rules Section
              if (bethak.rules.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildSectionHeader(theme, "ઝારીજી ભરવા માટે ના નિયમો"),
                _buildContentCard(
                  theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bethak.rules.map((rule) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "* $rule",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300, width: 1.5),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentCard(ThemeData theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300, width: 1.5),
      ),
      child: child,
    );
  }
}
