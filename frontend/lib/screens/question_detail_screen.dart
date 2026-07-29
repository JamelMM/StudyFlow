import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/answer_option.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/repositories/contracts/answeroptionsrepository.dart';
import 'package:frontend/screens/new_answer_option.dart';
import 'package:frontend/widgets/empty_state_message.dart';

class QuestionDetailScreen extends StatefulWidget {
  const QuestionDetailScreen({super.key, required this.question});

  final Question question;

  @override
  State<QuestionDetailScreen> createState() {
    return _QuestionDetailScreenState();
  }
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final AnswerOptionsRepository _answerOptionsRepository =
      getIt<AnswerOptionsRepository>();

  List<AnswerOption> _answerOptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnswerOptions();
  }

  Future<void> _loadAnswerOptions() async {
    final loadedAnswerOptions = await _answerOptionsRepository
        .getAnswerOptionsByQuestionId(widget.question.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _answerOptions = loadedAnswerOptions;
      _isLoading = false;
    });
  }

  void _openAddAnswerOptionOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return NewAnswerOption(onAddAnswerOption: _addAnswerOption);
      },
    );
  }

  Future<void> _addAnswerOption(String markdownText, bool isCorrect) async {
    await _answerOptionsRepository.addAnswerOption(
      questionId: widget.question.id,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    await _loadAnswerOptions();

    if (!mounted) {
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

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (_answerOptions.isEmpty) {
      mainContent = EmptyStateMessage(
        icon: Icons.checklist_outlined,
        title: 'No answers yet.',
        message: 'Create answer options for this question.',
        buttonText: 'Add answer',
        onPressed: _openAddAnswerOptionOverlay,
      );
    } else {
      mainContent = ListView.builder(
        itemCount: _answerOptions.length,
        itemBuilder: (context, index) {
          final answerOption = _answerOptions[index];

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
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question'),
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
