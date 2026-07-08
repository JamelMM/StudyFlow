import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'subject_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    // Configura el tiempo de espera (por ejemplo, 3 segundos)
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SubjectScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'StudyFlow',
              style: GoogleFonts.inter(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 80),
            IconButton.filledTonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubjectScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.auto_stories, size: 128),
            ),
            // Un indicador de carga
            SizedBox(height: 100),
            Text(
              "Learn. Organize. Remember.",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
