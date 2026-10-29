import 'package:flutter/material.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({
    super.key,
    required this.question,
    required this.onUpdateQuestion,
  });

  final Question question;
  final void Function(String markdownText, String? explanationMarkdown)
  onUpdateQuestion;

  @override
  State<EditQuestion> createState() {
    return _EditQuestionState();
  }
}

class _EditQuestionState extends State<EditQuestion> {
  late final TextEditingController _markdownTextController;
  late final TextEditingController _explanationMarkdownController;

  @override
  void initState() {
    super.initState();
    _markdownTextController = TextEditingController(
      text: widget.question.markdownText,
    );
    _explanationMarkdownController = TextEditingController(
      text: widget.question.explanationMarkdown ?? '',
    );
  }

  void _submitQuestionData() {
    final enteredMarkdownText = _markdownTextController.text.trim();
    final enteredExplanation = _explanationMarkdownController.text.trim();

    if (enteredMarkdownText.isEmpty) {
      return;
    }

    widget.onUpdateQuestion(
      enteredMarkdownText,
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
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
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
            children: [
              FilledButton(
                style: appPrimaryButtonStyle(context),
                onPressed: _submitQuestionData,
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
