import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Fachada fina sobre [SharedPreferences] para persistir todos os dados
/// locais do app (usuarios, sessao, receitas do usuario, cardapio, lista
/// de compras, contador de acessos).
///
/// Cada "colecao" e guardada como uma String JSON sob uma chave
/// especifica. Nao e eficiente, mas e simples e suficiente para a
/// versao de testes sem backend.
///
/// Metodos sao `async` mesmo quando poderiam ser sincronos para
/// facilitar a troca por outro backend no futuro.
class LocalDb {
  LocalDb({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // Helpers de leitura / escrita genericos
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> _lerLista(String chave) async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(chave);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <Map<String, dynamic>>[];
    return decoded
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  Future<void> _escreverLista(
    String chave,
    List<Map<String, dynamic>> itens,
  ) async {
    final prefs = await _getPrefs();
    await prefs.setString(chave, jsonEncode(itens));
  }

  Future<String?> _lerString(String chave) async {
    final prefs = await _getPrefs();
    return prefs.getString(chave);
  }

  Future<void> _escreverString(String chave, String? valor) async {
    final prefs = await _getPrefs();
    if (valor == null) {
      await prefs.remove(chave);
    } else {
      await prefs.setString(chave, valor);
    }
  }

  // ---------------------------------------------------------------------------
  // Chaves — centralizadas para evitar typo
  // ---------------------------------------------------------------------------

  static const _kUsuarios = 'usuarios';
  static const _kSessaoUid = 'sessao_uid';

  // ---------------------------------------------------------------------------
  // Usuarios (cadastro)
  // ---------------------------------------------------------------------------

  /// Lista todos os usuarios cadastrados.
  Future<List<Map<String, dynamic>>> listarUsuarios() => _lerLista(_kUsuarios);

  /// Retorna o usuario com o [uid] informado (ou null se nao existir).
  Future<Map<String, dynamic>?> buscarUsuario(String uid) async {
    final todos = await listarUsuarios();
    for (final u in todos) {
      if (u['uid'] == uid) return u;
    }
    return null;
  }

  /// Retorna o usuario cujo email bate com [email] (ou null).
  Future<Map<String, dynamic>?> buscarUsuarioPorEmail(String email) async {
    final todos = await listarUsuarios();
    final norm = email.trim().toLowerCase();
    for (final u in todos) {
      if ((u['email'] as String?)?.toLowerCase() == norm) return u;
    }
    return null;
  }

  /// Persiste (ou atualiza) um usuario.
  Future<void> salvarUsuario(Map<String, dynamic> usuario) async {
    final todos = await listarUsuarios();
    final idx = todos.indexWhere((u) => u['uid'] == usuario['uid']);
    if (idx >= 0) {
      todos[idx] = usuario;
    } else {
      todos.add(usuario);
    }
    await _escreverLista(_kUsuarios, todos);
  }

  // ---------------------------------------------------------------------------
  // Sessao (usuario logado)
  // ---------------------------------------------------------------------------

  Future<String?> lerSessaoUid() => _lerString(_kSessaoUid);
  Future<void> escreverSessaoUid(String? uid) => _escreverString(_kSessaoUid, uid);

  // ---------------------------------------------------------------------------
  // Receita do usuario (espaco reservado para futuro)
  // ---------------------------------------------------------------------------

  static const _kReceitasUsuario = 'receitas_usuario';
  Future<List<Map<String, dynamic>>> listarReceitasUsuario(String uid) async {
    final todas = await _lerLista(_kReceitasUsuario);
    return todas
        .where((r) => r['autorUid'] == uid)
        .toList(growable: false);
  }

  Future<void> salvarReceitaUsuario(Map<String, dynamic> receita) async {
    final todas = await _lerLista(_kReceitasUsuario);
    final idx = todas.indexWhere((r) => r['id'] == receita['id']);
    if (idx >= 0) {
      todas[idx] = receita;
    } else {
      todas.add(receita);
    }
    await _escreverLista(_kReceitasUsuario, todas);
  }

  Future<void> removerReceitaUsuario(String id) async {
    final todas = await _lerLista(_kReceitasUsuario);
    todas.removeWhere((r) => r['id'] == id);
    await _escreverLista(_kReceitasUsuario, todas);
  }

  // ---------------------------------------------------------------------------
  // Contador de acessos (Free 20min) — chave inclui dia para resetar diario
  // ---------------------------------------------------------------------------

  Future<int> lerContadorAcessos(String uid, DateTime dia) async {
    final chave = 'acessos_${uid}_${_formatarDia(dia)}';
    final prefs = await _getPrefs();
    return prefs.getInt(chave) ?? 0;
  }

  Future<void> escreverContadorAcessos(String uid, DateTime dia, int valor) async {
    final chave = 'acessos_${uid}_${_formatarDia(dia)}';
    final prefs = await _getPrefs();
    await prefs.setInt(chave, valor);
  }

  String _formatarDia(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return '${d.year}$m$dia';
  }

  // ---------------------------------------------------------------------------
  // Wipe total (util para testes)
  // ---------------------------------------------------------------------------

  Future<void> limparTudo() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }
}
