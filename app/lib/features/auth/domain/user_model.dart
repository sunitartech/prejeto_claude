import 'package:firebase_auth/firebase_auth.dart';

/// Representacao de dominio do usuario autenticado no Fitnho.
///
/// Encapsula apenas o que a UI/negocio precisa, sem vazar tipos do
/// `firebase_auth` para a camada de apresentacao.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
  });

  final String uid;
  final String? email;
  final String? displayName;

  /// Converte um [User] do Firebase Auth em [AppUser].
  /// Retorna `null` se o Firebase User for null (ninguem logado).
  static AppUser? fromFirebase(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  /// Primeiro nome do usuario, para saudacoes. Fallback para "voce".
  String get primeiroNome {
    if (displayName == null || displayName!.trim().isEmpty) return 'voce';
    final partes = displayName!.trim().split(RegExp(r'\s+'));
    return partes.first;
  }

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, displayName: $displayName)';
}
