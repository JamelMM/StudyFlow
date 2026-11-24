import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/exam/data/repositories/tostore_exam_sections_repository.dart';
import 'package:frontend/features/exam/domain/repositories/exam_sections_repository.dart';

final examSectionsRepositoryProvider = Provider<ExamSectionsRepository>((ref) {
  return ToStoreExamSectionsRepository();
});
