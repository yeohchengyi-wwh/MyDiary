import 'package:mydiary/models/mydairy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "mydiary.db";
  static final _databaseVersion = 1;
  static final tablename = 'tbl_mydiary';

  // Create a single shared instance of DatabaseHelper (Singleton pattern)
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor → always returns the SAME instance above
  factory DatabaseHelper() {
    return _instance;
  }
  // Private named constructor → used only internally
  DatabaseHelper._internal();

  // Holds the database object (initially null until opened)
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!; // Database already loaded → return it
    _db = await _initDb(); // Otherwise, open/create the database
    return _db!; // Return the ready database
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tablename (
            diary_id INTEGER PRIMARY KEY AUTOINCREMENT,
            diary_title TEXT,
            diary_notes TEXT,
            date TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  //Create Data (Insert)
  Future<int> insertMyDiary(MyDiary mydiary) async {
    final db = await database;

    final data = mydiary.toMap();
    data.remove("diary_id"); //Force auto-increment

    return await db.insert(tablename, data);
  }

  Future<List<MyDiary>> searchMyDiary(String keyword) async {
    final db = await database;
    final result = await db.query(
      tablename,
      where: 'diary_title LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'diary_id ASC',
    );
    return result.map((e) => MyDiary.fromMap(e)).toList();
  }

  Future<int> updateMyDiary(MyDiary mydiary) async {
    final db = await database;
    return await db.update(
      tablename,
      mydiary.toMap(),
      where: 'diary_id = ?',
      whereArgs: [mydiary.diaryId],
    );
  }

  //Delete Data (Based on diary ID, delete specific ID data)
  Future<int> deleteMyDiary(int diaryId) async {
    final db = await database;
    return await db.delete(
      tablename,
      where: 'diary_id = ?',
      whereArgs: [diaryId],
    );
  }

  Future<List<MyDiary>> getMyDiarysPaginated(int limit, int offset) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tablename,
      orderBy: 'diary_id ASC',
      limit: limit,
      offset: offset,
    );

    return result.map((e) => MyDiary.fromMap(e)).toList();
  }

  Future<int> getTotalCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM $tablename',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //CLOSE DATABASE
  Future<void> closeDb() async {
    final db = await database;
    await db.close();
  }
}