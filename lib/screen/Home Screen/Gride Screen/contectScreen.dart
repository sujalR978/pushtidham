import 'dart:ui';

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
    // Add haptic feedback on tap
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
          content: const Text("Thank you! Your message has been sent."),
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
          const SnackBar(content: Text('Could not open Mail application.')),
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
        SnackBar(content: Text('Error launching email client: $e')),
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
        backgroundColor: Colors.transparent,
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
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Intro
                _buildHeader(theme, l10n),
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
                // Interactive Contact Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Input Field
                      _buildGlassmorphicTextField(
                        theme: theme,
                        controller: _nameController,
                        hint: "Enter your name",
                        icon: Icons.person_outline_rounded,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "Please enter your name."
                                : null,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "Please enter your name"
                          : null,
                    ),
                    const SizedBox(height: 16),
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
                      // Email Input Field
                      _buildGlassmorphicTextField(
                        theme: theme,
                        controller: _emailController,
                        hint: "Enter your email",
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your email.";
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value.trim())) {
                            return "Please enter a valid email.";
                          }
                          return null;
                        },
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
                      const SizedBox(height: 16),

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
                      // Message Input Area
                      _buildGlassmorphicTextField(
                        theme: theme,
                        controller: _messageController,
                        hint: "Your message...",
                        icon: Icons.chat_bubble_outline_rounded,
                        maxLines: 5,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "Please enter a message."
                                : null,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "Please enter a message"
                          : null,
                    ),
                    const SizedBox(height: 40),
                      const SizedBox(height: 32),

                    // Submit Action Button (Solid single color)
                    _buildSubmitButton(theme, l10n),
                  ],
                      // Submit Button
                      _buildSubmitButton(theme, l10n),
                    ],
                  ),
                ),
              ),
            ],
              ],
            ),
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
  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.15),
              color: theme.colorScheme.onPrimary.withOpacity(0.15),
              border: Border.all(
                  color: theme.colorScheme.onPrimary.withOpacity(0.3)),
            ),
            child: Icon(
              Icons
                  .volunteer_activism_rounded, // Gives a welcoming, service-oriented vibe
              color: theme.colorScheme.primary,
              size: 36,
            ),
            child: Icon(Icons.connect_without_contact_rounded,
                color: theme.colorScheme.onPrimary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            "Get in Touch",
            style: TextStyle(
              fontSize: 20,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "We are here to assist you on your spiritual journey.",
            "We'd love to hear from you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
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
  Widget _buildGlassmorphicTextField({
    required ThemeData theme,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: theme.colorScheme.onSurface),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            prefixIcon:
                Icon(icon, color: theme.colorScheme.primary.withOpacity(0.8)),
            filled: true,
            fillColor: theme.cardTheme.color?.withOpacity(0.5),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: theme.colorScheme.onSurface.withOpacity(0.1)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: theme.colorScheme.error, width: 1.5),
            ),
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
    return Container(
      width: double.infinity,
      height: 56, // Taller for better touch target
      child: FilledButton.icon(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // Solid Color
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: const Icon(Icons.send_rounded, size: 22),
        label: Text(
          l10n.btn_submit,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, size: 20),
            const SizedBox(width: 10),
            Text(
              l10n.btn_submit,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
