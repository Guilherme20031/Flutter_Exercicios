import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/components/list.dart';
import '/components/model.dart';
import '/providers/movie_catalog.dart';
import '/providers/theme_mode.dart';

class MovieCatalogPage extends ConsumerWidget {
  const MovieCatalogPage({super.key});

  static const double _bottomPadding = 16;
  static const double _runSpacing = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dispara o fetch após o primeiro frame (equivale ao initState + ref.read(...).fetchAllByCategory())
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(MovieCatalogNotifier.provider.notifier).fetchAllByCategory();
    });

    return Scaffold(
      drawer: _buildDrawer(context),
      floatingActionButton: _buildFab(ref),
      appBar: AppBar(title: const Text('Movie Catalog')),
      body: _buildBody(ref),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Favourites'),
            onTap: () {
              // Mantém o mesmo placeholder (sem navegação no original)
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFab(WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
      child: const Icon(Icons.abc),
    );
  }

  // Corpo que observa o provider e rende conforme estado (data/error/loading)
  Widget _buildBody(WidgetRef ref) {
    return Consumer(
      builder: (context, ref, _) {
        final asyncCatalog = ref.watch(MovieCatalogNotifier.provider);

        return asyncCatalog.when(
          data: (data) => _buildCatalog(data),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  // Mantém a mesma estrutura de UI: Scroll + Wrap de MovieList por categoria
  Widget _buildCatalog(Map<String, List<Movie>> data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: _bottomPadding),
        child: Wrap(
          runSpacing: _runSpacing,
          children: data.entries.map((entry) {
            final title = entry.key;
            final movies = entry.value;
            return MovieList(title: title, movies: movies);
          }).toList(),
        ),
      ),
    );
  }
}
