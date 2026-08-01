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

  Future<void> _submitForm() async {
    // Add haptic and custom sound feedback on tap
    HapticFeedback.lightImpact();
    // SoundService().playClick(); // Play custom click sound

    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final userEmail = _emailController.text.trim();
      final message = _messageController.text.trim();

      await _sendViaMailApp(name: name, userEmail: userEmail, message: message);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Message sent successfully! 🙏"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } else {
      // Error feedback if form is invalid
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

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open Mail application.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching email client: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
      backgroundColor: theme.scaffoldBackgroundColor, // Native theme support
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Visual: Spiritual Header Card (Matches Review Page)
              _buildContactHeaderCard(theme, l10n),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: User Details
                    _buildSectionHeader(
                      theme,
                      "Your Details",
                      Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Name Input
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: _buildInputDecoration(
                        theme,
                        "Enter your name",
                        Icons.badge_outlined,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "Please enter your name"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        theme,
                        "Enter your email",
                        Icons.mail_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value.trim())) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Section: Message Body
                    _buildSectionHeader(
                      theme,
                      "Your Message",
                      Icons.edit_note_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Message Input Area
                    TextFormField(
                      controller: _messageController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      maxLines: 5,
                      decoration: _buildInputDecoration(
                        theme,
                        "How can we help you?",
                        Icons.chat_bubble_outline_rounded,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "Please enter a message"
                          : null,
                    ),
                    const SizedBox(height: 40),

                    // Submit Action Button (Solid single color)
                    _buildSubmitButton(theme, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Spiritual Header Card matching the Review Page's Rating Card
  Widget _buildContactHeaderCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.15),
            ),
            child: Icon(
              Icons
                  .volunteer_activism_rounded, // Gives a welcoming, service-oriented vibe
              color: theme.colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Get in Touch",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "We are here to assist you on your spiritual journey.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "॥ ${l10n.welcome_tagline} ॥",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // Modern Input Decoration mimicking the Review Page text area
  InputDecoration _buildInputDecoration(
    ThemeData theme,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
      filled: true,
      // Uses a soft color mapping that looks perfect on Day, Night, and Mandir themes
      fillColor: theme.colorScheme.primary.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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

  // Modern, Single-Color Submit Button matching Review Page
  Widget _buildSubmitButton(ThemeData theme, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56, // Taller for better touch target
      child: FilledButton.icon(
        onPressed: _submitForm,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // Solid Color
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.send_rounded, size: 22),
        label: Text(
          l10n.btn_submit,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
