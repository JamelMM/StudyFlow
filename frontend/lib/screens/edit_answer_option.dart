import 'package:flutter/material.dart';
import 'package:frontend/models/answer_option.dart';

class EditAnswerOption extends StatefulWidget {
  const EditAnswerOption({
    super.key,
    required this.answerOption,
    required this.onUpdateAnswerOption,
  });

  final AnswerOption answerOption;
  final void Function(String markdownText, bool isCorrect) onUpdateAnswerOption;

  @override
  State<EditAnswerOption> createState() {
    return _EditAnswerOptionState();
  }
}

class _EditAnswerOptionState extends State<EditAnswerOption> {
  late final TextEditingController _markdownTextController;
  late bool _isCorrect;

  @override
  void initState() {
    super.initState();
    _markdownTextController = TextEditingController(
      text: widget.answerOption.markdownText,
    );
    _isCorrect = widget.answerOption.isCorrect;
  }

  void _submitAnswerOptionData() {
    final enteredMarkdownText = _markdownTextController.text.trim();

    if (enteredMarkdownText.isEmpty) {
      return;
    }

    widget.onUpdateAnswerOption(enteredMarkdownText, _isCorrect);
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
            maxLines: 3,
            decoration: const InputDecoration(label: Text('Answer')),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _isCorrect,
            onChanged: (value) {
              setState(() {
                _isCorrect = value ?? false;
              });
            },
            title: const Text('Correct answer'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _submitAnswerOptionData,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
