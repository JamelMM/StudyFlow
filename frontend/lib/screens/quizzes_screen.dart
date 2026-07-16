import 'package:flutter/material.dart';
import 'package:frontend/models/topic.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Quizzes')));
  }
}
