import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/application/providers/subjects_repository_provider.dart';
import 'package:frontend/features/study_content/domain/models/subject.dart';

final subjectsStreamProvider = StreamProvider<List<Subject>>((ref) {
  final subjectsRepository = ref.watch(subjectsRepositoryProvider);

  return subjectsRepository.watchSubjects();
});
