import 'package:flutter/material.dart';
import 'package:frontend/models/study_note.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key, required this.note});

  final StudyNote note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.title)),

      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(note.content),
          ),
        ),
      ),
    );
  }
}
