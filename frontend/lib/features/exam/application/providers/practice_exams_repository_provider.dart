import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/domain/repositories/practice_exams_repository.dart';
import 'package:frontend/features/exam/data/repositories/tostore_practice_exams_repository.dart';

final practiceExamsRepositoryProvider = Provider<PracticeExamsRepository>(
  (ref) => ToStorePracticeExamsRepository(),
);
