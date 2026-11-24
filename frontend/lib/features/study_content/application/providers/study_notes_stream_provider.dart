import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/study_content/domain/models/study_note.dart';
import 'package:frontend/features/study_content/application/providers/study_notes_repository_provider.dart';

final studyNotesStreamProvider = StreamProvider.autoDispose
    .family<List<StudyNote>, String>((ref, subtopicId) {
      final studyNotesRepository = ref.watch(studyNotesRepositoryProvider);

      return studyNotesRepository.watchStudyNotesBySubtopicId(subtopicId);
    });
