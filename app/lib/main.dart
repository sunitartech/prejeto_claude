import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

/// Ponto de entrada do Fitnho.
///
/// Inicializa o Firebase (com fallback amigavel se ainda nao foi configurado)
/// e sobe a arvore de widgets dentro de um [ProviderScope] do Riverpod.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _inicializarFirebase();

  runApp(const ProviderScope(child: FitnhoApp()));
}

/// Tenta inicializar o Firebase. Se o `firebase_options.dart` ainda for
/// o stub (projeto nao configurado), registra um erro e segue em frente —
/// o app abre normalmente e a UI mostra um aviso pedindo para configurar.
Future<void> _inicializarFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (erro) {
    // Caso o firebase_options seja stub (ainda nao foi feito flutterfire configure)
    // O `firebase_options.dart` stub nao lanca FirebaseException, mas mantemos
    // o catch generico para qualquer problema de inicializacao.
    _logErro('Firebase nao inicializou', erro);
  } catch (erro) {
    _logErro('Erro inesperado ao inicializar Firebase', erro);
  }
}

void _logErro(String mensagem, Object erro) {
  if (kDebugMode) {
    // ignore: avoid_print
    print('$mensagem: $erro');
  }
}
