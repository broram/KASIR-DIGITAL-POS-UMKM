import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFFF7F1E3);
  static const surfaceBeige = Color(0xFFFBF7EC);
  static const surfaceSage = Color(0xFFC9D3C0);
  static const surfaceSand = Color(0xFFEFE6D2);
  static const line = Color(0xFFE9DFCB);
  static const textPrimary = Color(0xFF1F3D2F);
  static const textSecondary = Color(0xFF3F5045);
  static const gold = Color(0xFFD1B574);
  static const cream = Color(0xFFF4EDDD);

  static const _charcoal = textPrimary;
  static const _canvas = background;

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _charcoal,
      surface: _canvas,
      brightness: Brightness.light,
    );

    final editorialScheme = colorScheme.copyWith(
      primary: _charcoal,
      onPrimary: Colors.white,
      primaryContainer: surfaceBeige,
      onPrimaryContainer: textPrimary,
      secondary: textSecondary,
      onSecondary: Colors.white,
      secondaryContainer: surfaceBeige,
      onSecondaryContainer: textPrimary,
      surface: background,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: line,
      outlineVariant: line,
    );

    final theme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: _canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: _canvas,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceBeige,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: Colors.transparent,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(color: textPrimary, fontSize: 12),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: line)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _charcoal, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3261E)),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3261E), width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: _charcoal,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          foregroundColor: _charcoal,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: textPrimary),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: textPrimary),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
      listTileTheme: const ListTileThemeData(
        iconColor: textPrimary,
        textColor: textPrimary,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      splashFactory: InkSparkle.splashFactory,
    );

    return theme.copyWith(
      colorScheme: editorialScheme,
      textTheme: theme.textTheme.copyWith(
        headlineLarge: theme.textTheme.headlineLarge?.copyWith(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
          height: 1.05,
        ),
        headlineMedium: theme.textTheme.headlineMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
        ),
        headlineSmall: theme.textTheme.headlineSmall?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: theme.textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: theme.textTheme.titleMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: theme.textTheme.bodyLarge?.copyWith(
          color: textPrimary,
          height: 1.6,
        ),
        bodyMedium: theme.textTheme.bodyMedium?.copyWith(
          color: textSecondary,
          height: 1.5,
        ),
        bodySmall: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
        labelLarge: theme.textTheme.labelLarge?.copyWith(color: textPrimary),
      ),
    );
  }
}
