import 'package:flutter/material.dart';
import 'package:frontend/models/quiz.dart';

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<QuizQuestionsScreen> createState() {
    return _QuizQuestionsScreenState();
  }
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.name)),
      body: const Center(child: Text('Questions screen')),
    );
  }
}
