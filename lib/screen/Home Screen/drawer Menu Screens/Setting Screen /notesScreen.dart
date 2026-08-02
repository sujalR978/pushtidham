import 'package:flutter/material.dart';
import 'package:pushtidham/database/notes_database_helper.dart';
import 'package:pushtidham/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class NoteItem {
  final String id;
  final String content;
  final DateTime timestamp;

  NoteItem({required this.id, required this.content, required this.timestamp});

  // Convert a NoteItem into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert a Map from SQLite into a NoteItem
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
  bool _isLoading = true; // Added loading state
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Fetch data when screen opens
  }

  // Fetch notes from Database
  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);

    final dbNotes = await NotesDatabaseHelper.instance.getAllNotes();

    setState(() {
      _notes = dbNotes.map((json) => NoteItem.fromMap(json)).toList();
      _isLoading = false;
    });
  }

  // Add note to Database and UI
  Future<void> _addNote() async {
    if (_noteController.text.trim().isEmpty) return;

    final newNote = NoteItem(
      id: DateTime.now().toString(),
      content: _noteController.text.trim(),
      timestamp: DateTime.now(),
    );

    // Save to DB
    await NotesDatabaseHelper.instance.insertNote(newNote.toMap());

    // Update UI
    setState(() {
      _notes.insert(0, newNote);
    });

    _noteController.clear();
    FocusScope.of(context).unfocus(); // Close the virtual keyboard

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Note saved!"),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Delete note from Database and UI
  Future<void> _deleteNote(int index) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final noteToDelete = _notes[index];

    // Update UI first for responsiveness
    setState(() {
      _notes.removeAt(index);
    });

    // Remove from DB
    await NotesDatabaseHelper.instance.deleteNote(noteToDelete.id);

    // Show confirmation with Undo
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Note Deleted"),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: l10n.btn_undo.toUpperCase(),
            onPressed: () {
              _undoDelete(index, noteToDelete);
            },
          ),
        ),
      );
    }
  }

  // Handle the "Undo" action
  Future<void> _undoDelete(int index, NoteItem note) async {
    // Re-insert into DB
    await NotesDatabaseHelper.instance.insertNote(note.toMap());
    // Re-insert into UI at the original position
    setState(() {
      _notes.insert(index, note);
    });
  }

  String _formatDate(DateTime dt) {
    return DateFormat.yMMMd().add_jm().format(dt); // e.g., Jul 28, 2024 5:30 PM
  }

  @override
  void dispose() {
    _noteController.dispose();
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP INPUT PANEL
            Container(
              padding: const EdgeInsets.all(16.0),
              color: theme.colorScheme.primary.withOpacity(0.04),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: l10n.nav_notes,
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: theme.cardTheme.color,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: theme.colorScheme.onSurface.withOpacity(
                              0.15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _addNote,
                    ),
                  ),
                ],
              ),
            ),

            // 2. ACTIVE NOTES LIST VIEW
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : _notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_stories_outlined,
                            size: 80,
                            color: theme.colorScheme.primary.withOpacity(0.4),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Your thoughts are sacred.\nJot them down here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Dismissible(
                            key: ValueKey(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.error.withOpacity(0.75),
                                    theme.colorScheme.error,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) => _deleteNote(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 4,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadowColor.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.content,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        _formatDate(note.timestamp),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
