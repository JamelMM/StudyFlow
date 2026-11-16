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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 500;
          final minimumHeight = constraints.maxHeight > 32
              ? constraints.maxHeight - 32
              : 0.0;
          final minimumWidth = constraints.maxWidth > 32
              ? constraints.maxWidth - 32
              : 0.0;
          final logoSize = isCompact ? 96.0 : 140.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minimumHeight,
                minWidth: minimumWidth,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'StudyFlow',
                      style: GoogleFonts.inter(
                        fontSize: isCompact ? 34 : 48,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: isCompact ? 24 : 80),
                    Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        color: logoBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_stories,
                        size: isCompact ? 84 : 126,
                        color: logoColor,
                      ),
                    ),
                    SizedBox(height: isCompact ? 24 : 100),
                    Text(
                      'Learn. Organize. Remember.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
