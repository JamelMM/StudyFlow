import 'package:frontend/models/study_note.dart';

abstract class StudyNotesRepository {
  List<StudyNote> getStudyNotesByTopicId(String topicId);
  void addStudyNote(StudyNote studynote);
  void removeStudyNote(StudyNote studynote);
}
