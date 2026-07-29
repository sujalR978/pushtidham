import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pushtidham/model/bethakji_model.dart'; // Ensure correct import path

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

    final List<BethakjiModel> bethakji84List = [
    // 1 to 10

    BethakjiModel(
      id: '72',
      number: '72',
      name: 'વ્યાસ આશ્રમ - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, માણા ગામ પાસે, બદ્રીનાથ (ઉત્તરાખંડ)',
      contacts: [],
      mahatmy:
          'મહર્ષિ વેદવ્યાસજી સાથે શ્રાદ્ધ અને બ્રહ્મસૂત્ર અંગે ગહન ચર્ચા કરી.',
      directions: 'ભારતના છેલ્લા ગામ "માણા" ખાતે વ્યાસ ગુફા નજીક.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '73',
      number: '73',
      name: 'ઉજ્જૈન - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, ક્ષિપ્રા નદીના ઘાટ પાસે, સાંદીપનિ આશ્રમ નજીક, ઉજ્જૈન (મ.પ્ર.)',
      contacts: ['07312500000'],
      mahatmy:
          'સાંદીપનિ આશ્રમ ક્ષેત્રમાં ક્ષિપ્રા તીરે બિરાજીને શ્રીમદ્ ભાગવત પારાયણ કર્યું.',
      directions: 'ઉજ્જૈનમાં ક્ષિપ્રા નદીના કાંઠે સાંદીપનિ આશ્રમ પાસે.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '74',
      number: '74',
      name: 'પુષ્કર - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, બ્રહ્મા ઘાટ પાસે, પુષ્કર, અજમેર (રાજસ્થાન)',
      contacts: [],
      mahatmy:
          'પવિત્ર પુષ્કર સરોવરના તીરે બિરાજીને દૈવી આત્માઓનો બ્રહ્મસંબંધ કરાવ્યો.',
      directions: 'અજમેર નજીક પુષ્કર સરોવરના બ્રહ્મા ઘાટ પાસે.',
      rules: [],
      isFavorite: 0
    ),

    BethakjiModel(
      id: '75',
      number: '75',
      name: 'કુરુક્ષેત્ર - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, બ્રહ્મ સરોવર પાસે, કુરુક્ષેત્ર (હરિયાણા)',
      contacts: [],
      mahatmy:
          'સૂર્યગ્રહણ સમયે બ્રહ્મ સરોવર પર બિરાજી ગીતાજી તથા ભાગવતજીનું વ્યાખ્યાન કર્યું.',
      directions: 'કુરુક્ષેત્રમાં બ્રહ્મ સરોવરના તીર પર.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '76',
      number: '76',
      name: 'હરિહર ક્ષેત્ર - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, ગંડક અને ગંગા સંગમ પાસે, સોનપુર (બિહાર)',
      contacts: [],
      mahatmy:
          'ગજેન્દ્ર મોક્ષના સ્થાનકે બિરાજી પ્રભુના નામ સ્મરણનો મહિમા સમજાવ્યો.',
      directions: 'હાજીપુર-સોનપુર વચ્ચે ગંડકી નદી સંગમ પાસે.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '77',
      number: '77',
      name: 'ચિત્રકૂટ (દ્વિતીય) - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, પયસ્વિની નદી કિનારે, રામઘાટ, ચિત્રકૂટ (મ.પ્ર./ઉ.પ્ર.)',
      contacts: [],
      mahatmy:
          'પયસ્વિની નદીના રામઘાટ પર બિરાજી શ્રી રામચંદ્રજીના લીલા ગુણ ગાયા.',
      directions: 'ચિત્રકૂટમાં પયસ્વિની નદીના રામઘાટ પર.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '78',
      number: '78',
      name: 'પ્રયાગ (અલહાબાદ) - શ્રી મહાપ્રભુજી બેઠકજી',
      address:
          'શ્રી મહાપ્રભુજી બેઠકજી, ત્રિવેણી સંગમ પાસે, અરેલ ઘાટ, પ્રયાગરાજ (ઉ.પ્ર.)',
      contacts: ['05322500000'],
      mahatmy:
          'ગંગા, યમુના અને સરસ્વતીના ત્રિવેણી સંગમે અરેલ ગામ ખાતે બિરાજી સુબોધિનીજીની રચના કરી.',
      directions: 'પ્રયાગરાજ (અલહાબાદ) અરેલ ઘાટ પાસે.',
      rules: ['જારીજી ભરવા માટે નિયમાનુસાર ઉપવાસ કરવો.'],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '79',
      number: '79',
      name: 'અરેલ - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, મુ. અરેલ, પ્રયાગરાજ (ઉ.પ્ર.)',
      contacts: [],
      mahatmy:
          'અરેલમાં પોતાના નિવાસસ્થાને બિરાજીને અનેક ગ્રંથોની રચના કરી અને સેવકો પર કૃપા કરી.',
      directions: 'પ્રયાગરાજ ત્રિવેણી સંગમ સામે પાર અરેલ ગામે.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '80',
      number: '80',
      name: 'કાશી (તૃતીય) - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, પંચગંગા ઘાટ, વારાણસી (ઉ.પ્ર.)',
      contacts: [],
      mahatmy:
          'પંચગંગા ઘાટ પર વિદ્વાનો સાથે ચર્ચા કરી વિષ્ણુસ્વામી સંપ્રદાયના આચાર્ય તરીકે વિજય પત્રિકા લખી.',
      directions: 'વારાણસીમાં પંચગંગા ઘાટ પર.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '81',
      number: '81',
      name: 'ગોપાલપુર - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, મુ. ગોપાલપુર, જી. જબલપુર (મ.પ્ર.)',
      contacts: [],
      mahatmy: 'નર્મદા તીરે બિરાજી ભક્તોને ભગવદ્ રસનું પાન કરાવ્યું.',
      directions: 'જબલપુર નજીક ગોપાલપુર ખાતે.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '82',
      number: '82',
      name: 'ગુજરાત (અડાલજ) - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, અડાલજ વાવ પાસે, જી. ગાંધીનગર (ગુજરાત)',
      contacts: [],
      mahatmy:
          'અડાલજમાં બિરાજીને સ્થાનિક સત્સંગીઓને પુષ્ટિમાર્ગીય સેવા પ્રણાલી સમજાવી.',
      directions: 'ગાંધીનગર-અમદાવાદ રોડ પર અડાલજ વાવ પાસે.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '83',
      number: '83',
      name: 'ગોધરા - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, રામનાથ તળાવ પાસે, ગોધરા (ગુજરાત)',
      contacts: [],
      mahatmy: 'રામનાથ તળાવના કાંઠે બિરાજી સપ્તાહ પારાયણ કર્યું.',
      directions: 'ગોધરા શહેરમાં રામનાથ તળાવ નજીક.',
      rules: [],
      isFavorite: 0
    ),
    BethakjiModel(
      id: '84',
      number: '84',
      name: 'ચરણાટ (ચરણાંદ્રી) - શ્રી મહાપ્રભુજી બેઠકજી',
      address: 'શ્રી મહાપ્રભુજી બેઠકજી, ચરણાટ, વારાણસી પાસે (ઉ.પ્ર.)',
      contacts: [],
      mahatmy:
          'ચોર્યાસીમા બેઠકજી તરીકે પ્રસિદ્ધ ચરણાટ ક્ષેત્રમાં બિરાજી આપશ્રીએ ૮૪ બેઠકજીની યાત્રા પૂર્ણ કરી પૂર્ણકૃપા દર્શાવી.',
      directions: 'વારાણસી/મિર્ઝાપુર રોડ પર ચરણાટ ગામે.',
      rules: [
        'જારીજી ભરવા માટે કાર્યાલયમાંથી પહોંચ મેળવીને વિધિપૂર્વક સેવા કરવી.',
      ],
     isFavorite: 0
    ),
  ];
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Single source of truth for table name
  static const String tableName = 'bethakji';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'bethakji_yadi.db');

    const String sql = '''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        number TEXT,
        name TEXT NOT NULL,
        address TEXT,
        contacts TEXT,
        mahatmy TEXT,
        directions TEXT,
        rules TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''';

    return await openDatabase(
      path,
      version: 2, // Increment version if schema changed
      onCreate: (db, version) async {
        await db.execute(sql);

        Batch batch = db.batch();
        for (var bethakji in bethakji84List) {
          batch.insert(tableName, bethakji.toMap());
        }
        await batch.commit(noResult: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS $tableName');
        await db.execute(sql);

        Batch batch = db.batch();
        for (var bethakji in bethakji84List) {
          batch.insert(tableName, bethakji.toMap());
        }
        await batch.commit(noResult: true);
      },
    );
  }

  // Fetch all records
  Future<List<BethakjiModel>> getAllBethakji() async {
    final db = await database;

    // Standardized table name
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    debugPrint("RAW DB MAPS COUNT: ${maps.length}");
    if (maps.isNotEmpty) {
      debugPrint("FIRST ROW SAMPLE: ${maps.first}");
    }

    return List.generate(maps.length, (i) {
      return BethakjiModel.fromMap(maps[i]);
    });
  }

  // Insert or update individual item
  Future<int> insertBethakji(BethakjiModel bethakji) async {
    final db = await database;
    return await db.insert(
      tableName,
      bethakji.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update favorite status
  Future<int> updateFavoriteStatus(String id, int isFavorite) async {
    final db = await database;
    return await db.update(
      tableName,
      {'isFavorite': isFavorite},
      where: 'id = ?',
      whereArgs: [int.tryParse(id) ?? id], // Safe parse for INTEGER primary key
    );
  }

  // Fetch only favorite Bethakji items
  Future<List<BethakjiModel>> getFavoriteBethakji() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => BethakjiModel.fromMap(maps[i]));
  }
}