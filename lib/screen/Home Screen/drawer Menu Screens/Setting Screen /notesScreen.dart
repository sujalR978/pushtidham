import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart'; // Optional: Add this package to pubspec.yaml for sharing!
import 'package:pushtidham/database/notes_database_helper.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

// import 'package:pushtidham/services/sound_service.dart'; // Custom sounds

class NoteItem {
  final String id;
  final String content;
  final DateTime timestamp;

  NoteItem({required this.id, required this.content, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NoteItem.fromMap(Map<String, dynamic> map) {
    return NoteItem(
      id: map['id'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<NoteItem> _notes = [];
  String _searchQuery = ""; // New: Search feature
  bool _isLoading = true;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // New: Pastel colors for beautiful sticky-note vibes
  final List<Color> _cardColors = [
    const Color(0xFFFDE68A).withOpacity(0.3), // Soft Yellow
    const Color(0xFFA7F3D0).withOpacity(0.3), // Soft Green
    const Color(0xFFBFDBFE).withOpacity(0.3), // Soft Blue
    const Color(0xFFFBCFE8).withOpacity(0.3), // Soft Pink
    const Color(0xFFE9D5FF).withOpacity(0.3), // Soft Purple
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();

    // Listen for input to update the send button color
    _noteController.addListener(() => setState(() {}));
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      final dbNotes = await NotesDatabaseHelper.instance.getAllNotes();
      setState(() {
        _notes = dbNotes.map((json) => NoteItem.fromMap(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      // Failsafe in case DB isn't ready
      setState(() => _isLoading = false);
    }
  }

  // FIXED Add Note Function
  Future<void> _addNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    // SoundService().playClick();

    final l10n = AppLocalizations.of(context)!;

    final newNote = NoteItem(
      id: DateTime.now().toString(),
      content: text,
      timestamp: DateTime.now(),
    );

    // Save to DB
    await NotesDatabaseHelper.instance.insertNote(newNote.toMap());

    // Update UI
    setState(() {
      _notes.insert(0, newNote);
      _searchQuery = ""; // Reset search if adding a new note
      _searchController.clear();
    });

    _noteController.clear();
    FocusScope.of(context).unfocus(); // Hides keyboard

    _showToast("Note Saved!", Icons.check_circle_outline);
  }

  Future<void> _deleteNote(int index) async {
    HapticFeedback.mediumImpact();

    final noteId = _filteredNotes[index].id;

    await NotesDatabaseHelper.instance.deleteNote(noteId);

    setState(() {
      _notes.removeWhere((n) => n.id == noteId);
    });

    _showToast("Note deleted", Icons.delete_outline_rounded);
  }

  Future<void> _copyToClipboard(String content) async {
    HapticFeedback.lightImpact();
    await Clipboard.setData(ClipboardData(text: content));
    _showToast("Copied to clipboard", Icons.copy_rounded);
  }

  void _showToast(String message, IconData icon) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

    // Check if it's today
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return "Today • $time";
    }
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  // New: Getter for filtered notes based on search
  List<NoteItem> get _filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    return _notes
        .where(
          (n) => n.content.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _searchController.dispose();
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
          l10n.nav_notes,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // NEW FEATURE: Search Bar
            _buildSearchBar(theme),

            // 1. DYNAMIC NOTES LIST
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : _filteredNotes.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      itemCount: _filteredNotes.length,
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                        bottom: 24,
                      ),
                      itemBuilder: (context, index) {
                        return _buildNoteCard(
                          theme,
                          _filteredNotes[index],
                          index,
                        );
                      },
                    ),
            ),

            // 2. FIXED: Modern Bottom Input Bar
            _buildBottomInputArea(theme),
          ],
        ),
      ),
    );
  }

  // --- UPGRADED WIDGETS ---

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search notes...",
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = "");
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _searchQuery.isNotEmpty
                    ? Icons.search_off_rounded
                    : Icons.menu_book_rounded,
                size: 64,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isNotEmpty ? "No results found" : "No Notes Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? "Try searching with a different keyword."
                  : "Write down your spiritual thoughts, saved Kirtans, or daily reflections here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(ThemeData theme, NoteItem note, int index) {
    // Pick a pastel color based on the index to make the list look vibrant
    final cardColor = _cardColors[index % _cardColors.length];

    return Padding(
      key: Key(note.id),
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(note.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.delete_sweep_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        onDismissed: (direction) => _deleteNote(index),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.brightness == Brightness.dark
                ? theme
                      .colorScheme
                      .surface // Keep dark theme subtle
                : cardColor, // Show pastel colors in light themes
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(note.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.push_pin_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Copy Button
                    IconButton(
                      onPressed: () => _copyToClipboard(note.content),
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    // Optional: Share Button (Will just copy if you don't use share_plus package)
                    IconButton(
                      onPressed: () => _copyToClipboard(note.content),
                      icon: Icon(
                        Icons.share_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FIXED: The Send button is now a suffixIcon inside the TextField itself!
  Widget _buildBottomInputArea(ThemeData theme) {
    final isTyping = _noteController.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom
            : 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: TextField(
        controller: _noteController,
        style: TextStyle(color: theme.colorScheme.onSurface),
        maxLines: 4,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: "Write a new note...",
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
            fontSize: 15,
          ),
          filled: true,
          fillColor: theme.colorScheme.primary.withOpacity(0.05),
          contentPadding: const EdgeInsets.only(
            left: 20,
            right: 8,
            top: 14,
            bottom: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.5),
              width: 1,
            ),
          ),

          // THE FIX: Moving the button inside the TextField ensures it is ALWAYS tappable
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isTyping
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_upward_rounded,
                  color: isTyping
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withOpacity(0.4),
                  size: 20,
                ),
                onPressed: isTyping ? _addNote : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
