import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/data/repositories/tostore_questions_repository.dart';
import 'package:frontend/features/quiz/domain/repositories/questions_repository.dart';

final questionsRepositoryProvider = Provider<QuestionsRepository>(
  (ref) => ToStoreQuestionsRepository(),
);
