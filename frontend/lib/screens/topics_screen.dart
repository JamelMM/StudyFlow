import 'package:flutter/material.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/screens/new_topic.dart';
import 'package:frontend/screens/topic_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/repositories/contracts/topics_repository.dart';
import 'package:frontend/core/service_locator.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key, required this.subject});

  final Subject subject;

  @override
  State<TopicsScreen> createState() {
    return _TopicsScreenState();
  }
}

class _TopicsScreenState extends State<TopicsScreen> {
  final TopicsRepository _topicsRepository = getIt<TopicsRepository>();

  List<Topic> _subjectTopics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final loadedTopics = await _topicsRepository.getTopicsBySubjectId(
      widget.subject.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _subjectTopics = loadedTopics;
    });
  }

  void _openAddTopicOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) => NewTopic(onAddTopic: _addTopic),
    );
  }

  Future<void> _addTopic(String name) async {
    await _topicsRepository.addTopic(subjectId: widget.subject.id, name: name);

    await _loadTopics();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Topic successfully created',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  Future<void> _removeTopic(Topic topic) async {
    await _topicsRepository.removeTopic(topic.id);

    await _loadTopics();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Topic deleted', textAlign: TextAlign.center),
      ),
    );
  }

  Future<bool> _confirmRemoveTopic(Topic topic) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete topic?'),
          content: const Text(
            'This will also delete its notes, quiz, questions, and answers.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return shouldDelete == true;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = EmptyStateMessage(
      icon: Icons.create_new_folder_outlined,
      title: 'No topics yet.',
      message: 'Create your first topic for this subject.',
      buttonText: 'Add topic',
      onPressed: _openAddTopicOverlay,
    );

    if (_subjectTopics.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _subjectTopics.length,
        itemBuilder: (context, index) {
          final topic = _subjectTopics[index];

          return Dismissible(
            key: ValueKey(topic.id),
            background: Container(
              color: const Color(0xFFC53030),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) {
              return _confirmRemoveTopic(topic);
            },
            onDismissed: (direction) {
              _removeTopic(topic);
            },
            child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicDetailScreen(topic: topic),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.topic),
                      const SizedBox(width: 12),
                      Expanded(child: Text(topic.name)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        actions: [
          IconButton(onPressed: _openAddTopicOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Topics',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
