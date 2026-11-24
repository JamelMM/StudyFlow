import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/application/providers/practice_exam_answer_options_repository_provider.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exam_answer_options_repository.dart';

final practiceExamAnswerOptionsControllerProvider =
    Provider.family<PracticeExamAnswerOptionsController, String>((
      ref,
      practiceExamQuestionId,
    ) {
      final practiceExamAnswerOptionsRepository = ref.watch(
        practiceExamAnswerOptionsRepositoryProvider,
      );

      return PracticeExamAnswerOptionsController(
        practiceExamAnswerOptionsRepository:
            practiceExamAnswerOptionsRepository,
        practiceExamQuestionId: practiceExamQuestionId,
      );
    });

class PracticeExamAnswerOptionsController {
  const PracticeExamAnswerOptionsController({
    required this.practiceExamAnswerOptionsRepository,
    required this.practiceExamQuestionId,
  });

  final PracticeExamAnswerOptionsRepository
  practiceExamAnswerOptionsRepository;
  final String practiceExamQuestionId;

  Future<String?> addAnswerOption({
    required String markdownText,
    required bool isCorrect,
  }) async {
    final existingAnswers = await practiceExamAnswerOptionsRepository
        .getAnswerOptionsByQuestionId(practiceExamQuestionId);

    final alreadyHasCorrectAnswer = existingAnswers.any(
      (answer) => answer.isCorrect,
    );

    if (isCorrect && alreadyHasCorrectAnswer) {
      return 'A question can only have one correct answer.';
    }

    await practiceExamAnswerOptionsRepository.addAnswerOption(
      practiceExamQuestionId: practiceExamQuestionId,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    return null;
  }

  Future<String?> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final existingAnswers = await practiceExamAnswerOptionsRepository
        .getAnswerOptionsByQuestionId(practiceExamQuestionId);

    final alreadyHasAnotherCorrectAnswer = existingAnswers.any(
      (answer) => answer.id != id && answer.isCorrect,
    );

    if (isCorrect && alreadyHasAnotherCorrectAnswer) {
      return 'A question can only have one correct answer.';
    }

    await practiceExamAnswerOptionsRepository.updateAnswerOption(
      id: id,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    return null;
  }

  Future<void> removeAnswerOption(String id) async {
    await practiceExamAnswerOptionsRepository.removeAnswerOption(id);
  }
}
