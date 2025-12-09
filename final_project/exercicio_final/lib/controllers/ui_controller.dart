import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GridLib { aligned, staggered }

/// Escolha do tipo de grelha
final gridLibProvider = StateProvider<GridLib>((ref) => GridLib.aligned);
