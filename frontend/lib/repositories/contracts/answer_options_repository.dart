import 'package:frontend/models/answer_option.dart';

abstract class AnswerOptionsRepository {
  Future<List<AnswerOption>> getAnswerOptionsByQuestionId(String questionId);
  Future<AnswerOption> addAnswerOption({
    required String questionId,
    required String markdownText,
    required bool isCorrect,
  });

  Stream<List<AnswerOption>> watchAnswerOptionsByQuestionId(String questionId);

  Future<void> removeAnswerOption(String id);

  Future<void> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  });
}
