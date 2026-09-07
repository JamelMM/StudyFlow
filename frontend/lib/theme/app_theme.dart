import 'package:flutter/material.dart';

final lightColorScheme =
    ColorScheme.fromSeed(seedColor: const Color(0xFF14213D)).copyWith(
      secondaryContainer: const Color(0xFFFFF3B0),
      onSecondaryContainer: const Color(0xFF14213D),
    );

const darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF8EA7E9),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFF263A6B),
  onPrimaryContainer: Color(0xFFE5E7EB),
  secondary: Color(0xFF93C5FD),
  onSecondary: Color(0xFF0F172A),
  secondaryContainer: Color(0xFF0F172A),
  onSecondaryContainer: Color(0xFFE5E7EB),
  surface: Color(0xFF1F2937),
  onSurface: Color(0xFFE5E7EB),
  error: Color(0xFFFCA5A5),
);

final lightTheme = ThemeData().copyWith(
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.onPrimaryContainer,
    foregroundColor: lightColorScheme.primaryContainer,
  ),
  iconTheme: IconThemeData(
    color: lightColorScheme.onPrimaryContainer,
    size: 30.0,
  ),
  cardTheme: CardThemeData(
    color: lightColorScheme.primaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
  ),
  textTheme: ThemeData().textTheme.copyWith(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: lightColorScheme.onSecondaryContainer,
      fontSize: 24,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
      color: lightColorScheme.onSecondaryContainer,
      fontSize: 22,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: lightColorScheme.onPrimaryContainer,
    selectedItemColor: lightColorScheme.primaryContainer,
    unselectedItemColor: lightColorScheme.primaryContainer.withValues(
      alpha: 0.6,
    ),
    selectedIconTheme: IconThemeData(
      color: lightColorScheme.primaryContainer,
      size: 28,
    ),
    unselectedIconTheme: IconThemeData(
      color: lightColorScheme.primaryContainer.withValues(alpha: 0.6),
      size: 24,
    ),
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E2F5C),
    foregroundColor: Color(0xFFE5E7EB),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF8EA7E9), size: 30.0),
  cardTheme: const CardThemeData(
    color: Color(0xFF263A6B),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
    titleLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 6, 6, 6),
      fontSize: 24,
    ),
    titleMedium: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFE5E7EB),
      fontSize: 22,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E2F5C),
    selectedItemColor: Color(0xFFE5E7EB),
    unselectedItemColor: Color(0xFF9CA3AF),
    selectedIconTheme: IconThemeData(color: Color(0xFFE5E7EB), size: 28),
    unselectedIconTheme: IconThemeData(color: Color(0xFF9CA3AF), size: 24),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  ),
);
