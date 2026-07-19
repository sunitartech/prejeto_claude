import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/recipe_repository.dart';
import '../../domain/recipe_model.dart';

/// Provider singleton do repository de receitas.
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository();
});

/// Provider que carrega a lista completa de receitas.
final recipesListProvider = FutureProvider<List<Receita>>((ref) async {
  return ref.watch(recipeRepositoryProvider).listarTodas();
});

/// Provider que busca uma receita por id.
final recipeByIdProvider =
    FutureProvider.family<Receita?, String>((ref, id) async {
  return ref.watch(recipeRepositoryProvider).buscarPorId(id);
});

/// Provider que filtra receitas por texto de busca.
final recipesFiltradasProvider =
    FutureProvider.family<List<Receita>, String>((ref, texto) async {
  return ref.watch(recipeRepositoryProvider).buscarPorTexto(texto);
});
