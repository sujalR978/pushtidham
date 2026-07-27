import 'package:pushtidham/model/bethakji_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'bethakji_yadi');

    // SQL for creating a simple table; adjust columns as needed
    const String sql = '''
    CREATE TABLE bethakji(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bethak_no INTEGER NOT NULL,
  title TEXT NOT NULL,
  is_favorite INTEGER DEFAULT 0
)
    ''';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(sql);

        await db.insert('bethakji', {
          'bethak_no': 1,
          'title': 'શ્રીમદ ગોકુલ પહેલી બેઠક - શ્રી મહાપ્રભુજી બેઠકજી',
          'is_favorite': 0,
        });

        await db.insert('bethakji', {
          'bethak_no': 2,
          'title': 'શ્રીમદ ગોકુલ બીજી બેઠક - શ્રી મહાપ્રભુજી બેઠકજી',
          'is_favorite': 0,
        });

      
      },
    );
  }

  Future<int> insertBethakji(Bethakji bethakji) async {
    final db = await database;

    return await db.insert(
      'bethakji',
      bethakji.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllBethakji() async {
    final db = await database;

    return await db.query('bethakji');
  }
}
