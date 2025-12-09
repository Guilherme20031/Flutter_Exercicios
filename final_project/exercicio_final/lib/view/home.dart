
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../controllers/film_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/ui_controller.dart';
import '../widgets/search_field.dart';
import '/widgets/film_grid.dart';
import '/widgets/favorite_film.dart';
import '/model/film.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmState = ref.watch(filmControllerProvider);
    final gridLib = ref.watch(gridLibProvider);

    if (filmState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo Studio Ghibli'),
          actions: const [_GridSwitcher()],
        ),
        body: const Center(
          child: SizedBox(width: 36, height: 36, child: CircularProgressIndicator()),
        ),
      );
    }

    if (filmState.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo Studio Ghibli'),
          actions: const [_GridSwitcher()],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Erro ao carregar filmes:\n${filmState.error}'),
          ),
        ),
      );
    }

    final visible = filmState.visibleFilms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Studio Ghibli'),
        actions: const [_GridSwitcher()], // alternador
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SearchField()),

          if (visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey.shade500),
                  const SizedBox(height: 8),
                  const Text('Sem resultados para este título.'),
                  const SizedBox(height: 4),
                  const Text('Dica: correspondência exata (ex.: "Totoro")'),
                ],
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              sliver: gridLib == GridLib.aligned
                  ? SliverAlignedGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: visible.length,
                      itemBuilder: (context, index) => FilmGridItem(film: visible[index]),
                    )
                  : SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childCount: visible.length,
                      itemBuilder: (context, index) => FilmGridItem(film: visible[index]),
                    ),
            ),

          _FavoritesSection(),
        ],
      ),
    );
  }
}

/// Botão no AppBar para alternar o tipo de grelha (Riverpod)
class _GridSwitcher extends ConsumerWidget {
  const _GridSwitcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridLib = ref.watch(gridLibProvider);
    return PopupMenuButton<GridLib>(
      initialValue: gridLib,
      tooltip: 'Layout da grelha',
      icon: const Icon(Icons.grid_view),
      onSelected: (choice) => ref.read(gridLibProvider.notifier).state = choice,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: GridLib.aligned,
          child: Text('Aligned Grid'),
        ),
        PopupMenuItem(
          value: GridLib.staggered,
          child: Text('Staggered (Masonry)'),
        ),
      ],
    );
  }
}

class _FavoritesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(filmControllerProvider.select((s) => s.films));
    final favIds = ref.watch(favoritesProvider);

    final Map<String, Film> byId = {for (final f in films) f.id: f};
    final favFilms = <Film>[for (final id in favIds) if (byId[id] != null) byId[id]!];

    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: Column(
          key: ValueKey<int>(favFilms.length),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('Favoritos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      '(${favFilms.length})',
                      key: ValueKey(favFilms.length),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const Spacer(),
                  if (favFilms.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => ref.read(favoritesProvider.notifier).clear(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar'),
                    ),
                ],
              ),
            ),
            if (favFilms.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  'Ainda não tens filmes favoritos.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            else
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: favFilms.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) => FavoriteFilmTile(film: favFilms[index]),
              ),
          ],
        ),
      ),
    );
  }
}
