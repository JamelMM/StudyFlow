import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:google_fonts/google_fonts.dart';

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
      name: '${widget.topic.name} Quiz',
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
      title = quiz.name;

      mainContent = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: double.infinity,
              height: 160,
              child: Card(
                elevation: 12,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.quiz, size: 64),
                        const SizedBox(height: 12),
                        Text(
                          quiz.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
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
            ),
            const SizedBox(height: 36),
            FilledButton(onPressed: () {}, child: const Text('Start quiz')),
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
