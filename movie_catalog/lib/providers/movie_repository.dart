import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/components/repository.dart';

final movieRepositoryProvider = Provider((ref) {
  return MovieRepository();
});