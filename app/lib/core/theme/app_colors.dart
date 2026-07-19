import 'package:flutter/material.dart';

/// Paleta de cores do Fitnho.
///
/// Inspirada em verde-menta (saude, frescor) e coral (energia, apetite).
/// Os nomes sao em portugues para ficar claro o que cada cor representa.
class AppColors {
  const AppColors._();

  // Verde-menta — cor primaria
  static const Color verdeMenta = Color(0xFF26A69A);
  static const Color verdeMentaEscuro = Color(0xFF00796B);
  static const Color verdeMentaClaro = Color(0xFFB2DFDB);

  // Coral — cor secundaria
  static const Color coral = Color(0xFFFF6B6B);
  static const Color coralClaro = Color(0xFFFFAB91);

  // Fundo neutro
  static const Color areia = Color(0xFFFFF8F2);
  static const Color brancoGelo = Color(0xFFFAFAFA);

  // Texto
  static const Color cinzaTexto = Color(0xFF3A3A3A);
  static const Color cinzaSuave = Color(0xFF8A8A8A);
  static const Color cinzaClaro = Color(0xFFE0E0E0);

  // Premium — destaque dourado
  static const Color douradoPremium = Color(0xFFD4AF37);
  static const Color douradoPremiumClaro = Color(0xFFE8C766);
}
