import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/study_notes_controller.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/screens/new_study_note.dart';
import 'package:frontend/screens/quizzes_screen.dart';
import 'package:frontend/screens/study_notes_screen.dart';
import 'package:frontend/widgets/app_snack_bar.dart';

class TopicDetailScreen extends ConsumerStatefulWidget {
  const TopicDetailScreen({super.key, required this.topic});

  final Topic topic;

  @override
  ConsumerState<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends ConsumerState<TopicDetailScreen> {
  int _selectedPageIndex = 0;

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
    await ref
        .read(studyNotesControllerProvider(widget.topic.id))
        .addStudyNote(name: title, markdownText: markdownText);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      appSuccessSnackBar('Note successfully created'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      StudyNotesScreen(
        topic: widget.topic,
        onAddStudyNotePressed: _openAddStudyNoteOverlay,
      ),
      QuizzesScreen(topic: widget.topic),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
        actions: [
          if (_selectedPageIndex == 0)
            IconButton(
              onPressed: _openAddStudyNoteOverlay,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedPageIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
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
