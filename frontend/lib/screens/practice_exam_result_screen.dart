import 'package:flutter/material.dart';
import 'package:frontend/models/practice_exam.dart';
import 'package:frontend/screens/practice_exam_play_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PracticeExamResultScreen extends StatelessWidget {
  const PracticeExamResultScreen({
    super.key,
    required this.practiceExam,
    required this.correctAnswersCount,
    required this.totalQuestions,
  });

  final PracticeExam practiceExam;
  final int correctAnswersCount;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final percentage = totalQuestions == 0
        ? 0
        : ((correctAnswersCount / totalQuestions) * 100).round();
    final incorrectAnswersCount = totalQuestions - correctAnswersCount;
    final hasPassed = percentage >= practiceExam.passingPercentage;

    return Scaffold(
      appBar: AppBar(title: Text(practiceExam.name)),
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
                      percent: percentage / 100,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: hasPassed
                          ? const Color(0xFF2F855A)
                          : const Color(0xFFB91C1C),
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
                      hasPassed ? 'Practice exam passed' : 'Keep practicing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isCompact ? 22 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$correctAnswersCount correct | '
                      '$incorrectAnswersCount incorrect | '
                      'Required: ${practiceExam.passingPercentage}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: isCompact ? 24 : 72),
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
                            builder: (context) => PracticeExamPlayScreen(
                              practiceExam: practiceExam,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Retry practice exam'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to practice exams'),
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
