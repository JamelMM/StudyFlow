import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/controllers/study_notes_controller.dart';
import 'package:frontend/features/study_content/domain/models/subtopic.dart';
import 'package:frontend/features/study_content/presentation/screens/new_study_note.dart';
import 'package:frontend/features/study_content/presentation/screens/study_notes_screen.dart';
import 'package:frontend/core/widgets/app_snack_bar.dart';

class SubtopicDetailScreen extends ConsumerWidget {
  const SubtopicDetailScreen({super.key, required this.subtopic});

  final Subtopic subtopic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> addStudyNote(String title, String markdownText) async {
      await ref
          .read(studyNotesControllerProvider(subtopic.id))
          .addStudyNote(name: title, markdownText: markdownText);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(appSuccessSnackBar('Note successfully created'));
    }

    void openAddStudyNoteOverlay() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
        builder: (context) => NewStudyNote(onAddNote: addStudyNote),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(subtopic.name),
        actions: [
          IconButton(
            tooltip: 'Add note',
            onPressed: openAddStudyNoteOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StudyNotesScreen(
        subtopic: subtopic,
        onAddStudyNotePressed: openAddStudyNoteOverlay,
      ),
    );
  }
}
