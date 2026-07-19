import '../domain/recipe_model.dart';
import 'recipe_seed_loader.dart';

/// Repository de receitas.
///
/// TODO(backend): quando o Firestore estiver pronto, substituir a leitura
/// do seed JSON por queries em `cloud_firestore`. A interface publica
/// (listarTodas, buscarPorId, buscarPorTexto) ja esta preparada para isso.
class RecipeRepository {
  RecipeRepository({RecipeSeedLoader? loader})
      : _loader = loader ?? const RecipeSeedLoader();

  final RecipeSeedLoader _loader;
  List<Receita>? _cache;

  /// Lista todas as receitas (carrega do seed JSON na primeira chamada).
  Future<List<Receita>> listarTodas() async {
    _cache ??= await _loader.carregar();
    return _cache!;
  }

  /// Busca uma receita por id.
  Future<Receita?> buscarPorId(String id) async {
    final todas = await listarTodas();
    try {
      return todas.firstWhere((r) => r.id == id);
    } on StateError {
      return null;
    }
  }

  /// Busca receitas por texto — match no titulo OU em qualquer ingrediente.
  /// Case-insensitive e ignora acentuacao.
  Future<List<Receita>> buscarPorTexto(String texto) async {
    final todas = await listarTodas();
    if (texto.trim().isEmpty) return todas;
    final normalizado = _normalizar(texto);
    return todas.where((r) {
      if (_normalizar(r.titulo).contains(normalizado)) return true;
      if (_normalizar(r.descricao).contains(normalizado)) return true;
      for (final ing in r.ingredientes) {
        if (_normalizar(ing).contains(normalizado)) return true;
      }
      for (final tag in r.tags) {
        if (_normalizar(tag).contains(normalizado)) return true;
      }
      return false;
    }).toList();
  }

  /// Normaliza string para busca: lowercase + remove acentos.
  String _normalizar(String input) {
    final lower = input.toLowerCase();
    return lower
        .replaceAll('a', 'a')
        .replaceAll('a', 'a')
        .replaceAll('a', 'a')
        .replaceAll('e', 'e')
        .replaceAll('e', 'e')
        .replaceAll('i', 'i')
        .replaceAll('o', 'o')
        .replaceAll('o', 'o')
        .replaceAll('u', 'u')
        .replaceAll('c', 'c');
  }
}
