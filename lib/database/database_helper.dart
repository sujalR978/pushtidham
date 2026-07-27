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
    String path = join(await getDatabasesPath(), 'bethakji_yadi.db');

    const String sql = '''
    CREATE TABLE bethakji (
      id TEXT PRIMARY KEY,
      number TEXT,
      name TEXT NOT NULL,
      address TEXT,
      contacts TEXT,
      mahatmy TEXT,
      directions TEXT,
      rules TEXT
    )
    ''';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 1. Create the table
        await db.execute(sql);

        // 2. Define Sample Data 1
        BethakjiModel sample1 = BethakjiModel(
          id: '1',
          number: '1',
          name: 'શ્રીમદ ગોકુલ પહેલી બેઠક - શ્રી મહાપ્રભુજી',
          address: 'ગોકુલ, મથુરા, ઉત્તર પ્રદેશ',
          contacts: [
            {'label': 'મુખ્યાજી', 'phone': '+91 9876543210'},
            {'label': 'મંદિર ઓફિસ', 'phone': '+91 9123456789'},
          ],
          mahatmy:
              'આ શ્રી મહાપ્રભુજીની પ્રથમ બેઠકજી છે જ્યા શ્રીમદ ભાગવત પરાયણ કરેલ.',
          directions: 'ગોવિંદ ઘાટ પાસે, ગોકુલ',
          rules: ['મંદિરમાં શાંતિ જાળવવી', 'પરંપરાગત વસ્ત્રો પહેરવા'],
        );

        // 3. Define Sample Data 2
        BethakjiModel sample2 = BethakjiModel(
          id: '2',
          number: '2',
          name: 'શ્રીમદ ગોકુલ બીજી બેઠક - બડી ભીતર',
          address: 'ગોકુલ, ઉત્તર પ્રદેશ',
          contacts: [
            {'label': 'ટ્રસ્ટ ઓફિસ', 'phone': '+91 9998887770'},
          ],
          mahatmy: 'આ શ્રી મહાપ્રભુજીની બીજી બેઠકજી છે.',
          directions: 'બડી ભીતર વિસ્તારમાં સ્થિત',
          rules: ['કેમેરા અને મોબાઈલ ઉપયોગ નિષેધ છે'],
        );

        // 4. Insert sample data into database using .toMap()
        await db.insert('bethakji', sample1.toMap());
        await db.insert('bethakji', sample2.toMap());
      },
    );
  }

  // Fetch all records
  Future<List<BethakjiModel>> getAllBethakji() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bethakji');

    return List.generate(maps.length, (i) {
      return BethakjiModel.fromMap(maps[i]);
    });
  }

  // Insert or update individual item
  Future<int> insertBethakji(BethakjiModel bethakji) async {
    final db = await database;
    return await db.insert(
      'bethakji',
      bethakji.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
