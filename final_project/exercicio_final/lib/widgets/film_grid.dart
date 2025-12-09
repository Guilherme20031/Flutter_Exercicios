import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/model/film.dart';
//import '/controllers/favorites_controller.dart';

class FilmGridItem extends ConsumerWidget {
  final Film film;
  const FilmGridItem({super.key, required this.film});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.asset
                ( 'assets/capa.png',
                fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    film.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: Tween<double>(begin: 0.85, end: 1).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  /*child: IconButton(
                    key: ValueKey<bool>(isFav),
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null),
                    tooltip: isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                    onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(film.id),
                  ),*/
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

