import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/application/use_cases/validate_quiz_can_start.dart';
import 'package:frontend/features/quiz/application/providers/answer_options_repository_provider.dart';
import 'package:frontend/features/quiz/application/providers/questions_repository_provider.dart';

final validateQuizCanStartProvider = Provider<ValidateQuizCanStart>((ref) {
  return ValidateQuizCanStart(
    questionsRepository: ref.watch(questionsRepositoryProvider),
    answerOptionsRepository: ref.watch(answerOptionsRepositoryProvider),
  );
});
