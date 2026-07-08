import 'package:flutter/material.dart';
import 'package:frontend/models/study_note.dart';

class StudyNoteListItem extends StatelessWidget {
  const StudyNoteListItem({super.key, required this.note, required this.onTap});

  final StudyNote note;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.notes),
              const SizedBox(width: 12),
              Expanded(child: Text(note.name)),
            ],
          ),
        ),
      ),
    );
  }
}
