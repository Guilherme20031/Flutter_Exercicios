import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesController extends StateNotifier<Set<String>> {
  FavoritesController() : super(<String>{});

  bool isFavorite(String filmId) => state.contains(filmId);

  void toggleFavorite(String filmId) {
    final next = Set<String>.from(state);
    if (next.contains(filmId)) {
      next.remove(filmId);
    } else {
      next.add(filmId);
    }
    state = next;
  }

  void clear() {
    state = <String>{};
  }
}

/// Provider do controller de favoritos
final favoritesProvider =
    StateNotifierProvider<FavoritesController, Set<String>>((ref) {
  return FavoritesController();
});
