import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../domain/recipe_model.dart';

/// Carrega o JSON de receitas de exemplo embarcado em `assets/seed/recipes.json`.
///
/// Por enquanto e a fonte principal de dados do esqueleto.
/// Quando o backend Firestore estiver pronto, esse loader sera substituido
/// por um repository que busca de `cloud_firestore`.
class RecipeSeedLoader {
  const RecipeSeedLoader();

  static const String _caminhoAsset = 'assets/seed/recipes.json';

  Future<List<Receita>> carregar() async {
    final String conteudo = await rootBundle.loadString(_caminhoAsset);
    final List<dynamic> lista = jsonDecode(conteudo) as List<dynamic>;
    return lista
        .map((item) => Receita.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
