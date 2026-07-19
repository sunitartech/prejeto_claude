import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites_storage.dart';

/// Provider singleton da camada de persistencia de favoritos.
final favoritesStorageProvider = Provider<FavoritesStorage>((ref) {
  return FavoritesStorage();
});

/// Notifier com o conjunto de IDs de receitas favoritadas pelo usuario.
class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final storage = ref.watch(favoritesStorageProvider);
    return storage.carregar();
  }

  /// Adiciona ou remove um id do conjunto de favoritos.
  Future<void> toggle(String id) async {
    final atual = state.valueOrNull ?? <String>{};
    final novo = Set<String>.from(atual);
    if (novo.contains(id)) {
      novo.remove(id);
    } else {
      novo.add(id);
    }
    state = AsyncData(novo);
    await ref.read(favoritesStorageProvider).salvar(novo);
  }

  /// Retorna true se a receita esta favoritada.
  bool contains(String id) {
    return state.valueOrNull?.contains(id) ?? false;
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);
