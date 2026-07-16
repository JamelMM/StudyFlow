import 'package:flutter/material.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/screens/quizzes_screen.dart';
import 'package:frontend/screens/study_notes_screen.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  int _selectedPageIndex = 0;

  void _onSelectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = StudyNotesScreen(topic: widget.topic);

    if (_selectedPageIndex == 1) {
      activePage = QuizzesScreen(topic: widget.topic);
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.topic.name)),
      body: activePage,
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
