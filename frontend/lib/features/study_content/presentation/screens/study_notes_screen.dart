import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/controllers/study_notes_controller.dart';
import 'package:frontend/features/study_content/domain/models/study_note.dart';
import 'package:frontend/features/study_content/domain/models/subtopic.dart';
import 'package:frontend/features/study_content/application/providers/study_notes_stream_provider.dart';
import 'package:frontend/features/study_content/presentation/screens/edit_study_note.dart';
import 'package:frontend/features/study_content/presentation/screens/note_screen.dart';
import 'package:frontend/core/widgets/app_snack_bar.dart';
import 'package:frontend/core/widgets/empty_state_message.dart';
import 'package:frontend/core/widgets/responsive_layout.dart';
import 'package:frontend/features/study_content/presentation/widgets/study_note_list_item.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyNotesScreen extends ConsumerStatefulWidget {
  const StudyNotesScreen({
    super.key,
    required this.subtopic,
    required this.onAddStudyNotePressed,
  });

  final Subtopic subtopic;
  final VoidCallback onAddStudyNotePressed;

  @override
  ConsumerState<StudyNotesScreen> createState() {
    return _StudyNotesScreenState();
  }
}

class _StudyNotesScreenState extends ConsumerState<StudyNotesScreen> {
  void _openEditStudyNoteOverlay(StudyNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return EditStudyNote(
          note: note,
          onUpdateNote: (title, markdownText) {
            return _updateStudyNote(
              note: note,
              title: title,
              markdownText: markdownText,
            );
          },
        );
      },
    );
  }

  Future<void> _updateStudyNote({
    required StudyNote note,
    required String title,
    required String markdownText,
  }) async {
    await ref
        .read(studyNotesControllerProvider(widget.subtopic.id))
        .updateStudyNote(id: note.id, name: title, markdownText: markdownText);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(appSuccessSnackBar('Note successfully updated'));
  }

  Future<void> _confirmRemoveStudyNote(StudyNote note) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete note?'),
          content: Text('Do you want to delete "${note.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await _removeStudyNote(note);
  }

  Future<void> _removeStudyNote(StudyNote note) async {
    await ref
        .read(studyNotesControllerProvider(widget.subtopic.id))
        .removeStudyNote(note.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(appDeleteSnackBar('Note deleted'));
  }

  @override
  Widget build(BuildContext context) {
    final studyNotesAsync = ref.watch(
      studyNotesStreamProvider(widget.subtopic.id),
    );

    final mainContent = studyNotesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load study notes.')),
      data: (studyNotes) {
        if (studyNotes.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.note_add_outlined,
            title: 'No study notes yet.',
            message: 'Create your first note for this subtopic.',
            buttonText: 'Add note',
            onPressed: widget.onAddStudyNotePressed,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = ResponsiveBreakpoints.gridColumns(
              constraints.maxWidth,
            );

            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: studyNotes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 88,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final note = studyNotes[index];

                return StudyNoteListItem(
                  note: note,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(note: note),
                      ),
                    );
                  },
                  onEdit: () {
                    _openEditStudyNoteOverlay(note);
                  },
                  onDelete: () {
                    _confirmRemoveStudyNote(note);
                  },
                );
              },
            );
          },
        );
      },
    );

    return ResponsiveContent(
      maxWidth: 1100,
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Notes',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
