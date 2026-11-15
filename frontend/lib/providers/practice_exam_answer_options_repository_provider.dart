import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/contracts/practice_exam_answer_options_repository.dart';
import 'package:frontend/local/tostore/tostore_practice_exam_answer_options_repository.dart';

final practiceExamAnswerOptionsRepositoryProvider =
    Provider<PracticeExamAnswerOptionsRepository>(
      (ref) => ToStorePracticeExamAnswerOptionsRepository(),
    );
