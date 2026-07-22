import 'package:flutter/material.dart';

class NewQuestion extends StatefulWidget {
  const NewQuestion({super.key, required this.onAddQuestion});

  final void Function(String markdownText) onAddQuestion;

  @override
  State<NewQuestion> createState() {
    return _NewQuestionState();
  }
}

class _NewQuestionState extends State<NewQuestion> {
  final _markdownTextController = TextEditingController();

  void _submitQuestionData() {
    final enteredText = _markdownTextController.text.trim();

    if (enteredText.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter a valid question.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddQuestion(enteredText);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _markdownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _markdownTextController,
            maxLength: 300,
            maxLines: 4,
            decoration: const InputDecoration(label: Text('Question')),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _submitQuestionData,
                child: const Text('Save question'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
