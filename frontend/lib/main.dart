import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/app_shell/presentation/screens/start_screen.dart';
import 'package:frontend/core/theme/app_theme.dart';

import 'package:frontend/core/database/studyflow_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StudyFlowDatabase.initialize();

  runApp(const ProviderScope(child: StudyFlowApp()));
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const StartScreen(),
    );
  }
}
