import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../subscription/presentation/widgets/premium_badge.dart';
import '../../domain/recipe_model.dart';
import '../providers/recipes_provider.dart';

/// Tela de detalhe de uma receita.
///
/// Recebe o `id` da receita via [GoRouter] (rota `/receita/:id`).
class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.receitaId});

  final String receitaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receitaAsync = ref.watch(recipeByIdProvider(receitaId));
    final favoritos = ref.watch(favoritesProvider);
    final ehFavorita = favoritos.valueOrNull?.contains(receitaId) ?? false;

    return Scaffold(
      body: receitaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (receita) {
          if (receita == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Receita nao encontrada.')),
            );
          }
          return _Corpo(
            receita: receita,
            ehFavorita: ehFavorita,
            onFavoritar: () =>
                ref.read(favoritesProvider.notifier).toggle(receita.id),
          );
        },
      ),
    );
  }
}

class _Corpo extends StatelessWidget {
  const _Corpo({
    required this.receita,
    required this.ehFavorita,
    required this.onFavoritar,
  });

  final Receita receita;
  final bool ehFavorita;
  final VoidCallback onFavoritar;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // AppBar com imagem
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: receita.imagemUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: const Icon(Icons.restaurant, size: 60),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Corpo
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        receita.titulo,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (receita.ehPremium) const PremiumBadge(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  receita.descricao,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: Icons.schedule,
                      label: '${receita.tempoPreparoMin} min',
                    ),
                    _MetaChip(
                      icon: Icons.people_outline,
                      label: '${receita.porcoes} porcoes',
                    ),
                    _MetaChip(
                      icon: Icons.signal_cellular_alt,
                      label: receita.dificuldade.label,
                    ),
                    _MetaChip(
                      icon: Icons.local_offer_outlined,
                      label: receita.categoria.label,
                    ),
                  ],
                ),
                if (receita.informacaoNutricional != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            receita.informacaoNutricional!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Ingredientes
                Text(
                  'Ingredientes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                ...receita.ingredientes.map<Widget>(
                  (ing) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 7),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(ing, style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Modo de preparo
                Text(
                  'Modo de preparo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                ...receita.modoPreparo.asMap().entries.map<Widget>((entry) {
                  final i = entry.key;
                  final passo = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(passo, style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
