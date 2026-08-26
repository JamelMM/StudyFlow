import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/controllers/questions_controller.dart';
import 'package:frontend/screens/new_question.dart';
import 'package:frontend/screens/question_detail_screen.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/screens/edit_question.dart';

class QuizQuestionsScreen extends ConsumerStatefulWidget {
  const QuizQuestionsScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  ConsumerState<QuizQuestionsScreen> createState() {
    return _QuizQuestionsScreenState();
  }
}

class _QuizQuestionsScreenState extends ConsumerState<QuizQuestionsScreen> {
  Future<void> _addQuestion(String markdownText) async {
    await ref
        .read(questionsControllerProvider(widget.quiz.id).notifier)
        .addQuestion(markdownText);

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

  Future<void> _removeQuestion(Question question) async {
    await ref
        .read(questionsControllerProvider(widget.quiz.id).notifier)
        .removeQuestion(question.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question deleted', textAlign: TextAlign.center),
      ),
    );
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

  void _openEditQuestionOverlay(Question question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return EditQuestion(
          question: question,
          onUpdateQuestion: (markdownText) {
            _updateQuestion(id: question.id, markdownText: markdownText);
          },
        );
      },
    );
  }

  Future<void> _updateQuestion({
    required String id,
    required String markdownText,
  }) async {
    await ref
        .read(questionsControllerProvider(widget.quiz.id).notifier)
        .updateQuestion(id: id, markdownText: markdownText);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Question successfully updated',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(
      questionsControllerProvider(widget.quiz.id),
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
                    child: Row(
                      children: [
                        Expanded(child: Text(question.markdownText)),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              _openEditQuestionOverlay(question);
                            }

                            if (value == 'delete') {
                              final shouldRemove = await _confirmRemoveQuestion(
                                question,
                              );

                              if (shouldRemove == true) {
                                _removeQuestion(question);
                              }
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
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
            Text('Questions'),
            const SizedBox(height: 30),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
