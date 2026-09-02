import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/answer_options_repository_provider.dart';
import 'package:frontend/repositories/contracts/answer_options_repository.dart';

final answerOptionsControllerProvider =
    Provider.family<AnswerOptionsController, String>((ref, questionId) {
      final answerOptionsRepository = ref.watch(
        answerOptionsRepositoryProvider,
      );

      return AnswerOptionsController(
        answerOptionsRepository: answerOptionsRepository,
        questionId: questionId,
      );
    });

class AnswerOptionsController {
  const AnswerOptionsController({
    required this.answerOptionsRepository,
    required this.questionId,
  });

  final AnswerOptionsRepository answerOptionsRepository;
  final String questionId;

  Future<String?> addAnswerOption({
    required String markdownText,
    required bool isCorrect,
  }) async {
    final existingAnswers = await answerOptionsRepository
        .getAnswerOptionsByQuestionId(questionId);

    if (existingAnswers.length >= 4) {
      return 'A question can have a maximum of 4 answers.';
    }

    final alreadyHasCorrectAnswer = existingAnswers.any(
      (answer) => answer.isCorrect,
    );

    if (isCorrect && alreadyHasCorrectAnswer) {
      return 'A question can only have one correct answer.';
    }

    await answerOptionsRepository.addAnswerOption(
      questionId: questionId,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    return null;
  }

  Future<void> removeAnswerOption(String id) async {
    await answerOptionsRepository.removeAnswerOption(id);
  }

  Future<String?> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final existingAnswers = await answerOptionsRepository
        .getAnswerOptionsByQuestionId(questionId);

    final alreadyHasAnotherCorrectAnswer = existingAnswers.any(
      (answer) => answer.id != id && answer.isCorrect,
    );

    if (isCorrect && alreadyHasAnotherCorrectAnswer) {
      return 'A question can only have one correct answer.';
    }

    await answerOptionsRepository.updateAnswerOption(
      id: id,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    return null;
  }
}
