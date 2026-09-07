import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/start_screen.dart';
import 'package:frontend/theme/app_theme.dart';

import 'local/tostore/studyflow_database.dart';

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
