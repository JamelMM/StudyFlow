import 'package:flutter/material.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';
import 'package:frontend/screens/new_study_note.dart';
import 'package:frontend/screens/quizzes_screen.dart';
import 'package:frontend/screens/study_notes_screen.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final StudyNotesRepository _studyNotesRepository =
      getIt<StudyNotesRepository>();

  int _selectedPageIndex = 0;
  int _notesRefreshVersion = 0;

  void _onSelectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
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

    if (!mounted) {
      return;
    }

    setState(() {
      _notesRefreshVersion++;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note successfully created', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  void _handleAddPressed() {
    if (_selectedPageIndex == 0) {
      _openAddStudyNoteOverlay();
      return;
    }

    if (_selectedPageIndex == 1) {
      // Later: add quiz question or quiz-related action.
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      StudyNotesScreen(
        key: ValueKey(_notesRefreshVersion),
        topic: widget.topic,
      ),
      QuizzesScreen(topic: widget.topic),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
        actions: [
          IconButton(onPressed: _handleAddPressed, icon: const Icon(Icons.add)),
        ],
      ),
      body: IndexedStack(index: _selectedPageIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.primaryContainer.withAlpha(150),
        currentIndex: _selectedPageIndex,
        onTap: _onSelectedPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
        ],
      ),
    );
  }
}
