import 'package:flutter/material.dart';
import 'package:frontend/models/exam_tip.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class ExamTipForm extends StatefulWidget {
  const ExamTipForm({
    super.key,
    this.examTip,
    required this.onSubmit,
  });

  final ExamTip? examTip;
  final Future<bool> Function(String name, String markdownText) onSubmit;

  @override
  State<ExamTipForm> createState() => _ExamTipFormState();
}

class _ExamTipFormState extends State<ExamTipForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _markdownTextController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.examTip?.name);
    _markdownTextController = TextEditingController(
      text: widget.examTip?.markdownText,
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final markdownText = _markdownTextController.text.trim();

    if (name.isEmpty || markdownText.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final wasSaved = await widget.onSubmit(name, markdownText);

      if (mounted && wasSaved) {
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
    _markdownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.examTip != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            enabled: !_isSaving,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _markdownTextController,
            enabled: !_isSaving,
            maxLength: 4000,
            minLines: 6,
            maxLines: 12,
            decoration: const InputDecoration(
              labelText: 'Content (Markdown)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                style: appPrimaryButtonStyle(context),
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Save' : 'Save tip'),
              ),
              TextButton(
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
