import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/data/repositories/tostore_subtopics_repository.dart';
import 'package:frontend/features/study_content/domain/repositories/subtopics_repository.dart';

final subtopicsRepositoryProvider = Provider<SubtopicsRepository>(
  (ref) => ToStoreSubtopicsRepository(),
);
