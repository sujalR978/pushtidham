import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// IMPORTANT: Make sure this path points to where you created your SoundService!
// import 'package:pushtidham/services/sound_service.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  // Expanded Quick Feedback Tags for a better UX
  final List<String> _quickFeedbackTags = [
    "જય શ્રી કૃષ્ણ 🙏",
    "ખૂબ સુંદર એપ",
    "શ્રી કૃષ્ણઃ શરણં મમ",
    "Beautiful UI ✨",
    "Peaceful App 🪔",
    "Very Useful",
    "Divine Experience 🌺",
    "Great for daily Path 📖",
    "More Kirtans please 🎵",
    "Smooth & Fast ⚡",
  ];

  String? _selectedTag;

  // Change this to your target email address where you want to receive feedback
  final String _destinationEmail = 'srashiya955@rku.ac.in';

  Future<void> _submitReview() async {
    // Add haptic and custom sound feedback on tap
    HapticFeedback.lightImpact();
    // SoundService().playClick(); // Play custom click sound

    final l10n = AppLocalizations.of(context)!;

    // Check if user has provided at least a rating or text feedback
    if (_selectedRating == 0 && _reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please provide a rating or write a review."),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Launch email client with current user entries
    await _sendViaMailApp(
      rating: _selectedRating,
      selectedTag: _selectedTag,
      message: _reviewController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Thank you for your feedback! 🙏"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Reset UI state after launching
    setState(() {
      _selectedRating = 0;
      _reviewController.clear();
      _selectedTag = null;
    });
  }

  Future<void> _sendViaMailApp({
    required int rating,
    required String? selectedTag,
    required String message,
  }) async {
    final String starRatingText = rating > 0
        ? '$rating / 5 Stars ⭐'
        : 'Not Rated';
    final String tagText = selectedTag != null
        ? 'Tag: $selectedTag'
        : 'No Tag Selected';

    final String subject = 'Pushtidham App Review ($starRatingText)';
    final String body =
        '''
App Review & Feedback:
---------------------------------
Rating: $starRatingText
$tagText

User Message:
${message.isNotEmpty ? message : 'No additional text provided.'}
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
    _reviewController.dispose();
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
          l10n.grid_review,
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
              // Top Visual: Clean Card-based Rating Header
              _buildRatingCard(theme, l10n),
              const SizedBox(height: 32),

              // Section: Quick Recommendation Suggestion Chips
              _buildSectionHeader(theme, "Quick Feedback", Icons.bolt_rounded),
              const SizedBox(height: 16),
              _buildFeedbackChips(theme),
              const SizedBox(height: 32),

              // Section: Textarea Input Form Block
              _buildSectionHeader(
                theme,
                "Share More Details",
                Icons.edit_note_rounded,
              ),
              const SizedBox(height: 16),
              _buildReviewTextField(theme),
              const SizedBox(height: 40),

              // Submit Action Button (Now solid single color!)
              _buildSubmitButton(theme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  // Uses Theme's Surface Container colors so it looks perfect in Day/Night/Mandir themes
  Widget _buildRatingCard(ThemeData theme, AppLocalizations l10n) {
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
              Icons.spa_rounded,
              color: theme.colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "How was your experience?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Your feedback helps us improve.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int starValue = index + 1;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // SoundService().playClick(); // Play custom click sound

                  setState(() {
                    _selectedRating = starValue;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AnimatedScale(
                    scale: starValue <= _selectedRating ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      starValue <= _selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 44,
                      color: starValue <= _selectedRating
                          ? Colors.amber.shade500
                          : theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ),
              );
            }),
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

  Widget _buildFeedbackChips(ThemeData theme) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _quickFeedbackTags.map((tag) {
        final isSelected = _selectedTag == tag;
        return ChoiceChip(
          label: Text(tag),
          selected: isSelected,
          elevation: isSelected ? 2 : 0,
          showCheckmark: false, // Cleaner look without the checkmark
          selectedColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          labelStyle: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : theme.colorScheme.onSurface.withOpacity(0.2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (selected) {
            HapticFeedback.lightImpact();
            // SoundService().playClick(); // Play custom click sound

            setState(() {
              if (selected) {
                _selectedTag = tag;
                _reviewController.text = tag;
              } else {
                _selectedTag = null;
                _reviewController.clear();
              }
            });
          },
        );
      }).toList(),
    );
  }

  // Cleaner Material 3 Text Field
  Widget _buildReviewTextField(ThemeData theme) {
    return TextField(
      controller: _reviewController,
      maxLines: 5,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: "Share your thoughts...",
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }

  // Modern, Single-Color Submit Button
  Widget _buildSubmitButton(ThemeData theme, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56, // Slightly taller for better touch target
      child: FilledButton.icon(
        onPressed: _submitReview,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // Single Solid Color!
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
