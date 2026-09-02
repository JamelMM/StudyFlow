import 'package:frontend/models/question.dart';

abstract class QuestionsRepository {
  Future<List<Question>> getQuestionsByQuizId(String quizId);

  Future<Question> addQuestion({
    required String quizId,
    required String markdownText,
  });

  Stream<List<Question>> watchQuestionsByQuizId(String quizId);

  Future<void> removeQuestion(String id);

  Future<void> updateQuestion({
    required String id,
    required String markdownText,
  });
}
