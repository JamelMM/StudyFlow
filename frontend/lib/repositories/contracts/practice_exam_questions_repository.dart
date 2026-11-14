import 'package:frontend/models/practice_exam_question.dart';

abstract class PracticeExamQuestionsRepository {
  Future<List<PracticeExamQuestion>> getQuestionsByPracticeExamId(
    String practiceExamId,
  );

  Stream<List<PracticeExamQuestion>> watchQuestionsByPracticeExamId(
    String practiceExamId,
  );

  Future<PracticeExamQuestion> addQuestion({
    required String practiceExamId,
    required String markdownText,
    String? explanationMarkdown,
  });

  Future<void> updateQuestion({
    required String id,
    required String markdownText,
    String? explanationMarkdown,
  });

  Future<void> removeQuestion(String id);
}
