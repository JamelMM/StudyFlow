import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/contracts/practice_exams_repository.dart';
import 'package:frontend/local/tostore/tostore_practice_exams_repository.dart';

final practiceExamsRepositoryProvider = Provider<PracticeExamsRepository>(
  (ref) => ToStorePracticeExamsRepository(),
);
