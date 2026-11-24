import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/data/repositories/tostore_study_notes_repository.dart';
import 'package:frontend/features/study_content/domain/repositories/study_notes_repository.dart';

final studyNotesRepositoryProvider = Provider<StudyNotesRepository>(
  (ref) => ToStoreStudyNotesRepository(),
);
