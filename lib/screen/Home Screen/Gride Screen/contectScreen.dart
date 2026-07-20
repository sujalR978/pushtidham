import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

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

  void _submitForm() {
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
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
        title: Text(l10n.grid_contact, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              // 1. QUICK CONTACT CARD
              Card(
                color: theme.cardTheme.color,
                elevation: theme.cardTheme.elevation ?? 2,
                shape: theme.cardTheme.shape,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildContactMethodTile(
                        context,
                        icon: Icons.phone_in_talk,
                        title: l10n.grid_contact,
                        subtitle: "+91 98765 43210",
                        onTap: () {
                          // Integrate url_launcher to dial phone numbers
                        },
                      ),
                      const Divider(height: 20),
                      _buildContactMethodTile(
                        context,
                        icon: Icons.email_outlined,
                        title: l10n.grid_contact,
                        subtitle: "info@pushtidham.org",
                        onTap: () {
                          // Integrate url_launcher to open email client
                        },
                      ),
                      const Divider(height: 20),
                      _buildContactMethodTile(
                        context,
                        icon: Icons.location_on_outlined,
                        title: l10n.grid_contact,
                        subtitle: "શ્રી હરિરાયજી મહાપ્રભુજી ગાદી, ગુજરાત, ભારત",
                        onTap: () {
                          // Open address inside maps app
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // 2. INTERACTIVE CONTACT FORM
              Text(
                l10n.grid_contact,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: _buildInputDecoration(theme, l10n.grid_contact, Icons.person_outline),
                      validator: (value) => value!.isEmpty ? l10n.grid_contact : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(theme, l10n.grid_contact, Icons.mail_outline),
                      validator: (value) {
                        if (value!.isEmpty) return l10n.grid_contact;
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return l10n.grid_contact;
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _messageController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      maxLines: 4,
                      decoration: _buildInputDecoration(theme, l10n.grid_contact, Icons.chat_bubble_outline),
                      validator: (value) => value!.isEmpty ? l10n.grid_contact : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 2,
                        ),
                        child: Text(l10n.btn_submit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildContactMethodTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.3)),
      onTap: onTap,
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme, String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
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
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12)),
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