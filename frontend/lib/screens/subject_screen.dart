import 'package:flutter/material.dart';
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
                    Text(subject.name),
                  ],
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
