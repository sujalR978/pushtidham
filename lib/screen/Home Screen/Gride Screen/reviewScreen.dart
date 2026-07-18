import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  
  // Quick pre-defined feedback chips in Gujarati and English
  final List<String> _quickFeedbackTags = [
    "જય શ્રી કૃષ્ણ 🙏",
    "ખૂબ સુંદર એપ",
    "શ્રી કૃષ્ણઃ શરણં મમ",
    "Beautiful UI",
    "Peaceful App",
    "Very Useful",
  ];
  
  String? _selectedTag;

  void _submitReview() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("કૃપા કરીને રેટિંગ પસંદ કરો (Please select a rating)"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Success response handling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("તમારો અભિપ્રાય સબમિટ કરવા બદલ આભાર! 🙏"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    // Resetting inputs after submit
    setState(() {
      _selectedRating = 0;
      _reviewController.clear();
      _selectedTag = null;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("અભિપ્રાય (Review)", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Visual Card: Rating Summary Overview
              Card(
                color: theme.cardTheme.color,
                elevation: theme.cardTheme.elevation ?? 2,
                shape: theme.cardTheme.shape,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "તમારો અનુભવ કેવો રહ્યો?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "How is your experience with Pustidham?",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Interactive Star Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          int starValue = index + 1;
                          return IconButton(
                            icon: Icon(
                              starValue <= _selectedRating ? Icons.star : Icons.star_border,
                              size: 40,
                            ),
                            color: starValue <= _selectedRating 
                                ? const Color(0xFFF1C40F) // Vibrant Golden Star Color
                                : theme.colorScheme.onSurface.withOpacity(0.3),
                            onPressed: () {
                              setState(() {
                                _selectedRating = starValue;
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section: Quick Recommendation Suggestion Chips
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ઝડપી પ્રતિસાદ (Quick Tags)",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _quickFeedbackTags.map((tag) {
                  final isSelected = _selectedTag == tag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    backgroundColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.15),
                    ),
                    onSelected: (selected) {
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
              ),
              const SizedBox(height: 24),

              // Section: Textarea Input Form Block
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "તમારો વિગતવાર સંદેશ લખો (Detailed Review)",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: "અહીં તમારો કિંમતી અભિપ્રાય લખો (Type your feedback here...)",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  filled: true,
                  fillColor: theme.cardTheme.color,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Action Button Stack
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "સબમિટ કરો (Submit Feedback)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}