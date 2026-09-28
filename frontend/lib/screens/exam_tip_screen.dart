import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controllers/exam_tips_controller.dart';
import 'package:frontend/models/exam_tip.dart';
import 'package:frontend/screens/exam_tip_form.dart';
import 'package:frontend/widgets/app_snack_bar.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamTipScreen extends ConsumerStatefulWidget {
  const ExamTipScreen({super.key, required this.examTip});

  final ExamTip examTip;

  @override
  ConsumerState<ExamTipScreen> createState() => _ExamTipScreenState();
}

class _ExamTipScreenState extends ConsumerState<ExamTipScreen> {
  late ExamTip _examTip;

  @override
  void initState() {
    super.initState();
    _examTip = widget.examTip;
  }

  void _openEditOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) => ExamTipForm(
        examTip: _examTip,
        onSubmit: _updateExamTip,
      ),
    );
  }

  Future<bool> _updateExamTip(String name, String markdownText) async {
    try {
      await ref
          .read(examTipsControllerProvider(_examTip.examSectionId))
          .updateExamTip(
            id: _examTip.id,
            name: name,
            markdownText: markdownText,
          );

      if (!mounted) {
        return false;
      }

      setState(() {
        _examTip = ExamTip(
          id: _examTip.id,
          examSectionId: _examTip.examSectionId,
          name: name,
          markdownText: markdownText,
          createdAt: _examTip.createdAt,
          updatedAt: DateTime.now(),
        );
      });

      _showSnackBar(appSuccessSnackBar('Tip successfully updated'));
      return true;
    } catch (_) {
      if (mounted) {
        _showSnackBar(appErrorSnackBar('Could not update tip.'));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_examTip.name),
        actions: [
          IconButton(
            tooltip: 'Edit tip',
            onPressed: _openEditOverlay,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ResponsiveContent(
        maxWidth: 900,
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Tip',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MarkdownBody(data: _examTip.markdownText),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
