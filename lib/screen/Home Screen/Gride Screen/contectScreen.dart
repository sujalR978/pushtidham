import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final userEmail = _emailController.text.trim();
      final message = _messageController.text.trim();

      await _sendViaMailApp(name: name, userEmail: userEmail, message: message);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.btn_submit),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
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
          const SnackBar(content: Text('Could not open Mail application.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.grid_contact,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Intro Banner
              Card(
                color: theme.cardTheme.color,
                elevation: theme.cardTheme.elevation ?? 2,
                shape: theme.cardTheme.shape,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          Icons.mail_outline_rounded,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.grid_contact,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.welcome_tagline,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Interactive Contact Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Input Field
                    TextFormField(
                      controller: _nameController,

                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: _buildInputDecoration(
                        theme,
                        "Enter name",
                        Icons.person_outline,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.grid_contact
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        theme,
                        "Enter email...",
                        Icons.mail_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.grid_contact;
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value.trim())) {
                          return l10n.grid_contact;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Message Input Area
                    TextFormField(
                      controller: _messageController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      maxLines: 5,
                      decoration: _buildInputDecoration(
                        theme,
                        "message",
                        Icons.chat_bubble_outline,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.grid_contact
                          : null,
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send_rounded, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              l10n.btn_submit,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
      filled: true,
      fillColor: theme.cardTheme.color,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.12),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
    );
  }
}
