import 'package:flutter/material.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/answer_option.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/repositories/contracts/answeroptionsrepository.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';
import 'package:frontend/screens/quiz_result_screen.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<QuizPlayScreen> createState() {
    return _QuizPlayScreenState();
  }
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  final QuestionsRepository _questionsRepository = getIt<QuestionsRepository>();
  final AnswerOptionsRepository _answerOptionsRepository =
      getIt<AnswerOptionsRepository>();

  List<Question> _questions = [];
  List<AnswerOption> _currentAnswerOptions = [];

  int _currentQuestionIndex = 0;
  String? _selectedAnswerOptionId;
  bool _hasAnswered = false;
  bool _isLoading = true;
  int _correctAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    final loadedQuestions = await _questionsRepository.getQuestionsByQuizId(
      widget.quiz.id,
    );

    if (loadedQuestions.isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _questions = [];
        _currentAnswerOptions = [];
        _isLoading = false;
      });

      return;
    }

    final firstQuestion = loadedQuestions[0];

    final loadedAnswerOptions = await _answerOptionsRepository
        .getAnswerOptionsByQuestionId(firstQuestion.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _questions = loadedQuestions;
      _currentAnswerOptions = loadedAnswerOptions;
      _currentQuestionIndex = 0;
      _selectedAnswerOptionId = null;
      _hasAnswered = false;
      _isLoading = false;
    });
  }

  Future<void> _goToNextQuestion() async {
    final nextQuestionIndex = _currentQuestionIndex + 1;

    if (nextQuestionIndex >= _questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            quiz: widget.quiz,
            correctAnswersCount: _correctAnswersCount,
            totalQuestions: _questions.length,
          ),
        ),
      );
      return;
    }

    final nextQuestion = _questions[nextQuestionIndex];

    final loadedAnswerOptions = await _answerOptionsRepository
        .getAnswerOptionsByQuestionId(nextQuestion.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _currentQuestionIndex = nextQuestionIndex;
      _currentAnswerOptions = loadedAnswerOptions;
      _selectedAnswerOptionId = null;
      _hasAnswered = false;
    });
  }

  void _selectAnswer(AnswerOption answerOption) {
    if (_hasAnswered) {
      return;
    }

    setState(() {
      _selectedAnswerOptionId = answerOption.id;
      _hasAnswered = true;

      if (answerOption.isCorrect) {
        _correctAnswersCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (_questions.isEmpty) {
      mainContent = const Center(
        child: Text('No questions found for this quiz.'),
      );
    } else {
      final currentQuestion = _questions[_currentQuestionIndex];

      mainContent = Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              color: const Color(0xFFFFF3B0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(currentQuestion.markdownText),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _currentAnswerOptions.length,
                itemBuilder: (context, index) {
                  final answerOption = _currentAnswerOptions[index];

                  final isSelected = _selectedAnswerOptionId == answerOption.id;
                  final isCorrect = answerOption.isCorrect;

                  Color? cardColor;

                  if (_hasAnswered && isSelected && isCorrect) {
                    cardColor = const Color(0xFFD1FAE5);
                  } else if (_hasAnswered && isSelected && !isCorrect) {
                    cardColor = const Color(0xFFFEE2E2);
                  } else if (_hasAnswered && isCorrect) {
                    cardColor = const Color(0xFFD1FAE5);
                  }

                  return Card(
                    color: cardColor,
                    child: ListTile(
                      leading: Icon(
                        _hasAnswered && isCorrect
                            ? Icons.check_circle
                            : isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: _hasAnswered && isCorrect
                            ? const Color(0xFF2F855A)
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      title: Text(answerOption.markdownText),
                      onTap: () {
                        _selectAnswer(answerOption);
                      },
                    ),
                  );
                },
              ),
            ),
            if (_hasAnswered)
              FilledButton(
                onPressed: _goToNextQuestion,
                child: Text(
                  _currentQuestionIndex == _questions.length - 1
                      ? 'Finish quiz'
                      : 'Next question',
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.name)),
      body: mainContent,
    );
  }
}
