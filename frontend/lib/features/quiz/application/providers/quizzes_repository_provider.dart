import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/data/repositories/tostore_quizzes_repository.dart';
import 'package:frontend/features/quiz/domain/repositories/quizzes_repository.dart';

final quizzesRepositoryProvider = Provider<QuizzesRepository>(
  (ref) => ToStoreQuizzesRepository(),
);
