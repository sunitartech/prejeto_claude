import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

/// Tela de boas-vindas. Mostra o logo, slogan e os botoes
/// "Entrar" e "Criar conta".
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo grande
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.verdeMentaClaro,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 72,
                    color: scheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Nome do app
              Text(
                'Fitnho',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppColors.verdeMentaEscuro),
              ),
              const SizedBox(height: 12),

              // Slogan
              Text(
                'Receitas praticas, rapidas e saudaveis\npara os seus lanches do dia a dia.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.cinzaSuave,
                      height: 1.5,
                    ),
              ),

              const Spacer(),

              // Botao principal: criar conta
              ElevatedButton(
                onPressed: () => context.push('/register'),
                child: const Text('Criar conta'),
              ),
              const SizedBox(height: 12),

              // Botao secundario: entrar
              OutlinedButton(
                onPressed: () => context.push('/login'),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
