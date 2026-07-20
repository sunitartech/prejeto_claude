import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Ponto de entrada do Fitnho.
///
/// Sobe a arvore de widgets dentro de um [ProviderScope] do Riverpod.
/// A persistencia e feita localmente via SharedPreferences — sem Firebase
/// nesta versao de testes.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: FitnhoApp()));
}
