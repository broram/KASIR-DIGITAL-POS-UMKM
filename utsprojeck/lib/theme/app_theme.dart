import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const forest = Color(0xFF1F3D2F);
  static const forestSoft = Color(0xFF2A4D3C);
  static const forestDeep = Color(0xFF16301F);
  static const teal = Color(0xFF2F5D5A);
  static const sage = Color(0xFFC9D3C0);
  static const brown = Color(0xFF6B4F3A);
  static const beige = Color(0xFFEFE6D2);
  static const cream = Color(0xFFF7F1E3);
  static const paper = Color(0xFFFBF7EC);
  static const gold = Color(0xFFD1B574);
  static const goldDeep = Color(0xFF8C6F2E);
  static const line = Color(0xFFD9CDB3);
  static const textSecondary = Color(0xFF3F5045);
  static const onDark = Color(0xFFF4EDDD);
  static const onDarkMuted = Color(0xFFE9DFCB);
  static const danger = Color(0xFF9B2C2C);

  static const background = cream;
  static const surfaceBeige = paper;
  static const surfaceSage = sage;
  static const surfaceSand = beige;
  static const textPrimary = forest;
  static const radiusCard = 24.0;
  static const radiusField = 16.0;

  static const forestGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [forestSoft, forest],
  );
  static const canvasGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [cream, beige],
  );
  static const softShadow = [
    BoxShadow(color: Color(0x241F3D2F), blurRadius: 22, offset: Offset(0, 10)),
  ];
  static const deepShadow = [
    BoxShadow(color: Color(0x471F3D2F), blurRadius: 28, offset: Offset(0, 14)),
  ];

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: forest,
          brightness: Brightness.light,
        ).copyWith(
          primary: forest,
          onPrimary: onDark,
          secondary: teal,
          onSecondary: onDark,
          tertiary: brown,
          onTertiary: onDark,
          surface: paper,
          onSurface: forest,
          onSurfaceVariant: textSecondary,
          surfaceContainerHighest: beige,
          outline: line,
          outlineVariant: line,
          error: danger,
          onError: Colors.white,
        );

    const textTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.6,
      ),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.6,
      ),
    );

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusField),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      textTheme: textTheme.apply(bodyColor: forest, displayColor: forest),
      appBarTheme: const AppBarTheme(
        backgroundColor: forest,
        foregroundColor: onDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        titleTextStyle: TextStyle(
          color: onDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: forest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: beige,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: border(line),
        enabledBorder: border(line),
        focusedBorder: border(forest, 1.5),
        errorBorder: border(danger),
        focusedErrorBorder: border(danger, 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: onDark,
          minimumSize: const Size(0, 54),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: onDark,
          minimumSize: const Size(0, 54),
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: forest,
          minimumSize: const Size(0, 54),
          shape: const StadiumBorder(),
          side: const BorderSide(color: line),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: forest,
          minimumSize: const Size(44, 44),
          shape: const StadiumBorder(),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          foregroundColor: forest,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: paper,
        elevation: 8,
        shadowColor: forest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: forest,
        contentTextStyle: const TextStyle(color: onDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: forest),
    );
  }
}
