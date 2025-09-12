class Movie {
  final int? id;
  final String title;
  final String director;
  final int year;

  Movie({this.id, required this.title, required this.director, required this.year});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'director': director,
      'year': year,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      director: map['director'],
      year: map['year'],
    );
  }
}
