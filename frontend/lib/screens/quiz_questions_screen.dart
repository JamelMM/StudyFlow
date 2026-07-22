import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';
import 'package:frontend/screens/new_question.dart';
import 'package:frontend/widgets/empty_state_message.dart';

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<QuizQuestionsScreen> createState() {
    return _QuizQuestionsScreenState();
  }
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  final QuestionsRepository _questionsRepository = getIt<QuestionsRepository>();

  List<Question> _questions = [];

  bool _isLoading = true;

  Future<void> _loadQuestions() async {
    final loadedQuestions = await _questionsRepository.getQuestionsByQuizId(
      widget.quiz.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _questions = loadedQuestions;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _addQuestion(String markdownText) async {
    await _questionsRepository.addQuestion(
      quizId: widget.quiz.id,
      markdownText: markdownText,
    );

    await _loadQuestions();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Question successfully created',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  void _openAddQuestionOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return NewQuestion(onAddQuestion: _addQuestion);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (_questions.isEmpty) {
      mainContent = EmptyStateMessage(
        icon: Icons.quiz_outlined,
        title: 'No questions yet.',
        message: 'Create your first question for this quiz.',
        buttonText: 'Add question',
        onPressed: _openAddQuestionOverlay,
      );
    } else {
      mainContent = ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(question.markdownText),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.name)),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text('Questions'),
            const SizedBox(height: 30),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
