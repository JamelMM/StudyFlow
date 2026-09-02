import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/question.dart';
import 'package:frontend/providers/questions_repository_provider.dart';

final questionsStreamProvider = StreamProvider.autoDispose
    .family<List<Question>, String>((ref, quizId) {
      final questionsRepository = ref.watch(questionsRepositoryProvider);

      return questionsRepository.watchQuestionsByQuizId(quizId);
    });
