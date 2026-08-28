import 'package:flutter/material.dart';
import 'package:frontend/providers/subjects_stream_provider.dart';
import 'package:frontend/screens/edit_subject.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/screens/topics_screen.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/screens/new_subject.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/subjects_controller.dart';

class SubjectScreen extends ConsumerStatefulWidget {
  const SubjectScreen({super.key});

  @override
  ConsumerState<SubjectScreen> createState() {
    return _SubjectScreenState();
  }
}

class _SubjectScreenState extends ConsumerState<SubjectScreen> {
  void _openAddSubjectOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) => NewSubject(onAddSubject: _addSubject),
    );
  }

  Future<void> _addSubject(String name) async {
    await ref.read(subjectsControllerProvider).addSubject(name);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Subject successfully created',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  Future<void> _removeSubject(Subject subject) async {
    await ref.read(subjectsControllerProvider).removeSubject(subject.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subject deleted', textAlign: TextAlign.center),
      ),
    );
  }

  Future<bool> _confirmRemoveSubject(Subject subject) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete subject?'),
          content: const Text(
            'This will also delete its topics, notes, quizzes, questions, and answers.',
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

  void _openEditSubjectOverlay(Subject subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (ctx) {
        return EditSubject(
          subject: subject,
          onUpdateSubject: (name) {
            _updateSubject(subject: subject, name: name);
          },
        );
      },
    );
  }

  Future<void> _updateSubject({
    required Subject subject,
    required String name,
  }) async {
    await ref
        .read(subjectsControllerProvider)
        .updateSubject(id: subject.id, name: name);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Subject successfully updated',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF2F855A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsStreamProvider);

    final mainContent = subjectsAsync.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return const Center(child: Text('Could not load subjects.'));
      },
      data: (subjects) {
        if (subjects.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.menu_book_outlined,
            title: 'No subjects yet.',
            message: 'Create your first subject.',
            buttonText: 'Add subject',
            onPressed: _openAddSubjectOverlay,
          );
        }

        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicsScreen(subject: subject),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.school),
                      const SizedBox(width: 12),
                      Expanded(child: Text(subject.name)),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            _openEditSubjectOverlay(subject);
                          }

                          if (value == 'delete') {
                            final shouldRemove = await _confirmRemoveSubject(
                              subject,
                            );

                            if (shouldRemove == true) {
                              _removeSubject(subject);
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
        title: const Text('StudyFlow'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _openAddSubjectOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Subjects',
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
