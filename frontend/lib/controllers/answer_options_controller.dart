import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/answer_options_repository_provider.dart';
import 'package:frontend/models/answer_option.dart';

final answerOptionsControllerProvider =
    AsyncNotifierProvider.family<
      AnswerOptionsController,
      List<AnswerOption>,
      String
    >(AnswerOptionsController.new);

class AnswerOptionsController extends AsyncNotifier<List<AnswerOption>> {
  AnswerOptionsController(this.questionId);

  final String questionId;

  @override
  Future<List<AnswerOption>> build() async {
    final answerOptionsRepository = ref.watch(answerOptionsRepositoryProvider);

    return answerOptionsRepository.getAnswerOptionsByQuestionId(questionId);
  }

  Future<void> addAnswerOption({
    required String markdownText,
    required bool isCorrect,
  }) async {
    final answerOptionsRepository = ref.read(answerOptionsRepositoryProvider);

    await answerOptionsRepository.addAnswerOption(
      questionId: questionId,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    ref.invalidateSelf();
  }

  Future<void> removeAnswerOption(String id) async {
    final answerOptionsRepository = ref.read(answerOptionsRepositoryProvider);

    await answerOptionsRepository.removeAnswerOption(id);

    ref.invalidateSelf();
  }

  Future<void> updateAnswerOption({
    required String id,
    required String markdownText,
    required bool isCorrect,
  }) async {
    final answerOptionsRepository = ref.read(answerOptionsRepositoryProvider);

    await answerOptionsRepository.updateAnswerOption(
      id: id,
      markdownText: markdownText,
      isCorrect: isCorrect,
    );

    ref.invalidateSelf();
  }
}
