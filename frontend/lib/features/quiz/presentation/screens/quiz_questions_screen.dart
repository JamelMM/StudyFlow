import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/domain/models/question.dart';
import 'package:frontend/features/quiz/domain/models/quiz.dart';
import 'package:frontend/features/quiz/application/controllers/questions_controller.dart';
import 'package:frontend/features/quiz/application/providers/questions_stream_provider.dart';
import 'package:frontend/features/study_content/application/providers/subtopics_stream_provider.dart';
import 'package:frontend/features/quiz/presentation/screens/new_question.dart';
import 'package:frontend/features/quiz/presentation/screens/question_detail_screen.dart';
import 'package:frontend/core/widgets/empty_state_message.dart';
import 'package:frontend/core/widgets/app_snack_bar.dart';
import 'package:frontend/features/quiz/presentation/screens/edit_question.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizQuestionsScreen extends ConsumerStatefulWidget {
  const QuizQuestionsScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  ConsumerState<QuizQuestionsScreen> createState() {
    return _QuizQuestionsScreenState();
  }
}

class _QuizQuestionsScreenState extends ConsumerState<QuizQuestionsScreen> {
  Future<void> _addQuestion(
    String markdownText,
    String? explanationMarkdown,
    String subtopicId,
  ) async {
    await ref
        .read(questionsControllerProvider(widget.quiz.id))
        .addQuestion(
          markdownText: markdownText,
          subtopicId: subtopicId,
          explanationMarkdown: explanationMarkdown,
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(appSuccessSnackBar('Question successfully created'));
  }

  Future<void> _openAddQuestionOverlay() async {
    final subtopics = await ref.read(
      subtopicsStreamProvider(widget.quiz.topicId).future,
    );

    if (!mounted) {
      return;
    }

    if (subtopics.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(appErrorSnackBar('Create a subtopic first.'));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return NewQuestion(subtopics: subtopics, onAddQuestion: _addQuestion);
      },
    );
  }

  Future<void> _removeQuestion(Question question) async {
    await ref
        .read(questionsControllerProvider(widget.quiz.id))
        .removeQuestion(question.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(appDeleteSnackBar('Question deleted'));
  }

  Future<bool> _confirmRemoveQuestion(Question question) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete question?'),
          content: const Text('This will also delete its answer options.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return shouldDelete == true;
  }

  Future<void> _openEditQuestionOverlay(Question question) async {
    final subtopics = await ref.read(
      subtopicsStreamProvider(widget.quiz.topicId).future,
    );

    if (!mounted) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return EditQuestion(
          question: question,
          subtopics: subtopics,
          onUpdateQuestion: (markdownText, explanationMarkdown, subtopicId) {
            return _updateQuestion(
              id: question.id,
              subtopicId: subtopicId,
              markdownText: markdownText,
              explanationMarkdown: explanationMarkdown,
            );
          },
        );
      },
    );
  }

  Future<void> _updateQuestion({
    required String id,
    required String subtopicId,
    required String markdownText,
    String? explanationMarkdown,
  }) async {
    await ref
        .read(questionsControllerProvider(widget.quiz.id))
        .updateQuestion(
          id: id,
          subtopicId: subtopicId,
          markdownText: markdownText,
          explanationMarkdown: explanationMarkdown,
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(appSuccessSnackBar('Question successfully updated'));
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsStreamProvider(widget.quiz.id));
    final subtopicsAsync = ref.watch(
      subtopicsStreamProvider(widget.quiz.topicId),
    );
    final subtopicsById = subtopicsAsync.when(
      data: (subtopics) => {
        for (final subtopic in subtopics) subtopic.id: subtopic.name,
      },
      loading: () => const <String, String>{},
      error: (error, stackTrace) => const <String, String>{},
    );

    Widget mainContent = questionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: ((error, stackTrace) =>
          const Center(child: Text('Could not load questions.'))),
      data: (questions) {
        if (questions.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.quiz_outlined,
            title: 'No questions yet.',
            message: 'Create your first question for this quiz.',
            buttonText: 'Add question',
            onPressed: _openAddQuestionOverlay,
          );
        } else {
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionDetailScreen(question: question),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MarkdownBody(data: question.markdownText),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  _openEditQuestionOverlay(question);
                                }

                                if (value == 'delete') {
                                  final shouldRemove =
                                      await _confirmRemoveQuestion(question);

                                  if (shouldRemove == true) {
                                    _removeQuestion(question);
                                  }
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (subtopicsById[question.subtopicId]
                            case final label?)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.name),
        actions: [
          IconButton(
            onPressed: _openAddQuestionOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
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
            const SizedBox(height: 30),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
