/// Representacao de dominio do usuario autenticado no Fitnho.
///
/// Nesta versao de testes (sem Firebase), o [AppUser] e construido a
/// partir do banco local (SharedPreferences) e nao depende de
/// `firebase_auth`.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
  });

  final String uid;
  final String? email;
  final String? displayName;

  /// Construtor a partir de um mapa do banco local.
  /// Retorna `null` se o mapa for null.
  static AppUser? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
    );
  }

  /// Serializa para o formato do banco local.
  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
      };

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
