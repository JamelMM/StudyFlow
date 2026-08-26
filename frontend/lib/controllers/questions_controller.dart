import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/questions_repository_provider.dart';
import 'package:frontend/models/question.dart';

final questionsControllerProvider =
    AsyncNotifierProvider.family<QuestionsController, List<Question>, String>(
      QuestionsController.new,
    );

class QuestionsController extends AsyncNotifier<List<Question>> {
  QuestionsController(this.quizId);

  final String quizId;

  @override
  Future<List<Question>> build() async {
    final questionsRepository = ref.watch(questionsRepositoryProvider);

    return questionsRepository.getQuestionsByQuizId(quizId);
  }

  Future<void> addQuestion(String markdownText) async {
    final questionsRepository = ref.read(questionsRepositoryProvider);

    await questionsRepository.addQuestion(
      markdownText: markdownText,
      quizId: quizId,
    );

    ref.invalidateSelf();
  }

  Future<void> removeQuestion(String id) async {
    final questionsRepository = ref.read(questionsRepositoryProvider);

    await questionsRepository.removeQuestion(id);

    ref.invalidateSelf();
  }

  Future<void> updateQuestion({
    required String id,
    required String markdownText,
  }) async {
    final questionsRepository = ref.read(questionsRepositoryProvider);

    await questionsRepository.updateQuestion(
      id: id,
      markdownText: markdownText,
    );

    ref.invalidateSelf();
  }
}
