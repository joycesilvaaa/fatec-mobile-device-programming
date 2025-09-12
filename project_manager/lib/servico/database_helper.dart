import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelo/senha.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'senhas.db');
    print('📍 Banco de dados criado em: $path');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE senhas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        senha TEXT NOT NULL
      )
    ''');
  }

  // Inserir uma nova senha
  Future<int> inserirSenha(Senha senha) async {
    final db = await database;
    return await db.insert('senhas', senha.toMap());
  }

  // Buscar todas as senhas
  Future<List<Senha>> buscarTodasSenhas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('senhas');

    return List.generate(maps.length, (i) {
      return Senha.fromMap(maps[i]);
    });
  }

  // Buscar senha por ID
  Future<Senha?> buscarSenhaPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'senhas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Senha.fromMap(maps.first);
    }
    return null;
  }

  // Atualizar uma senha
  Future<int> atualizarSenha(Senha senha) async {
    final db = await database;
    return await db.update(
      'senhas',
      senha.toMap(),
      where: 'id = ?',
      whereArgs: [senha.id],
    );
  }

  // Deletar uma senha
  Future<int> deletarSenha(int id) async {
    final db = await database;
    return await db.delete(
      'senhas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}