import 'package:frontend/models/quiz.dart';

abstract class QuizzesRepository {
  Future<Quiz?> getQuizByTopicId(String topicId);
  Future<Quiz> addQuiz({required String name, required String topicId});
  Future<void> removeQuiz(String id);
}
