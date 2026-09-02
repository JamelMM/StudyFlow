import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/answer_option.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/screens/edit_answer_option.dart';
import 'package:frontend/screens/new_answer_option.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/controllers/answer_options_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/providers/answer_options_stream_provider.dart';

class QuestionDetailScreen extends ConsumerStatefulWidget {
  const QuestionDetailScreen({super.key, required this.question});

  final Question question;

  @override
  ConsumerState<QuestionDetailScreen> createState() {
    return _QuestionDetailScreenState();
  }
}

class _QuestionDetailScreenState extends ConsumerState<QuestionDetailScreen> {
  void _openAddAnswerOptionOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return NewAnswerOption(
          onAddAnswerOption: (markdownText, isCorrect) {
            _addAnswerOption(markdownText: markdownText, isCorrect: isCorrect);
          },
        );
      },
    );
  }

  Future<void> _addAnswerOption({
    required String markdownText,
    required bool isCorrect,
  }) async {
    final errorMessage = await ref
        .read(answerOptionsControllerProvider(widget.question.id))
        .addAnswerOption(markdownText: markdownText, isCorrect: isCorrect);

    if (!mounted) {
      return;
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage, textAlign: TextAlign.center)),
      );
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Answer successfully created',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  Future<void> _removeAnswerOption(String id) async {
    final answerOptionsController = ref.read(
      answerOptionsControllerProvider(widget.question.id),
    );

    await answerOptionsController.removeAnswerOption(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Answer deleted', textAlign: TextAlign.center),
      ),
    );
  }

  Future<bool> _confirmRemoveAnswerOption(AnswerOption answerOption) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete answer?'),
          content: const Text('This answer option will be deleted.'),
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

  void _openEditAnswerOptionOverlay(AnswerOption answerOption) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return EditAnswerOption(
          answerOption: answerOption,
          onUpdateAnswerOption: (markdownText, isCorrect) {
            _updateAnswerOption(
              answerOption: answerOption,
              markdownText: markdownText,
              isCorrect: isCorrect,
            );
          },
        );
      },
    );
  }

  Future<void> _updateAnswerOption({
    required AnswerOption answerOption,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final errorMessage = await ref
        .read(answerOptionsControllerProvider(widget.question.id))
        .updateAnswerOption(
          id: answerOption.id,
          markdownText: markdownText,
          isCorrect: isCorrect,
        );

    if (!mounted) {
      return;
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage, textAlign: TextAlign.center)),
      );
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Answer successfully updated',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final answerOptionsAsync = ref.watch(
      answerOptionsStreamProvider(widget.question.id),
    );

    final mainContent = answerOptionsAsync.when(
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
            onPressed: _openAddAnswerOptionOverlay,
          );
        }

        return ListView.builder(
          itemCount: answerOptions.length,
          itemBuilder: (context, index) {
            final answerOption = answerOptions[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      answerOption.isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: answerOption.isCorrect
                          ? const Color(0xFF2F855A)
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(answerOption.markdownText)),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _openEditAnswerOptionOverlay(answerOption);
                        }

                        if (value == 'delete') {
                          final shouldRemove = await _confirmRemoveAnswerOption(
                            answerOption,
                          );

                          if (shouldRemove == true) {
                            _removeAnswerOption(answerOption.id);
                          }
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
        title: Text(
          'Question',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddAnswerOptionOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFFFFF3B0),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(widget.question.markdownText),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Answers',
                style: TextStyle(
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
      ),
    );
  }
}
