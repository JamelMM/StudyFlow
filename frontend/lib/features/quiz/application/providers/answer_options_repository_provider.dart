import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quiz/domain/repositories/answer_options_repository.dart';
import 'package:frontend/features/quiz/data/repositories/tostore_answer_options_repository.dart';

final answerOptionsRepositoryProvider = Provider<AnswerOptionsRepository>(
  (ref) => ToStoreAnswerOptionsRepository(),
);
