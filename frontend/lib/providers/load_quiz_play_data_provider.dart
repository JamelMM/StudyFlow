import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/quiz/load_quiz_play_data.dart';
import 'package:frontend/application/quiz/quiz_play_data.dart';
import 'package:frontend/providers/answer_options_repository_provider.dart';
import 'package:frontend/providers/questions_repository_provider.dart';

final loadQuizPlayDataProvider = Provider<LoadQuizPlayData>((ref) {
  return LoadQuizPlayData(
    questionsRepository: ref.watch(questionsRepositoryProvider),
    answerOptionsRepository: ref.watch(answerOptionsRepositoryProvider),
  );
});

final quizPlayDataProvider = FutureProvider.autoDispose
    .family<QuizPlayData, String>((ref, quizId) {
      final loadQuizPlayData = ref.watch(loadQuizPlayDataProvider);

      return loadQuizPlayData(quizId);
    });
