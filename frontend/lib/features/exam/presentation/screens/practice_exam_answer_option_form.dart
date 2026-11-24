import 'package:flutter/material.dart';
import 'package:frontend/features/exam/domain/models/practice_exam_answer_option.dart';
import 'package:frontend/core/widgets/app_button_styles.dart';

class PracticeExamAnswerOptionForm extends StatefulWidget {
  const PracticeExamAnswerOptionForm({
    super.key,
    this.answerOption,
    required this.onSubmit,
  });

  final PracticeExamAnswerOption? answerOption;
  final Future<String?> Function(String markdownText, bool isCorrect) onSubmit;

  @override
  State<PracticeExamAnswerOptionForm> createState() =>
      _PracticeExamAnswerOptionFormState();
}

class _PracticeExamAnswerOptionFormState
    extends State<PracticeExamAnswerOptionForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _markdownTextController;
  late bool _isCorrect;
  bool _isSaving = false;
  String? _submissionError;

  @override
  void initState() {
    super.initState();

    _markdownTextController = TextEditingController(
      text: widget.answerOption?.markdownText ?? '',
    );
    _isCorrect = widget.answerOption?.isCorrect ?? false;
  }

  @override
  void dispose() {
    _markdownTextController.dispose();
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

    setState(() {
      _isSaving = true;
    });

    try {
      final errorMessage = await widget.onSubmit(
        _markdownTextController.text.trim(),
        _isCorrect,
      );

      if (!mounted) {
        return;
      }

      if (errorMessage == null) {
        Navigator.pop(context);
        return;
      }

      setState(() {
        _submissionError = errorMessage;
      });
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
    final isEditing = widget.answerOption != null;

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
              maxLength: 300,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Answer',
                helperText: 'Markdown supported',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter an answer.';
                }

                return null;
              },
              onChanged: (_) {
                if (_submissionError != null) {
                  setState(() {
                    _submissionError = null;
                  });
                }
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _isCorrect,
              onChanged: _isSaving
                  ? null
                  : (value) {
                      setState(() {
                        _isCorrect = value ?? false;
                        _submissionError = null;
                      });
                    },
              title: const Text('Correct answer'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (_submissionError != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _submissionError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
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
                      : Text(isEditing ? 'Save' : 'Create answer'),
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
