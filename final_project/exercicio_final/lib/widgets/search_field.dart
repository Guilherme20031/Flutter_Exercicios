import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/controllers/film_controller.dart';

class SearchField extends ConsumerWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(
      filmControllerProvider.select((s) => s.query),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar por título (correspondência exata)…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: query.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Limpar',
                  icon: const Icon(Icons.close),
                  onPressed: () => ref.read(filmControllerProvider.notifier).setQuery(''),
                ),
        ),
        textInputAction: TextInputAction.search,
        onChanged: (value) => ref.read(filmControllerProvider.notifier).setQuery(value),
      ),
    );
  }
}
