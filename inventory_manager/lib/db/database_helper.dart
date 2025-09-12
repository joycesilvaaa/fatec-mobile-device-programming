import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'inventario.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE itens(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            quantidade INTEGER,
            preco REAL
          )
        ''');
      },
    );
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('itens', item.toMap());
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('itens');
    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

  Future<int> updateItem(Item item) async {
    final db = await database;
    return await db.update('itens', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('itens', where: 'id = ?', whereArgs: [id]);
  }
}
