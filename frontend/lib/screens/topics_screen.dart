import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/data/example_data.dart';
import 'package:frontend/screens/study_notes_screen.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final subjectTopics = exampleTopics.where((topic) {
      return topic.subjectId == subject.id;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: ListView.builder(
        itemCount: subjectTopics.length,
        itemBuilder: (context, index) {
          final topic = subjectTopics[index];

          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyNotesScreen(topic: topic),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.topic),
                    const SizedBox(width: 12),
                    Text(topic.name),
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
