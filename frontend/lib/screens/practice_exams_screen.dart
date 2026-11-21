import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/practice_exams_controller.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/models/practice_exam.dart';
import 'package:frontend/providers/practice_exams_stream_provider.dart';
import 'package:frontend/providers/validate_practice_exam_can_start_provider.dart';
import 'package:frontend/screens/practice_exam_form.dart';
import 'package:frontend/screens/practice_exam_play_screen.dart';
import 'package:frontend/screens/practice_exam_questions_screen.dart';
import 'package:frontend/widgets/app_snack_bar.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class PracticeExamsScreen extends ConsumerStatefulWidget {
  const PracticeExamsScreen({
    super.key,
    required this.examSection,
    required this.onAddExamPressed,
  });

  final ExamSection examSection;
  final VoidCallback onAddExamPressed;

  @override
  ConsumerState<PracticeExamsScreen> createState() =>
      _PracticeExamsScreenState();
}

class _PracticeExamsScreenState extends ConsumerState<PracticeExamsScreen> {
  Future<void> _startPracticeExam(PracticeExam practiceExam) async {
    try {
      final validatePracticeExamCanStart = ref.read(
        validatePracticeExamCanStartProvider,
      );
      final errorMessage = await validatePracticeExamCanStart(practiceExam.id);

      if (!mounted) {
        return;
      }

      if (errorMessage != null) {
        _showSnackBar(appErrorSnackBar(errorMessage));
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PracticeExamPlayScreen(practiceExam: practiceExam),
        ),
      );
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not start the practice exam.'));
      }
    }
  }

  void _openEditOverlay(PracticeExam practiceExam) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => PracticeExamForm(
        practiceExam: practiceExam,
        onSubmit: (name, passingPercentage, durationMinutes) {
          return _updatePracticeExam(
            practiceExam: practiceExam,
            name: name,
            passingPercentage: passingPercentage,
            durationMinutes: durationMinutes,
          );
        },
      ),
    );
  }

  Future<bool> _updatePracticeExam({
    required PracticeExam practiceExam,
    required String name,
    required int passingPercentage,
    required int? durationMinutes,
  }) async {
    try {
      await ref
          .read(practiceExamsControllerProvider(widget.examSection.id))
          .updatePracticeExam(
            id: practiceExam.id,
            name: name,
            passingPercentage: passingPercentage,
            durationMinutes: durationMinutes,
          );

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Practice exam successfully updated'));

      return true;
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not update practice exam.'));
      }

      return false;
    }
  }

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  Future<void> _confirmRemovePracticeExam(PracticeExam practiceExam) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete practice exam?'),
        content: Text(
          'Do you want to delete "${practiceExam.name}"? '
          'Its questions and results will also be deleted.',
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

    try {
      await ref
          .read(practiceExamsControllerProvider(widget.examSection.id))
          .removePracticeExam(practiceExam.id);

      if (mounted) {
        _showSnackBar(appDeleteSnackBar('Practice exam deleted'));
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not delete practice exam.'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final practiceExamsAsync = ref.watch(
      practiceExamsStreamProvider(widget.examSection.id),
    );

    final mainContent = practiceExamsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load practice exams.')),
      data: (practiceExams) {
        if (practiceExams.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.assignment_outlined,
            title: 'No practice exams yet.',
            message: 'Create a practice exam for this section.',
            buttonText: 'Add practice exam',
            onPressed: widget.onAddExamPressed,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = ResponsiveBreakpoints.gridColumns(
              constraints.maxWidth,
            );

            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: practiceExams.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 104,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final practiceExam = practiceExams[index];

                final durationText = practiceExam.durationMinutes == null
                    ? 'No time limit'
                    : '${practiceExam.durationMinutes} min';

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PracticeExamQuestionsScreen(
                            practiceExam: practiceExam,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.assignment_outlined),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  practiceExam.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Passing: '
                                  '${practiceExam.passingPercentage}%'
                                  ' | $durationText',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Start practice exam',
                            onPressed: () => _startPracticeExam(practiceExam),
                            icon: const Icon(Icons.play_arrow),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openEditOverlay(practiceExam);
                              }

                              if (value == 'delete') {
                                _confirmRemovePracticeExam(practiceExam);
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
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        children: [
          Center(
            child: Text(
              'Practice exams',
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
    );
  }
}
