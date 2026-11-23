import 'package:frontend/models/study_note.dart';

abstract class StudyNotesRepository {
  Future<List<StudyNote>> getStudyNotesBySubtopicId(String subtopicId);

  Future<StudyNote> addStudyNote({
    required String subtopicId,
    required String name,
    required String markdownText,
  });

  Stream<List<StudyNote>> watchStudyNotesBySubtopicId(String subtopicId);

  Future<void> removeStudyNote(String id);

  Future<void> updateStudyNote({
    required String id,
    required String subtopicId,
    required String name,
    required String markdownText,
  });
}
