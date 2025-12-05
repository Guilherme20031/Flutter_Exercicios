
import 'package:flutter/material.dart';
import 'card.dart';
import 'model.dart';
import '/pages/details.dart';

class MovieList extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const MovieList({
    super.key,
    required this.title,
    required this.movies,
  });

  static const double _listHeight = 280;
  static const double _hPadding = 16;
  static const double _vPadding = 16;
  static const double _itemSpacing = 16;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(_vPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: textTheme.titleLarge),
              Text(
                'View all',
                style: textTheme.titleSmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(
          height: _listHeight,
          child: ListView.separated(
            itemCount: movies.length,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.only(
              start: _hPadding,
              end: _hPadding,
              bottom: _vPadding,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: _itemSpacing),
            itemBuilder: (context, index) {
              final movie = movies[index];

              // Mantém mesma navegação, apenas com sintaxe mais direta
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsPage(movie: movie),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16), // puramente visual
                child: MovieCard(movie: movie),
              );
            },
          ),
        ),
      ],
    );
  }
}
