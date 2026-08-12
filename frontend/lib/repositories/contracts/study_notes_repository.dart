import 'package:frontend/models/study_note.dart';

abstract class StudyNotesRepository {
  Future<List<StudyNote>> getStudyNotesByTopicId(String topicId);

  Future<StudyNote> addStudyNote({
    required String topicId,
    required String name,
    required String markdownText,
  });

  Future<void> removeStudyNote(String id);

  Future<void> updateStudyNote({
    required String id,
    required String name,
    required String markdownText,
  });
}
