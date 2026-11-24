import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exam_answer_options_repository.dart';
import 'package:frontend/features/exam/data/repositories/tostore_practice_exam_answer_options_repository.dart';

final practiceExamAnswerOptionsRepositoryProvider =
    Provider<PracticeExamAnswerOptionsRepository>(
      (ref) => ToStorePracticeExamAnswerOptionsRepository(),
    );
