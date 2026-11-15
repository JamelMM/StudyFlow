import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/contracts/practice_exam_questions_repository.dart';
import 'package:frontend/local/tostore/tostore_practice_exam_questions_repository.dart';

final practiceExamQuestionsRepositoryProvider =
    Provider<PracticeExamQuestionsRepository>(
      (ref) => ToStorePracticeExamQuestionsRepository(),
    );
