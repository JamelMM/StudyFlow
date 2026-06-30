import 'package:flutter/material.dart';
import 'package:frontend/data/example_data.dart';
import 'package:frontend/screens/topics_screen.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyFlow'), centerTitle: true),
      body: ListView.builder(
        itemCount: exampleSubjects.length,
        itemBuilder: (context, index) {
          final subject = exampleSubjects[index];

          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicsScreen(subject: subject),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.school),
                    const SizedBox(width: 12),
                    Text(subject.name),
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
