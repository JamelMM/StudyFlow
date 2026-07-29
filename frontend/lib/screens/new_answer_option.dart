import 'package:flutter/material.dart';

class NewAnswerOption extends StatefulWidget {
  const NewAnswerOption({super.key, required this.onAddAnswerOption});

  final void Function(String markdownText, bool isCorrect) onAddAnswerOption;

  @override
  State<NewAnswerOption> createState() {
    return _NewAnswerOptionState();
  }
}

class _NewAnswerOptionState extends State<NewAnswerOption> {
  final _markdownTextController = TextEditingController();
  bool _isCorrect = false;

  @override
  void dispose() {
    _markdownTextController.dispose();
    super.dispose();
  }

  void _submitAnswerOptionData() {
    final enteredText = _markdownTextController.text.trim();

    if (enteredText.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter an answer text.'),
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

    widget.onAddAnswerOption(enteredText, _isCorrect);

    Navigator.pop(context);
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
            maxLines: 3,
            decoration: const InputDecoration(label: Text('Answer text')),
          ),
          CheckboxListTile(
            value: _isCorrect,
            onChanged: (value) {
              setState(() {
                _isCorrect = value ?? false;
              });
            },
            title: const Text('Correct answer'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitAnswerOptionData,
                child: const Text('Save answer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
