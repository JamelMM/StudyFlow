import 'package:flutter/material.dart';
import 'package:frontend/features/quiz/domain/models/quiz.dart';
import 'package:frontend/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.correctAnswersCount,
    required this.totalQuestions,
    required this.selectedSubtopicIds,
  });

  final Quiz quiz;
  final int correctAnswersCount;
  final int totalQuestions;
  final Set<String> selectedSubtopicIds;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 600;
          final minimumHeight = constraints.maxHeight > 32
              ? constraints.maxHeight - 32
              : 0.0;
          final minimumWidth = constraints.maxWidth > 32
              ? constraints.maxWidth - 32
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minimumHeight,
                minWidth: minimumWidth,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularPercentIndicator(
                      radius: isCompact ? 70 : 100,
                      lineWidth: isCompact ? 12 : 16,
                      percent: progressValue,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: colorScheme.onPrimaryContainer,
                      backgroundColor: colorScheme.primaryContainer,
                      center: Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: isCompact ? 26 : 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: isCompact ? 16 : 32),
                    Text(
                      '$correctAnswersCount / $totalQuestions correct',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isCompact ? 22 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isCompact ? 12 : 24),
                    Text(
                      resultMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: isCompact ? 24 : 96),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            appBarTheme.backgroundColor ?? colorScheme.primary,
                        foregroundColor:
                            appBarTheme.foregroundColor ??
                            colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPlayScreen(
                              quiz: quiz,
                              selectedSubtopicIds: selectedSubtopicIds,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Retry quiz'),
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
            ),
          );
        },
      ),
    );
  }
}
