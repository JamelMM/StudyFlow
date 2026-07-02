import 'package:flutter/Material.dart';

class NewTopic extends StatefulWidget {
  const NewTopic({super.key, required this.onAddTopic});

  final Function(String name) onAddTopic;

  @override
  State<NewTopic> createState() => _NewTopicState();
}

class _NewTopicState extends State<NewTopic> {
  final _titleController = TextEditingController();

  void _submitTopicData() {
    if (_titleController.text.trim() == "") {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please make sure a valid name was entered.'),
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
    widget.onAddTopic(_titleController.text.trim());
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 80,
            decoration: InputDecoration(label: Text('Title')),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _submitTopicData,
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
