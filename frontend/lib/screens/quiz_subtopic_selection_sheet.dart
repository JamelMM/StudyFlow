import 'package:flutter/material.dart';
import 'package:frontend/models/subtopic.dart';
import 'package:frontend/widgets/app_button_styles.dart';

class QuizSubtopicSelectionSheet extends StatefulWidget {
  const QuizSubtopicSelectionSheet({super.key, required this.subtopics});

  final List<Subtopic> subtopics;

  @override
  State<QuizSubtopicSelectionSheet> createState() =>
      _QuizSubtopicSelectionSheetState();
}

class _QuizSubtopicSelectionSheetState
    extends State<QuizSubtopicSelectionSheet> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.subtopics.map((subtopic) => subtopic.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose subtopics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Select one for focused practice or several for a mixed quiz.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: widget.subtopics
                    .map(
                      (subtopic) => CheckboxListTile(
                        value: _selectedIds.contains(subtopic.id),
                        title: Text(subtopic.name),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedIds.add(subtopic.id);
                            } else {
                              _selectedIds.remove(subtopic.id);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedIds.length == widget.subtopics.length) {
                        _selectedIds.clear();
                      } else {
                        _selectedIds
                          ..clear()
                          ..addAll(
                            widget.subtopics.map((subtopic) => subtopic.id),
                          );
                      }
                    });
                  },
                  child: Text(
                    _selectedIds.length == widget.subtopics.length
                        ? 'Clear all'
                        : 'Select all',
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: appPrimaryButtonStyle(context),
                  onPressed: _selectedIds.isEmpty
                      ? null
                      : () => Navigator.pop(context, Set.of(_selectedIds)),
                  child: const Text('Start quiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
