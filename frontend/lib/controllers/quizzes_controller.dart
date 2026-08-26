import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/providers/quizzes_repository_provider.dart';

final quizzesControllerProvider =
    AsyncNotifierProvider.family<QuizzesController, Quiz?, String>(
      QuizzesController.new,
    );

class QuizzesController extends AsyncNotifier<Quiz?> {
  QuizzesController(this.topicId);

  final String topicId;

  @override
  Future<Quiz?> build() async {
    final quizzesRepository = ref.watch(quizzesRepositoryProvider);

    return quizzesRepository.getQuizByTopicId(topicId);
  }

  Future<void> addQuiz({required String name}) async {
    final quizzesRepository = ref.read(quizzesRepositoryProvider);

    await quizzesRepository.addQuiz(name: name, topicId: topicId);

    ref.invalidateSelf();
  }

  Future<void> removeQuiz(String id) async {
    final quizzesRepository = ref.read(quizzesRepositoryProvider);

    await quizzesRepository.removeQuiz(id);

    ref.invalidateSelf();
  }
}
