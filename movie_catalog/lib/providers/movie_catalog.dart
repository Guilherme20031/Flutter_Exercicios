import 'package:movie_catalog/providers/movie_repository.dart';
import '/components/model.dart';
import '/components/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MovieCatalogNotifier
    extends StateNotifier<AsyncValue<Map<String, List<Movie>>>> {
  static final provider = StateNotifierProvider((ref) {
    return MovieCatalogNotifier(
      const AsyncValue.loading(),
      movieRepository: ref.read(movieRepositoryProvider),
    );
  });

  final MovieRepository movieRepository;

  MovieCatalogNotifier(super.state, {required this.movieRepository});

  void fetchAllByCategory() async {
    state = const AsyncValue.loading();

    state = AsyncValue.data(await movieRepository.fetchAllByGenre());
  }
}