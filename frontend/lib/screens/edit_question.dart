import 'package:flutter/material.dart';
import 'package:frontend/models/question.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({
    super.key,
    required this.question,
    required this.onUpdateQuestion,
  });

  final Question question;
  final void Function(String markdownText) onUpdateQuestion;

  @override
  State<EditQuestion> createState() {
    return _EditQuestionState();
  }
}

class _EditQuestionState extends State<EditQuestion> {
  late final TextEditingController _markdownTextController;

  @override
  void initState() {
    super.initState();
    _markdownTextController = TextEditingController(
      text: widget.question.markdownText,
    );
  }

  void _submitQuestionData() {
    final enteredMarkdownText = _markdownTextController.text.trim();

    if (enteredMarkdownText.isEmpty) {
      return;
    }

    widget.onUpdateQuestion(enteredMarkdownText);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _markdownTextController.dispose();
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
          Row(
            children: [
              FilledButton(
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
