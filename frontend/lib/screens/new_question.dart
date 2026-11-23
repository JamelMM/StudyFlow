import 'package:flutter/material.dart';
import 'package:frontend/models/subtopic.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class NewQuestion extends StatefulWidget {
  const NewQuestion({
    super.key,
    required this.subtopics,
    required this.onAddQuestion,
  });

  final List<Subtopic> subtopics;
  final Future<void> Function(
    String markdownText,
    String? explanationMarkdown,
    String subtopicId,
  )
  onAddQuestion;

  @override
  State<NewQuestion> createState() {
    return _NewQuestionState();
  }
}

class _NewQuestionState extends State<NewQuestion> {
  final _markdownTextController = TextEditingController();
  final _explanationMarkdownController = TextEditingController();
  String? _selectedSubtopicId;
  bool _isSaving = false;

  Future<void> _submitQuestionData() async {
    final enteredText = _markdownTextController.text.trim();
    final enteredExplanation = _explanationMarkdownController.text.trim();

    if (enteredText.isEmpty || _selectedSubtopicId == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Enter a question and select a subtopic.'),
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

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onAddQuestion(
        enteredText,
        enteredExplanation.isEmpty ? null : enteredExplanation,
        _selectedSubtopicId!,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
          DropdownButtonFormField<String>(
            initialValue: _selectedSubtopicId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Subtopic'),
            items: widget.subtopics
                .map(
                  (subtopic) => DropdownMenuItem(
                    value: subtopic.id,
                    child: Text(subtopic.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: _isSaving
                ? null
                : (value) {
                    setState(() {
                      _selectedSubtopicId = value;
                    });
                  },
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
                onPressed: _isSaving
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: appPrimaryButtonStyle(context),
                onPressed: _isSaving ? null : _submitQuestionData,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save question'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
