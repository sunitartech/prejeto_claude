import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

/// Tela inicial do app. Decide automaticamente se mostra o onboarding
/// (`/welcome`) ou a tela principal (`/home`) com base no estado de auth.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espera o primeiro emit do authStateChanges e redireciona.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirecionar();
    });
  }

  void _redirecionar() {
    final auth = ref.read(authStateChangesProvider);
    auth.when(
      data: (user) {
        if (!mounted) return;
        if (user == null) {
          context.go('/welcome');
        } else {
          context.go('/home');
        }
      },
      loading: () {
        // Mantem splash. O redirect do router cuida quando o stream emitir.
      },
      error: (_, __) {
        if (!mounted) return;
        context.go('/welcome');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo estilizado por enquanto — sem asset
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.eco,
                size: 56,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Fitnho',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lanches saudaveis, do seu jeito',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
