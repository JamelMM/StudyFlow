import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/controllers/subtopics_controller.dart';
import 'package:frontend/features/study_content/domain/models/topic.dart';
import 'package:frontend/features/study_content/presentation/screens/new_subtopic.dart';
import 'package:frontend/features/quiz/presentation/screens/quizzes_screen.dart';
import 'package:frontend/features/study_content/presentation/screens/subtopics_screen.dart';
import 'package:frontend/core/widgets/app_snack_bar.dart';

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

  void _openAddSubtopicOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) => NewSubtopic(onAddSubtopic: _addSubtopic),
    );
  }

  Future<void> _addSubtopic(String name) async {
    await ref
        .read(subtopicsControllerProvider(widget.topic.id))
        .addSubtopic(name: name);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(appSuccessSnackBar('Subtopic successfully created'));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      SubtopicsScreen(
        topic: widget.topic,
        onAddSubtopicPressed: _openAddSubtopicOverlay,
      ),
      QuizzesScreen(topic: widget.topic),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
        actions: [
          if (_selectedPageIndex == 0)
            IconButton(
              tooltip: 'Add subtopic',
              onPressed: _openAddSubtopicOverlay,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedPageIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _onSelectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_outlined),
            label: 'Subtopics',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
        ],
      ),
    );
  }
}
