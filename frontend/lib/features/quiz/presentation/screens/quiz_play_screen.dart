import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/application/use_cases/quiz_play_data.dart';
import 'package:frontend/features/quiz/domain/models/answer_option.dart';
import 'package:frontend/features/quiz/domain/models/quiz.dart';
import 'package:frontend/features/quiz/application/providers/load_quiz_play_data_provider.dart';
import 'package:frontend/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/core/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/question_explanation_card.dart';

class QuizPlayScreen extends ConsumerStatefulWidget {
  const QuizPlayScreen({
    super.key,
    required this.quiz,
    required this.selectedSubtopicIds,
  });

  final Quiz quiz;
  final Set<String> selectedSubtopicIds;

  @override
  ConsumerState<QuizPlayScreen> createState() {
    return _QuizPlayScreenState();
  }
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _selectedAnswerOptionIdsByQuestionId = {};
  int _correctAnswersCount = 0;

  void _selectAnswer({
    required String questionId,
    required AnswerOption answerOption,
  }) {
    if (_selectedAnswerOptionIdsByQuestionId.containsKey(questionId)) {
      return;
    }

    setState(() {
      _selectedAnswerOptionIdsByQuestionId[questionId] = answerOption.id;

      if (answerOption.isCorrect) {
        _correctAnswersCount++;
      }
    });
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex == 0) {
      return;
    }

    setState(() {
      _currentQuestionIndex--;
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
            selectedSubtopicIds: widget.selectedSubtopicIds,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentQuestionIndex = nextQuestionIndex;
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
        final filteredQuizPlayData = QuizPlayData(
          questions: quizPlayData.questions
              .where(
                (question) =>
                    widget.selectedSubtopicIds.contains(question.subtopicId),
              )
              .toList(),
          answerOptionsByQuestionId: quizPlayData.answerOptionsByQuestionId,
        );

        if (filteredQuizPlayData.questions.isEmpty) {
          return const Center(child: Text('No questions found for this quiz.'));
        }

        final currentQuestion =
            filteredQuizPlayData.questions[_currentQuestionIndex];
        final explanationMarkdown = currentQuestion.explanationMarkdown?.trim();
        final selectedAnswerOptionId =
            _selectedAnswerOptionIdsByQuestionId[currentQuestion.id];
        final hasAnswered = selectedAnswerOptionId != null;

        final currentAnswerOptions =
            filteredQuizPlayData.answerOptionsByQuestionId[currentQuestion
                .id] ??
            [];

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = ResponsiveBreakpoints.isDesktopOrWider(
              constraints.maxWidth,
            );
            final questionCard = Card(
              color: appBarTheme.backgroundColor ?? colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentAnswerOptions.length,
              itemBuilder: (context, index) {
                final answerOption = currentAnswerOptions[index];

                final isSelected = selectedAnswerOptionId == answerOption.id;
                final isCorrect = answerOption.isCorrect;

                Color? cardColor;

                if (hasAnswered && isSelected && isCorrect) {
                  cardColor = const Color(0xFFD1FAE5);
                } else if (hasAnswered && isSelected && !isCorrect) {
                  cardColor = const Color(0xFFFEE2E2);
                } else if (hasAnswered && isCorrect) {
                  cardColor = const Color(0xFFD1FAE5);
                }

                final hasFeedbackColor =
                    hasAnswered && (isCorrect || isSelected);
                final answerTextColor = hasFeedbackColor
                    ? Colors.black
                    : colorScheme.onPrimaryContainer;
                final answerIconColor = hasAnswered && isCorrect
                    ? const Color(0xFF2F855A)
                    : hasAnswered && isSelected && !isCorrect
                    ? const Color(0xFFB91C1C)
                    : colorScheme.onPrimaryContainer;

                return Card(
                  color: cardColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    leading: Icon(
                      hasAnswered && isCorrect
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
                      _selectAnswer(
                        questionId: currentQuestion.id,
                        answerOption: answerOption,
                      );
                    },
                  ),
                );
              },
            );
            final nextButton = FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    appBarTheme.backgroundColor ?? colorScheme.primary,
                foregroundColor:
                    appBarTheme.foregroundColor ?? colorScheme.onPrimary,
              ),
              onPressed: hasAnswered
                  ? () => _goToNextQuestion(filteredQuizPlayData)
                  : null,
              child: Text(
                _currentQuestionIndex ==
                        filteredQuizPlayData.questions.length - 1
                    ? 'Finish quiz'
                    : 'Next question',
              ),
            );
            final hasExplanation =
                explanationMarkdown != null && explanationMarkdown.isNotEmpty;
            final explanationSection = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasAnswered && hasExplanation) ...[
                  QuestionExplanationCard(
                    explanationMarkdown: explanationMarkdown,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
            final navigationButtons = SafeArea(
              top: false,
              left: false,
              right: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _currentQuestionIndex == 0
                            ? null
                            : _goToPreviousQuestion,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: nextButton),
                  ],
                ),
              ),
            );

            if (MediaQuery.orientationOf(context) == Orientation.portrait) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1} of ${filteredQuizPlayData.questions.length}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          questionCard,
                          const SizedBox(height: 16),
                          answers,
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),
                          explanationSection,
                          navigationButtons,
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${filteredQuizPlayData.questions.length}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: questionCard),
                          const SizedBox(width: 16),
                          Expanded(child: answers),
                        ],
                      )
                    else ...[
                      questionCard,
                      const SizedBox(height: 16),
                      answers,
                    ],
                    if (hasAnswered) ...[
                      const SizedBox(height: 12),
                      explanationSection,
                    ],
                    navigationButtons,
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.name)),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ResponsiveContent(
          maxWidth: 1100,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: mainContent,
        ),
      ),
    );
  }
}
