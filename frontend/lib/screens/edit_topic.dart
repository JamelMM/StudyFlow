import 'package:flutter/material.dart';
import 'package:frontend/models/topic.dart';

class EditTopic extends StatefulWidget {
  const EditTopic({
    super.key,
    required this.topic,
    required this.onUpdateTopic,
  });

  final Topic topic;
  final void Function(String name) onUpdateTopic;

  @override
  State<EditTopic> createState() => _EditTopicState();
}

class _EditTopicState extends State<EditTopic> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.topic.name);
  }

  void _submitTopicData() {
    final enteredName = _nameController.text.trim();

    if (enteredName.isEmpty) {
      return;
    }

    widget.onUpdateTopic(enteredName);
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
            decoration: const InputDecoration(label: Text('Topic name')),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _submitTopicData,
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
