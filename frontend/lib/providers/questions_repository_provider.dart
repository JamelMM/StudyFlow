import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_questions_repository.dart';
import 'package:frontend/repositories/contracts/questions_repository.dart';

final questionsRepositoryProvider = Provider<QuestionsRepository>(
  (ref) => ToStoreQuestionsRepository(),
);
