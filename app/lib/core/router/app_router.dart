import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/recipes/presentation/screens/home_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../../features/recipes/presentation/screens/search_screen.dart';
import '../widgets/app_shell.dart';

/// Wrapper para expor o [GoRouter] ao `MaterialApp.router`.
class GoRouterConfig {
  const GoRouterConfig(this.router);
  final GoRouter router;
}

/// Provider do router. Escuta o `authStateChangesProvider` para redirecionar
/// entre `/welcome` e `/home` quando o usuario loga ou desloga.
final appRouterProvider = Provider<GoRouterConfig>((ref) {
  // Notifier customizado que escuta o stream de auth e dispara refresh
  final notifier = _AuthRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);

  final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: kDebugMode,
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authStateChangesProvider);
      final loggedIn = auth.valueOrNull != null;
      final loc = state.matchedLocation;
      final indoParaAuth =
          loc == '/splash' ||
          loc == '/welcome' ||
          loc == '/login' ||
          loc == '/register';

      // Se o estado de auth ainda esta carregando, fica na splash
      if (auth.isLoading && loc == '/splash') return null;

      if (!loggedIn && !indoParaAuth) return '/welcome';
      if (loggedIn && indoParaAuth && loc != '/splash') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),

      // Shell com 4 abas (apos login)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/busca', builder: (_, _) => const SearchScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favoritos',
                builder: (_, _) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/perfil',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Detalhe de receita (fullscreen, fora do shell)
      GoRoute(
        path: '/receita/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RecipeDetailScreen(receitaId: id);
        },
      ),
    ],
  );

  return GoRouterConfig(router);
});

/// `ChangeNotifier` que escuta o stream de auth do Firebase e dispara
/// refresh no [GoRouter] para que o `redirect` reavalie a rota atual.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    // `ref.listen` reage a cada novo [AsyncValue] do provider, incluindo
    // a transicao de `loading` para `data` (login confirmado).
    _sub = ref.listen<AsyncValue<dynamic>>(
      authStateChangesProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AsyncValue<dynamic>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
