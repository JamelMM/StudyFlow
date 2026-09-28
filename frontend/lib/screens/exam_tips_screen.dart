import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/exam_tips_controller.dart';
import 'package:frontend/models/exam_section.dart';
import 'package:frontend/models/exam_tip.dart';
import 'package:frontend/providers/exam_tips_stream_provider.dart';
import 'package:frontend/screens/exam_tip_form.dart';
import 'package:frontend/screens/exam_tip_screen.dart';
import 'package:frontend/widgets/app_snack_bar.dart';
import 'package:frontend/widgets/empty_state_message.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamTipsScreen extends ConsumerStatefulWidget {
  const ExamTipsScreen({
    super.key,
    required this.examSection,
    required this.onAddTipPressed,
  });

  final ExamSection examSection;
  final VoidCallback onAddTipPressed;

  @override
  ConsumerState<ExamTipsScreen> createState() => _ExamTipsScreenState();
}

class _ExamTipsScreenState extends ConsumerState<ExamTipsScreen> {
  void _openEditOverlay(ExamTip examTip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => ExamTipForm(
        examTip: examTip,
        onSubmit: (name, markdownText) {
          return _updateExamTip(
            examTip: examTip,
            name: name,
            markdownText: markdownText,
          );
        },
      ),
    );
  }

  Future<bool> _updateExamTip({
    required ExamTip examTip,
    required String name,
    required String markdownText,
  }) async {
    try {
      await ref
          .read(examTipsControllerProvider(widget.examSection.id))
          .updateExamTip(
            id: examTip.id,
            name: name,
            markdownText: markdownText,
          );

      if (!mounted) {
        return false;
      }

      _showSnackBar(appSuccessSnackBar('Tip successfully updated'));
      return true;
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not update tip.'));
      }
      return false;
    }
  }

  Future<void> _confirmRemoveExamTip(ExamTip examTip) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete tip?'),
        content: Text('Do you want to delete "${examTip.name}"?'),
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
          .read(examTipsControllerProvider(widget.examSection.id))
          .removeExamTip(examTip.id);

      if (mounted) {
        _showSnackBar(appDeleteSnackBar('Tip deleted'));
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not delete tip.'));
      }
    }
  }

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final examTipsAsync = ref.watch(
      examTipsStreamProvider(widget.examSection.id),
    );

    final mainContent = examTipsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Could not load tips.')),
      data: (examTips) {
        if (examTips.isEmpty) {
          return EmptyStateMessage(
            icon: Icons.lightbulb_outline,
            title: 'No tips yet.',
            message: 'Add advice and recommendations for this exam.',
            buttonText: 'Add tip',
            onPressed: widget.onAddTipPressed,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = ResponsiveBreakpoints.gridColumns(
              constraints.maxWidth,
            );

            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: examTips.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 88,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final examTip = examTips[index];

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamTipScreen(examTip: examTip),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline),
                          const SizedBox(width: 12),
                          Expanded(child: Text(examTip.name)),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openEditOverlay(examTip);
                              }
                              if (value == 'delete') {
                                _confirmRemoveExamTip(examTip);
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
              'Tips & recommendations',
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
