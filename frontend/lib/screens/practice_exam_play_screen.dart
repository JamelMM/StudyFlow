import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/practice_exam/practice_exam_play_data.dart';
import 'package:frontend/models/practice_exam.dart';
import 'package:frontend/models/practice_exam_answer_option.dart';
import 'package:frontend/providers/load_practice_exam_play_data_provider.dart';
import 'package:frontend/widgets/app_button_styles.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class PracticeExamPlayScreen extends ConsumerStatefulWidget {
  const PracticeExamPlayScreen({super.key, required this.practiceExam});

  final PracticeExam practiceExam;

  @override
  ConsumerState<PracticeExamPlayScreen> createState() =>
      _PracticeExamPlayScreenState();
}

class _PracticeExamPlayScreenState
    extends ConsumerState<PracticeExamPlayScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _selectedAnswerOptionIdsByQuestionId = {};

  void _selectAnswer({
    required String questionId,
    required String answerOptionId,
  }) {
    setState(() {
      _selectedAnswerOptionIdsByQuestionId[questionId] = answerOptionId;
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

  Future<void> _goToNextQuestion(PracticeExamPlayData playData) async {
    final isLastQuestion =
        _currentQuestionIndex == playData.questions.length - 1;

    if (isLastQuestion) {
      await _finishExam(playData);
      return;
    }

    setState(() {
      _currentQuestionIndex++;
    });
  }

  Future<void> _finishExam(PracticeExamPlayData playData) async {
    var correctAnswersCount = 0;

    for (final question in playData.questions) {
      final selectedAnswerOptionId =
          _selectedAnswerOptionIdsByQuestionId[question.id];
      final answerOptions =
          playData.answerOptionsByQuestionId[question.id] ?? const [];

      final selectedAnswerIsCorrect = answerOptions.any(
        (answerOption) =>
            answerOption.id == selectedAnswerOptionId && answerOption.isCorrect,
      );

      if (selectedAnswerIsCorrect) {
        correctAnswersCount++;
      }
    }

    final totalQuestions = playData.questions.length;
    final percentage = ((correctAnswersCount / totalQuestions) * 100).round();
    final hasPassed = percentage >= widget.practiceExam.passingPercentage;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(hasPassed ? 'Practice exam passed' : 'Practice exam ended'),
        content: Text(
          '$correctAnswersCount of $totalQuestions correct ($percentage%).',
        ),
        actions: [
          FilledButton(
            style: appPrimaryButtonStyle(context),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playDataAsync = ref.watch(
      practiceExamPlayDataProvider(widget.practiceExam.id),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.practiceExam.name)),
      body: playDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('Could not load the practice exam.')),
        data: _buildPlayContent,
      ),
    );
  }

  Widget _buildPlayContent(PracticeExamPlayData playData) {
    if (playData.questions.isEmpty) {
      return const Center(child: Text('No questions found.'));
    }

    final currentQuestion = playData.questions[_currentQuestionIndex];
    final answerOptions =
        playData.answerOptionsByQuestionId[currentQuestion.id] ?? const [];
    final selectedAnswerOptionId =
        _selectedAnswerOptionIdsByQuestionId[currentQuestion.id];

    return ResponsiveContent(
      maxWidth: 1100,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useSideBySideLayout =
              constraints.maxWidth >= 700 ||
              constraints.maxWidth > constraints.maxHeight * 1.4;
          final questionCard = _QuestionCard(
            markdownText: currentQuestion.markdownText,
          );
          final answers = _AnswerOptionsList(
            answerOptions: answerOptions,
            selectedAnswerOptionId: selectedAnswerOptionId,
            onSelected: (answerOptionId) {
              _selectAnswer(
                questionId: currentQuestion.id,
                answerOptionId: answerOptionId,
              );
            },
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of '
                '${playData.questions.length}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: useSideBySideLayout
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: questionCard),
                          const SizedBox(width: 16),
                          Expanded(child: answers),
                        ],
                      )
                    : ListView(
                        children: [
                          questionCard,
                          const SizedBox(height: 12),
                          ...answerOptions.map(
                            (answerOption) => _AnswerOptionCard(
                              answerOption: answerOption,
                              isSelected:
                                  selectedAnswerOptionId == answerOption.id,
                              onTap: () {
                                _selectAnswer(
                                  questionId: currentQuestion.id,
                                  answerOptionId: answerOption.id,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              SafeArea(
                top: false,
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
                    Expanded(
                      child: FilledButton.icon(
                        style: appPrimaryButtonStyle(context),
                        onPressed: selectedAnswerOptionId == null
                            ? null
                            : () => _goToNextQuestion(playData),
                        icon: Icon(
                          _currentQuestionIndex == playData.questions.length - 1
                              ? Icons.flag_outlined
                              : Icons.arrow_forward,
                        ),
                        label: Text(
                          _currentQuestionIndex == playData.questions.length - 1
                              ? 'Finish'
                              : 'Next',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.markdownText});

  final String markdownText;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: appBarTheme.backgroundColor ?? colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: MarkdownBody(
          data: markdownText,
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.sourceSans3(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.35,
              color: appBarTheme.foregroundColor ?? colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerOptionsList extends StatelessWidget {
  const _AnswerOptionsList({
    required this.answerOptions,
    required this.selectedAnswerOptionId,
    required this.onSelected,
  });

  final List<PracticeExamAnswerOption> answerOptions;
  final String? selectedAnswerOptionId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: answerOptions.length,
      itemBuilder: (context, index) {
        final answerOption = answerOptions[index];

        return _AnswerOptionCard(
          answerOption: answerOption,
          isSelected: selectedAnswerOptionId == answerOption.id,
          onTap: () => onSelected(answerOption.id),
        );
      },
    );
  }
}

class _AnswerOptionCard extends StatelessWidget {
  const _AnswerOptionCard({
    required this.answerOption,
    required this.isSelected,
    required this.onTap,
  });

  final PracticeExamAnswerOption answerOption;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: isSelected ? colorScheme.secondaryContainer : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(child: MarkdownBody(data: answerOption.markdownText)),
            ],
          ),
        ),
      ),
    );
  }
}
