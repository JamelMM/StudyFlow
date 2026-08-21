import 'package:flutter/material.dart';
import 'package:frontend/models/study_note.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/screens/new_study_note.dart';
import 'package:frontend/screens/note_screen.dart';
import 'package:frontend/widgets/study_notes/study_note_list_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/study_notes_controller.dart';
import 'package:frontend/screens/edit_study_note.dart';

class StudyNotesScreen extends ConsumerStatefulWidget {
  const StudyNotesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  ConsumerState<StudyNotesScreen> createState() {
    return _StudyNotesScreenState();
  }
}

class _StudyNotesScreenState extends ConsumerState<StudyNotesScreen> {
  void _openAddStudyNoteOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) => NewStudyNote(onAddNote: _addStudyNote),
    );
  }

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

  Future<void> _addStudyNote(String title, String markdownText) async {
    await ref
        .read(studyNotesControllerProvider(widget.topic.id).notifier)
        .addStudyNote(name: title, markdownText: markdownText);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note successfully created', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  Future<void> _updateStudyNote({
    required StudyNote note,
    required String title,
    required String markdownText,
  }) async {
    await ref
        .read(studyNotesControllerProvider(widget.topic.id).notifier)
        .updateStudyNote(id: note.id, name: title, markdownText: markdownText);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note successfully updated', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
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
        .read(studyNotesControllerProvider(widget.topic.id).notifier)
        .removeStudyNote(note.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted', textAlign: TextAlign.center),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studyNotesAsync = ref.watch(
      studyNotesControllerProvider(widget.topic.id),
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
            message: 'Create your first note for this topic.',
            buttonText: 'Add note',
            onPressed: _openAddStudyNoteOverlay,
          );
        }

        return ListView.builder(
          itemCount: studyNotes.length,
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

    return Padding(
      padding: const EdgeInsets.only(top: 20),
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
