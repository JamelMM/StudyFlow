import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/screens/edit_topic.dart';
import 'package:frontend/screens/new_topic.dart';
import 'package:frontend/screens/topic_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/controllers/topics_controller.dart';

class TopicsScreen extends ConsumerStatefulWidget {
  const TopicsScreen({super.key, required this.subject});

  final Subject subject;

  @override
  ConsumerState<TopicsScreen> createState() {
    return _TopicsScreenState();
  }
}

class _TopicsScreenState extends ConsumerState<TopicsScreen> {
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
    await ref
        .read(topicsControllerProvider(widget.subject.id).notifier)
        .addTopic(name: name);

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
    await ref
        .read(topicsControllerProvider(widget.subject.id).notifier)
        .removeTopic(topic.id);

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

  void _openEditTopicOverlay(Topic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return EditTopic(
          topic: topic,
          onUpdateTopic: (name) {
            _updateTopic(topic: topic, name: name);
          },
        );
      },
    );
  }

  Future<void> _updateTopic({
    required Topic topic,
    required String name,
  }) async {
    await ref
        .read(topicsControllerProvider(widget.subject.id).notifier)
        .updateTopic(id: topic.id, name: name);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Topic successfully updated',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(topicsControllerProvider(widget.subject.id));

    Widget mainContent = topicsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load topics.')),
      data: (topics) {
        if (topics.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.create_new_folder_outlined,
            title: 'No topics yet.',
            message: 'Create your first topic for this subject.',
            buttonText: 'Add topic',
            onPressed: _openAddTopicOverlay,
          );
        }

        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return Card(
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
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            _openEditTopicOverlay(topic);
                          }

                          if (value == 'delete') {
                            final shouldRemove = await _confirmRemoveTopic(
                              topic,
                            );

                            if (shouldRemove == true) {
                              _removeTopic(topic);
                            }
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        actions: [
          IconButton(
            onPressed: _openAddTopicOverlay,
            icon: const Icon(Icons.add),
          ),
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
            const SizedBox(height: 30),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
