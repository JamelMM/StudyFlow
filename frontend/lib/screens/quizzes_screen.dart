import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/quiz_play_screen.dart';
import 'package:frontend/screens/quiz_questions_screen.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';
import 'package:frontend/repositories/contracts/answeroptionsrepository.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  State<QuizzesScreen> createState() {
    return _QuizzesScreenState();
  }
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final QuizzesRepository _quizzesRepository = getIt<QuizzesRepository>();
  final AnswerOptionsRepository _answerOptionsRepository =
      getIt<AnswerOptionsRepository>();
  final QuestionsRepository _questionsRepository = getIt<QuestionsRepository>();

  Quiz? _quiz;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final loadedQuiz = await _quizzesRepository.getQuizByTopicId(
      widget.topic.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _quiz = loadedQuiz;
      _isLoading = false;
    });
  }

  Future<void> _createQuiz() async {
    await _quizzesRepository.addQuiz(
      name: widget.topic.name,
      topicId: widget.topic.id,
    );

    await _loadQuiz();

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
    final questions = await _questionsRepository.getQuestionsByQuizId(quiz.id);

    if (questions.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add at least one question before starting the quiz.',
            textAlign: TextAlign.center,
          ),
        ),
      );

      return;
    }

    for (final question in questions) {
      final answers = await _answerOptionsRepository
          .getAnswerOptionsByQuestionId(question.id);

      if (answers.isEmpty) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Every question needs at least one answer.',
              textAlign: TextAlign.center,
            ),
          ),
        );

        return;
      }

      final hasCorrectAnswer = answers.any((answer) => answer.isCorrect);

      if (!hasCorrectAnswer) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Every question needs one correct answer.',
              textAlign: TextAlign.center,
            ),
          ),
        );
        return;
      }
    }

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPlayScreen(quiz: quiz)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quiz;

    Widget mainContent;
    String title = 'Quiz';

    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (quiz == null) {
      mainContent = EmptyStateMessage(
        icon: Icons.quiz_outlined,
        title: 'No quiz yet.',
        message: 'Create your first quiz for this topic.',
        buttonText: 'Create quiz',
        onPressed: _createQuiz,
      );
    } else {
      mainContent = Padding(
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
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
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
