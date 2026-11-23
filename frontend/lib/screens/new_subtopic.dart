import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class NewSubtopic extends StatefulWidget {
  const NewSubtopic({super.key, required this.onAddSubtopic});

  final Future<void> Function(String name) onAddSubtopic;

  @override
  State<NewSubtopic> createState() => _NewSubtopicState();
}

class _NewSubtopicState extends State<NewSubtopic> {
  final _nameController = TextEditingController();
  bool _isSaving = false;

  Future<void> _submitSubtopicData() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter a valid subtopic name.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onAddSubtopic(name);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create subtopic.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 80,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: _isSaving ? null : (_) => _submitSubtopicData(),
            decoration: const InputDecoration(labelText: 'Subtopic name'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: appPrimaryButtonStyle(context),
                onPressed: _isSaving ? null : _submitSubtopicData,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save subtopic'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
