
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
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: _buildFavFab(ref),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(),
            Padding(
              padding: const EdgeInsets.all(_pagePadding),
              child: Wrap(
                runSpacing: _gapMedium,
                children: [
                  _buildTitleSection(),
                  _buildSummaryRow(),
                  _buildDescription(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // Widgets (mesmo conteúdo)
  // ---------------------------

  Widget _buildCoverImage() {
    return SizedBox(
      height: _coverHeight,
      width: double.infinity,
      child: Image.network(
        movie.coverUrl ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title),
        Text(movie.subititle ?? ''),
      ],
    );
  }

  Widget _buildSummaryRow() {
    return Row(
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
    );
  }

  Widget _buildDescription() {
    return Text(movie.description ?? '');
  }

  // ---------------------------
  // Ação do FAB (mesma lógica)
  // ---------------------------

  Widget _buildFavFab(WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        final movies = ref.read(favouriteMoviesProvider.notifier).state;

        // Mantém exatamente o mesmo toggle de favoritos
        if (movies.contains(movie)) {
          ref.read(favouriteMoviesProvider.notifier).state = [
            ...movies.where((element) => element.id != movie.id),
          ];
        } else {
          ref.read(favouriteMoviesProvider.notifier).state = [
            ...movies,
            movie,
          ];
        }
      },
      child: const Icon(Icons.favorite),
    );
  }
}
