import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/quiz/quiz_play_data.dart';
import 'package:frontend/models/answer_option.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/providers/load_quiz_play_data_provider.dart';
import 'package:frontend/screens/quiz_result_screen.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizPlayScreen extends ConsumerStatefulWidget {
  const QuizPlayScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  ConsumerState<QuizPlayScreen> createState() {
    return _QuizPlayScreenState();
  }
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswerOptionId;
  bool _hasAnswered = false;
  int _correctAnswersCount = 0;

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

  void _goToNextQuestion(QuizPlayData quizPlayData) {
    final nextQuestionIndex = _currentQuestionIndex + 1;

    if (nextQuestionIndex >= quizPlayData.questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            quiz: widget.quiz,
            correctAnswersCount: _correctAnswersCount,
            totalQuestions: quizPlayData.questions.length,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentQuestionIndex = nextQuestionIndex;
      _selectedAnswerOptionId = null;
      _hasAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizPlayDataAsync = ref.watch(quizPlayDataProvider(widget.quiz.id));
    final appBarTheme = Theme.of(context).appBarTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final mainContent = quizPlayDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load quiz data.')),
      data: (quizPlayData) {
        if (quizPlayData.questions.isEmpty) {
          return const Center(child: Text('No questions found for this quiz.'));
        }

        final currentQuestion = quizPlayData.questions[_currentQuestionIndex];

        final currentAnswerOptions =
            quizPlayData.answerOptionsByQuestionId[currentQuestion.id] ?? [];

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = ResponsiveBreakpoints.isDesktopOrWider(
              constraints.maxWidth,
            );
            final questionCard = Card(
              color: appBarTheme.backgroundColor ?? colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MarkdownBody(
                  data: currentQuestion.markdownText,
                  styleSheet: MarkdownStyleSheet(
                    p: GoogleFonts.sourceSans3(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color:
                          appBarTheme.foregroundColor ?? colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            );
            final answers = ListView.builder(
              itemCount: currentAnswerOptions.length,
              itemBuilder: (context, index) {
                final answerOption = currentAnswerOptions[index];

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

                final hasFeedbackColor =
                    _hasAnswered && (isCorrect || isSelected);
                final answerTextColor = hasFeedbackColor
                    ? Colors.black
                    : colorScheme.onPrimaryContainer;
                final answerIconColor = _hasAnswered && isCorrect
                    ? const Color(0xFF2F855A)
                    : _hasAnswered && isSelected && !isCorrect
                    ? const Color(0xFFB91C1C)
                    : colorScheme.onPrimaryContainer;

                return Card(
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(
                      _hasAnswered && isCorrect
                          ? Icons.check_circle
                          : isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: answerIconColor,
                    ),
                    title: MarkdownBody(
                      data: answerOption.markdownText,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: answerTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      _selectAnswer(answerOption);
                    },
                  ),
                );
              },
            );
            final nextButton = _hasAnswered
                ? FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          appBarTheme.backgroundColor ?? colorScheme.primary,
                      foregroundColor:
                          appBarTheme.foregroundColor ?? colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      _goToNextQuestion(quizPlayData);
                    },
                    child: Text(
                      _currentQuestionIndex == quizPlayData.questions.length - 1
                          ? 'Finish quiz'
                          : 'Next question',
                    ),
                  )
                : const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${quizPlayData.questions.length}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: questionCard),
                              const SizedBox(width: 24),
                              Expanded(child: answers),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              questionCard,
                              const SizedBox(height: 24),
                              Expanded(child: answers),
                            ],
                          ),
                  ),
                  if (_hasAnswered) ...[
                    const SizedBox(height: 12),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: nextButton,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.name)),
      body: ResponsiveContent(maxWidth: 1100, child: mainContent),
    );
  }
}
