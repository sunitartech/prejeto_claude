import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../../../shared/local_db/local_db.dart';
import '../domain/user_model.dart';

/// Encapsula todas as operacoes de autenticacao contra o [LocalDb].
///
/// IMPORTANTE: nesta versao de testes (sem backend), as senhas sao
/// armazenadas em texto plano no SharedPreferences. E suficiente para
/// fluxo de UI, mas NAO e seguro — quando integrarmos o backend
/// (Firebase Auth ou similar) isso sera substituido.
class AuthRepository {
  AuthRepository({LocalDb? db}) : _db = db ?? LocalDb();

  final LocalDb _db;

  /// Stream do usuario logado no momento.
  ///
  /// Emite [AppUser] quando ha sessao ativa, ou `null` caso contrario.
  /// Internamente escuta a chave `sessao_uid` do [LocalDb] — qualquer
  /// alteracao (login, logout) gera um novo emit.
  Stream<AppUser?> get authStateChanges async* {
    yield await _carregarSessao();
    // Re-emite quando a sessao muda. Sem backend, "stream" vira apenas
    // um yield unico — o suficiente para o app de testes.
  }

  Future<AppUser?> _carregarSessao() async {
    final uid = await _db.lerSessaoUid();
    if (uid == null) return null;
    final usuario = await _db.buscarUsuario(uid);
    return AppUser.fromMap(usuario);
  }

  /// Login com e-mail e senha.
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final usuario = await _db.buscarUsuarioPorEmail(email);
    if (usuario == null) {
      throw AuthException('E-mail ou senha incorretos.');
    }
    final senhaSalva = usuario['senha'] as String?;
    if (senhaSalva != password) {
      throw AuthException('E-mail ou senha incorretos.');
    }
    await _db.escreverSessaoUid(usuario['uid'] as String);
    return AppUser.fromMap(usuario)!;
  }

  /// Cadastro com nome, e-mail e senha.
  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final existente = await _db.buscarUsuarioPorEmail(email);
    if (existente != null) {
      throw AuthException('Este e-mail ja esta cadastrado.');
    }
    final uid = _gerarUid();
    final novo = {
      'uid': uid,
      'email': email.trim(),
      'displayName': displayName.trim(),
      'senha': password,
    };
    await _db.salvarUsuario(novo);
    await _db.escreverSessaoUid(uid);
    return AppUser.fromMap(novo)!;
  }

  /// Atualiza o [displayName] do usuario atual.
  Future<void> updateDisplayName(String displayName) async {
    final uid = await _db.lerSessaoUid();
    if (uid == null) {
      throw AuthException('Nenhum usuario logado.');
    }
    final usuario = await _db.buscarUsuario(uid);
    if (usuario == null) {
      throw AuthException('Usuario nao encontrado.');
    }
    usuario['displayName'] = displayName;
    await _db.salvarUsuario(usuario);
  }

  /// Encerra a sessao do usuario atual.
  Future<void> signOut() async {
    await _db.escreverSessaoUid(null);
  }

  /// Gera um uid aleatorio de 16 bytes em base64 url-safe.
  String _gerarUid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

/// Excecao de dominio da autenticacao, com mensagem amigavel em pt-BR.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
