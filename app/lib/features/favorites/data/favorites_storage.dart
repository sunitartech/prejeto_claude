import 'package:shared_preferences/shared_preferences.dart';

/// Persiste os IDs de receitas favoritadas em [SharedPreferences].
///
/// No esqueleto, favoritos sao locais. Quando o backend estiver pronto,
/// essa classe sera substituida por um repository que sincroniza
/// `users/{uid}/favorites` no Firestore.
class FavoritesStorage {
  FavoritesStorage({SharedPreferences? prefs}) : _prefs = prefs;

  static const String _chave = 'favorite_recipe_ids';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// Carrega o conjunto de IDs de receitas favoritadas.
  Future<Set<String>> carregar() async {
    final prefs = await _getPrefs();
    final listaJson = prefs.getStringList(_chave) ?? const [];
    return listaJson.toSet();
  }

  /// Salva o conjunto de IDs de receitas favoritadas.
  Future<void> salvar(Set<String> ids) async {
    final prefs = await _getPrefs();
    await prefs.setStringList(_chave, ids.toList());
  }
}
