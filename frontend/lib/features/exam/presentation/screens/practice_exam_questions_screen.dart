import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/controllers/practice_exam_questions_controller.dart';
import 'package:frontend/features/exam/domain/models/practice_exam.dart';
import 'package:frontend/features/exam/domain/models/practice_exam_question.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_questions_stream_provider.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_subtopic_options_provider.dart';
import 'package:frontend/features/exam/presentation/screens/practice_exam_question_form.dart';
import 'package:frontend/features/exam/presentation/screens/practice_exam_question_detail_screen.dart';
import 'package:frontend/core/widgets/app_snack_bar.dart';
import 'package:frontend/core/widgets/empty_state_message.dart';
import 'package:frontend/core/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class PracticeExamQuestionsScreen extends ConsumerStatefulWidget {
  const PracticeExamQuestionsScreen({super.key, required this.practiceExam});

  final PracticeExam practiceExam;

  @override
  ConsumerState<PracticeExamQuestionsScreen> createState() =>
      _PracticeExamQuestionsScreenState();
}

class _PracticeExamQuestionsScreenState
    extends ConsumerState<PracticeExamQuestionsScreen> {
  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  Future<void> _openAddQuestionOverlay() async {
    await _openQuestionOverlay();
  }

  Future<void> _openEditQuestionOverlay(PracticeExamQuestion question) async {
    await _openQuestionOverlay(question: question);
  }

  Future<void> _openQuestionOverlay({PracticeExamQuestion? question}) async {
    List<PracticeExamSubtopicOption> subtopicOptions;

    try {
      subtopicOptions = await ref.read(
        practiceExamSubtopicOptionsProvider.future,
      );
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not load subtopics.'));
      }
      return;
    }

    if (!mounted) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => PracticeExamQuestionForm(
        question: question,
        subtopicOptions: subtopicOptions,
        onSubmit: (markdownText, explanationMarkdown, subtopicId) {
          if (question == null) {
            return _addQuestion(
              markdownText: markdownText,
              explanationMarkdown: explanationMarkdown,
              subtopicId: subtopicId,
            );
          }

          return _updateQuestion(
            question: question,
            markdownText: markdownText,
            explanationMarkdown: explanationMarkdown,
            subtopicId: subtopicId,
          );
        },
      ),
    );
  }

  Future<bool> _addQuestion({
    required String markdownText,
    String? explanationMarkdown,
    String? subtopicId,
  }) async {
    try {
      await ref
          .read(practiceExamQuestionsControllerProvider(widget.practiceExam.id))
          .addQuestion(
            markdownText: markdownText,
            explanationMarkdown: explanationMarkdown,
            subtopicId: subtopicId,
          );

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Question successfully created'));
      return true;
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not create question.'));
      }

      return false;
    }
  }

  Future<bool> _updateQuestion({
    required PracticeExamQuestion question,
    required String markdownText,
    String? explanationMarkdown,
    String? subtopicId,
  }) async {
    try {
      await ref
          .read(practiceExamQuestionsControllerProvider(widget.practiceExam.id))
          .updateQuestion(
            id: question.id,
            markdownText: markdownText,
            explanationMarkdown: explanationMarkdown,
            subtopicId: subtopicId,
          );

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Question successfully updated'));
      return true;
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not update question.'));
      }

      return false;
    }
  }

  Future<void> _confirmRemoveQuestion(PracticeExamQuestion question) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete question?'),
        content: const Text(
          'This will also delete all answer options for this question.',
        ),
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
          .read(practiceExamQuestionsControllerProvider(widget.practiceExam.id))
          .removeQuestion(question.id);

      if (mounted) {
        _showSnackBar(appDeleteSnackBar('Question deleted'));
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not delete question.'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtopicOptions = ref
        .watch(practiceExamSubtopicOptionsProvider)
        .when(
          data: (options) => options,
          loading: () => const <PracticeExamSubtopicOption>[],
          error: (error, stackTrace) => const <PracticeExamSubtopicOption>[],
        );
    final questionsAsync = ref.watch(
      practiceExamQuestionsStreamProvider(widget.practiceExam.id),
    );

    final mainContent = questionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load questions.')),
      data: (questions) {
        if (questions.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.quiz_outlined,
            title: 'No questions yet.',
            message: 'Create the first question for this practice exam.',
            buttonText: 'Add question',
            onPressed: _openAddQuestionOverlay,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            final subtopicLabel = _findSubtopicLabel(
              subtopicOptions,
              question.subtopicId,
            );

            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PracticeExamQuestionDetailScreen(question: question),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 8),
                            MarkdownBody(data: question.markdownText),
                            if (subtopicLabel != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.topic_outlined, size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      subtopicLabel,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (question.explanationMarkdown != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Explanation added',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _openEditQuestionOverlay(question);
                          }

                          if (value == 'delete') {
                            _confirmRemoveQuestion(question);
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
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.practiceExam.name),
        actions: [
          IconButton(
            tooltip: 'Add question',
            onPressed: _openAddQuestionOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ResponsiveContent(
        maxWidth: 900,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          children: [
            Text(
              'Questions',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }

  String? _findSubtopicLabel(
    List<PracticeExamSubtopicOption> options,
    String? subtopicId,
  ) {
    if (subtopicId == null) {
      return null;
    }

    for (final option in options) {
      if (option.subtopicId == subtopicId) {
        return option.label;
      }
    }

    return null;
  }
}
