import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/study_note.dart';
import 'package:frontend/screens/edit_study_note.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/controllers/study_notes_controller.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key, required this.note});

  final StudyNote note;

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  late StudyNote _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  void _openEditStudyNoteOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) =>
          EditStudyNote(note: _note, onUpdateNote: _updateStudyNote),
    );
  }

  Future<void> _updateStudyNote(String name, String markdownText) async {
    await ref
        .read(studyNotesControllerProvider(_note.topicId))
        .updateStudyNote(id: _note.id, name: name, markdownText: markdownText);

    if (!mounted) {
      return;
    }

    setState(() {
      // local copy
      _note = StudyNote(
        id: _note.id,
        topicId: _note.topicId,
        name: name,
        markdownText: markdownText,
        createdAt: _note.createdAt,
        updatedAt: DateTime.now(),
      );
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note successfully updated', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_note.name),
        actions: [
          IconButton(
            onPressed: _openEditStudyNoteOverlay,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                'Study Note',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_note.markdownText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
