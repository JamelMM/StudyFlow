import 'package:flutter/material.dart';

class NewSubject extends StatefulWidget {
  const NewSubject({super.key, required this.onAddSubject});

  final Function(String name) onAddSubject;

  @override
  State<NewSubject> createState() => _NewSubjectState();
}

class _NewSubjectState extends State<NewSubject> {
  final _nameController = TextEditingController();

  void _submitSubjectData() {
    if (_nameController.text.trim() == "") {
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

    widget.onAddSubject(_nameController.text.trim());
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            maxLength: 50,
            decoration: InputDecoration(label: Text('Title')),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: _submitSubjectData,
                child: Text('Save Subject'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
