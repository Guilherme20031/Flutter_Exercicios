import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/model/film.dart';
import '/services/ghibli_api.dart';

/// Provider do serviço
final ghibliApiServiceProvider = Provider<GhibliApiService>((ref) {
  return GhibliApiService();
});

/// Estado do controller
class FilmState {
  final List<Film> films;
  final bool isLoading;
  final String? error;
  final String query;

  const FilmState({
    this.films = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  FilmState copyWith({
    List<Film>? films,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return FilmState(
      films: films ?? this.films,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      query: query ?? this.query,
    );
  }

  /// Filtragem por título com correspondência
  List<Film> get visibleFilms {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return films;
    return films.where((f) => f.title.toLowerCase() == q).toList();
  }
}

/// StateNotifier
class FilmController extends StateNotifier<FilmState> {
  final GhibliApiService _service;
  FilmController(this._service) : super(const FilmState()) {
    loadFilms();
  }

  Future<void> loadFilms() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _service.fetchFilms();
      state = state.copyWith(isLoading: false, films: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setQuery(String value) {
    if (value == state.query) return;
    state = state.copyWith(query: value);
  }
}

/// Provider do controller
final filmControllerProvider =
    StateNotifierProvider<FilmController, FilmState>((ref) {
  final service = ref.watch(ghibliApiServiceProvider);
  return FilmController(service);
});
