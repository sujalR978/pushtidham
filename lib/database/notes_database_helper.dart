import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// Adjust import based on your structure

class NotesDatabaseHelper {
  static final NotesDatabaseHelper instance = NotesDatabaseHelper._init();
  static Database? _database;

  NotesDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE notes (
  id $idType,
  content $textType,
  timestamp $textType
)
''');
  }

  // Insert a Note
  Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await instance.database;
    await db.insert('notes', note, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch all Notes (ordered by newest first)
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await instance.database;
    return await db.query('notes', orderBy: 'timestamp DESC');
  }

  // Delete a Note
  Future<void> deleteNote(String id) async {
    final db = await instance.database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}