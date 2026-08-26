import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/contracts/answer_options_repository.dart';
import 'package:frontend/local/tostore/tostore_answer_options_repository.dart';

final answerOptionsRepositoryProvider = Provider<AnswerOptionsRepository>(
  (ref) => ToStoreAnswerOptionsRepository(),
);
