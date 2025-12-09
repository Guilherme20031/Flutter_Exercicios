
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/model/film.dart';

class GhibliApiService {
  static const String _baseUrl = 'https://ghibliapi.vercel.app/films';

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse(_baseUrl));

    final List<dynamic> list = json.decode(response.body) as List<dynamic>;
    return list.map((j) => Film.fromJson(j as Map<String, dynamic>)).toList();
  }
}
