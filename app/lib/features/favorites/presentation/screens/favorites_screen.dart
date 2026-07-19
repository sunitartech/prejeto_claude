import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/recipe_card.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart';
import '../providers/favorites_provider.dart';

/// Tela de Favoritos. Lista todas as receitas cujo ID esta
/// no `favoritesProvider`. Persistencia local (SharedPreferences).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final recipesAsync = ref.watch(recipesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
        data: (todas) {
          final favoritos = favoritesAsync.valueOrNull ?? <String>{};
          final lista = todas.where((r) => favoritos.contains(r.id)).toList();

          if (lista.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              title: 'Voce ainda nao favoritou nenhuma receita',
              subtitle: 'Toque no coracao de uma receita para salva-la aqui.',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: lista.length,
            itemBuilder: (_, i) => RecipeCard(receita: lista[i]),
          );
        },
      ),
    );
  }
}
