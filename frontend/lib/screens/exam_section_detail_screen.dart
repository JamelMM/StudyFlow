import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/exam_tips_controller.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/screens/exam_tip_form.dart';
import 'package:frontend/screens/exam_tips_screen.dart';
import 'package:frontend/widgets/app_snack_bar.dart';

class ExamSectionDetailScreen extends ConsumerStatefulWidget {
  const ExamSectionDetailScreen({super.key, required this.examSection});

  final ExamSection examSection;

  @override
  ConsumerState<ExamSectionDetailScreen> createState() =>
      _ExamSectionDetailScreenState();
}

class _ExamSectionDetailScreenState
    extends ConsumerState<ExamSectionDetailScreen> {
  int _selectedPageIndex = 0;

  void _openAddExamTipOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => ExamTipForm(onSubmit: _addExamTip),
    );
  }

  Future<bool> _addExamTip(String name, String markdownText) async {
    try {
      await ref
          .read(examTipsControllerProvider(widget.examSection.id))
          .addExamTip(name: name, markdownText: markdownText);

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Tip successfully created'));
      return true;
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not create tip.'));
      }
      return false;
    }
  }

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ExamTipsScreen(
        examSection: widget.examSection,
        onAddTipPressed: _openAddExamTipOverlay,
      ),
      const _ExamAreaEmptyState(
        icon: Icons.assignment_outlined,
        title: 'No practice exams yet.',
        message: 'Practice exams for this section will appear here.',
      ),
      const _ExamAreaEmptyState(
        icon: Icons.history,
        title: 'No attempts yet.',
        message: 'Completed exam attempts will appear here.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.examSection.name),
        actions: [
          if (_selectedPageIndex == 0)
            IconButton(
              tooltip: 'Add tip',
              onPressed: _openAddExamTipOverlay,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedPageIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Exams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class _ExamAreaEmptyState extends StatelessWidget {
  const _ExamAreaEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 88, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
