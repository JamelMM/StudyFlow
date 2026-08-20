import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_subjects_repository.dart';
import 'package:frontend/repositories/contracts/subjects_repository.dart';

final subjectsRepositoryProvider = Provider<SubjectsRepository>((ref) {
  return ToStoreSubjectsRepository();
});
