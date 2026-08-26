import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_quizzes_repository.dart';
import 'package:frontend/repositories/contracts/quizzes_repository.dart';

final quizzesRepositoryProvider = Provider<QuizzesRepository>(
  (ref) => ToStoreQuizzesRepository(),
);
