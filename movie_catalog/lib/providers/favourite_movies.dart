import '/components/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteMoviesProvider = StateProvider((ref) {
  return <Movie>[];
});