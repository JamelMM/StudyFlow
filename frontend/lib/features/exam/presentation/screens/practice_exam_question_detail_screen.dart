import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/controllers/practice_exam_answer_options_controller.dart';
import 'package:frontend/features/exam/domain/models/practice_exam_answer_option.dart';
import 'package:frontend/features/exam/domain/models/practice_exam_question.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_answer_options_stream_provider.dart';
import 'package:frontend/features/exam/presentation/screens/practice_exam_answer_option_form.dart';
import 'package:frontend/core/widgets/app_snack_bar.dart';
import 'package:frontend/core/widgets/empty_state_message.dart';
import 'package:frontend/core/widgets/question_explanation_card.dart';
import 'package:frontend/core/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class PracticeExamQuestionDetailScreen extends ConsumerStatefulWidget {
  const PracticeExamQuestionDetailScreen({super.key, required this.question});

  final PracticeExamQuestion question;

  @override
  ConsumerState<PracticeExamQuestionDetailScreen> createState() =>
      _PracticeExamQuestionDetailScreenState();
}

class _PracticeExamQuestionDetailScreenState
    extends ConsumerState<PracticeExamQuestionDetailScreen> {
  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void _openAddAnswerOverlay() {
    _openAnswerOverlay();
  }

  void _openEditAnswerOverlay(PracticeExamAnswerOption answerOption) {
    _openAnswerOverlay(answerOption: answerOption);
  }

  void _openAnswerOverlay({PracticeExamAnswerOption? answerOption}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => PracticeExamAnswerOptionForm(
        answerOption: answerOption,
        onSubmit: (markdownText, isCorrect) {
          if (answerOption == null) {
            return _addAnswerOption(
              markdownText: markdownText,
              isCorrect: isCorrect,
            );
          }

          return _updateAnswerOption(
            answerOption: answerOption,
            markdownText: markdownText,
            isCorrect: isCorrect,
          );
        },
      ),
    );
  }

  Future<String?> _addAnswerOption({
    required String markdownText,
    required bool isCorrect,
  }) async {
    try {
      final errorMessage = await ref
          .read(practiceExamAnswerOptionsControllerProvider(widget.question.id))
          .addAnswerOption(markdownText: markdownText, isCorrect: isCorrect);

      if (!mounted) {
        return 'Could not create answer.';
      }

      if (errorMessage != null) {
        return errorMessage;
      }

      _showSnackBar(appSuccessSnackBar('Answer successfully created'));
      return null;
    } catch (_) {
      return 'Could not create answer.';
    }
  }

  Future<String?> _updateAnswerOption({
    required PracticeExamAnswerOption answerOption,
    required String markdownText,
    required bool isCorrect,
  }) async {
    try {
      final errorMessage = await ref
          .read(practiceExamAnswerOptionsControllerProvider(widget.question.id))
          .updateAnswerOption(
            id: answerOption.id,
            markdownText: markdownText,
            isCorrect: isCorrect,
          );

      if (!mounted) {
        return 'Could not update answer.';
      }

      if (errorMessage != null) {
        return errorMessage;
      }

      _showSnackBar(appSuccessSnackBar('Answer successfully updated'));
      return null;
    } catch (_) {
      return 'Could not update answer.';
    }
  }

  Future<void> _confirmRemoveAnswerOption(
    PracticeExamAnswerOption answerOption,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete answer?'),
        content: const Text('This answer option will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await ref
          .read(practiceExamAnswerOptionsControllerProvider(widget.question.id))
          .removeAnswerOption(answerOption.id);

      if (mounted) {
        _showSnackBar(appDeleteSnackBar('Answer deleted'));
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not delete answer.'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final answerOptionsAsync = ref.watch(
      practiceExamAnswerOptionsStreamProvider(widget.question.id),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final explanationMarkdown = widget.question.explanationMarkdown?.trim();

    final answersContent = answerOptionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load answers.')),
      data: (answerOptions) {
        if (answerOptions.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.checklist_outlined,
            title: 'No answers yet.',
            message: 'Create answer options for this question.',
            buttonText: 'Add answer',
            onPressed: _openAddAnswerOverlay,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: answerOptions.length,
          itemBuilder: (context, index) {
            final answerOption = answerOptions[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                child: Row(
                  children: [
                    Icon(
                      answerOption.isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: answerOption.isCorrect
                          ? const Color(0xFF2F855A)
                          : colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MarkdownBody(data: answerOption.markdownText),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _openEditAnswerOverlay(answerOption);
                        }

                        if (value == 'delete') {
                          _confirmRemoveAnswerOption(answerOption);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question'),
        actions: [
          IconButton(
            tooltip: 'Add answer',
            onPressed: _openAddAnswerOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ResponsiveContent(
        maxWidth: 900,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MarkdownBody(
                  data: widget.question.markdownText,
                  styleSheet: MarkdownStyleSheet(
                    p: GoogleFonts.sourceSans3(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  ),
                ),
              ),
            ),
            if (explanationMarkdown != null &&
                explanationMarkdown.isNotEmpty) ...[
              const SizedBox(height: 12),
              QuestionExplanationCard(explanationMarkdown: explanationMarkdown),
            ],
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Answers',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: answersContent),
          ],
        ),
      ),
    );
  }
}
