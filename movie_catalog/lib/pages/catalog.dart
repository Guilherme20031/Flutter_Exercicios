
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/components/list.dart';
import '/components/model.dart';
import '/pages/details.dart';
import '/providers/movie_catalog.dart';
import '/providers/theme_mode.dart';
import '/providers/favourite_movies.dart';

class MovieCatalogPage extends ConsumerStatefulWidget {
  const MovieCatalogPage({super.key});

  @override
  ConsumerState<MovieCatalogPage> createState() => _MovieCatalogPageState();
}

class _MovieCatalogPageState extends ConsumerState<MovieCatalogPage> {
  @override
  void initState() {
    ref.read(MovieCatalogNotifier.provider.notifier).fetchAllByCategory();
    super.initState();
  }

  static const double _drawerThumbRadius = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Consumer(
          builder: (context, ref, _) {
            final favourites = ref.watch(favouriteMoviesProvider);

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  child: Text(
                    'Favoutires', // mantém tua grafia original
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                if (favourites.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Nenhum favorito ainda'),
                  )
                else
                  ...favourites.map((movie) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: _drawerThumbRadius,
                        backgroundImage: movie.coverUrl != null
                            ? NetworkImage(movie.coverUrl!)
                            : null,
                        child: movie.coverUrl == null
                            ? const Icon(Icons.movie)
                            : null,
                      ),
                      title: Text(movie.title),
                      subtitle: Text(
                        movie.description ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // Fecha a Drawer e navega para detalhes (opcional)
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailsPage(movie: movie),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          final current =
                              ref.read(favouriteMoviesProvider.notifier).state;
                          ref.read(favouriteMoviesProvider.notifier).state = [
                            ...current.where((m) => m.id != movie.id),
                          ];
                        },
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(themeModeProvider.notifier).toggleTheme();
        },
        child: const Icon(Icons.abc),
      ),
      appBar: AppBar(title: const Text('Movie Catalog')),
      body: Consumer(
        builder: (context, ref, _) {
          return ref.watch(MovieCatalogNotifier.provider).when(
                data: (data) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        runSpacing: 15,
                        children: data.keys
                            .map((key) => MovieList(title: key, movies: data[key]!))
                            .toList(),
                      ),
                    ),
                  );
                },
                error: (error, _) => Text(error.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
        },
      ),
    );
  }
}
