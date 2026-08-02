import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:pushtidham/model/bethakji_model.dart';
import 'package:url_launcher/url_launcher.dart';

// IMPORTANT: Uncomment this to enable your custom sounds!
// import 'package:pushtidham/services/sound_service.dart'; 

class BethakjiDetailPage extends StatelessWidget {
  final BethakjiModel bethak;

  const BethakjiDetailPage({super.key, required this.bethak});

  Future<void> _makePhoneCall(dynamic rawContact) async {
    HapticFeedback.lightImpact();
    // SoundService().playClick(); 
    
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
    // SoundService().playClick(); 
    
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
      phoneNumber = (rawContact['phone'] ?? rawContact['number'] ?? '').toString();
    } else {
      phoneNumber = rawContact.toString();
    }
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
              // 1. Upgraded Hero Header with Spiritual Watermark
              _buildHeroHeader(theme),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  children: [
                    // 2. Beautiful Address Card
                    _buildAddressCard(theme),
                    const SizedBox(height: 24),

                    // 3. Upgraded Contact Cards (Buttons now clearly visible!)
                    if (bethak.contacts.isNotEmpty) _buildContactsSection(theme, bethak.name),

                    // 4. Mahatmy (Glory/Story) Section - Scripture Style
                    if (bethak.mahatmy.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildScriptureSection(
                        theme: theme,
                        title: "બેઠકજીનું મહાત્મ્ય",
                        icon: Icons.menu_book_rounded,
                        content: bethak.mahatmy,
                      ),
                    ],

                    // 5. Directions Section - Scripture Style
                    if (bethak.directions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildScriptureSection(
                        theme: theme,
                        title: "માર્ગદર્શન (Directions)",
                        icon: Icons.explore_rounded,
                        content: bethak.directions,
                      ),
                    ],

                    // 6. Rules Section with Custom Elegant Bullet Points
                    if (bethak.rules.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildRulesSection(theme),
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
      decoration: BoxDecoration(
        // Soft gradient for a premium feel
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.6),
            theme.colorScheme.primaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Spiritual Watermark (Lotus/Temple vibe)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.spa_rounded, 
              size: 150, 
              color: theme.colorScheme.primary.withOpacity(0.05),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Column(
              children: [
                // Elegant Number Badge with gold-like accent
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.onPrimary.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Text(
                    "${bethak.number}",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Bethakji Name
                Text(
                  bethak.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    height: 1.3,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on_rounded, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "સરનામું",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  bethak.address,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsSection(ThemeData theme, String bethakName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.support_agent_rounded, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              "સંપર્ક (Contact)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...bethak.contacts.map((contact) {
          final String phoneNumber = _extractPhoneNumber(contact);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                // Phone Number Text
                Expanded(
                  child: Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                // FIXED: Highly Visible Call & SMS Buttons
                Row(
                  children: [
                    // SMS Button (Subtle Outline)
                    IconButton(
                      onPressed: () => _sendSms(contact, body: "જય શ્રી કૃષ્ણ, $bethakName"),
                      icon: const Icon(Icons.message_rounded),
                      color: theme.colorScheme.primary,
                      tooltip: "Send SMS",
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Call Button (Prominent Solid Green)
                    FilledButton.icon(
                      onPressed: () => _makePhoneCall(contact),
                      icon: const Icon(Icons.call_rounded, size: 18, color: Colors.white),
                      label: const Text(
                        "Call",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade600, // Guaranteed high visibility!
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // A special elegant layout for texts like Mahatmy and Directions
  Widget _buildScriptureSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required String content,
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Scripture Accent Line
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6, // Taller line height for easy reading
                      color: theme.colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRulesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.front_hand_rounded, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              "ઝારીજી ભરવા માટેના નિયમો",
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
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bethak.rules.map((rule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, right: 12.0),
                      child: Icon(
                        Icons.circle_rounded, // Minimal, clean bullet point
                        size: 8,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: theme.colorScheme.onSurface.withOpacity(0.9),
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
    );
  }
}