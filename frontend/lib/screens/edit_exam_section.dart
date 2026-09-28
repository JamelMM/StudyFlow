import 'package:flutter/material.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class EditExamSection extends StatefulWidget {
  const EditExamSection({
    super.key,
    required this.examSection,
    required this.onUpdateExamSection,
  });

  final ExamSection examSection;
  final Future<bool> Function(String name) onUpdateExamSection;

  @override
  State<EditExamSection> createState() => _EditExamSectionState();
}

class _EditExamSectionState extends State<EditExamSection> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.examSection.name);
  }

  Future<void> _submitExamSectionData() async {
    final name = _nameController.text.trim();

    if (name.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final wasSaved = await widget.onUpdateExamSection(name);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            enabled: !_isSaving,
            maxLength: 50,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitExamSectionData(),
            decoration: const InputDecoration(labelText: 'Section name'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                style: appPrimaryButtonStyle(context),
                onPressed: _isSaving ? null : _submitExamSectionData,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
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
