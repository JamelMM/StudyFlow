import 'package:flutter/material.dart';
import 'package:frontend/models/study_note.dart';
import 'package:frontend/widgets/studyflow_screen_body.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key, required this.note});

  final StudyNote note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.name)),
      body: StudyFlowScreenBody(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Study Note',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(note.markdownText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
