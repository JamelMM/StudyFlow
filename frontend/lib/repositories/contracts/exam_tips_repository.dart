import 'package:frontend/models/exam_tip.dart';

abstract class ExamTipsRepository {
  Future<List<ExamTip>> getExamTipsBySectionId(String examSectionId);

  Stream<List<ExamTip>> watchExamTipsBySectionId(String examSectionId);

  Future<ExamTip> addExamTip({
    required String examSectionId,
    required String name,
    required String markdownText,
  });

  Future<void> updateExamTip({
    required String id,
    required String name,
    required String markdownText,
  });

  Future<void> removeExamTip(String id);
}
