import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price INTEGER NOT NULL,
      quantity INTEGER NOT NULL DEFAULT 0
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Check if the column already exists
      final tableInfo = await db.rawQuery('PRAGMA table_info(items)');
      final columnExists = tableInfo.any((column) => column['name'] == 'quantity');

      if (!columnExists) {
        await db.execute('ALTER TABLE items ADD COLUMN quantity INTEGER NOT NULL DEFAULT 0');
      }
    }
  }

  Future<int> create(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> readAllItems() async {
    final db = await instance.database;
    return await db.query('items');
  }

  Future<int> update(Map<String, dynamic> item, int id) async {
    final db = await instance.database;
    return await db.update('items', item, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}