import 'package:flutter/material.dart';
import 'package:frontend/screens/start_screen.dart';

import 'local/tostore/studyflow_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF14213D));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StudyFlowDatabase.initialize();

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: colorScheme.onPrimaryContainer,
            foregroundColor: colorScheme.primaryContainer,
          ),
          iconTheme: const IconThemeData().copyWith(
            color: colorScheme.onPrimaryContainer,
            size: 30.0,
          ),
          cardTheme: CardThemeData().copyWith(
            color: colorScheme.primaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
          ),
          textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondaryContainer,
              fontSize: 24,
            ),
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondaryContainer,
              fontSize: 22,
            ),
          ),
        ),
        home: StartScreen(),
      ),
    ),
  );
}
