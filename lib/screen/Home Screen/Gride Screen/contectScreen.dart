import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// IMPORTANT: Uncomment this to enable your custom sounds!
// import 'package:pushtidham/services/sound_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Target email address where user inquiries will be sent
  final String _destinationEmail = 'srashiya955@rku.ac.in';
  final String _contactPhone = '+910000000000'; // Replace with real number

  Future<void> _submitForm() async {
    HapticFeedback.lightImpact();
    // SoundService().playClick();

    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final userEmail = _emailController.text.trim();
      final message = _messageController.text.trim();

      await _sendViaMailApp(name: name, userEmail: userEmail, message: message);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text("Message sent successfully! 🙏"),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } else {
      HapticFeedback.vibrate();
    }
  }

  Future<void> _sendViaMailApp({
    required String name,
    required String userEmail,
    required String message,
  }) async {
    final String subject = 'App Inquiry from $name';
    final String body =
        '''
User Contact Details:
---------------------------------
Name: $name
Email: $userEmail

Message / Inquiry:
$message
---------------------------------
''';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _destinationEmail,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    _launchAction(emailLaunchUri);
  }

  // Generic launcher for Phone, Email, etc.
  Future<void> _launchAction(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        _showErrorToast('Could not launch application.');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorToast('Error launching client: $e');
    }
  }

  void _showErrorToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
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
          l10n.grid_contact,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Beautiful Header with Soft Background Pattern
              _buildHeroHeader(theme, l10n),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Quick Connect Grid
                    Text(
                      "Quick Connect",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            theme,
                            icon: Icons.phone_in_talk_rounded,
                            label: "Call Us",
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _launchAction(
                                Uri(scheme: 'tel', path: _contactPhone),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            theme,
                            icon: Icons.mail_outline_rounded,
                            label: "Email",
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _launchAction(
                                Uri(scheme: 'mailto', path: _destinationEmail),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            theme,
                            icon: Icons.location_on_outlined,
                            label: "Visit",
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Add Google Maps link or location info here
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // 3. Main Contact Form Wrapped in a unified Card
                    Text(
                      "Send a Message",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormContainer(theme, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UPGRADED WIDGETS ---

  Widget _buildHeroHeader(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              size: 42,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "We're here for you",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Have questions about the app, Kirtans, or paths? Reach out to us anytime.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContainer(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              textInputAction: TextInputAction.next,
              decoration: _buildInputDecoration(
                theme,
                "Your Name",
                Icons.badge_outlined,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Name is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _buildInputDecoration(
                theme,
                "Email Address",
                Icons.mail_outline_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Email is required";
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value.trim())) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              maxLines: 4,
              textInputAction: TextInputAction.done,
              decoration: _buildInputDecoration(
                theme,
                "How can we help?",
                Icons.chat_bubble_outline_rounded,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Please write a message"
                  : null,
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(theme, l10n),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    ThemeData theme,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withOpacity(0.4),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: theme.colorScheme.primary.withOpacity(0.6),
        size: 20,
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.error.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: _submitForm,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.send_rounded, size: 20),
        label: Text(
          l10n.btn_submit,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
