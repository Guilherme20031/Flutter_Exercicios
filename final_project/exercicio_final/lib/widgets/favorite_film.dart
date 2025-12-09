import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/model/film.dart';
import '../controllers/favorites_controller.dart';

class FavoriteFilmTile extends ConsumerWidget {
  final Film film;
  const FavoriteFilmTile({super.key, required this.film});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select((ids) => ids.contains(film.id)),
    );

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset
              ( 'assets/capa.png',
              fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(film.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : null),
        tooltip: isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
        onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(film.id),
      ),
      onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(film.id),
    );
  }
}