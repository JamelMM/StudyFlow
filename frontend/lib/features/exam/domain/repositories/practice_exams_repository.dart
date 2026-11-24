import 'package:frontend/features/exam/domain/models/practice_exam.dart';

abstract class PracticeExamsRepository {
  Future<List<PracticeExam>> getPracticeExamsBySectionId(String examSectionId);

  Stream<List<PracticeExam>> watchPracticeExamsBySectionId(
    String examSectionId,
  );

  Future<PracticeExam> addPracticeExam({
    required String examSectionId,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  });

  Future<void> updatePracticeExam({
    required String id,
    required String name,
    required int passingPercentage,
    int? durationMinutes,
  });

  Future<void> removePracticeExam(String id);
}
