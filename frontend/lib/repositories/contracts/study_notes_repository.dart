import 'package:frontend/models/study_note.dart';

abstract class StudyNotesRepository {
  List<StudyNote> getStudyNotesByTopicId(int topicId);
  void addStudyNote(StudyNote studynote);
  void removeStudyNote(StudyNote studynote);
}
