import 'package:flutter/material.dart';
import 'package:frontend/features/study_content/domain/models/subtopic.dart';
import 'package:frontend/core/widgets/app_button_styles.dart';

class EditSubtopic extends StatefulWidget {
  const EditSubtopic({
    super.key,
    required this.subtopic,
    required this.onUpdateSubtopic,
  });

  final Subtopic subtopic;
  final Future<void> Function(String name) onUpdateSubtopic;

  @override
  State<EditSubtopic> createState() => _EditSubtopicState();
}

class _EditSubtopicState extends State<EditSubtopic> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subtopic.name);
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();

    if (name.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onUpdateSubtopic(name);

      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            enabled: !_isSaving,
            autofocus: true,
            maxLength: 80,
            textInputAction: TextInputAction.done,
            onSubmitted: _isSaving ? null : (_) => _submit(),
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
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
