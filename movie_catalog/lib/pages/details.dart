
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/components/model.dart';
import '/providers/favourite_movies.dart';

class MovieDetailsPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  static const double _coverHeight = 500;
  static const double _pagePadding = 16;
  static const double _gapSmall = 4;
  static const double _gapMedium = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouriteMoviesProvider);
    final isFav = favourites.any((m) => m.id == movie.id);

    return Scaffold(
      appBar: AppBar(),
      // FAB dentro dos detalhes: adiciona/remove favoritos
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final current = ref.read(favouriteMoviesProvider.notifier).state;
          final exists = current.any((m) => m.id == movie.id);

          ref.read(favouriteMoviesProvider.notifier).state = exists
              ? [
                  ...current.where((m) => m.id != movie.id),
                ]
              : [
                  ...current,
                  movie,
                ];

          // Feedback rápido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                exists ? 'Removido dos favoritos' : 'Adicionado aos favoritos',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Icon(isFav ? Icons.favorite : Icons.favorite_border),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: _coverHeight,
              width: double.infinity,
              child: Image.network(
                movie.coverUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(_pagePadding),
              child: Wrap(
                runSpacing: _gapMedium,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title),
                      Text(movie.subititle ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Summary'),
                      Row(
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.favorite),
                              SizedBox(width: _gapSmall),
                              Text('100'),
                            ],
                          ),
                          const SizedBox(width: _gapMedium),
                          Row(
                            children: const [
                              Icon(Icons.visibility),
                              SizedBox(width: _gapSmall),
                              Text('100'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(movie.description ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
