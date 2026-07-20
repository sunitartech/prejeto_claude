import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/local_db/local_db.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

/// Provider do banco local (singleton).
final localDbProvider = Provider<LocalDb>((ref) {
  return LocalDb();
});

/// Provider do repositorio de autenticacao (singleton).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(db: ref.watch(localDbProvider));
});

/// Stream que emite o [AppUser] atual (ou `null` se nao logado).
///
/// E o provider que o router escuta para redirecionar entre
/// `/welcome` e `/home`.
final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Estado de UI do controlador de auth: usado pelas telas de
/// login/cadastro para mostrar loading e erros.
class AuthUiState {
  const AuthUiState({this.isLoading = false, this.errorMessage});
  final bool isLoading;
  final String? errorMessage;

  AuthUiState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier com as acoes de autenticacao: login, cadastro, logout.
///
/// As acoes sao `async` mas NAO retornam nada — quem chama observa
/// o [authStateChangesProvider] para saber se a operacao deu certo
/// (mais limpo do que acoplar retorno de cada acao na UI).
class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() => const AuthUiState();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authRepositoryProvider).signInWithEmail(
            email: email,
            password: password,
          );
      state = const AuthUiState();
    } on AuthException catch (e) {
      state = AuthUiState(errorMessage: e.message);
    } catch (_) {
      state = const AuthUiState(
        errorMessage: 'Nao foi possivel entrar. Tente novamente.',
      );
    }
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authRepositoryProvider).registerWithEmail(
            email: email,
            password: password,
            displayName: displayName,
          );
      state = const AuthUiState();
    } on AuthException catch (e) {
      state = AuthUiState(errorMessage: e.message);
    } catch (_) {
      state = const AuthUiState(
        errorMessage: 'Nao foi possivel criar a conta. Tente novamente.',
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AuthUiState();
    } catch (_) {
      state = const AuthUiState(
        errorMessage: 'Nao foi possivel sair. Tente novamente.',
      );
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthUiState>(AuthController.new);
