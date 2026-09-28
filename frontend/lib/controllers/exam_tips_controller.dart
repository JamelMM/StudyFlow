import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/exam_tips_repository_provider.dart';
import 'package:frontend/repositories/contracts/exam_tips_repository.dart';

final examTipsControllerProvider =
    Provider.family<ExamTipsController, String>((ref, examSectionId) {
      final repository = ref.watch(examTipsRepositoryProvider);
      return ExamTipsController(
        repository: repository,
        examSectionId: examSectionId,
      );
    });

class ExamTipsController {
  const ExamTipsController({
    required this.repository,
    required this.examSectionId,
  });

  final ExamTipsRepository repository;
  final String examSectionId;

  Future<void> addExamTip({
    required String name,
    required String markdownText,
  }) async {
    await repository.addExamTip(
      examSectionId: examSectionId,
      name: name,
      markdownText: markdownText,
    );
  }

  Future<void> updateExamTip({
    required String id,
    required String name,
    required String markdownText,
  }) async {
    await repository.updateExamTip(
      id: id,
      name: name,
      markdownText: markdownText,
    );
  }

  Future<void> removeExamTip(String id) async {
    await repository.removeExamTip(id);
  }
}
