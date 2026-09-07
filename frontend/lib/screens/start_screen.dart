import 'package:flutter/material.dart';

import 'package:frontend/screens/mode_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final logoBackgroundColor = isDarkMode
        ? const Color(0xFF263A6B)
        : colorScheme.primaryContainer;
    final logoColor = isDarkMode
        ? colorScheme.secondaryContainer
        : appBarTheme.backgroundColor ?? colorScheme.onPrimaryContainer;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'StudyFlow',
              style: GoogleFonts.inter(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 80),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: logoBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories,
                size: 126,
                color: logoColor,
              ),
            ),
            const SizedBox(height: 100),
            Text(
              "Learn. Organize. Remember.",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
