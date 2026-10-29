import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class NewQuestion extends StatefulWidget {
  const NewQuestion({super.key, required this.onAddQuestion});

  final void Function(String markdownText, String? explanationMarkdown)
  onAddQuestion;

  @override
  State<NewQuestion> createState() {
    return _NewQuestionState();
  }
}

class _NewQuestionState extends State<NewQuestion> {
  final _markdownTextController = TextEditingController();
  final _explanationMarkdownController = TextEditingController();

  void _submitQuestionData() {
    final enteredText = _markdownTextController.text.trim();
    final enteredExplanation = _explanationMarkdownController.text.trim();

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

    widget.onAddQuestion(
      enteredText,
      enteredExplanation.isEmpty ? null : enteredExplanation,
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _markdownTextController.dispose();
    _explanationMarkdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.viewInsetsOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _markdownTextController,
            maxLength: 300,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Question',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _explanationMarkdownController,
            maxLength: 2000,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Explanation (optional)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
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
                style: appPrimaryButtonStyle(context),
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
