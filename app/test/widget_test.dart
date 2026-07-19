// Smoke test para o Fitnho.
//
// Verifica que o widget raiz consegue ser construido sem erro.
// Substitui o teste default do `flutter create` (que referenciava
// o contador antigo).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitnho/app.dart';

void main() {
  testWidgets('App constroi sem erro', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FitnhoApp(),
      ),
    );

    // Nao precisa verificar o conteudo especifico (depende de Firebase
    // e do estado async). Apenas garante que a arvore nao quebra ao construir.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
