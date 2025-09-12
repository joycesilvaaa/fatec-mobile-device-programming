
import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_database.dart';


void main() {
  runApp(const MovieApp());
}


class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Filmes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MovieHomePage(),
    );
  }
}


class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  List<Movie> _movies = [];
  String _search = '';
  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _yearController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movies = await MovieDatabase.instance.getMovies(query: _search);
    setState(() {
      _movies = movies;
    });
  }

  Future<void> _addMovie() async {
    final title = _titleController.text.trim();
    final director = _directorController.text.trim();
    final year = int.tryParse(_yearController.text.trim()) ?? 0;
    if (title.isEmpty || director.isEmpty || year == 0) return;
    await MovieDatabase.instance.insertMovie(
      Movie(title: title, director: director, year: year),
    );
    _titleController.clear();
    _directorController.clear();
    _yearController.clear();
    _loadMovies();
  }

  void _onSearchChanged() {
    setState(() {
      _search = _searchController.text.trim();
    });
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Filmes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por título ou diretor',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => _onSearchChanged(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _movies.isEmpty
                  ? const Center(child: Text('Nenhum filme encontrado.'))
                  : ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ListTile(
                          title: Text(movie.title),
                          subtitle: Text('${movie.director} • ${movie.year}'),
                        );
                      },
                    ),
            ),
            const Divider(),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _directorController,
              decoration: const InputDecoration(labelText: 'Diretor'),
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: 'Ano'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addMovie,
              child: const Text('Adicionar Filme'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
