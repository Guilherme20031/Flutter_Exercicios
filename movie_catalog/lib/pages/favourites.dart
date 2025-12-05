
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/components/model.dart';
import '/providers/favourite_movies.dart';

class FavouriteMoviesPage extends StatelessWidget {
  const FavouriteMoviesPage({super.key});

  static const double _thumbSize = 56; // tamanho do avatar/thumbnail
  static const int _subtitleMaxLines = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: Consumer(
        builder: (context, ref, _) {
          final movies = ref.watch(favouriteMoviesProvider);

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final Movie movie = movies[index];

              return ListTile(
                leading: _buildLeadingThumb(movie),
                title: Text(movie.title),
                subtitle: Text(
                  movie.description ?? '',
                  maxLines: _subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            
          );
        },
        child:Positioned(
          right: 0,
          top: 0,
          child: FloatingActionButton.small(
            onPressed:() {}
        ),
        ),
        ),
      );
  }

  Widget _buildLeadingThumb(Movie movie) {
    final imageUrl = movie.coverUrl ?? '';
    return SizedBox(
      width: _thumbSize,
      height: _thumbSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
