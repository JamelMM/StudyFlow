import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_exam_sections_repository.dart';
import 'package:frontend/repositories/contracts/exam_sections_repository.dart';

final examSectionsRepositoryProvider = Provider<ExamSectionsRepository>((ref) {
  return ToStoreExamSectionsRepository();
});
