import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/data/repositories/tostore_subjects_repository.dart';
import 'package:frontend/features/study_content/domain/repositories/subjects_repository.dart';

final subjectsRepositoryProvider = Provider<SubjectsRepository>((ref) {
  return ToStoreSubjectsRepository();
});
