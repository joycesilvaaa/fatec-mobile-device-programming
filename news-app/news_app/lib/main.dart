import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(NewsApp());

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Notícias',
      home: NewsList(),
      routes: {
        '/favoritos': (_) => FavoritesScreen(),
      },
    );
  }
}

class Article {
  int? id;
  String titulo;
  String conteudo;
  String autor;

  Article({this.id, required this.titulo, required this.conteudo, required this.autor});

  factory Article.fromMap(Map<String, dynamic> map) => Article(
    id: map['id'],
    titulo: map['titulo'],
    conteudo: map['conteudo'],
    autor: map['autor'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'conteudo': conteudo,
    'autor': autor,
  };
}

class NewsList extends StatefulWidget {
  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<Article> articles = [];
  Database? db;
  Set<int> favoritos = {};

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'favorites.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favoritos(id INTEGER PRIMARY KEY, titulo TEXT, conteudo TEXT, autor TEXT)',
        );
      },
      version: 1,
    );
    await loadFavoritos();
  }

  Future<void> fetchNews() async {
    final res = await http.get(Uri.parse('http://localhost:3003/noticias'));
    final List data = json.decode(res.body);
    setState(() {
      articles = List.generate(data.length, (i) => Article.fromMap(data[i]));
    });
  }

  Future<void> loadFavoritos() async {
    final List<Map<String, dynamic>> maps = await db!.query('favoritos');
    setState(() {
      favoritos = maps.map((m) => m['id'] as int).toSet();
    });
  }

  Future<void> addFavorito(Article article) async {
    await db?.insert('favoritos', article.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await loadFavoritos();
  }

  Future<void> removeFavorito(int id) async {
    await db?.delete('favoritos', where: 'id = ?', whereArgs: [id]);
    await loadFavoritos();
  }

  @override
  void initState() {
    super.initState();
    initDb().then((_) => fetchNews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => Navigator.pushNamed(context, '/favoritos'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, i) {
          final a = articles[i];
          final isFav = favoritos.contains(a.id);
          return ListTile(
            title: Text(a.titulo),
            subtitle: Text('${a.conteudo}\n${a.autor}'),
            isThreeLine: true,
            trailing: IconButton(
              icon: Icon(isFav ? Icons.star : Icons.star_border),
              color: isFav ? Colors.amber : null,
              onPressed: () {
                if (isFav) {
                  removeFavorito(a.id!);
                } else {
                  addFavorito(a);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> favoritos = [];
  Database? db;

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'favorites.db'),
      version: 1,
    );
    await loadFavoritos();
  }

  Future<void> loadFavoritos() async {
    final List<Map<String, dynamic>> maps = await db!.query('favoritos');
    setState(() {
      favoritos = List.generate(maps.length, (i) => Article.fromMap(maps[i]));
    });
  }

  @override
  void initState() {
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Favoritos')),
      body: ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, i) {
          final a = favoritos[i];
          return ListTile(
            title: Text(a.titulo),
            subtitle: Text('${a.conteudo}\n${a.autor}'),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}