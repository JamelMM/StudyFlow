import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/domain/models/quiz.dart';
import 'package:frontend/features/quiz/application/providers/quizzes_repository_provider.dart';

final quizzesStreamProvider = StreamProvider.autoDispose.family<Quiz?, String>((
  ref,
  topicId,
) {
  final quizzesRepository = ref.watch(quizzesRepositoryProvider);

  return quizzesRepository.watchQuizByTopicId(topicId);
});
