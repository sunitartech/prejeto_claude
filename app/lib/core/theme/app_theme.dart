import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tema do Fitnho — Material 3 com a paleta verde-menta/coral.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.verdeMenta,
      secondary: AppColors.coral,
      surface: AppColors.brancoGelo,
      brightness: Brightness.light,
    );

    final TextTheme baseTextTheme = GoogleFonts.interTextTheme();
    final TextTheme poppinsTextTheme = GoogleFonts.poppinsTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.areia,
      textTheme: poppinsTextTheme.copyWith(
        headlineLarge: poppinsTextTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.cinzaTexto,
        ),
        headlineMedium: poppinsTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.cinzaTexto,
        ),
        titleLarge: poppinsTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.cinzaTexto,
        ),
        bodyLarge: poppinsTextTheme.bodyLarge?.copyWith(
          color: AppColors.cinzaTexto,
        ),
        bodyMedium: poppinsTextTheme.bodyMedium?.copyWith(
          color: AppColors.cinzaTexto,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.areia,
        foregroundColor: AppColors.cinzaTexto,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: poppinsTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.cinzaTexto,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.brancoGelo,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cinzaClaro),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cinzaClaro),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.verdeMenta,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.coral),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeMenta,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: poppinsTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.verdeMenta,
          side: const BorderSide(color: AppColors.verdeMenta, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.verdeMenta,
        foregroundColor: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.verdeMentaClaro,
        labelTextStyle: WidgetStatePropertyAll(
          poppinsTextTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.verdeMentaEscuro);
          }
          return const IconThemeData(color: AppColors.cinzaSuave);
        }),
      ),
    );
  }
}
