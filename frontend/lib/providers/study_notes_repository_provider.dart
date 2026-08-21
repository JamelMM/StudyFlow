import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/local/tostore/tostore_study_notes_repository.dart';
import 'package:frontend/repositories/contracts/study_notes_repository.dart';

final studyNotesRepositoryProvider = Provider<StudyNotesRepository>(
  (ref) => ToStoreStudyNotesRepository(),
);
