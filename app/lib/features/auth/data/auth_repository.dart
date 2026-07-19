import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../domain/user_model.dart';

/// Encapsula todas as chamadas ao Firebase Auth.
///
/// Mantem a UI livre de detalhes do Firebase, expondo apenas
/// tipos do dominio (AppUser) e operacoes de alto nivel.
class AuthRepository {
  AuthRepository({fb.FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  /// Stream de mudancas no estado de autenticacao.
  /// Emite [AppUser] quando alguem esta logado, ou `null` caso contrario.
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges.map(AppUser.fromFirebase);
  }

  /// Login com e-mail e senha.
  ///
  /// Lanca [AuthException] com mensagem em portugues para qualquer
  /// erro do Firebase Auth.
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppUser.fromFirebase(credential.user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_traduzirErro(e));
    }
  }

  /// Cadastro com e-mail, senha e nome.
  /// Apos criar a conta, define o [displayName] do usuario.
  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      await credential.user?.reload();
      // Recarrega o user para pegar o displayName atualizado
      final user = _auth.currentUser;
      return AppUser.fromFirebase(user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_traduzirErro(e));
    }
  }

  /// Atualiza o [displayName] do usuario atual.
  Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw AuthException('Nenhum usuario logado.');
    }
    await user.updateDisplayName(displayName);
  }

  /// Encerra a sessao do usuario atual.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Traduz codigos de erro do Firebase para mensagens amigaveis em pt-BR.
  String _traduzirErro(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail invalido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail ja esta cadastrado.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Login por e-mail/senha nao esta habilitado no Firebase.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em alguns instantes.';
      case 'network-request-failed':
        return 'Sem conexao de internet. Verifique sua rede.';
      default:
        return 'Nao foi possivel concluir a operacao. Tente novamente.';
    }
  }
}

/// Excecao de dominio da autenticacao, com mensagem amigavel em pt-BR.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
