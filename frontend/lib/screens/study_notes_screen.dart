import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/study_note.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/screens/new_study_note.dart';
import 'package:frontend/screens/note_screen.dart';
import 'package:frontend/widgets/study_notes/study_note_list_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/core/service_locator.dart';

class StudyNotesScreen extends StatefulWidget {
  const StudyNotesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  State<StudyNotesScreen> createState() {
    return _StudyNotesScreenState();
  }
}

class _StudyNotesScreenState extends State<StudyNotesScreen> {
  final StudyNotesRepository _studyNotesRepository =
      getIt<StudyNotesRepository>();

  List<StudyNote> _studyNotes = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudyNotes();
  }

  Future<void> _loadStudyNotes() async {
    final loadedStudyNotes = await _studyNotesRepository.getStudyNotesByTopicId(
      widget.topic.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _studyNotes = loadedStudyNotes;
      _isLoading = false;
    });
  }

  void _openAddStudyNoteOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) => NewStudyNote(onAddNote: _addStudyNote),
    );
  }

  Future<void> _addStudyNote(String title, String markdownText) async {
    await _studyNotesRepository.addStudyNote(
      topicId: widget.topic.id,
      name: title,
      markdownText: markdownText,
    );

    await _loadStudyNotes();

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

  Future<void> _removeStudyNote(StudyNote note) async {
    await _studyNotesRepository.removeStudyNote(note.id);
    await _loadStudyNotes();

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
    Widget mainContent;

    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (_studyNotes.isEmpty) {
      mainContent = EmptyStateMessage(
        icon: Icons.note_add_outlined,
        title: 'No study notes yet.',
        message: 'Create your first note for this topic.',
        buttonText: 'Add note',
        onPressed: _openAddStudyNoteOverlay,
      );
    } else {
      mainContent = ListView.builder(
        itemCount: _studyNotes.length,
        itemBuilder: (context, index) {
          final note = _studyNotes[index];

          return Dismissible(
            key: ValueKey(note.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _removeStudyNote(note);
            },
            child: StudyNoteListItem(
              note: note,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(note: note),
                  ),
                );
              },
            ),
          );
        },
      );
    }

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
