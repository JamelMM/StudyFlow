import 'package:flutter/material.dart';
import 'package:frontend/features/exam/domain/models/practice_exam.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/widgets/app_button_styles.dart';

class PracticeExamForm extends StatefulWidget {
  const PracticeExamForm({
    super.key,
    this.practiceExam,
    required this.onSubmit,
  });

  final PracticeExam? practiceExam;

  final Future<bool> Function(
    String name,
    int passingPercentage,
    int? durationMinutes,
  )
  onSubmit;

  @override
  State<PracticeExamForm> createState() => _PracticeExamFormState();
}

class _PracticeExamFormState extends State<PracticeExamForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _passingPercentageController;
  late final TextEditingController _durationMinutesController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.practiceExam?.name ?? '',
    );

    _passingPercentageController = TextEditingController(
      text: widget.practiceExam?.passingPercentage.toString() ?? '50',
    );

    _durationMinutesController = TextEditingController(
      text: widget.practiceExam?.durationMinutes?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passingPercentageController.dispose();
    _durationMinutesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final name = _nameController.text.trim();
    final passingPercentage = int.parse(
      _passingPercentageController.text.trim(),
    );

    final durationText = _durationMinutesController.text.trim();
    final durationMinutes = durationText.isEmpty
        ? null
        : int.parse(durationText);

    setState(() {
      _isSaving = true;
    });

    try {
      final wasSaved = await widget.onSubmit(
        name,
        passingPercentage,
        durationMinutes,
      );

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
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.practiceExam != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: true,
              enabled: !_isSaving,
              maxLength: 80,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Exam name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter an exam name.';
                }

                return null;
              },
            ),
            TextFormField(
              controller: _passingPercentageController,
              enabled: !_isSaving,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Passing percentage',
                suffixText: '%',
              ),
              validator: (value) {
                final percentage = int.tryParse(value?.trim() ?? '');

                if (percentage == null || percentage < 1 || percentage > 100) {
                  return 'Enter a percentage between 1 and 100.';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationMinutesController,
              enabled: !_isSaving,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Duration',
                suffixText: 'minutes',
                helperText: 'Optional',
              ),
              validator: (value) {
                final text = value?.trim() ?? '';

                if (text.isEmpty) {
                  return null;
                }

                final duration = int.tryParse(text);

                if (duration == null || duration < 1) {
                  return 'Enter a duration greater than zero.';
                }

                return null;
              },
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
                      : Text(isEditing ? 'Save' : 'Create exam'),
                ),
                TextButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
