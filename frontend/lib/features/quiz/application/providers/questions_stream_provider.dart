import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/domain/models/question.dart';
import 'package:frontend/features/quiz/application/providers/questions_repository_provider.dart';

final questionsStreamProvider = StreamProvider.autoDispose
    .family<List<Question>, String>((ref, quizId) {
      final questionsRepository = ref.watch(questionsRepositoryProvider);

      return questionsRepository.watchQuestionsByQuizId(quizId);
    });
