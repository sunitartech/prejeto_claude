import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Widget raiz do Fitnho.
///
/// Configura o [MaterialApp.router] com:
/// - Tema Material 3 (paleta verde-menta/coral)
/// - Locale pt-BR (rotulos, formatacao de data, etc.)
/// - Roteador injetado via Riverpod
class FitnhoApp extends ConsumerWidget {
  const FitnhoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouterConfig routerConfig = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Fitnho',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      themeMode: ThemeMode.system,
      // Forca o locale pt-BR para toda a UI (formatacao de datas, etc.)
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: routerConfig.router,
    );
  }
}
