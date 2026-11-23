import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/subtopics_controller.dart';
import 'package:frontend/models/subtopic.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/providers/subtopics_stream_provider.dart';
import 'package:frontend/screens/edit_subtopic.dart';
import 'package:frontend/screens/subtopic_detail_screen.dart';
import 'package:frontend/widgets/app_snack_bar.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class SubtopicsScreen extends ConsumerStatefulWidget {
  const SubtopicsScreen({
    super.key,
    required this.topic,
    required this.onAddSubtopicPressed,
  });

  final Topic topic;
  final VoidCallback onAddSubtopicPressed;

  @override
  ConsumerState<SubtopicsScreen> createState() => _SubtopicsScreenState();
}

class _SubtopicsScreenState extends ConsumerState<SubtopicsScreen> {
  Future<void> _updateSubtopic(Subtopic subtopic, String name) async {
    await ref
        .read(subtopicsControllerProvider(widget.topic.id))
        .updateSubtopic(id: subtopic.id, name: name);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(appSuccessSnackBar('Subtopic successfully updated'));
  }

  void _openEditSubtopicOverlay(Subtopic subtopic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => EditSubtopic(
        subtopic: subtopic,
        onUpdateSubtopic: (name) => _updateSubtopic(subtopic, name),
      ),
    );
  }

  Future<void> _confirmRemoveSubtopic(Subtopic subtopic) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete subtopic?'),
        content: const Text(
          'This will delete its notes and Study Mode questions. Practice exam questions will be kept without a subtopic.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    await ref
        .read(subtopicsControllerProvider(widget.topic.id))
        .removeSubtopic(subtopic.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(appDeleteSnackBar('Subtopic deleted'));
  }

  @override
  Widget build(BuildContext context) {
    final subtopicsAsync = ref.watch(subtopicsStreamProvider(widget.topic.id));

    final content = subtopicsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load subtopics.')),
      data: (subtopics) {
        if (subtopics.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.account_tree_outlined,
            title: 'No subtopics yet.',
            message: 'Divide this topic into focused learning sections.',
            buttonText: 'Add subtopic',
            onPressed: widget.onAddSubtopicPressed,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = ResponsiveBreakpoints.gridColumns(
              constraints.maxWidth,
            );

            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: subtopics.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 72,
                mainAxisSpacing: 6,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final subtopic = subtopics[index];

                return Card(
                  elevation: 1,
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubtopicDetailScreen(subtopic: subtopic),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
                      child: Row(
                        children: [
                          const Icon(Icons.folder_outlined, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              subtopic.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openEditSubtopicOverlay(subtopic);
                              } else if (value == 'delete') {
                                _confirmRemoveSubtopic(subtopic);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
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
      },
    );

    return ResponsiveContent(
      maxWidth: 1100,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Text(
            'Subtopics',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: content),
        ],
      ),
    );
  }
}
