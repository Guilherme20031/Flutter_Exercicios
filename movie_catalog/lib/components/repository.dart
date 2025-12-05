
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
class MovieRepository {
  static final repository = MovieRepository();

  // Mantém a mesma base URL
  final String baseURL = 'https://api.jikan.moe/v4';

  late final List<Movie>? _movies;

  MovieRepository({List<Movie>? movies}) {
    _movies = movies;
  }

  // Mantém a mesma assinatura e comportamento (não faz nada)
  void add(Movie movie) {}

  // Mantém a mesma assinatura e comportamento (retorna null)
  Movie? fetch(String s) {
    return null;
  }

  /// Busca animes e agrupa por género.
  /// Mantém a mesma lógica de:
  /// - GET em `https://api.jikan.moe/v4/anime`
  /// - Montar `Movie` a partir do JSON
  /// - Agrupar por `genres[].name`
  Future<Map<String, List<Movie>>> fetchAllByGenre() async {
    final uri = Uri.parse('$baseURL/anime');
    final response = await http.get(uri);

    final decoded = _safeJsonDecode(response.body);
    final dataList = (decoded['data'] as List?) ?? const [];

    final Map<String, List<Movie>> movieGenres = {};

    for (final item in dataList) {
      final jsonMovie = (item as Map<String, dynamic>);

      final movie = Movie(
        id: _asString(jsonMovie['mal_id']),
        title: _titleFrom(jsonMovie),
        subititle: _asString(jsonMovie['title_japanese']),
        coverUrl: _coverFrom(jsonMovie),
        description: _asString(jsonMovie['synopsis']),
      );

      final genres = (jsonMovie['genres'] as List?) ?? const [];
      for (final g in genres) {
        final genreName = _asString((g as Map<String, dynamic>)['name']);
        if (genreName.isEmpty) continue;

        movieGenres.putIfAbsent(genreName, () => <Movie>[]);
        movieGenres[genreName]!.add(movie);
      }
    }

    return movieGenres;
  }

  /// Mantém a mesma lógica: faz a requisição, imprime o primeiro item e retorna lista vazia.
  Future<List<Movie>> fetchAll() async {
    final uri = Uri.parse('$baseURL/anime');
    final response = await http.get(uri);

    final decoded = _safeJsonDecode(response.body);
    final data = decoded['data'] as List?;
    if (data != null && data.isNotEmpty) {
      // Comportamento original: printa o primeiro item
      print(data.first);
    }

    return Future.value(List.empty());
  }

  /// Mantém a mesma lógica: retorna lista vazia.
  List<Movie> search(String s) {
    return List.empty();
  }

  // ----------------------------
  // Helpers de parsing (defensivos)
  // ----------------------------

  Map<String, dynamic> _safeJsonDecode(String source) {
    final dynamic decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) return decoded;
    return <String, dynamic>{};
  }

  String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  String _titleFrom(Map<String, dynamic> json) {
    // Mantém a lógica de pegar o primeiro título de `titles`
    final titles = json['titles'] as List?;
    if (titles != null && titles.isNotEmpty) {
      final first = titles.first as Map<String, dynamic>;
      final title = first['title'];
      if (title != null) return title.toString();
    }
    return _asString(json['title']); // fallback defensivo
  }

  String? _coverFrom(Map<String, dynamic> json) {
    // Mantém estrutura de acesso, mas com checagens seguras
    final images = json['images'] as Map<String, dynamic>?;
    final jpg = images?['jpg'] as Map<String, dynamic>?;
    final url = jpg?['large_image_url'];
    return url?.toString();
  }
}