import 'package:flutter/material.dart';
import 'package:frontend/screens/edit_subject.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/screens/topics_screen.dart';
import 'package:frontend/models/subject.dart';
import 'package:frontend/screens/new_subject.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';
import 'package:frontend/core/service_locator.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() {
    return _SubjectScreenState();
  }
}

class _SubjectScreenState extends State<SubjectScreen> {
  final SubjectsRepository _subjectsRepository = getIt<SubjectsRepository>();

  List<Subject> _subjects = [];

  Future<void> _loadSubjects() async {
    final loadedSubjects = await _subjectsRepository.getSubjects();

    if (!mounted) {
      return;
    }

    setState(() {
      _subjects = loadedSubjects;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

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
    await _subjectsRepository.addSubject(name);
    await _loadSubjects();

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
    await _subjectsRepository.removeSubject(subject.id);

    await _loadSubjects();

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
    await _subjectsRepository.updateSubject(id: subject.id, name: name);

    await _loadSubjects();

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
    Widget mainContent = EmptyStateMessage(
      icon: Icons.menu_book_outlined,
      title: 'No subjects yet.',
      message: 'Create your first subject.',
      buttonText: 'Add subject',
      onPressed: _openAddSubjectOverlay,
    );

    if (_subjects.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];

          return Dismissible(
            key: ValueKey(subject.id),
            background: Container(
              color: const Color(0xFFC53030),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) {
              return _confirmRemoveSubject(subject);
            },
            onDismissed: (direction) {
              _removeSubject(subject);
            },
            child: Card(
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
            ),
          );
        },
      );
    }

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
