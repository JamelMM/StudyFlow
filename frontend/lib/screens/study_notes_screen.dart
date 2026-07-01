import 'package:flutter/material.dart';
import 'package:frontend/data/example_data.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/screens/note_screen.dart';

class StudyNotesScreen extends StatelessWidget {
  const StudyNotesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final notes = exampleStudyNotes.where((studyNote) {
      return studyNote.topicId == topic.id;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(topic.name)),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteScreen(note: note),
                    ),
                  );
                },

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.topic),
                      const SizedBox(width: 12),
                      Text(note.title),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
