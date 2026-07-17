import 'package:frontend/models/answer_option.dart';

abstract class AnswerOptionsRepository {
  Future<List<AnswerOption>> getAnswerOptionsByQuestionId(String questionId);
  Future<AnswerOption> addAnswerOption({
    required String questionId,
    required String markdownText,
    required bool isCorrect,
  });
  Future<void> removeAnswerOption(String id);
}
