import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/study_note.dart';
import 'package:frontend/providers/study_notes_repository_provider.dart';

final studyNotesStreamProvider = StreamProvider.autoDispose
    .family<List<StudyNote>, String>((ref, topicId) {
      final studyNotesRepository = ref.watch(studyNotesRepositoryProvider);

      return studyNotesRepository.watchStudyNotesByTopicId(topicId);
    });
