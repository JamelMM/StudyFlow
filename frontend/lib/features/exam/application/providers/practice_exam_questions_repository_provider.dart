import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exam_questions_repository.dart';
import 'package:frontend/features/exam/data/repositories/tostore_practice_exam_questions_repository.dart';

final practiceExamQuestionsRepositoryProvider =
    Provider<PracticeExamQuestionsRepository>(
      (ref) => ToStorePracticeExamQuestionsRepository(),
    );
