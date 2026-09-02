import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/quizzes_repository_provider.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';

final quizzesControllerProvider = Provider.family<QuizzesController, String>((
  ref,
  topicId,
) {
  final quizzesRepository = ref.watch(quizzesRepositoryProvider);

  return QuizzesController(
    quizzesRepository: quizzesRepository,
    topicId: topicId,
  );
});

class QuizzesController {
  const QuizzesController({
    required this.quizzesRepository,
    required this.topicId,
  });

  final QuizzesRepository quizzesRepository;
  final String topicId;

  Future<void> addQuiz({required String name}) async {
    await quizzesRepository.addQuiz(name: name, topicId: topicId);
  }

  Future<void> removeQuiz(String id) async {
    await quizzesRepository.removeQuiz(id);
  }
}
