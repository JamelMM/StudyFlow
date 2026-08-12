import 'package:flutter/material.dart';
import 'package:frontend/models/study_note.dart';

class EditStudyNote extends StatefulWidget {
  const EditStudyNote({
    super.key,
    required this.onUpdateNote,
    required this.note,
  });

  final Future<void> Function(String name, String markdownText) onUpdateNote;

  final StudyNote note;

  @override
  State<EditStudyNote> createState() => _EditStudyNoteState();
}

class _EditStudyNoteState extends State<EditStudyNote> {
  late final TextEditingController _nameController;
  late final TextEditingController _markdownTextController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.note.name);
    _markdownTextController = TextEditingController(
      text: widget.note.markdownText,
    );
  }

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
    await widget.onUpdateNote(
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
