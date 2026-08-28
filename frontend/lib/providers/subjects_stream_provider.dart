import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/subjects_repository_provider.dart';
import '../models/subject.dart';

final subjectsStreamProvider = StreamProvider<List<Subject>>((ref) {
  final subjectsRepository = ref.watch(subjectsRepositoryProvider);

  return subjectsRepository.watchSubjects();
});
