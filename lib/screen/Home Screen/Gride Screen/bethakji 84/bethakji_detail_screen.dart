import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/bethakji_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BethakjiDetailPage extends StatelessWidget {
  final BethakjiModel bethak;

  const BethakjiDetailPage({super.key, required this.bethak});

  Future<void> _makePhoneCall(dynamic rawContact) async {
    HapticFeedback.lightImpact();
    String phoneNumber = _extractPhoneNumber(rawContact);
    if (phoneNumber.isEmpty) return;

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch phone dialer for $phoneNumber');
    }
  }

  Future<void> _sendSms(dynamic rawContact, {String? body}) async {
    HapticFeedback.lightImpact();
    String phoneNumber = _extractPhoneNumber(rawContact);
    if (phoneNumber.isEmpty) return;

    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: body != null ? <String, String>{'body': body} : null,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch SMS app for $phoneNumber');
    }
  }

  String _extractPhoneNumber(dynamic rawContact) {
    String phoneNumber = '';
    if (rawContact is Map) {
      phoneNumber = (rawContact['phone'] ?? rawContact['number'] ?? '')
          .toString();
    } else {
      phoneNumber = rawContact.toString();
    }
    // Remove spaces, dashes, or formatting chars, leaving only digits and +
    return phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Beautiful Hero Header
              _buildHeroHeader(theme),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    // 2. Unified Location & Contact Hub
                    _buildLocationAndContactHub(theme),

                    // 3. Mahatmy (Glory/Story) Section
                    if (bethak.mahatmy.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSpiritualSection(
                        theme: theme,
                        title: "બેઠકજીનું મહાત્મ્ય",
                        icon: Icons.menu_book_rounded,
                        content: Text(
                          bethak.mahatmy,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: theme.colorScheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],

                    // 4. Directions Section
                    if (bethak.directions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSpiritualSection(
                        theme: theme,
                        title: "માર્ગદર્શન (Directions)",
                        icon: Icons.directions_walk_rounded,
                        content: Text(
                          bethak.directions,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: theme.colorScheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],

                    // 5. Rules Section with Custom Bullet Points
                    if (bethak.rules.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSpiritualSection(
                        theme: theme,
                        title: "ઝારીજી ભરવા માટેના નિયમો",
                        icon: Icons.front_hand_rounded,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bethak.rules.map((rule) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                      right: 12.0,
                                    ),
                                    child: Icon(
                                      Icons
                                          .spa_rounded, // Beautiful spiritual bullet point
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      rule,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UPGRADED UI COMPONENTS ---

  Widget _buildHeroHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Bethakji Number Badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              "${bethak.number}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Bethakji Name
          Text(
            bethak.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // Combines Address and Contacts into one interactive premium card
  Widget _buildLocationAndContactHub(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "સરનામું",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bethak.address,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contacts Section
          if (bethak.contacts.isNotEmpty) ...[
            Divider(
              height: 1,
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "સંપર્ક કરો (Contact)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...bethak.contacts.map((dynamic contact) {
                    final String phoneNumber = contact is Map
                        ? (contact['phone'] ?? contact['number'] ?? '').toString()
                        : contact.toString();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              phoneNumber,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          // Premium Action Buttons
                          Row(
                            children: [
                              _buildActionButton(
                                theme: theme,
                                icon: Icons.chat_bubble_rounded,
                                onTap: () => _sendSms(
                                  contact,
                                  body: "જય શ્રી કૃષ્ણ, ${bethak.name}",
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildActionButton(
                                theme: theme,
                                icon: Icons.phone_rounded,
                                isPrimary: true,
                                onTap: () => _makePhoneCall(contact),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Universal Content Section Builder
  Widget _buildSpiritualSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: content,
        ),
      ],
    );
  }

  // Custom rounded action button for Phone and SMS
  Widget _buildActionButton({
    required ThemeData theme,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
