import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/tarefa.dart';

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
    String path = join(await getDatabasesPath(), 'tarefas.db');
    print('📍 Banco de dados criado em: $path');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        prioridade TEXT NOT NULL
      )
    ''');
  }

  // Inserir uma nova tarefa
  Future<int> inserirTarefa(Tarefa tarefa) async {
    final db = await database;
    return await db.insert('tarefas', tarefa.toMap());
  }

  // Buscar todas as tarefas
  Future<List<Tarefa>> buscarTodasTarefas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tarefas',
      orderBy: 'CASE prioridade WHEN "Alta" THEN 1 WHEN "Média" THEN 2 WHEN "Baixa" THEN 3 END, nome',
    );

    return List.generate(maps.length, (i) {
      return Tarefa.fromMap(maps[i]);
    });
  }

  // Buscar tarefas por prioridade
  Future<List<Tarefa>> buscarTarefasPorPrioridade(PrioridadeNivel prioridade) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tarefas',
      where: 'prioridade = ?',
      whereArgs: [prioridade.displayName],
      orderBy: 'nome',
    );

    return List.generate(maps.length, (i) {
      return Tarefa.fromMap(maps[i]);
    });
  }

  // Buscar tarefa por ID
  Future<Tarefa?> buscarTarefaPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Tarefa.fromMap(maps.first);
    }
    return null;
  }

  // Atualizar uma tarefa
  Future<int> atualizarTarefa(Tarefa tarefa) async {
    final db = await database;
    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  // Deletar uma tarefa
  Future<int> deletarTarefa(int id) async {
    final db = await database;
    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Contar tarefas por prioridade
  Future<Map<PrioridadeNivel, int>> contarTarefasPorPrioridade() async {
    final db = await database;
    Map<PrioridadeNivel, int> contadores = {};
    
    for (PrioridadeNivel prioridade in PrioridadeNivel.values) {
      final resultado = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tarefas WHERE prioridade = ?',
        [prioridade.displayName],
      );
      contadores[prioridade] = resultado.first['count'] as int;
    }
    
    return contadores;
  }

  // Fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}