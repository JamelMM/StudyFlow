import 'package:flutter/material.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/models/subtopic.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({
    super.key,
    required this.question,
    required this.subtopics,
    required this.onUpdateQuestion,
  });

  final Question question;
  final List<Subtopic> subtopics;
  final Future<void> Function(
    String markdownText,
    String? explanationMarkdown,
    String subtopicId,
  )
  onUpdateQuestion;

  @override
  State<EditQuestion> createState() {
    return _EditQuestionState();
  }
}

class _EditQuestionState extends State<EditQuestion> {
  late final TextEditingController _markdownTextController;
  late final TextEditingController _explanationMarkdownController;
  late String _selectedSubtopicId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _markdownTextController = TextEditingController(
      text: widget.question.markdownText,
    );
    _explanationMarkdownController = TextEditingController(
      text: widget.question.explanationMarkdown ?? '',
    );
    _selectedSubtopicId = widget.question.subtopicId;
  }

  Future<void> _submitQuestionData() async {
    final enteredMarkdownText = _markdownTextController.text.trim();
    final enteredExplanation = _explanationMarkdownController.text.trim();

    if (enteredMarkdownText.isEmpty) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onUpdateQuestion(
        enteredMarkdownText,
        enteredExplanation.isEmpty ? null : enteredExplanation,
        _selectedSubtopicId,
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
                    if (value != null) {
                      setState(() {
                        _selectedSubtopicId = value;
                      });
                    }
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
            children: [
              FilledButton(
                style: appPrimaryButtonStyle(context),
                onPressed: _isSaving ? null : _submitQuestionData,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
              TextButton(
                onPressed: _isSaving
                    ? null
                    : () {
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
