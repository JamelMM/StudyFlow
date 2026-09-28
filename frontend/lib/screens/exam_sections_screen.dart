import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/exam_sections_controller.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/providers/exam_sections_stream_provider.dart';
import 'package:frontend/screens/edit_exam_section.dart';
import 'package:frontend/screens/exam_section_detail_screen.dart';
import 'package:frontend/screens/new_exam_section.dart';
import 'package:frontend/widgets/app_snack_bar.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamSectionsScreen extends ConsumerStatefulWidget {
  const ExamSectionsScreen({super.key});

  @override
  ConsumerState<ExamSectionsScreen> createState() =>
      _ExamSectionsScreenState();
}

class _ExamSectionsScreenState extends ConsumerState<ExamSectionsScreen> {
  void _openAddExamSectionOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => NewExamSection(
        onAddExamSection: _addExamSection,
      ),
    );
  }

  void _openEditExamSectionOverlay(ExamSection examSection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => EditExamSection(
        examSection: examSection,
        onUpdateExamSection: (name) {
          return _updateExamSection(examSection: examSection, name: name);
        },
      ),
    );
  }

  Future<bool> _addExamSection(String name) async {
    try {
      await ref.read(examSectionsControllerProvider).addExamSection(name);

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Exam section successfully created'));
      return true;
    } catch (_) {
      if (!mounted) {
        return false;
      }

      _showSnackBar(appErrorSnackBar('Could not create exam section.'));
      return false;
    }
  }

  Future<bool> _updateExamSection({
    required ExamSection examSection,
    required String name,
  }) async {
    try {
      await ref
          .read(examSectionsControllerProvider)
          .updateExamSection(id: examSection.id, name: name);

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Exam section successfully updated'));
      return true;
    } catch (_) {
      if (!mounted) {
        return false;
      }

      _showSnackBar(appErrorSnackBar('Could not update exam section.'));
      return false;
    }
  }

  Future<void> _removeExamSection(ExamSection examSection) async {
    try {
      await ref
          .read(examSectionsControllerProvider)
          .removeExamSection(examSection.id);

      if (!mounted) {
        return;
      }

      _showSnackBar(appDeleteSnackBar('Exam section deleted'));
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showSnackBar(appErrorSnackBar('Could not delete exam section.'));
    }
  }

  Future<bool> _confirmRemoveExamSection(ExamSection examSection) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete exam section?'),
          content: Text(
            'Delete "${examSection.name}"? Its practice exams and results '
            'will also be deleted.',
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
        );
      },
    );

    return shouldDelete == true;
  }

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final examSectionsAsync = ref.watch(examSectionsStreamProvider);

    final mainContent = examSectionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load exam sections.')),
      data: (examSections) {
        if (examSections.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.fact_check_outlined,
            title: 'No exam sections yet.',
            message: 'Create a section such as AP1, AP2, or WISO.',
            buttonText: 'Add exam section',
            onPressed: _openAddExamSectionOverlay,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = ResponsiveBreakpoints.gridColumns(
              constraints.maxWidth,
            );

            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: examSections.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 88,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final examSection = examSections[index];

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamSectionDetailScreen(
                            examSection: examSection,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.fact_check_outlined),
                          const SizedBox(width: 12),
                          Expanded(child: Text(examSection.name)),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                _openEditExamSectionOverlay(examSection);
                              }

                              if (value == 'delete') {
                                final shouldDelete =
                                    await _confirmRemoveExamSection(examSection);

                                if (shouldDelete) {
                                  await _removeExamSection(examSection);
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Mode'),
        actions: [
          IconButton(
            tooltip: 'Add exam section',
            onPressed: _openAddExamSectionOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ResponsiveContent(
        maxWidth: 1100,
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          children: [
            Center(
              child: Text(
                'Exam sections',
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
