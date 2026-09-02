import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/questions_repository_provider.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';

final questionsControllerProvider =
    Provider.family<QuestionsController, String>((ref, quizId) {
      final questionsRepository = ref.watch(questionsRepositoryProvider);

      return QuestionsController(
        questionsRepository: questionsRepository,
        quizId: quizId,
      );
    });

class QuestionsController {
  const QuestionsController({
    required this.questionsRepository,
    required this.quizId,
  });

  final QuestionsRepository questionsRepository;
  final String quizId;

  Future<void> addQuestion(String markdownText) async {
    await questionsRepository.addQuestion(
      markdownText: markdownText,
      quizId: quizId,
    );
  }

  Future<void> removeQuestion(String id) async {
    await questionsRepository.removeQuestion(id);
  }

  Future<void> updateQuestion({
    required String id,
    required String markdownText,
  }) async {
    await questionsRepository.updateQuestion(
      id: id,
      markdownText: markdownText,
    );
  }
}
