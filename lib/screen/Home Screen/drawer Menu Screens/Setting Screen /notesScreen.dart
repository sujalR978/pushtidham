import 'package:flutter/material.dart';
import 'package:pushtidham/l10n/app_localizations.dart';

class NoteItem {
  final String id;
  final String content;
  final DateTime timestamp;

  NoteItem({required this.id, required this.content, required this.timestamp});
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<NoteItem> _notes = [
    NoteItem(
      id: '1',
      content:
          'શ્રી મહાપ્રભુજીના ઉત્સવ સંબંધી વિશેષ નિયમો અને પાઠ વિધિ વાંચવી.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NoteItem(
      id: '2',
      content: 'નિયમિત સવારે જપ માળા પૂરી કર્યા બાદ જ ષોડશ ગ્રંથનું મનન કરવું.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  final TextEditingController _noteController = TextEditingController();

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _notes.insert(
        0,
        NoteItem(
          id: DateTime.now().toString(),
          content: _noteController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
    });
    _noteController.clear();
    FocusScope.of(context).unfocus(); // Close the virtual keyboard

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.btn_submit),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteNote(int index) {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _notes.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.btn_delete),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
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
                      maxLines: null, // Dynamic expanding box heights
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
              child: _notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 60,
                            color: theme.colorScheme.onSurface.withOpacity(0.2),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.nav_notes,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                              fontSize: 14,
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
                          key: Key(note.id),
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Dismissible(
                            key: Key(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete_sweep,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) => _deleteNote(index),
                            child: Card(
                              color: theme.cardTheme.color,
                              elevation: theme.cardTheme.elevation ?? 2,
                              shape: theme.cardTheme.shape,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.edit_note,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.7),
                                          size: 20,
                                        ),
                                        Text(
                                          _formatDate(note.timestamp),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      note.content,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.4,
                                        color: theme.colorScheme.onSurface,
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
