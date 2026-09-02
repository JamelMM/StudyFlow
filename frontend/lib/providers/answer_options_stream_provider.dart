import 'package:frontend/models/answer_option.dart';
import 'package:frontend/providers/answer_options_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final answerOptionsStreamProvider = StreamProvider.autoDispose
    .family<List<AnswerOption>, String>((ref, questionId) {
      final answerOptionsRepository = ref.watch(
        answerOptionsRepositoryProvider,
      );

      return answerOptionsRepository.watchAnswerOptionsByQuestionId(questionId);
    });
