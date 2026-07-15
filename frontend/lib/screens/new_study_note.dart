import 'package:flutter/material.dart';

class NewStudyNote extends StatefulWidget {
  const NewStudyNote({super.key, required this.onAddNote});

  final Future<void> Function(String name, String content) onAddNote;

  @override
  State<NewStudyNote> createState() => _NewStudyNoteState();
}

class _NewStudyNoteState extends State<NewStudyNote> {
  final _nameController = TextEditingController();
  final _markdownTextController = TextEditingController();

  Future<void> _submitNewStudyNoteData() async {
    if (_nameController.text.trim() == "" ||
        _markdownTextController.text.trim() == "") {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid name and content were entered.',
          ),
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
    await widget.onAddNote(
      _nameController.text.trim(),
      _markdownTextController.text.trim(),
    );

    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _markdownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 50),
          TextField(
            controller: _nameController,
            maxLength: 80,
            decoration: InputDecoration(label: Text('Title')),
          ),
          TextField(
            controller: _markdownTextController,
            maxLength: 2000,
            maxLines: 8,
            decoration: InputDecoration(label: Text('Content')),
          ),

          SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _submitNewStudyNoteData,
                child: Text('Save Topic'),
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
