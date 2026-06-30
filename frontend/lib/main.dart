import 'package:flutter/material.dart';
import 'package:frontend/screens/subject_screen.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF14213D));

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: colorScheme,

        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: colorScheme.onPrimaryContainer,
          foregroundColor: colorScheme.primaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: colorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
            fontSize: 20,
          ),
        ),
      ),
      home: SubjectScreen(),
    ),
  );
}
