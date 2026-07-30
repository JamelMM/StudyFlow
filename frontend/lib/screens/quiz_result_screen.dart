import 'package:flutter/material.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/screens/quiz_play_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.correctAnswersCount,
    required this.totalQuestions,
  });

  final Quiz quiz;
  final int correctAnswersCount;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final percentage = totalQuestions == 0
        ? 0
        : ((correctAnswersCount / totalQuestions) * 100).round();

    final progressValue = percentage / 100;

    String resultMessage;

    if (percentage == 100) {
      resultMessage = 'Excellent work!';
    } else if (percentage >= 70) {
      resultMessage = 'Good progress!';
    } else {
      resultMessage = 'Keep practicing!';
    }

    return Scaffold(
      appBar: AppBar(title: Text(quiz.name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularPercentIndicator(
              radius: 100,
              lineWidth: 16,
              percent: progressValue,
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Theme.of(context).colorScheme.onPrimaryContainer,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              center: Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '$correctAnswersCount / $totalQuestions correct',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(resultMessage, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 96),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPlayScreen(quiz: quiz),
                  ),
                );
              },
              child: const Text('Try again'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
