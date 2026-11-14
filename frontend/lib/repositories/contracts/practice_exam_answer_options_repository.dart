import 'package:frontend/models/practice_exam_answer_option.dart';

abstract class PracticeExamAnswerOptionsRepository {
  Future<List<PracticeExamAnswerOption>> getAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  );

  Stream<List<PracticeExamAnswerOption>> watchAnswerOptionsByQuestionId(
    String practiceExamQuestionId,
  );

  Future<PracticeExamAnswerOption> addAnswerOption({
    required String practiceExamQuestionId,
    required String markdownText,
    required bool isCorrect,
  });

  Future<void> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  });

  Future<void> removeAnswerOption(String id);
}
