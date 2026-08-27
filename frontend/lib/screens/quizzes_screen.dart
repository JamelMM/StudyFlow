import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/quizzes_controller.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/quiz_play_screen.dart';
import 'package:frontend/screens/quiz_questions_screen.dart';
import 'package:frontend/providers/validate_quiz_can_start_provider.dart';

class QuizzesScreen extends ConsumerStatefulWidget {
  const QuizzesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  ConsumerState<QuizzesScreen> createState() {
    return _QuizzesScreenState();
  }
}

class _QuizzesScreenState extends ConsumerState<QuizzesScreen> {
  Future<void> _createQuiz() async {
    await ref
        .read(quizzesControllerProvider(widget.topic.id).notifier)
        .addQuiz(name: widget.topic.name);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz successfully created', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  Future<void> _startQuiz(Quiz quiz) async {
    final validateQuizCanStart = ref.read(validateQuizCanStartProvider);

    final errorMessage = await validateQuizCanStart(quiz.id);

    if (!mounted) {
      return;
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage, textAlign: TextAlign.center)),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPlayScreen(quiz: quiz)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizzesAsync = ref.watch(quizzesControllerProvider(widget.topic.id));

    Widget mainContent = quizzesAsync.when(
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load quiz.')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (quiz) {
        if (quiz == null) {
          return EmptyStateMessage(
            icon: Icons.quiz_outlined,
            title: 'No quiz yet.',
            message: 'Create your first quiz for this topic.',
            buttonText: 'Create quiz',
            onPressed: _createQuiz,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 360,
                child: Card(
                  color: const Color(0xFFFFF3B0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.quiz, size: 80),
                        const SizedBox(height: 64),
                        Text(
                          quiz.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: () {
                  _startQuiz(quiz);
                },
                child: const Text('Start quiz'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizQuestionsScreen(quiz: quiz),
                    ),
                  );
                },
                child: const Text('Manage questions'),
              ),
            ],
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Quiz',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
