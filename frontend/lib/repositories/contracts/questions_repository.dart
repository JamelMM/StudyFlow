import 'package:frontend/models/question.dart';

abstract class QuestionsRepository {
  Future<List<Question>> getQuestionsByQuizId(String quizId);
  Future<Question> addQuestion({
    required String quizId,
    required String markdownText,
  });
  Future<void> removeQuestion(String id);
}
