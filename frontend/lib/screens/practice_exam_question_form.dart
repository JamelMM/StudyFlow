import 'package:flutter/material.dart';
import 'package:frontend/models/practice_exam_question.dart';
import 'package:frontend/providers/practice_exam_topic_options_provider.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class PracticeExamQuestionForm extends StatefulWidget {
  const PracticeExamQuestionForm({
    super.key,
    this.question,
    required this.topicOptions,
    required this.onSubmit,
  });

  final PracticeExamQuestion? question;
  final List<PracticeExamTopicOption> topicOptions;
  final Future<bool> Function(
    String markdownText,
    String? explanationMarkdown,
    String? topicId,
  )
  onSubmit;

  @override
  State<PracticeExamQuestionForm> createState() =>
      _PracticeExamQuestionFormState();
}

class _PracticeExamQuestionFormState extends State<PracticeExamQuestionForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _markdownTextController;
  late final TextEditingController _explanationMarkdownController;
  String? _selectedTopicId;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _markdownTextController = TextEditingController(
      text: widget.question?.markdownText ?? '',
    );
    _explanationMarkdownController = TextEditingController(
      text: widget.question?.explanationMarkdown ?? '',
    );
    _selectedTopicId = widget.question?.topicId;
  }

  @override
  void dispose() {
    _markdownTextController.dispose();
    _explanationMarkdownController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final markdownText = _markdownTextController.text.trim();
    final explanationText = _explanationMarkdownController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      final wasSaved = await widget.onSubmit(
        markdownText,
        explanationText.isEmpty ? null : explanationText,
        _selectedTopicId,
      );

      if (mounted && wasSaved) {
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
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.question != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _markdownTextController,
              autofocus: true,
              enabled: !_isSaving,
              maxLength: 500,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Question',
                helperText: 'Markdown supported',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a question.';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedTopicId ?? '',
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Topic',
                helperText: 'Optional',
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('No topic'),
                ),
                ...widget.topicOptions.map(
                  (option) => DropdownMenuItem(
                    value: option.topicId,
                    child: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) {
                      setState(() {
                        _selectedTopicId = value == null || value.isEmpty
                            ? null
                            : value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _explanationMarkdownController,
              enabled: !_isSaving,
              minLines: 3,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Explanation',
                helperText: 'Optional, Markdown supported',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  style: appPrimaryButtonStyle(context),
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Save' : 'Create question'),
                ),
                TextButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
