import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/providers/quizzes_repository_provider.dart';

final quizzesStreamProvider = StreamProvider.autoDispose.family<Quiz?, String>((
  ref,
  topicId,
) {
  final quizzesRepository = ref.watch(quizzesRepositoryProvider);

  return quizzesRepository.watchQuizByTopicId(topicId);
});
