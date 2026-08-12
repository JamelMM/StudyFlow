import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';
import 'package:frontend/screens/new_question.dart';
import 'package:frontend/screens/question_detail_screen.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/screens/edit_question.dart';

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

  Future<void> _removeQuestion(Question question) async {
    await _questionsRepository.removeQuestion(question.id);

    await _loadQuestions();

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
            _updateQuestion(question: question, markdownText: markdownText);
          },
        );
      },
    );
  }

  Future<void> _updateQuestion({
    required Question question,
    required String markdownText,
  }) async {
    await _questionsRepository.updateQuestion(
      id: question.id,
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
          'Question successfully updated',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
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
          return Dismissible(
            key: ValueKey(question.id),
            background: Container(
              color: const Color(0xFFC53030),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) {
              return _confirmRemoveQuestion(question);
            },
            onDismissed: (direction) {
              _removeQuestion(question);
            },
            child: Card(
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
                              final shouldRemove = await _confirmRemoveQuestion(
                                question,
                              );

                              if (shouldRemove == true) {
                                _removeQuestion(question);
                              }
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
              ),
            ),
          );
        },
      );
    }

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
