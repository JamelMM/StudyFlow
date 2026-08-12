import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';

class EditSubject extends StatefulWidget {
  const EditSubject({
    super.key,
    required this.subject,
    required this.onUpdateSubject,
  });

  final Subject subject;
  final void Function(String name) onUpdateSubject;

  @override
  State<EditSubject> createState() {
    return _EditSubjectState();
  }
}

class _EditSubjectState extends State<EditSubject> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
  }

  void _submitSubjectData() {
    final enteredName = _nameController.text.trim();

    if (enteredName.isEmpty) {
      return;
    }

    widget.onUpdateSubject(enteredName);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            controller: _nameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('Subject name')),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _submitSubjectData,
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
